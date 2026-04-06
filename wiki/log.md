---
title: Wiki Log
type: meta
created: 2026-04-06
updated: 2026-04-06
tags: [log, meta]
---

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

## [2026-04-06] lint | Karpathy 패턴 재점검

- people/ 7개 문서에 누락된 `type: person` 추가
- index.md, log.md에 `type: meta` frontmatter 추가
- CLAUDE.md type 체계에 `meta` 타입 추가 (위키 운영 문서용)


## [2026-04-06] ingest | raw/feedback/ MD 변환 파일 9건 위키 통합

- **대상**: raw/feedback/ 내 PDF/XLSX/DOCX → MD 변환 완료된 9개 파일
  - Minicraft_0.0.6 사업팀 피드백 취합.md (사업팀 9명)
  - 미니크래프트_0.0.6_B팀 테스트 피드백.md (B팀 12명)
  - 미니크래프트 2차 테스트(응답).md (M5 플레이테스트 응답 원본)
  - 미니크래프트_0.0.6_럭키배틀 피드백 by PCELL.md (PCELL 외부)
  - comtus_타이니캣어셈블_옥석감정단평가서.md (Comtus, 옥 PASSED 86.6%)
  - comtus_Tiny Cat Assemble_FunQA.md (Comtus FunQA 3.7/5)
  - user_tiny_after.docx.md (유저 상세 UX 피드백 23항목)
  - Review_Tiny Cat Assemble _ Planet Busters_20260406.md (최신 리뷰)
  - Survey_Tiny Cat Assemble _ Planet Busters_20260406.md (최신 설문)
- **삭제 처리**: Minicraft_Eng.csv, ミニクラフト アンケート.csv (MD 미변환, 원본 삭제)
- **index.md**: 피드백 섹션 재편 (비마크다운→MD 위키링크), 카운트 23→21, 총215→213
- **신규 생성**: wiki/concepts/외부-파트너-평가.md (Comtus·PCELL·사업팀 평가 종합)
- **업데이트**: 플레이테스트-유저피드백.md (출처 9개 추가, 3개 새 섹션), BM & 모네타이제이션.md (사업팀 BM 피드백), 튜토리얼-온보딩.md (외부 공통 지적 정리)

## [2026-04-06] query | 택틱 시스템 변화 흐름

- 질문: 택틱 시스템이 어떻게 변화해 왔는가
- concepts/택틱 시스템.md, decisions/택틱-시스템.md 참조
- decisions/택틱-시스템.md에 반복 패턴 분석 섹션 추가 (랜덤성 vs 전략적 빌드업 긴장 구조)

## [2026-04-06] query | 미니크래프트 빌드 진화 단계

- 질문: 전체적인 모습이 완전히 다른 버전으로 느껴지는 빌드 시기와 형태
- 4개 타임라인 문서 전체 참조
- 신규 생성: wiki/concepts/빌드-진화-단계.md (6개 시기 정리)

## [2026-04-06] query | NCsoft vs 일반 유저 피드백 비교 분석

- 질문: 퍼블리셔 NCsoft와 일반 유저 피드백의 교차점·이격점 인사이트
- 참조: [0303] nc피드백 정리, [0306] nc피드백 2차, NCsoft BM 제안 (3월 20일), FGT 유저피드백_1, FGT 결과 (0119), TGS 설문, 내부 플레이테스트 시계열
- **교차점**: 전설 유닛 접근성(완전 합의), 스테이지 단조로움, 랜덤성 과다, 시인성
- **이격점**: 머지 USP(NC=핵심재미 vs 유저=자동화 요청), 관심 축(NC=BM/아웃게임 vs 유저=인게임 흐름), 전략 깊이 vs 캐주얼 편의
- **핵심 인사이트**: 머지 정체성 충돌이 마케팅·UX 방향성 딜레마. 전설 유닛 접근성이 유일한 완전 합의 지점.
- **업데이트**: wiki/concepts/외부-파트너-평가.md에 NCsoft 섹션 추가 + NC vs 유저 비교 분석 테이블 추가

## [2026-04-06] ingest | TGS 설문 CSV 2건 복원·MD 변환·위키 연결

- **복원**: git checkout HEAD로 삭제된 CSV 2개 복원
  - ミニクラフト アンケート.csv (일본어, 124명, TGS 2025-09-25)
  - Minicraft_Eng.csv (영문, 12명, TGS 2025-09-28)
- **MD 변환**: 집계·분석 포함한 마크다운 문서 생성
  - raw/feedback/ミニクラフト アンケート.md
  - raw/feedback/Minicraft_Eng.md
- **index.md**: 피드백 수 21→23, 총 213→215로 복원. TGS 설문 2건 위키링크 추가
- **플레이테스트-유저피드백.md**: 출처 2개 추가, TGS 원본 데이터 비교표 섹션 추가

## [2026-04-06] ingest | GDD raw/gdd/ 114건 전체 심층 인제스트

