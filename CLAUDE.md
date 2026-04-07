# Meeting Knowledge Base

LLM이 컴파일·관리하는 마크다운 위키. Obsidian 뷰어, Claude가 wiki/ 전체를 생성·수정한다.

## 구조

```
raw/          # 읽기 전용 원본 (meetings/, gdd/, feedback/)
wiki/         # LLM 컴파일 영역
  index.md    # 라우터 — 도메인 코드 + 요약 + 서브인덱스 포인터
  index-raw-XX.md    # 도메인별 원본 마이크로인덱스 (CM/UB/TC/BM/UX/GE/CT/MP)
  index-meetings.md  # (사람용) 회의록 시간순 전체보기 (85건)
  index-feedback.md  # (사람용) 피드백 전체보기 (24건)
  log.md      # append-only 작업 로그 (## [YYYY-MM-DD] 작업유형 | 제목)
  concepts/   # 주제별 통합 정리
  decisions/  # 확정 결정사항 (날짜 + 맥락 + 결론)
  timeline/   # 월별·마일스톤 시간순 정리
output/       # Q&A 결과물, 슬라이드
```

## 도메인 코드

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

## 규칙

- **raw/ 불변** — 절대 수정·삭제·이동하지 않는다
- **사실만 기록** — 원본에 없는 내용을 추론하지 않는다. 불확실하면 `(미확인)` 표기
- **구현 상태 구분** — GDD 기획서 내용을 기술할 때 실제 구현 여부를 반드시 명시한다. 원본의 `상태` 필드가 `superseded`·`draft`이거나 구현 여부가 불명확한 경우 `(아이디어 단계, 미구현)` 또는 `(미확인)` 으로 표기한다. "기획됨"과 "실제 구현됨"을 혼용하지 않는다
- **한국어** 작성, **Obsidian 위키링크** `[[]]` 사용, 출처 명시 (`> 출처: [[원본]]`)
- **외부 피드백과 내부 논의**를 구분하여 기록
- **순방향 참조만** — `## 관련 문서`에는 해당 문서의 이해에 직접 필요한 링크만 기재한다. 역방향 링크는 Obsidian 백링크 패널이 자동 처리하므로 수동 유지하지 않는다
  - concepts → decisions: 해당 concept에 영향을 준 핵심 결정 1~2개
  - concepts → concepts: 직접 의존하는 concept만 (A가 B 없이 설명 불가할 때만 A→B)
  - concepts → timeline: 원칙적으로 불필요 (timeline은 라우터로 탐색)
  - decisions → concepts: 결정의 주제가 되는 주 concept 1개
  - timeline → concepts: 해당 시기의 핵심 주제 concept (월별 2~4개)

## Frontmatter

모든 wiki/ 문서 상단:

```yaml
---
title: 제목
type: concept | decision | timeline | meta
created: YYYY-MM-DD
updated: YYYY-MM-DD
tags: [태그]
domain: XX              # 주 도메인 코드 (필수)
domain_sub: [YY]        # 보조 도메인 (선택)
summary: "한줄 요약"    # 15~30자 (필수)
---
```

선택 필드: `aliases`, `related: [{ doc, rel }]`
관계 유형: `parent-of`, `child-of`, `part-of`, `contradicts`, `supersedes`, `depends-on`

## 작업 패턴

### Ingest (새 원본 추가)
새 원본 1건 → 주 도메인 분류 → index.md(라우터) + 해당 도메인 마이크로인덱스(index-raw-XX) + log.md 필수 업데이트 + 관련 concepts/decisions/timeline 터치 (목표 5~15페이지)
- 새로 생성/수정하는 wiki 문서에 `domain`, `summary` frontmatter 필수 포함

### Query (Two Outputs)
1. **1단계 — 탐색**: Grep으로 wiki/ 내 키워드 검색 → 해당 문서 직독으로 답변 구성
   - wiki/에서 충분하면 여기서 완료
   - wiki/에 없거나 부족하면 → Grep으로 raw/ 검색 → 원본 참조
2. **2단계 — 보충** (필요시): index.md 라우터나 index-raw-XX 마이크로인덱스는 도메인 전체 맥락이 필요할 때만 읽는다
3. 관련 wiki/ + raw/ 참조 → **답변**
4. 새로운 합성이 나왔으면 → **wiki 업데이트** + log.md 기록
- ⚠️ Grep 1회로 관련 문서를 특정한 뒤 읽는다 — 인덱스를 순차적으로 타고 내려가지 않는다

### Lint (헬스체크)
문서 간 불일치, 누락 백링크, 미등록 결정사항, frontmatter 점검(`domain`·`summary` 필수), index.md 파일목록 검증, **순방향 참조 규칙 준수 점검** → log.md 기록
