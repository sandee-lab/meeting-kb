wiki 기반으로 질문에 답변하고, 새로운 지식을 wiki에 반영한다 (Two Outputs).

## 입력
$ARGUMENTS — 사용자의 질문

## 절차
1. wiki/index.md를 읽어 관련 문서를 파악한다
2. 관련 wiki/ 문서를 읽는다
3. 필요하면 raw/ 원본을 참조한다
4. **Output 1: 답변** — 질문에 대한 직접 응답을 제공한다
5. **Output 2: wiki 업데이트** — 답변 과정에서 새로운 합성/정리가 나왔다면:
   - 관련 concepts/, decisions/ 문서를 업데이트한다
   - 새로운 주제라면 concepts/ 문서 생성을 제안한다
6. 유의미한 Q&A인 경우 log.md에 query 항목을 추가한다
7. 장문 결과물은 output/에 저장할지 묻는다
