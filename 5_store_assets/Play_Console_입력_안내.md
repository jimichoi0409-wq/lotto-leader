# Play Console 입력 안내 (순서대로)

작성일: 2026-10-26 · 계정: 한지성 (jnhteamsoft@gmail.com, 개인 계정)

> 본인 확인이 끝나야 "앱 만들기"가 열립니다. 끝나면 아래 순서대로 진행합니다.
> 회색 상자 안 값은 그대로 복사해서 넣으면 됩니다.

## 1. 앱 만들기

| 칸 | 값 |
|---|---|
| 앱 이름 | `로또대장 - 로또 번호 생성기` (기본 언어 이름. 다른 언어 이름은 4번에서 추가) |
| 기본 언어 | 한국어 – ko-KR |
| 앱 또는 게임 | 앱 |
| 무료 또는 유료 | 무료 (나중에 유료로 바꿀 수 없음) |
| 선언 2개 | 개발자 프로그램 정책, 미국 수출법 — 내용을 읽고 직접 체크 |

## 2. 앱 콘텐츠 (대시보드 → "앱 설정")

| 항목 | 답 |
|---|---|
| 개인정보처리방침 | `https://jimichoi0409-wq.github.io/lotto-leader/privacy/` |
| 앱 액세스 권한 | 모든 기능을 제한 없이 사용 가능 (로그인 없음) |
| 광고 | 예, 광고 포함 |
| 콘텐츠 등급 | `데이터보안_연령등급_안내.md` "연령 등급" 참고. 이메일은 jnhteamsoft@gmail.com, 카테고리는 "기타 앱"(게임 아님). 도박 관련 언급 질문은 사실대로 "예", 실제 돈 베팅·모의 도박은 "아니요" |
| 타겟층 | 18세 이상만 선택 |
| 데이터 보안 | `데이터보안_연령등급_안내.md` "Google Play 데이터 보안" 표 그대로 |
| 광고 ID | 예 — 광고 목적 |
| 정부 앱 | 아니요 |
| 금융 기능 | 해당 없음 |
| 건강 | 해당 없음 |
| 뉴스 앱 | 아니요 |

## 3. 스토어 설정

| 항목 | 값 |
|---|---|
| 앱 카테고리 | 엔터테인먼트 |
| 태그 | 최대 5개까지 고를 수 있음 — 목록에서 "도구"·"엔터테인먼트" 성격만 |
| 이메일 | jnhteamsoft@gmail.com |
| 웹사이트 | `https://jimichoi0409-wq.github.io/lotto-leader/` |
| 전화번호 | 비워 둠 (선택 항목) |

## 4. 기본 스토어 등록정보 (언어마다)

"번역 관리 → 자체 번역 추가"로 en-US, es-ES, fr-FR, de-DE, ja-JP, vi-VN 을 추가하고 언어마다 넣습니다.

| 칸 | 파일 |
|---|---|
| 앱 이름 / 간단한 설명 / 자세한 설명 | `스토어_등록_문구.md` 해당 언어 |
| 앱 아이콘 (512×512) | `play_store_icon_512.png` |
| 그래픽 이미지 (1024×500) | `feature_graphic/feature_<언어>.png` |
| 휴대전화 스크린샷 (4장) | `screenshots/<언어>/01_main.png` ~ `04_stats.png` |

스페인어·프랑스어는 같은 파일을 es-419(중남미), fr-CA(캐나다)에도 넣어도 됩니다.

## 5. 비공개 테스트 (출시 전 필수: 테스터 12명 이상 × 14일 연속)

1. 테스트 및 출시 → 테스트 → **비공개 테스트** → 트랙 만들기 (이름 예: `closed-beta`)
2. **국가/지역**: 대한민국 (테스터가 있는 나라 모두)
3. **테스터**: "이메일 목록 만들기" → 테스터 Gmail 주소 입력 (권장 15명 이상)
   - 피드백 URL 또는 이메일: jnhteamsoft@gmail.com
4. **새 버전 만들기** → `app-release.aab` 업로드
   - 파일 위치: `1_app_flutter/lotto_app/build/app/outputs/bundle/release/app-release.aab`
   - Play 앱 서명: "Google에서 앱 서명 키 관리"(기본값) 그대로
   - 출시 노트: 아래 6번
5. 검토 후 출시 → Google 검토(보통 며칠) → 통과하면 **테스터 참여 링크**가 생깁니다.
6. 링크를 테스터에게 보내고 `비공개_테스트_참여_안내.md` 를 함께 전달합니다.
7. 14일이 지나면 대시보드 → **프로덕션 액세스 신청** → 질문 3묶음 답변

## 6. 출시 노트 (500자 이내)

```
<ko-KR>
첫 테스트 버전입니다. 9개 복권 번호 조합, 패턴 필터, 당첨번호 확인과 통계를 써 보시고 불편한 점을 알려 주세요.
</ko-KR>
<en-US>
First test release. Try number combinations for 9 lotteries, pattern filters, results and stats, and tell us what to improve.
</en-US>
<es-ES>
Primera versión de prueba. Prueba combinaciones para 9 loterías, filtros, resultados y estadísticas, y cuéntanos qué mejorar.
</es-ES>
<fr-FR>
Première version de test. Essayez les combinaisons pour 9 loteries, les filtres, les résultats et les statistiques, et dites-nous quoi améliorer.
</fr-FR>
<de-DE>
Erste Testversion. Probieren Sie Kombinationen für 9 Lotterien, Filter, Ergebnisse und Statistiken aus und sagen Sie uns, was wir verbessern können.
</de-DE>
<ja-JP>
最初のテスト版です。9種類のロトの番号組み合わせ、フィルター、当選結果と統計をお試しいただき、改善点をお知らせください。
</ja-JP>
<vi-VN>
Bản thử nghiệm đầu tiên. Hãy thử tạo bộ số cho 9 loại xổ số, bộ lọc, kết quả và thống kê, rồi cho chúng tôi biết cần cải thiện gì.
</vi-VN>
```

## 7. 확인해 둔 것 (2026-10-26)

- 대상 API 36 (Android 16): 2026-08-31 부터 새 앱 필수 조건 충족
- 버전: 1.0.0 (versionCode 1). 다음 업로드부터는 `pubspec.yaml` 의 `+1` 을 `+2`, `+3` … 으로 올려야 함
- 권한 `FOREGROUND_SERVICE` 는 광고·백그라운드 작업 라이브러리(WorkManager) 기본값이고 실제 포그라운드 서비스 유형이 없어 별도 선언 대상 아님
