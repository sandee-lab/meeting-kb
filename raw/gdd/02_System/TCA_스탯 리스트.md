---
제목: 스탯 리스트
카테고리: 02_System
상태: active
작성시점: 2026.04
원본: Docs/01_System/convert
대체문서: ""
키워드:
  - 스탯
  - 공격력
  - 체력
  - add_mul
  - 아웃게임
  - 인게임
관련_기획서:
  - Docs/00_Plan/TCA_스탯 리스트.md
---

# 스탯 리스트

> **요약:** 유닛 스탯 분류(아웃/인게임), add/mul 체계 및 계산 공식 정의. 물리·마법 피해 구분, 버프 스탯 분리 원칙 포함.
> **현재 상태:** 미적용

# 스탯 리스트

Created by: 해룡 정
Created time: 2026년 4월 7일 오후 2:07
Last updated time: 2026년 4월 7일 오후 2:08
상태: 진행 중
영역: 유닛
유형: 설계문서

## 스탯 관련 방향성

1. 기본적인 강화 수치들은 곱연산으로 처리한다. (다른 이름끼리 곱연산, 같은 이름끼리 합연산)
2. 물리, 마법 피해로 구분하고, 각각 연산을 다르게 처리한다.
3. 인게임 규칙에 따라서 초기화되지 않는 스탯은 스탯으로, 인게임에서 초기화되는 스탯은 효과(buff_) 스탯으로 처리한다.
4. 큰 틀에서는 테오크의 공식과 비슷한 방향이고, 몇 가지 달라지는 부분을 고려한다. (방어 계산, 효과 저항 계산)
5. 아웃게임, 인게임에서 공통으로 사용하는 스탯은 밸런스에 따라서 스탯을 분리하거나 아웃게임에서 주는 스탯의 수치를 제한적으로 관리할 수 있다.

---

# 기본 스탯

## 공격력

| 중분류 | 컨텐츠 구분 | 스탯 타입 | 스탯 설명 | 계산 예시 | 코멘트 |
| --- | --- | --- | --- | --- | --- |
| 기본 공격 | 아웃게임 | `add_atk` | 기본 공격력 | sum(add_atk) | - |
| 공격력 | 아웃게임 | `mul_atk_1` | %로 증가하는 공격력 | 공격력 계산에 곱연산 처리. _1, _2 형태로 종류 추가 가능. (1 + sum(mul_atk_1))  *(1 + sum(buff_mul_atk_1))*  (1 + sum(mul_atk_2))을 유닛 별 최종 공격력에 곱연산 | - |
| 공격력 증가 | 인게임 | `mul_atk_2` | %로 증가하는 공격력(택틱, 버프 등) | (1 + sum(mul_atk_1))  *(1 + sum(buff_mul_atk_1))*  (1 + sum(mul_atk_2) + (sum(mul_move_speed)  *atk_transition_from_move_speed_weight) + (sum(mul_max_hp_2)*  atk_transition_from_max_hp_2_weight))을 유닛 별 최종 공격력에 곱연산 | - |
| 공격력 증폭 | 인게임 | `mul_atk_3` | %로 증가하는 공격력(유닛 버프 효과) | (1 + sum(mul_atk_1))  *(1 + sum(buff_mul_atk_1))*  (1 + sum(mul_atk_2))을 유닛 별 최종 공격력에 곱연산 | - |

## 체력

| 중분류 | 컨텐츠 구분 | 스탯 타입 | 스탯 설명 | 계산 예시 | 코멘트 |
| --- | --- | --- | --- | --- | --- |
| 기본 체력 | 아웃게임 | `add_max_hp` | 기본 체력 | sum(add_max_hp) | - |
| 체력 | 아웃게임 | `mul_max_hp_1` | %로 증가하는 체력 | 최대 체력 계산에 곱연산 처리. 종류 늘어날 수 있음. (1 + sum(mul_max_hp_1)) * (1+ sum(buff_mul_max_hp_1))을 유닛 별 최종 체력에 곱연산 | - |
| 체력 증가 | 인게임 | `mul_max_hp_2` | %로 증가하는 체력(택틱, 버프 등) | 위와 동일 | - |
| 체력 증폭 | 인게임 | `mul_max_hp_3` | %로 증가하는 체력(유닛 버프 효과) | 위와 동일 | - |

