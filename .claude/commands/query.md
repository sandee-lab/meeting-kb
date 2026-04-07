wiki 기반으로 질문에 답변하고, 새로운 지식을 wiki에 반영한다 (Two Outputs).

## 입력
$ARGUMENTS — 사용자의 질문

## 절차

### 1단계 — 검색: Grep으로 매칭 파일 특정
- `Grep pattern="키워드" path="wiki/" output_mode="files_with_matches" head_limit=0`
- **head_limit=0** (wiki/는 55개 이하이므로 전체 반환)
- 파일명만으로 핵심 2~3개를 특정할 수 있으면 → 바로 2단계로

### 1-1단계 — 보조 (필요시): index.md 라우팅 참조
- Grep 결과만으로 **어떤 파일이 핵심인지 판단이 불확실할 때만** index.md를 읽는다
- 도메인 코드 + 요약 + concept↔decision 관계로 판단
- ⚠️ index.md에서 microindex·다른 인덱스로 순차 탐색하지 않는다
- ⚠️ index-meetings.md / index-feedback.md는 LLM 라우팅에 사용하지 않는다 (사람용)

### 2단계 — 직독: 특정된 wiki/ 문서를 읽어 답변 구성

### 3단계 — 보충 (필요시): raw/ 원본 참조
- wiki/에 없거나 부족하면 → `Grep pattern="키워드" path="raw/"` → 원본 직독
- 도메인 전체 맥락이 필요할 때만 index-raw-XX 마이크로인덱스 참조
- ⚠️ 마이크로인덱스를 여러 개 읽지 않는다 — 필요한 도메인만

### 4단계 — 출력
- **Output 1: 답변** — 질문에 대한 직접 응답
- **Output 2: wiki 업데이트** — 새로운 합성/정리가 나왔다면:
  - 관련 concepts/, decisions/ 문서 업데이트
  - 새 주제라면 concepts/ 생성 제안
  - 새/수정 문서에 `domain`, `summary` frontmatter 필수
- 유의미한 Q&A인 경우 log.md에 query 항목 추가
- 장문 결과물은 output/에 저장할지 묻는다
