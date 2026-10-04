-- RE:KIT 101 성향 분석 페이지 수집 표 (AX 콕핏 Supabase 에 적용됨, 2026-10-04 migration rk101_events)
-- 한 방문 = session_id 하나. 아이디 제출 시 'start', 정확도 제출 시 'score' 한 줄씩 insert 한다.
-- 공개 페이지는 insert 만 가능하고, 읽기·수정·삭제는 막혀 있다(대시보드·service_role 로만 조회).
create table if not exists public.rk101_events (
  id          bigint generated always as identity primary key,
  session_id  uuid        not null,
  event       text        not null check (event in ('start','score')),
  ig_handle   text        not null check (ig_handle ~ '^[A-Za-z0-9._]{1,30}$'),
  consent     boolean     not null check (consent),
  score       smallint    check (score between 0 and 10),
  referrer    text,
  created_at  timestamptz not null default now(),
  check ((event = 'score') = (score is not null))
);
alter table public.rk101_events enable row level security;
revoke all on public.rk101_events from anon, authenticated;
grant insert on public.rk101_events to anon;
create policy rk101_anon_insert on public.rk101_events for insert to anon with check (true);

-- 조회용(대시보드 SQL 에디터에서): 방문별 아이디·점수
create or replace view public.rk101_summary with (security_invoker = true) as
select session_id,
       max(ig_handle)                                   as ig_handle,
       max(score)                                        as score,
       min(created_at) filter (where event='start')     as started_at,
       max(created_at) filter (where event='score')     as scored_at
from public.rk101_events group by session_id;
revoke all on public.rk101_summary from anon, authenticated;
