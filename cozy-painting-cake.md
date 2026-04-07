# Wiki 검색 속도 최적화: 도메인 코드 + 마이크로 인덱스

## Context

현재 위키 쿼리 시 토큰 소모가 크고 느린 이유:
- **서브인덱스가 단일 파일**: index-meetings.md(180줄, ~10,000 토큰)를 회의 1건 찾기 위해 전부 로드
- **태그 체계 불일치**: wiki 태그, GDD 태그, index.md 키워드가 각각 다른 어휘 사용
- **요약 부재**: index.md에 한 줄 요약이 없어 문서를 열어봐야 관련성 판단 가능

조사 결과 Karpathy LLM Wiki, A-MEM(제텔카스텐+LLM), Knowledge Engine 등의 접근법을 참고하여 **마크다운 전용(Obsidian 호환)** 범위 내에서 최적화안을 설계함.

## 핵심 아이디어: 8개 도메인 코드

| 코드 | 도메인 | 대표 키워드 |
|------|--------|------------|
| CM | 코어메커닉 | 머지, 카드, 소환, 코어루프, 승급 |
| UB | 유닛밸런스 | 유닛, 속성, 시너지, 등급, 전설, 스폰 |
| TC | 택틱 | 택틱, 드로우, 진화, 스택, 리롤 |
| BM | BM수익화 | 과금, 광고, 배틀패스, 패키지 |
| UX | UX폴리싱 | UI, UX, 연출, 사운드, 이펙트 |
| GE | 성장경제 | 골드, 자원, 경제, 장비, 유물, 성장 |
| CT | 콘텐츠모드 | 던전, 랭킹, 이벤트, 시즌, 덱 |
| MP | 메타프로젝트 | 컨셉, 방향성, 피드백, 마일스톤, 튜토리얼, 스토리 |

## 예상 토큰 절감

| 시나리오 | 현재 | 개선 후 | 절감 |
|---------|------|---------|-----|
| 광범위 주제 검색 | 16,500~24,500 | 8,700~13,700 | **~45%** |
| 결정사항 조회 | 11,500~17,500 | 4,200~8,200 | **~55%** |
| 특정 도메인 원본 탐색 | ~16,000 | ~4,700 | **~70%** |

## 구현 3단계

### Phase 1: index.md 강화 (가장 큰 효과, 가장 낮은 위험)

**변경 1-1**: 모든 wiki 문서 frontmatter에 3개 필드 추가
```yaml
domain: CM              # 주 도메인 코드 (필수)
domain_sub: [UB]        # 보조 도메인 (선택)
summary: "머지+럭가챠 코어루프, 승급전설 시스템"  # 한줄 요약 (필수)
```

**변경 1-2**: index.md를 제텔카스텐 ID + 요약 포맷으로 개편
```
## 도메인 코드
(위 표 삽입)

## concepts → decisions
CM.01 [[concepts/머지-카드-시스템]] | 머지+럭가챠 코어루프, 승급전설 시스템 | → D.CM.01 [[decisions/코어-메커닉]](16)
UB.01 [[concepts/유닛-속성-밸런스]] | 5속성 시너지·등급체계·전설 조합식 | → D.UB.01 [[decisions/유닛-밸런스]](36)
...

## timeline
T1 [[timeline/2024-Q4]] | 기획초안→M2착수 | CM,MP
```

**대상 파일** (34개):
- `wiki/index.md` — 포맷 개편
- `wiki/concepts/*.md` 26개 — frontmatter 추가
- `wiki/decisions/*.md` 8개 — frontmatter 추가 (이미 있는 필드 유지)

### Phase 2: 도메인별 마이크로 인덱스 (최대 토큰 절감)

현재 단일 index-meetings.md(85건, ~10K 토큰) → **8개 도메인별 micro-index로 분할**

**새 파일 8개 생성**:
- `wiki/index-raw-CM.md` — 코어메커닉 관련 원본 (~25건, ~1,500 토큰)
- `wiki/index-raw-UB.md` — 유닛밸런스 관련 원본 (~30건)
- `wiki/index-raw-TC.md`, `index-raw-BM.md`, `index-raw-UX.md`, `index-raw-GE.md`, `index-raw-CT.md`, `index-raw-MP.md`

