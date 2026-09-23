-- SmartWean Navigator: assessment records (replaces the Google Sheet backend)
create table if not exists public.assessments (
  save_id    text primary key default gen_random_uuid()::text,
  hn         text,
  ward       text,
  adate      text,
  data       jsonb not null default '{}'::jsonb,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create index if not exists assessments_hn_idx on public.assessments (hn);
create index if not exists assessments_created_at_idx on public.assessments (created_at);

alter table public.assessments enable row level security;

-- The app has no login, so the browser (anon/publishable key) needs full CRUD —
-- the same access level the old shared-secret Apps Script gave.
-- Tighten these once Supabase Auth is added.
create policy "anon select" on public.assessments for select to anon, authenticated using (true);
create policy "anon insert" on public.assessments for insert to anon, authenticated with check (true);
create policy "anon update" on public.assessments for update to anon, authenticated using (true) with check (true);
create policy "anon delete" on public.assessments for delete to anon, authenticated using (true);
