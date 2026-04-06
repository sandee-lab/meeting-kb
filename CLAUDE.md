# Meeting Knowledge Base

LLM이 컴파일·관리하는 마크다운 위키. Obsidian 뷰어, Claude가 wiki/ 전체를 생성·수정한다.

## 구조

```
raw/          # 읽기 전용 원본 (meetings/, gdd/, feedback/, publisher/)
wiki/         # LLM 컴파일 영역
  index.md    # 라우터 — 전체 목록 + 한줄 요약, 항상 최신 유지
  log.md      # append-only 작업 로그 (## [YYYY-MM-DD] 작업유형 | 제목)
  concepts/   # 주제별 통합 정리
  decisions/  # 확정 결정사항 (날짜 + 맥락 + 결론)
  timeline/   # 월별·마일스톤 시간순 정리
  people/     # 담당자별 관여 이력
output/       # Q&A 결과물, 슬라이드
```

## 규칙

- **raw/ 불변** — 절대 수정·삭제·이동하지 않는다
- **사실만 기록** — 원본에 없는 내용을 추론하지 않는다. 불확실하면 `(미확인)` 표기
- **한국어** 작성, **Obsidian 위키링크** `[[]]` 사용, 출처 명시 (`> 출처: [[원본]]`)
- **외부 피드백과 내부 논의**를 구분하여 기록

## Frontmatter

모든 wiki/ 문서 상단:

```yaml
---
title: 제목
type: concept | decision | timeline | person | meta
created: YYYY-MM-DD
updated: YYYY-MM-DD
tags: [태그]
---
```

선택 필드: `aliases`, `role` (person), `related: [{ doc, rel }]`
관계 유형: `parent-of`, `child-of`, `part-of`, `contradicts`, `supersedes`, `depends-on`

## 작업 패턴

### Ingest (새 원본 추가)
새 원본 1건 → index.md, log.md 필수 업데이트 + 관련 concepts/decisions/timeline/people 터치 (목표 5~15페이지)

### Query (Two Outputs)
1. index.md → 관련 wiki/ → 필요시 raw/ 참조 → **답변**
2. 새로운 합성이 나왔으면 → **wiki 업데이트** + log.md 기록

### Lint (헬스체크)
문서 간 불일치, 누락 백링크, 미등록 결정사항, frontmatter 점검, index.md 파일목록 검증 → log.md 기록