## 치명타

| 중분류 | 컨텐츠 구분 | 스탯 타입 | 스탯 설명 | 계산 예시 | 코멘트 |
| --- | --- | --- | --- | --- | --- |
| 치명 확률 | 아웃게임 / 인게임 | `add_critical_rate` | 치명타 피해 발생 확률 | 최종 치명타 확률 = min((add_critical_rate), 1). 치명타 확률에 의해서 치명타 피해를 계산에 넣을지 결정 | - |
| 치명 피해 | 초기 값 | `add_critical_damage` | 치명타 피해 시 기본 증가량 (200%) | 치명타 판정 시에 적용되는 능력치. 대미지 * (1 + mul_critical_damage) | - |
| 치명 피해 증가 | 아웃게임 / 인게임 | `mul_critical_damage` | 치명타 발생 시 피해 증가 | - | - |

## 이동 속도

| 중분류 | 컨텐츠 구분 | 스탯 타입 | 스탯 설명 | 계산 예시 | 코멘트 |
| --- | --- | --- | --- | --- | --- |
| 기본 이동 속도 | 초기 값 | `add_move_speed` | 기본 이동 속도 값 | 이동 속도 = add_move_speed  *(1 + mul_move_speed)*  (1 + mul_move_speed_1). add_move_speed 값은 초기 값으로 게임에서 제공되지 않는다. | - |
| 이동 속도 증가 | 아웃게임 / 인게임 | `mul_move_speed` | 이동 속도 증가 % | - | - |
| 이동 속도 증폭 | 인게임 | `mul_move_speed_1` | 이동 속도 증폭 | - | - |

## 공격 속도

| 중분류 | 컨텐츠 구분 | 스탯 타입 | 스탯 설명 | 계산 예시 | 코멘트 |
| --- | --- | --- | --- | --- | --- |
| 기본 공격 속도 | 초기 값 | `add_atk_speed` | 기본 공격, 스킬 공격의 모션 속도 실행 시간 가중치 | 액티브 스킬의 모션 속도에 영향. 모션 시간 = 애니메이션 시간 / add_atk_speed  *(1 + mul_atk_speed)*  (1 + mul_atk_speed_1). add_atk_speed 값은 초기 값으로 게임에서 제공되지 않는다. 모든 모션 시간 수정하는 작업 필요 (영섭, 승언) | - |
| 공격 속도 증가 | 아웃게임 / 인게임 | `mul_atk_speed` | 공격 속도 | - | - |
| 공격 속도 증폭 | 인게임 | `mul_atk_speed_1` | 공격 속도 증폭 | - | - |

## 쿨타임 가속

| 중분류 | 컨텐츠 구분 | 스탯 타입 | 스탯 설명 | 계산 예시 | 코멘트 |
| --- | --- | --- | --- | --- | --- |
| 기본 쿨타임 속도 | 초기 값 | `add_skill_recharge_speed` | 기본 쿨타임 시간 가중치 | 공격 후 쿨타임 속도에 영향. 쿨타임 시간 = 기본 쿨타임 / add_skill_recharge_speed  *(1 + mul_skill_recharge_speed)*  (1 + mul_skill_recharge_speed_1). 쿨타임은 공격 모션 종료 후에 시작하도록 구현 변경 필요 (영섭, 영삼) | - |
| 쿨타임 속도 증가 | 아웃게임 / 인게임 | `mul_skill_recharge_speed` | 쿨타임 속도 증가율 % | - | - |
| 쿨타임 속도 증폭 | 인게임 | `mul_skill_recharge_speed_1` | 쿨타임 속도 증가율 % | - | - |

---

> ⚠️ **신규 추가 필요**
> 

---

## [상태이상]