- **대상**: raw/gdd/ 6개 카테고리 전체 (01_Core 11 + 02_System 44 + 03_Content 14 + 04_BM 13 + 05_UX 22 + 06_Feedback 10)
- **방식**: 파일 본문 전체 읽기 → 핵심 수치·규칙·설계 결정사항 추출 → concepts 반영
- **업데이트된 concepts** (14개):
  - 머지-카드-시스템, 유닛-속성-밸런스, 성장시스템-경제, 지휘관-배틀슈트
  - 튜토리얼-온보딩, 이벤트-시즌운영, 택틱 시스템, 빌드-진화-단계
  - 덱-저장-관리, 랭킹-경쟁시스템, 유물-시스템, 운과-확률-메커니즘
  - 스폰-몬스터-시스템, BM & 모네타이제이션, UI-UX-폴리싱
- **신규 생성 concepts** (5개):
  - 게임-컨셉-방향성 (장르/타겟/채널 경쟁 구조/LTV)
  - 스토리-세계관 (카마존 SF 블랙코미디, 미적용 상태)
  - 인게임-전체설계 (15웨이브 구조, 전설 2-트랙, 유물 경제)
  - 연출-이펙트 (승급·전투시작·결과창 MVP 연출 규격)
  - 성장-가이드-시스템 (7지표 진단, 5단계 분기 가이드)
- **index.md**: concepts 19→25개, 신규 7개 항목 추가

## [2026-04-06] ingest | NCsoft_TinyCatAssemble 피드백_20260303.xlsx MD 변환·위키 연결

- **대상**: raw/feedback/NCsoft_TinyCatAssemble 피드백_20260303.xlsx (3-Sheet, Ver.0.0.10)
- **MD 변환**: raw/feedback/NCsoft_TinyCatAssemble 피드백_20260303.md 생성
  - Sheet 1: 주요 논의 피드백 (7대 이슈 + 개선방향 + 벤치마크 비교)
  - Sheet 2: 제안 요약 (배경, 핵심 제안, 세부 이슈 7개, Phase 1 우선순위)
  - Sheet 3: 참고 Ver.0.0.1.0 플레이 의견 (5개 분류 테스터 상세 피드백)
- **index.md**: 피드백 수 23→24, 총 215→216. 피드백 섹션 + 퍼블리셔 섹션 모두 위키링크로 갱신
- **외부-파트너-평가.md**: NCsoft 섹션(7번)에 xlsx 상세 내용 추가 (7대 이슈 테이블, Phase 1, 벤치마크), 비교 테이블에 행 추가
- **BM & 모네타이제이션.md**: NCsoft 공식 피드백 — 과금 가치 구조 섹션 추가 (다이아 소비 동선, 전설 중심 BM, 유닛 성장 매력도)
- **유닛-속성-밸런스.md**: NCsoft 공식 피드백 — 밸런스 및 유닛 역할 섹션 추가 (등급 간 성능 격차, 유닛 역할 부재)
- **UI-UX-폴리싱.md**: NCsoft 공식 피드백 — UI/UX 이슈 섹션 추가 (전황 파악 방해, 배치 로직, 덱 가시성, UI 버그 10건)
- **머지-카드-시스템.md**: NCsoft 공식 피드백 — 머지 정체성 이슈 섹션 추가 (역체감 구조, 카드 메타 전환 제안, 레시피 패턴 없음)

## [2026-04-06] ingest | 바이너리 3건 변환 + wiki 통합 (PDF 2건, DOCX 1건)

### 변환 내역
- `raw/meetings/TCA_0.0.12_빌드 작업 내역.pdf` → `.md` (markitdown, PDF→MD, 원본 .archive/meetings/ 이동)
- `raw/meetings/[260305]TCA_2월 빌드 피드백에 대한 개선 방향.docx` → `.md` (markitdown, DOCX→MD, 원본 .archive/meetings/ 이동)
- `raw/feedback/Ncsoft회의록_260310.pdf` → `.md` (markitdown, PDF→MD, 원본 .archive/feedback/ 이동)

### wiki 업데이트 (7개 파일)
- **index.md**: [260305] 신규 행 추가, TCA_0.0.12 행 추가, Ncsoft회의록_260310 위키링크 업데이트, 총 원본 수 216→218
- **유닛-속성-밸런스.md**: 전설 기본:시너지 50:50 섹션, 카드 확률 배치점수 보정 표, 공용 스탯 배치, 리롤 풀 보정 추가
- **외부-파트너-평가.md**: NC-SR 공식 회의(2026-03-10) 섹션 신규 추가 (참석자, 결정사항, 액션 아이템 5건, IAA 전망)
- **decisions/코어-메커닉.md**: 3개 결정사항 추가 (전설 50:50, 배치점수 보정 도입, 유닛 승계 3/20 검증)
- **timeline/2026-Q1.md**: 3월 주요 논의에 03/05·03/10 항목 추가, 핵심 변화 3개 항목 추가
