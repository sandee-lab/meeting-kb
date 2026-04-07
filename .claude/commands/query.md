wiki 기반으로 질문에 답변하고, 새로운 지식을 wiki에 반영한다 (Two Outputs).

## 입력
$ARGUMENTS — 사용자의 질문

## 절차
1. wiki/index.md를 읽어 **도메인 코드 + 요약**으로 관련 문서를 파악한다
   - 도메인 코드 테이블에서 질문 키워드와 매칭되는 도메인 식별
   - 요약을 보고 관련 concept/decision을 특정 (문서를 열지 않고 판단)
2. 관련 wiki/ 문서를 읽는다
3. 원본이 필요하면 **해당 도메인의 마이크로인덱스(index-raw-XX)만** 읽어 특정 원본을 찾는다
   - ⚠️ 마이크로인덱스를 여러 개 읽지 않는다 — 필요한 도메인만 읽는다
   - ⚠️ index-meetings.md / index-feedback.md는 LLM 라우팅에 사용하지 않는다 (사람용 전체보기)
4. 필요시 raw/ 원본을 참조한다
5. **Output 1: 답변** — 질문에 대한 직접 응답을 제공한다
6. **Output 2: wiki 업데이트** — 답변 과정에서 새로운 합성/정리가 나왔다면:
   - 관련 concepts/, decisions/ 문서를 업데이트한다
   - 새로운 주제라면 concepts/ 문서 생성을 제안한다
   - 새/수정 문서에 `domain`, `summary` frontmatter 필수 포함
7. 유의미한 Q&A인 경우 log.md에 query 항목을 추가한다
8. 장문 결과물은 output/에 저장할지 묻는다