| 중분류 | 컨텐츠 구분 | 스탯 타입 | 스탯 설명 | 계산 예시 | 코멘트 |
| --- | --- | --- | --- | --- | --- |
| 효과 저항 | 보스 몬스터 / 밸런스 용 | `add_skill_effect_regist_rate` | 받는 상태이상 저항 확률 (최대 100%) | 효과 적용 시도 시 저항 확률(%)에 따라 무시. 최종 확률 = (add_skill_effect_regist_rate * unitdata@skill_effect_regist_weight). is_debuff = TRUE인 경우에만 적용 | 보스 몬스터에게 효과가 확정 적용되는 문제를 해결하기 위해서 사용. 아군 부대가 해당 스탯을 갖지는 않는다. |
| 효과 적용 확률 | 인게임 | `mul_skill_effect_add_rate` | 효과 부여 시 확률 증가 | 스킬, 상태이상 부여 시 확률 추가. skilldata@skill_effect_add_rate * (1 + mul_skill_effect_add_rate) | - |
| 효과 강화 | 아웃게임 / 인게임 | `mul_skill_effect_increase_duration` | 주는 상태이상 효과 유지 시간 증가율 | 효과의 유지 시간에 영향. 기본 시간  *(1 + mul_skill_effect_increase_duration)*  (1 - (mul_skill_effect_decrease_duration * unitdata@skill_effect_decrease_duration_weight)). 효과 부여 시 duration에 영향, 효과 스택 시 stack_duration에 영향 (개발 체크). 효과 감쇄는 is_debuff = TRUE인 경우에만 적용 | 상태이상 비중이 높은 경우 추천 |
| 효과 감쇄 | 보스 몬스터 / 밸런스 용 | `mul_skill_effect_decrease_duration` | 받는 상태이상 효과 유지 시간 감쇄율 | - | 보스 몬스터에게 효과가 확정 적용되는 문제를 해결하기 위해서 사용. 아군 부대가 해당 스탯을 갖지는 않는다. |

## [추가 피해]

> 추가 피해 스탯 끼리는 합연산. 기본 스탯 공식에 합연산으로 반영하고, 조건에 맞지 않는 스탯은 값을 0으로 처리
> 

| 중분류 | 컨텐츠 구분 | 스탯 타입 | 스탯 설명 | 계산 예시 | 코멘트 |
| --- | --- | --- | --- | --- | --- |
| 일반 몬스터 추가 피해 | 아웃게임 / 인게임 | `mul_damage_target_grade_normal` | 일반 몬스터 추가 피해 | 공격 대상이 일반 몬스터일 경우 각각 곱연산 적용 | - |
| 보스 몬스터 추가 피해 | 아웃게임 / 인게임 | `mul_damage_target_grade_boss` | 보스 몬스터 추가 피해 | 공격 대상이 보스 몬스터일 경우 각각 곱연산 적용 | - |
| [기절] 적 추가 피해 | 아웃게임 / 인게임 | `mul_increase_damage_to_stunning` | 적이 Stun 상태면 추가 피해 적용 | [Stun] 상태이상 보유 중인 적이라면, * (1 + increase_damage_to_stunning). DotDamage / InstantDamage 등 상태이상에서 체력 비례로 피해주는 경우에는 제외 | 상태이상 비중이 높은 경우 추천 |
| [화염] 적 추가 피해 | 아웃게임 / 인게임 | `mul_increase_damage_to_fire` | 적이 StatEffect_Fire 상태이상 보유 시 추가 피해 적용 | [StatEffect_Fire] 상태이상 보유 중인 적이라면, [추가 피해] + mul_increase_damage_to_fire. DotDamage / InstantDamage 제외 | - |
| [빙결] 적 추가 피해 | 아웃게임 / 인게임 | `mul_increase_damage_to_ice` | 적이 Stun_Ice 상태이상 보유 시 추가 피해 적용 | [Stun_Ice] 상태이상 보유 중인 적이라면, [추가 피해] + mul_increase_damage_to_ice. DotDamage / InstantDamage 제외 | - |
| [감전] 적 추가 피해 | 아웃게임 / 인게임 | `mul_increase_damage_to_electric` | 적이 StatEffect_Electric 상태이상 보유 시 추가 피해 적용 | [StatEffect_Electric] 상태이상 보유 중인 적이라면, [추가 피해] + mul_increase_damage_to_electric. DotDamage / InstantDamage 제외 | - |

## [피해 저항]

| 중분류 | 컨텐츠 구분 | 스탯 타입 | 스탯 설명 | 계산 예시 | 코멘트 |
| --- | --- | --- | --- | --- | --- |
| 피해 저항 | 아웃게임 / 인게임 | `mul_decrease_damage_taken` | - | 피격 시 받는 최종 피해량 / (1 + mul_decrease_damage_taken) | 체력 증가 택틱과 경쟁하는 스탯 |

