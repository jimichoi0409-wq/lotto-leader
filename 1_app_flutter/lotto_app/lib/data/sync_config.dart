// 당첨번호 자동 갱신 주소.
//
// GitHub 저장소에 올리고 Pages 를 켠 뒤 (.github/workflows/update-draws.yml 참고)
// 아래 값을 'https://<계정>.github.io/<저장소>/draws/' 처럼 넣으세요. 끝에 / 를 붙입니다.
// 비어 있으면 자동 갱신을 하지 않고 앱에 내장된 당첨번호만 씁니다.
const String drawsBaseUrl =
    'https://jimichoi0409-wq.github.io/lotto-leader/draws/';

/// 앱을 다시 화면에 띄울 때(백그라운드 → 앞) 다시 확인하기까지의 최소 간격.
/// 앱을 새로 실행할 때는 간격과 상관없이 항상 확인합니다.
const Duration drawSyncInterval = Duration(minutes: 5);
