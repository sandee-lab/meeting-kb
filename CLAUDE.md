# Meeting Knowledge Base

LLM이 컴파일·관리하는 마크다운 위키. Obsidian 뷰어, Claude가 wiki/ 전체를 생성·수정한다.

## 구조

```
raw/          # 읽기 전용 원본 (meetings/, gdd/, feedback/)
wiki/         # LLM 컴파일 영역
  index.md    # 라우터 — 전체 목록 + 한줄 요약, 항상 최신 유지
  log.md      # append-only 작업 로그 (## [YYYY-MM-DD] 작업유형 | 제목)
  concepts/   # 주제별 통합 정리
  decisions/  # 확정 결정사항 (날짜 + 맥락 + 결론)
  timeline/   # 월별·마일스톤 시간순 정리
output/       # Q&A 결과물, 슬라이드
```

## 규칙

- **raw/ 불변** — 절대 수정·삭제·이동하지 않는다
- **사실만 기록** — 원본에 없는 내용을 추론하지 않는다. 불확실하면 `(미확인)` 표기
- **한국어** 작성, **Obsidian 위키링크** `[[]]` 사용, 출처 명시 (`> 출처: [[원본]]`)
- **외부 피드백과 내부 논의**를 구분하여 기록
- **양방향 링크 유지** — concepts ↔ decisions, concepts ↔ timeline 링크는 반드시 양방향으로 유지한다
  - decisions 문서가 concepts를 참조하면, 해당 concepts의 `## 관련 문서`에 역방향 링크 필수
  - timeline 문서가 concepts를 참조하면, 해당 concepts의 `## 관련 문서`에 역방향 링크 필수
  - concepts ↔ concepts 상호 참조 시 `## 관련 문서` 양쪽 모두에 반영

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
새 원본 1건 → index.md, log.md 필수 업데이트 + 관련 concepts/decisions/timeline 터치 (목표 5~15페이지)

### Query (Two Outputs)
1. index.md → 관련 wiki/ → 필요시 raw/ 참조 → **답변**
2. 새로운 합성이 나왔으면 → **wiki 업데이트** + log.md 기록

### Lint (헬스체크)
문서 간 불일치, 누락 백링크, 미등록 결정사항, frontmatter 점검, index.md 파일목록 검증, **concepts 양방향 링크 점검** → log.md 기록