## [회피]

| 중분류 | 컨텐츠 구분 | 스탯 타입 | 스탯 설명 | 계산 예시 | 코멘트 |
| --- | --- | --- | --- | --- | --- |
| 회피율 | 아웃게임 / 인게임 | `add_avoid_rate` | %로 피격을 무시함. 최대 50% | 공격 피격 시 % 확률로 피격 판정을 무효화. 회피 판정 시 전투 메시지 표시 고려 | 체력 증가 택틱과 경쟁하는 스탯. 가치는 높지만, 피격 횟수 기반 택틱이 있는 경우에는 비추천 |

## [전투 쾌적함]

| 중분류 | 컨텐츠 구분 | 스탯 타입 | 스탯 설명 | 계산 예시 | 코멘트 |
| --- | --- | --- | --- | --- | --- |
| 시야거리 증가 | 아웃게임 / 인게임 | `add_skill_visible_range` | 시야 거리 증가 | SkillData@visible_range + add_skill_visible_range, SkillData@attackable_range + add_skill_visible_range | 더 먼거리의 적을 발견 |
| 넉백 거리 증가 | 아웃게임 / 인게임 | `mul_increase_knockback_distance` | 넉백 거리 증가 | 넉백 발동 시 넉백 거리 * (1 + mul_increase_knockback_distance) | 유닛 스킬 정보에 [넉백] 태그 추가 |

## [상호작용 오브젝트]

| 중분류 | 컨텐츠 구분 | 스탯 타입 | 스탯 설명 | 계산 예시 | 코멘트 |
| --- | --- | --- | --- | --- | --- |
| 빠른 발견 | 아웃게임 / 인게임 | `mul_interaction_object_spawn_speed` | %만큼 오브젝트가 생성 시간이 단축됩니다 | 상호작용 오브젝트는 매 웨이브 시작 시 생성되고, 정해진 간격(stagemode_interaction_object_spawn_interval)마다 추가 생성. 다음 생성 시간 = stagemode_interaction_object_spawn_interval / (1 + mul_interaction_object_spawn_speed) | 자원 획득량 가속 |
| 빠른 채굴 | 아웃게임 / 인게임 | `mul_interaction_object_charge_speed` | %만큼 오브젝트 상호작용 시간이 단축 됩니다 | 상호작용 오브젝트 획득에 필요한 체류 시간이 단축. 체류 시간 = interaction_condition_value2 / (1 + mul_interaction_object_charge_speed) | 자원 획득 속도 증가, 생존력 강화 |

## [자원 획득]

| 중분류 | 컨텐츠 구분 | 스탯 타입 | 스탯 설명 | 계산 예시 | 코멘트 |
| --- | --- | --- | --- | --- | --- |
| 골드 획득량 증가 | 아웃게임 / 인게임 | `mul_increase_gold_amount` | 골드 획득량 증가 | 골드 획득 시 reward_gold  *effect_value2*  (1 + mul_increase_gold_amount) | 골드 많이 주는 컨텐츠에서 의미 있게 |
| 경험치 획득량 증가 | 아웃게임 / 인게임 | `mul_increase_exp_amount` | 경험치 획득량 증가 | 인게임 경험치 획득 시 * (1 + mul_increase_exp_amount) | - |
| 시작 미네랄 | 아웃게임 / 인게임 | `add_base_gas_amount` | 시작 가스 | 게임 시작 시 기본 지급 수량 | - |
| 웨이브 미네랄 | 아웃게임 / 인게임 | `add_wave_reward_gas_amount` | 월급 | 웨이브 클리어 시 미네랄 지급량 증가 = ConstantData@stagemode_base_gas_of_wave + add_wave_reward_gas_amount | - |
| 미네랄 이자율 | 아웃게임 | `add_gas_interest_rate` | 미네랄 이자율 증가 | 아머리 진입 시 미네랄 보율량에 %만큼 추가 지급 | - |
| 이자 상한 | 아웃게임 | `add_limit_interest_value` | 이자 상한 | - | - |

## [체력 회복]

