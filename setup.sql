-- Hobby Circuit — Prototype Database Setup
-- Run this in Supabase: Project → SQL Editor → New Query → paste this → Run

-- Table: hobbies (the taxonomy — starts small, grows as friends add new ones)
create table hobbies (
  id uuid primary key default gen_random_uuid(),
  name text not null unique,
  user_submitted boolean default false,
  created_at timestamp with time zone default now()
);

-- Seed a small starter list so the dropdown isn't empty on day one
insert into hobbies (name, user_submitted) values
  ('Knitting', false),
  ('Woodworking', false),
  ('Rock climbing', false),
  ('Baking', false),
  ('Photography', false),
  ('Gardening', false),
  ('Painting', false),
  ('3D printing', false),
  ('Guitar', false),
  ('Journaling', false);

-- Table: testers (very simple identity — just a name, no auth needed for a friend test)
create table testers (
  id uuid primary key default gen_random_uuid(),
  display_name text not null,
  created_at timestamp with time zone default now()
);

-- Table: hobby_logs (the core lifespan tracker)
create table hobby_logs (
  id uuid primary key default gen_random_uuid(),
  tester_id uuid references testers(id) not null,
  hobby_id uuid references hobbies(id) not null,
  started_at timestamp with time zone default now(),
  ended_at timestamp with time zone,
  created_at timestamp with time zone default now()
);

-- Enable Row Level Security (required by Supabase) but allow open read/write
-- for this friend-test phase — this is intentionally permissive since it's
-- just a small trusted test group, NOT how the real production app should be configured
alter table hobbies enable row level security;
alter table testers enable row level security;
alter table hobby_logs enable row level security;

create policy "Allow all read" on hobbies for select using (true);
create policy "Allow all insert" on hobbies for insert with check (true);

create policy "Allow all read" on testers for select using (true);
create policy "Allow all insert" on testers for insert with check (true);

create policy "Allow all read" on hobby_logs for select using (true);
create policy "Allow all insert" on hobby_logs for insert with check (true);
create policy "Allow all update" on hobby_logs for update using (true);
