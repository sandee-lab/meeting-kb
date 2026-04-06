# Wiki Log

> 모든 ingest, query, lint 작업을 시간순으로 기록하는 append-only 로그.
> 형식: `## [YYYY-MM-DD] 작업유형 | 제목`

---

## [2026-04-06] ingest | 초기 컴파일

- raw/meetings/ 72개 회의록 전체 인덱싱
- wiki/index.md 생성 (전체 목록 + 한줄 요약)
- concepts/ 8개 주제 문서 생성 (머지, 유닛, 택틱, BM, UI/UX, 피드백, 튜토리얼, 경제)
- decisions/ 8개 결정사항 문서 생성
- timeline/ 4개 월별 타임라인 문서 생성

## [2026-04-06] ingest | raw/ 경로 재구성

- raw/ → raw/meetings/ 경로 이동 반영
- 전체 위키링크 334개 일괄 수정

## [2026-04-06] ingest | 피드백·퍼블리셔 원본 추가

- raw/feedback/ 23개 문서 인덱싱 (md/xlsx/pdf/csv/docx)
- raw/publisher/ 5개 문서 인덱싱
- concepts/플레이테스트-유저피드백, BM & 모네타이제이션, 성장시스템-경제 업데이트
- decisions/BM-수익화, 마일스톤-일정 업데이트

## [2026-04-06] ingest | GDD 기획서 115건 연결

- raw/gdd/ 6개 카테고리 115건 위키 연결
- 신규 concepts 6개 생성, 기존 concepts 8개 GDD 출처 보강
- index.md에 GDD 목록 섹션 추가

## [2026-04-06] lint | 헬스체크 1차

- [0213] 중복 제거 (2026년 문서)
- 피드백 누락 2건 추가 (9월18일/2월13일)
- 헤더 숫자 보정 (53+12+3=68)
- 삭제된 파일 22개 정리

## [2026-04-06] lint | 헬스체크 2차

- 누락 회의록 19건 등록
- decisions 상충 6건 최종결정 명시
- 미등록 결정사항 10건 추가
- 신규 concepts 4건 생성 (사운드/확률/스폰/난이도)
- 크로스 레퍼런스 9쌍 보강

## [2026-04-06] ingest | 기존 concepts GDD 본문 상세 추가

- 기존 concepts 8개에 GDD 본문 상세 섹션 추가

## [2026-04-06] structure | Karpathy LLM Wiki 패턴 점검 및 구조 개선

- wiki/log.md 생성 (append-only 작업 로그)
- wiki/people/ 초기 문서 생성 (7명)
- CLAUDE.md 업데이트: log.md 규칙, Two Outputs 원칙, frontmatter 표준, 관계유형, ingest 범위 가이드 추가
- 기존 wiki/ 문서 30개에 YAML frontmatter 추가