| 중분류 | 컨텐츠 구분 | 스탯 타입 | 스탯 설명 | 계산 예시 | 코멘트 |
| --- | --- | --- | --- | --- | --- |
| 받는 회복량 | 아웃게임 / 인게임 | `mul_increase_hp_regen_rate` | 회복양 증가 +% | 체력 회복 시 체력 회복양 * (1 + mul_increase_hp_regen_rate) 만큼의 체력을 회복 | 체력 회복 효율 컨트롤 |

## [스탯 트렌지션]

| 중분류 | 컨텐츠 구분 | 스탯 타입 | 스탯 설명 | 계산 예시 | 코멘트 |
| --- | --- | --- | --- | --- | --- |
| 전환율 | 인게임 | `atk_transition_from_move_speed_weight` | [이속 → 공격력] | 전환 공격력 = sum(mul_move_speed) * atk_transition_from_move_speed_weight. 전환 공격력은 mul_max_atk_2에 합연산 | - |
| - | - | `atk_transition_from_max_hp_weight` | [체력 → 공격력] | 전환 공격력 = sum(mul_max_hp_2) * atk_transition_from_max_hp_weight. 전환 공격력은 mul_max_atk_2에 합연산 | - |

## [주는 피해 증가]

> 최종 피해량에 곱연산
> 

| 중분류 | 컨텐츠 구분 | 스탯 타입 | 스탯 설명 | 계산 예시 |
| --- | --- | --- | --- | --- |
| [불꽃] 유닛 위력 증가 | 인게임 | `mul_increase_fire_damage` | [불꽃] 속성 주는 피해 증가 | Type_Fire 유닛 스킬일 때, 주는 피해량 * (1 + mul_increase_fire_damage) |
| [냉기] 유닛 위력 증가 | 인게임 | `mul_increase_ice_damage` | [냉기] 속성 주는 피해 증가 | Type_Ice 유닛 스킬일 때, 주는 피해량 * (1 + mul_increase_ice_damage) |
| [전기] 유닛 위력 증가 | 인게임 | `mul_increase_electric_damage` | [전기] 속성 주는 피해 증가 | Type_Electric 유닛 스킬일 때, 주는 피해량 * (1 + mul_increase_electric_damage) |
| [카오스] 유닛 위력 증가 | 인게임 | `mul_increase_chaos_damage` | [카오스] 속성 주는 피해 증가 | Type_Chaos 유닛 스킬일 때, 주는 피해량 * (1 + mul_increase_chaos_damage) |
| [무속성] 유닛 위력 증가 | 인게임 | `mul_increase_nothing_damage` | [무속성] 유닛 위력 증가 | - |

## [주는 피해 보너스]

> 최종 피해량에 곱연산
> 

| 중분류 | 컨텐츠 구분 | 스탯 타입 | 스탯 설명 | 계산 예시 |
| --- | --- | --- | --- | --- |
| [불꽃] 보너스 | 인게임 | `mul_increase_fire_damage_2` | [불꽃] 속성 보너스 | Type_Fire 유닛 스킬일 때, 주는 피해량 * (1 + mul_increase_fire_damage) |
| [냉기] 보너스 | 인게임 | `mul_increase_ice_damage_2` | [냉기] 속성 보너스 | Type_Ice 유닛 스킬일 때 동일 |
| [전기] 보너스 | 인게임 | `mul_increase_electric_damage_2` | [전기] 속성 보너스 | Type_Electric 유닛 스킬일 때 동일 |
| [카오스] 보너스 | 인게임 | `mul_increase_chaos_damage_2` | [카오스] 속성 보너스 | Type_Chaos 유닛 스킬일 때 동일 |
| [무속성] 보너스 | 인게임 | `mul_increase_nothing_damage_2` | [무속성] 보너스 | - |

## [속성 피해 보너스]

> [주는 피해 증가]에 우선 곱연산
> 

