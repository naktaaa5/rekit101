# rekit101 — 일하는 성향 분석 (RE:KIT 101 연동 페이지)

정적 페이지 하나(`index.html`) + 오브 이미지(`orb_ref.png`). GitHub Pages 로 배포한다.

- 로컬 보기: `python3 -m http.server 8788` → http://localhost:8788
- 수집: Supabase(AX 콕핏 프로젝트) `rk101_events` 에 insert 만. 조회는 대시보드에서 `select * from rk101_summary`. 표·권한은 `supabase/schema.sql`.
- 카운터: `START` 상수(오픈 시각) 기준, 768명에서 시작. 연출용 숫자이며 실제 응답 수가 아니다.
- 기획·와이어프레임 원본: 볼트 `40_프로젝트/RE-KIT/101_성향분석페이지/`
