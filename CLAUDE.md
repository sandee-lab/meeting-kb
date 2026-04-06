# Meeting Knowledge Base

회의록 원본(raw/meetings/)을 기반으로 LLM이 컴파일·관리하는 마크다운 위키 프로젝트.
Obsidian을 뷰어로 사용하며, 위키의 모든 파일은 Claude가 생성·수정한다.

## 디렉토리 구조

```
meeting-kb/
├── raw/                    # 원본 자료 (읽기 전용)
│   ├── meetings/           # 노션에서 내보낸 원본 회의록 (53개, 폴더별 .md + 이미지)
│   ├── gdd/                # 게임 디자인 문서 (105개, 6개 카테고리)
│   │   ├── 01_Core/        # 핵심 설계 (11개)
│   │   ├── 02_System/      # 시스템 기획 (43개 + gdd_index.csv)
│   │   ├── 03_Content/     # 콘텐츠 모드 (14개)
│   │   ├── 04_BM/          # 비즈니스 모델 (13개)
│   │   ├── 05_UX/          # UI/UX 폴리싱 (22개)
│   │   └── 06_Feedback/    # 피드백/작업 리스트 (10개)
│   ├── feedback/           # 내부 테스트 피드백 문서 (23개, .md/.xlsx/.pdf/.csv/.docx)
│   └── publisher/          # 퍼블리셔(Ncsoft) 관련 문서 (1개 .md + xlsx + pdf)
├── wiki/                   # LLM이 컴파일한 지식 베이스
│   ├── index.md            # 전체 목록 + 라우터
│   ├── log.md              # 작업 로그 (append-only, 시간순)
│   ├── concepts/           # 주제별 정리 — 18개
│   ├── timeline/           # 월별·마일스톤별 시간순 정리 — 4개
│   ├── decisions/          # 확정된 결정사항 모음 — 8개
│   └── people/             # 담당자별 관여 이력 — 7명
├── output/                 # Q&A 결과물, 슬라이드, 시각화
└── CLAUDE.md
```

## 핵심 규칙

### raw/ — 읽기 전용
- raw/meetings/, raw/gdd/, raw/feedback/, raw/publisher/ 모두 절대 수정·삭제·이동하지 않는다
- 노션 내보내기 원본 그대로 유지 (폴더별 .md + 이미지)
- 새 문서가 추가되면 해당 하위 폴더에 넣고, wiki를 증분 업데이트한다
- raw/gdd/: 게임 디자인 문서 (YAML frontmatter 포함, gdd_index.csv로 목록 관리)
- raw/feedback/: 내부 플레이 테스트 피드백 (6월~2월 + 외부 피드백, 다양한 포맷)
- raw/publisher/: 퍼블리셔(Ncsoft) 제안서, 피드백, 회의록

### wiki/ — Claude 전용 영역
- 모든 파일은 Claude가 생성하고 관리한다
- 사용자가 직접 편집하지 않는다
- 모든 문서에 Obsidian 위키링크 `[[파일명]]`를 사용하여 문서 간 연결한다
- 각 문서 상단에 출처 회의록을 명시한다: `> 출처: [[raw/meetings/[0102] 빌드 피드백 회의]]`
- wiki/ 문서 작성 시 외부 피드백과 내부 논의를 구분하여 기록한다

### index.md — 라우터 역할
- wiki/index.md는 항상 최신 상태를 유지한다
- 포함할 내용:
  - 전체 회의록 목록 (날짜, 제목, 한줄 요약)
  - concepts/, decisions/, timeline/, people/ 각 폴더의 문서 목록과 한줄 설명
  - 최근 업데이트 이력
- 이 파일을 먼저 읽으면 전체 위키의 내용을 파악할 수 있어야 한다

### log.md — 작업 로그 (append-only)
- wiki/log.md는 모든 ingest, query, lint 작업을 시간순으로 기록한다
- 형식: `## [YYYY-MM-DD] 작업유형 | 제목` + 변경 내용 bullet list
- 작업유형: `ingest` (새 원본 추가), `query` (유의미한 Q&A), `lint` (헬스체크), `structure` (구조 변경)
- 새 항목은 항상 기존 항목 아래에 추가한다 (append-only, 기존 내용 수정 금지)
- 세션 시작 시 log.md를 읽으면 위키의 변경 이력을 파악할 수 있어야 한다

### output/ — 결과물 저장
- Q&A 결과, 분석 문서, 슬라이드 등을 저장한다
- 유용한 결과물은 사용자 확인 후 wiki/에 재투입할 수 있다

## 컴파일 가이드라인