| 중분류 | 컨텐츠 구분 | 스탯 타입 | 스탯 설명 | 계산 예시 |
| --- | --- | --- | --- | --- |
| [불꽃] 유닛 위력 증폭 | 인게임 | `fire_weight` | [불꽃] 유닛 위력 증폭 | Type_Fire 유닛 스킬일 때, 주는 피해량  *(1 + (mul_increase_fire_damage*  (1 + fire_weight))) |
| [냉기] 유닛 위력 증폭 | 인게임 | `ice_weight` | [냉기] 유닛 위력 증폭 | Type_Ice 유닛 스킬일 때, 주는 피해량  *(1 + (mul_increase_ice_damage*  (1 + ice_weight))) |
| [전기] 유닛 위력 증폭 | 인게임 | `electric_weight` | [전기] 유닛 위력 증폭 | Type_Electric 유닛 스킬일 때, 주는 피해량  *(1 + (mul_increase_electric_damage*  (1 + electric_weight))) |
| [카오스] 유닛 위력 증폭 | 인게임 | `chaos_weight` | [카오스] 유닛 위력 증폭 | Type_Chaos 유닛 스킬일 때, 주는 피해량  *(1 + (mul_increase_chaos_damage*  (1 + chaos_weight))) |
| [무속성] 유닛 위력 증폭 | 인게임 | `nothing_weight` | [무속성] 유닛 위력 증폭 | - |

## [받는 피해 증가]

> 최종 피해량에 곱연산
> 

| 중분류 | 컨텐츠 구분 | 스탯 타입 | 스탯 설명 | 계산 예시 |
| --- | --- | --- | --- | --- |
| [불꽃] 유닛에게 받는 피해 증가 | 인게임 | `mul_increase_fire_damage_taken` | [불꽃] 속성 받는 피해 증가 | 공격자가 Type_Fire 유닛일 때, 받는 피해량 * (1 + mul_increase_fire_damage_taken) |
| [냉기] 유닛에게 받는 피해 증가 | 인게임 | `mul_increase_ice_damage_taken` | [냉기] 속성 받는 피해 증가 | 공격자가 Type_Ice 유닛일 때, 받는 피해량 * (1 + mul_increase_ice_damage_taken) |
| [전기] 유닛에게 받는 피해 증가 | 인게임 | `mul_increase_electric_damage_taken` | [전기] 속성 받는 피해 증가 | 공격자가 Type_Electric 유닛일 때, 받는 피해량 * (1 + mul_increase_electric_damage_taken) |
| [카오스] 유닛에게 받는 피해 증가 | 인게임 | `mul_increase_chaos_damage_taken` | [카오스] 속성 받는 피해 증가 | 공격자가 Type_Chaos 유닛일 때, 받는 피해량 * (1 + mul_increase_chaos_damage_taken) |
| [무속성] 유닛에게 받는 피해 증가 | 인게임 | `mul_increase_nothing_damage_taken` | [무속성] 속성 받는 피해 증가 | 공격자가 Type_Nothing 유닛일 때 동일 |

## [공격 형태]

| 중분류 | 컨텐츠 구분 | 스탯 타입 | 스탯 설명 | 계산 예시 | 코멘트 |
| --- | --- | --- | --- | --- | --- |
| 소환 수 증가 | 아웃게임 / 인게임 | `add_spawn_count` | 소환 수 증가 | [소환] 태그 스킬 일 때, 기본 소환 수 + add_spawn_count | - |
| 지속 시간 증가 | 아웃게임 / 인게임 | `mul_attackbox_duration` | 지속 시간 증가 | [지속] 태그 스킬 일 때, 어택박스 지속 시간 * (1 + mul_attackbox_duration) | - |
| 공격 범위 증가 | 아웃게임 / 인게임 | `mul_attackbox_scale` | 공격 범위 증가 | [범위] 태그 스킬 일 때, 어택박스 사이즈 * (1 + mul_attackbox_scale) | - |
| 연속 공격 확률 | 아웃게임 / 인게임 | `add_repeatable_rate` | 연속 공격 확률 | [연사] 태그 스킬 일 때, 연사 공격 확률 + add_repeatable_rate | - |
| 타겟 수 증가 | 아웃게임 / 인게임 | `mul_passive_target_count` | 타겟 수 증가 | [멀티타겟] 태그 스킬 일 때, passive_target_count * (1 + mul_passive_target_count) | - |

## 채널링 시간

