# Meeting Knowledge Base

LLM이 컴파일·관리하는 마크다운 위키. Obsidian 뷰어, Claude가 wiki/ 전체를 생성·수정한다.

## 구조

```
raw/          # 읽기 전용 원본 (meetings/, gdd/, feedback/)
wiki/         # LLM 컴파일 영역
  index.md    # 라우터 — wiki 문서 키워드 테이블 + 서브인덱스 포인터
  index-meetings.md   # 회의록 서브인덱스 (85건)
  index-feedback.md   # 피드백/퍼블리셔 서브인덱스 (24건)
  log.md      # append-only 작업 로그 (## [YYYY-MM-DD] 작업유형 | 제목)
  concepts/   # 주제별 통합 정리
  decisions/  # 확정 결정사항 (날짜 + 맥락 + 결론)
  timeline/   # 월별·마일스톤 시간순 정리
output/       # Q&A 결과물, 슬라이드
```

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
---
```

선택 필드: `aliases`, `related: [{ doc, rel }]`
관계 유형: `parent-of`, `child-of`, `part-of`, `contradicts`, `supersedes`, `depends-on`

## 작업 패턴

### Ingest (새 원본 추가)
새 원본 1건 → index.md(라우터) + 해당 서브인덱스(index-meetings/index-feedback) + log.md 필수 업데이트 + 관련 concepts/decisions/timeline 터치 (목표 5~15페이지)

### Query (Two Outputs) — 2단계 라우팅
1. **1단계**: index.md(라우터)만 읽는다 → 키워드 테이블로 관련 wiki 문서 식별
2. **2단계**: 원본이 필요하면 해당 서브인덱스(index-meetings 또는 index-feedback)를 읽어 특정 원본 찾기
3. 관련 wiki/ → 필요시 raw/ 참조 → **답변**
4. 새로운 합성이 나왔으면 → **wiki 업데이트** + log.md 기록
- ⚠️ 서브인덱스를 매번 모두 읽지 않는다 — 라우터 키워드로 판단 후 필요한 것만 읽는다

### Lint (헬스체크)
문서 간 불일치, 누락 백링크, 미등록 결정사항, frontmatter 점검, index.md 파일목록 검증, **순방향 참조 규칙 준수 점검** → log.md 기록
