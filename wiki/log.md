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

## [2026-04-06] ingest | TGS 설문 CSV 2건 복원·MD 변환·위키 연결

- **복원**: git checkout HEAD로 삭제된 CSV 2개 복원
  - ミニクラフト アンケート.csv (일본어, 124명, TGS 2025-09-25)
  - Minicraft_Eng.csv (영문, 12명, TGS 2025-09-28)
- **MD 변환**: 집계·분석 포함한 마크다운 문서 생성
  - raw/feedback/ミニクラフト アンケート.md
  - raw/feedback/Minicraft_Eng.md
- **index.md**: 피드백 수 21→23, 총 213→215로 복원. TGS 설문 2건 위키링크 추가
- **플레이테스트-유저피드백.md**: 출처 2개 추가, TGS 원본 데이터 비교표 섹션 추가