**micro-index 포맷**:
```markdown
---
title: 코어메커닉 원본 인덱스
type: meta
tags: [index, raw, CM]
---

## meetings
| 날짜 | 원본 | 요약 |
|------|------|------|
| 10/29 | [[raw/meetings/[1029] 기획 방향 초안]] | 머지+럭가챠 코어, 세로뷰 기획초안 |

## feedback
| 날짜 | 원본 | 요약 |
|------|------|------|

## GDD
| 원본 | 요약 |
|------|------|
```

**기존 파일 처리**: index-meetings.md, index-feedback.md는 삭제하지 않고 사람용 전체보기로 보존. LLM 라우팅에서는 micro-index만 사용.

**작업**: 85건 회의 + 24건 피드백 + GDD 139건의 주 도메인 분류 필요.

### Phase 3: 스킬(query/ingest/lint) 업데이트

**query.md 개편**:
```
1. index.md 읽기 → 도메인 코드 + 요약으로 관련 문서 식별
2. 원본 필요시: 해당 도메인의 index-raw-XX.md만 읽기 (전체 서브인덱스 X)
3. wiki/ 문서 읽기 → raw/ 참조 → 답변
```

**ingest.md 개편**:
- 새 원본의 주 도메인 분류 단계 추가
- index.md 대신 해당 도메인의 micro-index에 항목 추가
- index.md 라우터 테이블도 업데이트

**lint.md 개편**:
- `domain`, `summary` frontmatter 필수 필드 점검 추가
- index.md 요약과 frontmatter summary 일치 여부 검증

**CLAUDE.md 업데이트**:
- 도메인 코드 테이블 추가
- Query 절차의 2단계 라우팅 설명을 도메인 기반으로 수정
- frontmatter 필수 필드에 `domain`, `summary` 추가

## 대상 파일 목록

| 파일 | 작업 |
|------|------|
| `wiki/index.md` | 포맷 전면 개편 |
| `wiki/concepts/*.md` (26개) | frontmatter에 domain/summary 추가 |
| `wiki/decisions/*.md` (8개) | frontmatter에 domain/summary 추가 |
| `wiki/timeline/*.md` (4개) | frontmatter에 domain/summary 추가 |
| `wiki/index-raw-*.md` (8개 신규) | 도메인별 micro-index 생성 |
| `CLAUDE.md` | 도메인 코드 + 수정된 Query 절차 |
| `.claude/commands/query.md` | 도메인 라우팅 절차 |
| `.claude/commands/ingest.md` | 도메인 분류 + micro-index 업데이트 |
| `.claude/commands/lint.md` | domain/summary 필수 필드 점검 |

## 하지 않는 것

- **벡터 DB 추가 안 함** — 이 규모(248건)에서 불필요. 마크다운 인덱스로 충분
- **concept 파일 분할 안 함** — 최대 43KB도 LLM이 한 번에 처리 가능
- **JSON 스키마 레이어 안 함** — frontmatter YAML이 이미 그 역할 수행
- **raw 248개에 개별 ID 안 붙임** — 도메인 micro-index로 접근, 개별 ID 불필요

## 검증 방법

1. Phase 1 완료 후: `/query 전설 유닛 밸런스 히스토리` 실행 → 서브인덱스 로딩 없이 UB 도메인 직접 라우팅 확인
2. Phase 2 완료 후: `/query BM 과금 구조 정리` 실행 → index-raw-BM.md만 로딩되는지 확인
3. Phase 3 완료 후: `/ingest` 새 문서 추가 → micro-index에 정확히 분류되는지 확인 + `/lint` 실행 → domain/summary 필드 점검 동작 확인

## 참고 소스

- [Karpathy LLM Wiki gist](https://gist.github.com/karpathy/442a6bf555914893e9891c11519de94f)
- [A-MEM: Agentic Memory for LLM Agents](https://arxiv.org/abs/2502.12110)
- [Knowledge Engine (Karpathy + Memvid)](https://github.com/tashisleepy/knowledge-engine)
- [LLM Wiki vs RAG 비교](https://www.mindstudio.ai/blog/llm-wiki-vs-rag-markdown-knowledge-base-comparison)