| 중분류 | 컨텐츠 구분 | 스탯 타입 | 스탯 설명 | 계산 예시 |
| --- | --- | --- | --- | --- |
| 채널링 시간 증가 | 아웃게임 / 인게임 | `mul_channeling_duration` | 채널링 시간 증가 | [채널링] 태그 스킬 일 때, loop_duration * (1 + mul_channeling_duration) |

## 멤버십

| 중분류 | 컨텐츠 구분 | 스탯 타입 | 스탯 설명 | 계산 예시 | 코멘트 |
| --- | --- | --- | --- | --- | --- |
| 전투 배속 | 아웃게임 | `mul_stage_game_speed` | 전투 배속 | 1.5배 배속 옵션 기능 활성화 | - |
| 일일 빠른 순찰 횟수 증가 | 아웃게임 | `add_stage_quick_sweep_daily_try` | 일일 빠른 순찰 횟수 증가 | 99일 때 무제한 순찰 가능, 그 이하일 때 순찰 횟수 + add_stage_quick_sweep_daily_try | - |
| 순찰 보상 증가 | 아웃게임 | `mul_stage_sweep_reward` | 순찰 보상 증가 | 자동 순찰 보상도 같이 증가, 순찰 보상 * (1 + mul_stage_sweep_reward) | - |
| 스태미나 충전 속도 증가 | 아웃게임 | `mul_energy_charge_speed` | 스태미나 충전 속도 증가 | 20분마다 회복되는 스태미나 회복량 * (1 + mul_energy_charge_speed) | - |
| 스태미나 보유량 | 아웃게임 | `add_energy_default_capacity` | 스태미나 보유량 증가 | 스태미나 상한 + add_energy_default_capacity | - |
| 유닛 리롤 횟수 | 아웃게임 / 인게임 | `add_unit_reroll` | 유닛 리롤 횟수 증가 | 유닛 리롤 횟수 + add_unit_reroll | - |
| 택틱 리롤 횟수 | 아웃게임 / 인게임 | `add_tactic_reroll` | 택틱 리롤 횟수 증가 | 택틱 리롤 횟수 + add_tactic_reroll | - |

## 유물

| 중분류 | 컨텐츠 구분 | 스탯 타입 | 스탯 설명 | 계산 예시 | 코멘트 |
| --- | --- | --- | --- | --- | --- |
| 분실물 뽑기 기회 | 아웃게임 | `add_unititem_draw_count` | 유물 뽑기 기회 | 유물 뽑기 기회 기본 값 1, 특별 성장에서 +2 (최대값 3으로 제한) | - |
| 축복 부여 확률 | 아웃게임 / 인게임 | `add_bless_rate` | 축복 부여 확률 | 유물 획득 시 축복 부여 확률 = UnitItemBoxPoolData@add_bless_rate + add_bless_rate | - |
| 저주 부여 확률 | 아웃게임 / 인게임 | `add_curse_rate` | 저주 부여 확률 | 유물 획득 시 저주 부여 확률 = UnitItemBoxPoolData@add_curse_rate + add_curse_rate | - |

## 유닛 소환

| 중분류 | 컨텐츠 구분 | 스탯 타입 | 스탯 설명 | 계산 예시 |
| --- | --- | --- | --- | --- |
| 유닛 소환 비용 | 아웃게임 / 인게임 | `add_unit_spawn_fee` | 유닛 소환 비용 | 유닛 소환 비용 = ConstantData@stage_tactic_shop_cost + add_unit_spawn_fee |
| 유닛 대기열 | 아웃게임 | `add_inventory_count` | 유닛 대기열 | 아머리 유닛 보관 슬롯 |

## 게임 플레이

| 중분류 | 컨텐츠 구분 | 스탯 타입 | 스탯 설명 | 계산 예시 | 코멘트 |
| --- | --- | --- | --- | --- | --- |
| 신화 카드 등장 확률 | 아웃게임 | `add_tactic_draw_mythic_select_rate` | 신화 카드 등장 확률 | 확률을 지정. 지정 확률로 신화 카드 등장 여부를 판단 | - |
| 신화 카드 오브젝트 등장 | 아웃게임 | `special_tactic_draw` | 신화 카드 오브젝트 등장 | 특별 성장에서 사용. special_effect_type 값이 Special_Tactic_Draw 일 때, 해당 택틱 지정해서 로컬, 아이콘 등 처리 | - |