### 첫 번째 컴파일 (초기 세팅)
1. raw/meetings/의 모든 .md 파일을 읽는다
2. wiki/index.md를 생성한다 (전체 목록 + 한줄 요약)
3. 주요 반복 주제를 식별하여 concepts/ 문서를 생성한다
4. 주요 결정사항을 추출하여 decisions/ 문서를 생성한다
5. 월별 타임라인을 timeline/에 정리한다

### 증분 업데이트
- 새 회의록이 raw/meetings/에 추가되면:
  1. 새 파일만 읽는다
  2. index.md를 업데이트한다
  3. 관련 concepts/, decisions/ 문서를 업데이트한다
  4. 기존 문서와의 연결(백링크)을 추가한다

### 문서 작성 규칙
- 한국어로 작성한다
- 사실만 기록한다 — 회의록에 없는 내용을 추론하거나 추가하지 않는다
- 여러 회의에서 같은 주제가 등장하면 하나의 concepts/ 문서로 통합한다
- 결정사항은 날짜 + 맥락 + 결론을 반드시 포함한다
- 불확실한 정보는 `(미확인)` 태그를 붙인다

### YAML Frontmatter 표준
모든 wiki/ 문서 상단에 YAML frontmatter를 포함한다:

```yaml
---
title: 문서 제목
aliases: [별칭1, 별칭2]       # Obsidian 검색용 (선택)
type: concept | decision | timeline | person
created: YYYY-MM-DD
updated: YYYY-MM-DD
tags: [태그1, 태그2]
related:                       # 관계 유형 명시 (선택)
  - { doc: "문서명", rel: "parent-of | part-of | contradicts | supersedes | depends-on" }
---
```

- `type`: 문서 종류 (concept, decision, timeline, person)
- `created`: 최초 생성일
- `updated`: 마지막 수정일 (수정 시 반드시 갱신)
- `tags`: Obsidian/Dataview 쿼리용 태그
- `related`: 문서 간 관계 유형 (선택 사항, 복잡한 관계가 있을 때 사용)

### 관계 유형 (Typed Relationships)
위키링크 `[[]]`로 문서를 연결할 때, 필요하면 관계 유형을 명시한다:
- `parent-of` / `child-of`: 상위/하위 개념 (예: 밸런스 → PvP 밸런스)
- `part-of`: 구성요소 관계 (예: 택틱 시스템 → 코어 메커닉의 일부)
- `contradicts`: 상충하는 결정/의견
- `supersedes`: 이전 결정/문서를 대체
- `depends-on`: 선행 의존 관계

### Ingest 영향 범위 가이드
새 원본 문서 1건을 ingest할 때, 일반적으로 다음을 점검·업데이트한다:
1. **index.md** — 새 항목 추가 (필수)
2. **log.md** — ingest 로그 추가 (필수)
3. **concepts/** — 관련 주제 문서 1~5개 업데이트 또는 신규 생성
4. **decisions/** — 새 결정사항이 있으면 해당 문서 업데이트
5. **timeline/** — 해당 시기 타임라인 업데이트
6. **people/** — 새 참석자가 있으면 해당 문서 업데이트
7. **기존 문서 백링크** — 새 문서를 참조해야 하는 기존 문서에 링크 추가

목표: 1건의 원본이 평균 5~15개 wiki 페이지에 영향을 미치도록 한다.

## Q&A 패턴 (Two Outputs 원칙)

모든 작업은 두 가지 산출물을 낸다:
1. **즉각적 답변** — 사용자의 질문에 대한 직접 응답
2. **wiki 업데이트** — 답변 과정에서 도출된 새로운 합성/정리를 wiki에 반영

사용자가 질문하면:
1. wiki/index.md를 먼저 읽어 관련 문서를 파악한다
2. 관련 wiki/ 문서를 읽는다
3. 필요하면 raw/ 원본을 참조한다
4. 답변을 제공한다
5. 답변 과정에서 새로운 정리/합성이 나왔다면:
   - 관련 concepts/, decisions/ 문서를 업데이트한다
   - 새로운 주제라면 concepts/ 문서 생성을 제안한다
6. log.md에 query 항목을 추가한다 (유의미한 Q&A인 경우)
7. 장문 결과물은 output/에 저장할지 묻는다

## 린팅 (품질 관리)

사용자가 "헬스체크" 또는 "린팅"을 요청하면:
- 문서 간 불일치 탐지 (같은 사안에 대한 상충하는 기록)
- 누락된 백링크 식별
- 결정사항이 있지만 decisions/에 미등록된 항목 탐지
- 새로운 concepts/ 문서 후보 제안
- index.md가 실제 파일 목록과 일치하는지 검증
- frontmatter 누락·불일치 점검 (updated 날짜, tags, type 등)
- people/ 문서가 실제 참석자 목록과 일치하는지 검증
- log.md에 lint 결과를 기록한다
