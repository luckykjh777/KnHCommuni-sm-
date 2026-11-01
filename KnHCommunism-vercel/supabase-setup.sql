-- KnHCommunism database schema (Supabase SQL Editor에서 한 번 실행)
create table if not exists public.profiles (
  id uuid primary key references auth.users(id) on delete cascade,
  nickname text not null default '새 사용자',
  created_at timestamptz not null default now()
);
create table if not exists public.posts (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references public.profiles(id) on delete cascade,
  title text not null check (char_length(title) between 1 and 120),
  body text not null check (char_length(body) between 1 and 20000),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);
create table if not exists public.comments (
  id uuid primary key default gen_random_uuid(),
  post_id uuid not null references public.posts(id) on delete cascade,
  user_id uuid not null references public.profiles(id) on delete cascade,
  body text not null check (char_length(body) between 1 and 5000),
  created_at timestamptz not null default now()
);

create or replace function public.handle_new_user()
returns trigger language plpgsql security definer set search_path = '' as $$
begin
  insert into public.profiles (id, nickname)
  values (new.id, coalesce(nullif(new.raw_user_meta_data ->> 'nickname',''), nullif(split_part(coalesce(new.email,''),'@',1),''), '익명 사용자'));
  return new;
end;
$$;
drop trigger if exists on_auth_user_created on auth.users;
create trigger on_auth_user_created after insert on auth.users
for each row execute procedure public.handle_new_user();

alter table public.profiles enable row level security;
alter table public.posts enable row level security;
alter table public.comments enable row level security;

drop policy if exists "Profiles readable by everyone" on public.profiles;
create policy "Profiles readable by everyone" on public.profiles for select using (true);
drop policy if exists "Users update own profile" on public.profiles;
create policy "Users update own profile" on public.profiles for update to authenticated using (auth.uid() = id) with check (auth.uid() = id);

drop policy if exists "Posts readable by everyone" on public.posts;
create policy "Posts readable by everyone" on public.posts for select using (true);
drop policy if exists "Authenticated users create posts" on public.posts;
create policy "Authenticated users create posts" on public.posts for insert to authenticated with check (auth.uid() = user_id);
drop policy if exists "Authors delete own posts" on public.posts;
create policy "Authors delete own posts" on public.posts for delete to authenticated using (auth.uid() = user_id);

drop policy if exists "Comments readable by everyone" on public.comments;
create policy "Comments readable by everyone" on public.comments for select using (true);
drop policy if exists "Authenticated users create comments" on public.comments;
create policy "Authenticated users create comments" on public.comments for insert to authenticated with check (auth.uid() = user_id);
drop policy if exists "Authors delete own comments" on public.comments;
create policy "Authors delete own comments" on public.comments for delete to authenticated using (auth.uid() = user_id);

create index if not exists posts_created_at_idx on public.posts(created_at desc);
create index if not exists comments_post_id_created_at_idx on public.comments(post_id, created_at);
