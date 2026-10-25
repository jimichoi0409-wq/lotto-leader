// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Korean (`ko`).
class AppLocalizationsKo extends AppLocalizations {
  AppLocalizationsKo([String locale = 'ko']) : super(locale);

  @override
  String get appTitle => '로또대장';

  @override
  String get close => '닫기';

  @override
  String get apply => '적 용';

  @override
  String get lookup => '조 회';

  @override
  String get calculating => '계산중';

  @override
  String get extracting => '추출중...';

  @override
  String get extractButton => '번호추출';

  @override
  String get countHint => '갯수입력';

  @override
  String get remainingCombos => '남은 조합 수';

  @override
  String get menuResults => '당첨번호';

  @override
  String get menuReset => '새로고침';

  @override
  String get menuAlarm => '알람';

  @override
  String get menuSettings => '설정';

  @override
  String get privacyPolicy => '개인정보처리방침';

  @override
  String get disclaimer => '면책고지';

  @override
  String get contact => '문의하기';

  @override
  String get versionLabel => '버전정보';

  @override
  String currentVersion(String version) {
    return '현재 앱 버전 $version';
  }

  @override
  String get language => '언어';

  @override
  String get languageSystem => '기기 설정 따르기';

  @override
  String drawAlarm(String game) {
    return '$game 추첨일 알람';
  }

  @override
  String get resetDone => '처음 시작값으로 초기화했습니다.';

  @override
  String get privacyText =>
      '본 앱은 무료로 이용할 수 있으며, 처음 실행할 때 닉네임만으로 간단히 가입합니다. 닉네임과 번호 추출 기록은 이 기기에만 저장되고 운영자에게 전송되지 않으며, 설정 → 탈퇴로 언제든 삭제할 수 있습니다.\n\n본 앱은 사용자의 이름, 전화번호, 이메일 등 직접 식별 가능한 개인정보를 앱 내부에서 별도로 수집하지 않습니다.\n\n본 앱은 광고 제공을 위해 Google AdMob을 사용하며, 이 과정에서 광고 ID, 기기 정보, 앱 사용 정보 등이 Google에 수집될 수 있습니다. 유럽 등 동의가 필요한 지역에서는 처음 실행할 때 동의 여부를 묻고, 설정 → 광고 개인정보 설정에서 언제든 바꿀 수 있습니다.\n\n수집 및 이용되는 정보는 광고 제공, 앱 품질 개선, 부정 이용 방지 목적으로 사용될 수 있습니다.';

  @override
  String get disclaimerText =>
      '본 앱은 과거 로또 당첨번호를 기반으로 통계 분석 및 번호 조합 참고 기능을 제공하는 도구입니다.\n\n모든 복권은 번호 조합마다 1등 당첨 확률이 동일합니다(예: 로또 6/45는 1/8,145,060, 파워볼은 1/292,201,338). 본 앱의 필터와 통계는 당첨 확률을 높이지 않습니다. 번호 선택의 재미와 참고용으로만 이용해주세요.\n\n본 앱은 각 복권 운영사(동행복권, Powerball, Mega Millions, Lotto 6/49, EuroMillions, Eurojackpot, 로토6, Irish Lotto, Vietlott 등)와 관련이 없는 독립 앱입니다.\n\n본 앱은 당첨을 보장하지 않으며, 복권 구매 및 이용에 대한 모든 책임은 사용자 본인에게 있습니다.\n\n본 앱은 복권 구매, 베팅, 현금성 보상, 도박 서비스를 제공하지 않습니다.';

  @override
  String get contactText =>
      '앱 이용 중 궁금한 점이나 오류, 제안이 있으면 아래 이메일로 보내 주세요.\n\n운영자: 한지성\n이메일: jnhteamsoft@gmail.com\n\n보통 3영업일 안에 답변드립니다.';

  @override
  String get chooseLottery => '복권 선택';

  @override
  String gameRule(String count, String max) {
    return '번호 $count개(1~$max)';
  }

  @override
  String gameRuleBonus(String label, String count, String max) {
    return ' + $label $count개(1~$max)';
  }

  @override
  String jackpotOdds(String odds) {
    return '1등 확률 1/$odds';
  }

  @override
  String drawCount(String count) {
    return '당첨번호 $count회';
  }

  @override
  String get drawsPending => '당첨번호 준비 중';

  @override
  String get drawRoundPrefix => '제 ';

  @override
  String get drawRoundSuffix => '회 추첨 결과';

  @override
  String get drawResultPrefix => '';

  @override
  String get drawResultSuffix => ' 추첨 결과';

  @override
  String drawDate(String date) {
    return '$date 추첨';
  }

  @override
  String get noDrawDate => '추첨일 정보 없음';

  @override
  String get noResultsStored => '저장된 당첨번호가 없습니다.\n(이 복권은 당첨번호 데이터를 준비 중입니다)';

  @override
  String get dbLoading => '당첨번호 DB를 불러오는 중입니다. 잠시 후 다시 시도해주세요.';

  @override
  String get dbLoadingShort => '당첨번호 DB를 불러오는 중입니다.';

  @override
  String get dbLoadFailed => '당첨번호 DB를 불러오지 못했습니다. DB/CSV asset을 확인해주세요.';

  @override
  String get freqPrefix => '최근 [';

  @override
  String get freqSuffix => ']회 최다 | 최저 당첨번호 숫자';

  @override
  String get freqHint => '입력';

  @override
  String get mostDrawn => '최다추첨번호';

  @override
  String get leastDrawn => '최저추첨번호';

  @override
  String get noDrawData => '이 복권은 아직 당첨번호 데이터가 없습니다.';

  @override
  String get recentTooLarge => '입력한 회차가 전체 저장 회차보다 커서 전회차 기준으로 조회합니다.';

  @override
  String get freqError => '빈도 계산 중 오류가 발생했습니다.';

  @override
  String includeExcludeHeader(String maxInc) {
    return '포함[최대 $maxInc개] | 제외[최대 18개] 숫자 지정';
  }

  @override
  String get includeRow => '포함할 숫자';

  @override
  String get excludeRow => '제외할 숫자';

  @override
  String get includeBonusRow => '포함할 번호';

  @override
  String get excludeBonusRow => '제외할 번호';

  @override
  String bonusHeader(String label, String max, String inc, String exc) {
    return '$label 지정 (1~$max, 포함 최대 $inc개 · 제외 최대 $exc개)';
  }

  @override
  String get numbersWord => '숫자';

  @override
  String pickerInclude(String kind) {
    return '포함 $kind 지정';
  }

  @override
  String pickerExclude(String kind) {
    return '제외 $kind 지정';
  }

  @override
  String pickerConflict(String number) {
    return '포함 숫자와 제외 숫자가 중복됩니다: $number';
  }

  @override
  String pickerMax(String max) {
    return '최대 $max개까지만 선택할 수 있습니다.';
  }

  @override
  String get includeLabel => '포함 숫자';

  @override
  String get excludeLabel => '제외 숫자';

  @override
  String includeBonusLabel(String label) {
    return '포함 $label';
  }

  @override
  String excludeBonusLabel(String label) {
    return '제외 $label';
  }

  @override
  String notNumber(String label, String raw) {
    return '$label에 숫자가 아닌 값이 입력되었습니다: $raw';
  }

  @override
  String outOfRange(String label, String max) {
    return '$label: 1부터 $max까지의 숫자만 입력할 수 있습니다.';
  }

  @override
  String get dupInclude => '포함할 숫자에 중복이 있습니다.';

  @override
  String get dupExclude => '제외할 숫자에 중복이 있습니다.';

  @override
  String conflict(String numbers) {
    return '포함 숫자와 제외 숫자가 중복됩니다: $numbers';
  }

  @override
  String get calcError => '연산 중 오류가 발생했습니다. 필터를 다시 확인해주세요.';

  @override
  String get busy => '계산 중입니다. 잠시만 기다려주세요!';

  @override
  String get noResults => '결과가 없습니다. 조건을 다시 설정해주세요.';

  @override
  String tooMany(String count) {
    return '남은 조합 수보다 요청 개수가 많아 $count개만 추출합니다.';
  }

  @override
  String get noExtract => '추출 가능한 조합이 없습니다. 조건을 다시 설정해주세요.';

  @override
  String get extractError => '번호 추출 중 오류가 발생했습니다. 조건을 다시 확인해주세요.';

  @override
  String get resultsTitle => '추출된 조합';

  @override
  String get copied => '번호가 복사되었습니다.';

  @override
  String get copyButton => '추출번호복사';

  @override
  String get shareButton => '추출번호보내기';

  @override
  String shareHeader(String game) {
    return '🍀나의 $game 조합 번호🍀';
  }

  @override
  String get shareSubject => '로또 조합 번호 공유';

  @override
  String get noHelp => '설명이 준비되지 않았습니다.';

  @override
  String get obWelcome => '로또대장에 오신 것을 환영합니다';

  @override
  String get obChooseLanguage => '사용할 언어를 선택하세요. 나중에 설정에서 바꿀 수 있습니다.';

  @override
  String get obNext => '다음';

  @override
  String get obBack => '이전';

  @override
  String get obProfileTitle => '간단 가입';

  @override
  String get obProfileBody =>
      '닉네임만 정하면 바로 시작할 수 있어요.\n가입 정보와 이용 기록은 이 기기에만 저장됩니다.';

  @override
  String get obNickname => '닉네임';

  @override
  String get obNicknameHint => '2~12자';

  @override
  String get obNicknameError => '닉네임은 2~12자로 입력해 주세요.';

  @override
  String get obAge => '복권을 구매할 수 있는 나이입니다 (한국 만 19세 이상)';

  @override
  String get obAgree => '개인정보처리방침과 면책고지에 동의합니다';

  @override
  String get obView => '보기';

  @override
  String get obStart => '시작하기';

  @override
  String get obNeedChecks => '필수 항목에 모두 동의해 주세요.';

  @override
  String get menuHistory => '내 기록';

  @override
  String historyJoined(String date) {
    return '$date 가입';
  }

  @override
  String historyStats(int count) {
    return '번호 추출 $count회';
  }

  @override
  String get historyEmpty => '아직 추출한 기록이 없습니다.\n번호를 추출하면 여기에 저장됩니다.';

  @override
  String historyTickets(int count) {
    return '$count개 조합';
  }

  @override
  String historyFilters(int count) {
    return '필터 $count개';
  }

  @override
  String get historyClearAll => '기록 모두 지우기';

  @override
  String get historyClearConfirm => '추출 기록을 모두 지울까요?';

  @override
  String get historyDeleted => '기록을 삭제했습니다.';

  @override
  String get delete => '삭제';

  @override
  String get cancel => '취소';

  @override
  String get confirm => '확인';

  @override
  String profileNickname(String name) {
    return '닉네임: $name';
  }

  @override
  String get withdraw => '탈퇴 (가입 정보·기록 삭제)';

  @override
  String get withdrawConfirm =>
      '가입 정보와 추출 기록을 이 기기에서 모두 삭제하고 처음 화면으로 돌아갑니다. 계속할까요?';

  @override
  String get manualEntry => '당첨번호 직접 입력';

  @override
  String get manualHelp =>
      '자동 갱신이 되지 않을 때 공식 발표를 보고 입력하세요. 나중에 같은 날짜의 공식 데이터가 들어오면 공식 데이터가 우선합니다.';

  @override
  String get manualRound => '회차';

  @override
  String get manualDate => '추첨일';

  @override
  String manualMain(String count) {
    return '당첨번호 $count개';
  }

  @override
  String manualBonus(String label, String count) {
    return '$label $count개';
  }

  @override
  String get manualSave => '저장';

  @override
  String get manualSaved => '직접 입력한 당첨번호를 저장했습니다.';

  @override
  String get manualList => '직접 입력한 기록';

  @override
  String get manualNone => '직접 입력한 기록이 없습니다.';

  @override
  String get manualTag => '직접 입력';

  @override
  String get mErrRound => '회차를 확인해 주세요.';

  @override
  String mErrMain(String count) {
    return '당첨번호를 $count개 골라 주세요.';
  }

  @override
  String mErrBonus(String label, String count) {
    return '$label: $count개를 골라 주세요.';
  }

  @override
  String get mErrBonusOverlap => '보너스 번호는 당첨번호와 겹칠 수 없습니다.';

  @override
  String get mErrDate =>
      '추첨일을 확인해 주세요. 미래 날짜, 추첨 요일이 아닌 날, 현재 규칙 이전 날짜는 입력할 수 없습니다.';

  @override
  String get mErrExists => '같은 날짜(회차)의 당첨번호가 이미 있습니다.';

  @override
  String get adPrivacyOptions => '광고 개인정보 설정';

  @override
  String rewardTitle(String count) {
    return '$count개 추출';
  }

  @override
  String rewardBody(String free, String count) {
    return '한 번에 $free개까지는 바로 추출됩니다.\n짧은 광고를 보면 $count개를 모두 추출합니다.';
  }

  @override
  String rewardWatch(String count) {
    return '광고 보고 $count개';
  }

  @override
  String rewardFreeOnly(String free) {
    return '$free개만 추출';
  }

  @override
  String rewardNotEarned(String free) {
    return '광고를 끝까지 보지 않아 $free개만 추출합니다.';
  }

  @override
  String get patternFilters => '패턴 제외 필터';

  @override
  String get pastPending => ' (당첨번호 준비 중)';

  @override
  String get fKr1st => '역대 1등 당첨번호 패턴 제외';

  @override
  String get hKr1st => '1회차부터 최근 회차까지 1등 당첨번호와 완전히 동일한 조합을 제외합니다.';

  @override
  String get fKr23 => '역대 2/3등 당첨번호 패턴 제외';

  @override
  String get hKr23 => '과거 1등 당첨번호 6개 중 5개가 동일하게 포함되는 조합을 제외합니다.';

  @override
  String get fKr4th => '역대 4등 당첨번호 조합 패턴 제외';

  @override
  String get hKr4th => '최근 100회차의 1등 당첨번호에서 만들어지는 4개 번호 조합이 포함된 경우 제외합니다.';

  @override
  String get fKr5th => '역대 5등 당첨번호 중 연속 이어진 조합 제외';

  @override
  String get hKr5th => '과거 당첨번호 안에 포함되었던 3연속 번호 묶음이 포함된 조합을 제외합니다.';

  @override
  String get fKrRange => '10구간 내 올인 제외 (n6-n1 > 9)';

  @override
  String get hKrRange => '가장 낮은 숫자와 가장 높은 숫자의 차이가 9 이하인 좁은 구간 조합을 제외합니다.';

  @override
  String fPastFull(String k) {
    return '역대 당첨 메인 번호 $k개 일치 제외';
  }

  @override
  String hPastFull(String k) {
    return '현재 규칙이 시작된 뒤 나온 당첨 메인 번호 $k개와 완전히 같은 조합을 제외합니다.';
  }

  @override
  String fPastMinus1(String m) {
    return '역대 당첨 메인 번호 $m개 일치 제외';
  }

  @override
  String hPastMinus1(String k, String m) {
    return '과거 당첨 메인 번호 $k개 중 $m개가 같은 조합을 제외합니다.';
  }

  @override
  String fPastMinus2(String r, String m) {
    return '최근 $r회 메인 번호 $m개 일치 제외';
  }

  @override
  String hPastMinus2(String r, String m) {
    return '최근 $r회 당첨 메인 번호 중 $m개가 같은 조합을 제외합니다.';
  }

  @override
  String get fPastConsec => '역대 당첨번호의 연속 3개 묶음 제외';

  @override
  String get hPastConsec =>
      '과거 당첨번호에 들어 있던 연속 3개 번호 묶음(예: 7, 8, 9)이 포함된 조합을 제외합니다.';

  @override
  String fNarrow(String n) {
    return '좁은 구간 올인 제외 (최대-최소 ≤ $n)';
  }

  @override
  String hNarrow(String n) {
    return '가장 낮은 숫자와 가장 높은 숫자의 차이가 $n 이하인 좁은 구간 조합을 제외합니다.';
  }

  @override
  String get f3Consec => '연속 이어진 숫자 3개 패턴 제외';

  @override
  String get h3Consec => '1, 2, 3 또는 33, 34, 35처럼 연속 3개의 숫자가 이어지는 경우 제외합니다.';

  @override
  String get fSkip1 => '1개씩 건너뛴 3자리이상 패턴 제외';

  @override
  String get hSkip1 =>
      '1, 3, 5 또는 15, 17, 19처럼 숫자 차이가 2인 패턴이 3개 연속 포함되는 경우 제외합니다.';

  @override
  String get fSkip2 => '2개씩 건너뛴 3자리이상 패턴 제외';

  @override
  String get hSkip2 =>
      '1, 4, 7 또는 15, 18, 21처럼 숫자 차이가 3인 패턴이 3개 연속 포함되는 경우 제외합니다.';

  @override
  String get fSkip3 => '3개씩 건너뛴 3자리이상 패턴 제외';

  @override
  String get hSkip3 =>
      '1, 5, 9 또는 15, 19, 23처럼 숫자 차이가 4인 패턴이 3개 연속 포함되는 경우 제외합니다.';

  @override
  String get f2Pairs => '2쌍 이상의 연속 번호 패턴 제외';

  @override
  String get h2Pairs => '1, 2와 15, 16처럼 연속된 번호 쌍이 2개 이상 포함되는 경우 제외합니다.';

  @override
  String fAllOdd(String k) {
    return '\'홀수\' $k개로 구성된 패턴 제외';
  }

  @override
  String hAllOdd(String k) {
    return '$k개의 숫자가 모두 홀수인 경우 제외합니다.';
  }

  @override
  String fAllEven(String k) {
    return '\'짝수\' $k개로 구성된 패턴 제외';
  }

  @override
  String hAllEven(String k) {
    return '$k개의 숫자가 모두 짝수인 경우 제외합니다.';
  }

  @override
  String get fOE1 => '\'홀짝홀짝홀짝\', \'짝홀짝홀짝홀\' 패턴 제외';

  @override
  String get fOE2 => '\'짝짝홀홀짝짝\', \'홀홀짝짝홀홀\' 패턴 제외';

  @override
  String get fOE3 => '\'짝짝짝짝짝홀\', \'홀홀홀홀홀짝\' 패턴 제외';

  @override
  String get fOE4 => '\'짝짝짝짝홀홀\', \'홀홀홀홀짝짝\' 패턴 제외';

  @override
  String get fOE5 => '\'짝짝짝홀홀홀\', \'홀홀홀짝짝짝\' 패턴 제외';

  @override
  String hOE(String pattern) {
    return '정렬된 6개 숫자의 홀짝 순서가 $pattern인 경우 제외합니다.';
  }

  @override
  String get fSameDigit => '같은 끝수 3개 이상 제외';

  @override
  String get hSameDigit => '1, 11, 21, 31처럼 같은 끝수를 가진 숫자가 3개 이상 포함된 조합을 제외합니다.';

  @override
  String get fTripleMult => '3연속 배수 조합 패턴 제외';

  @override
  String get hTripleMult =>
      '2, 4, 6 또는 4, 8, 12처럼 같은 기준수의 3연속 배수가 포함된 조합을 제외합니다.';

  @override
  String get alarmIntro => '켜 둔 복권은 추첨 3시간 전에 휴대폰 알림을 보내 드립니다.';

  @override
  String alarmDrawAt(String days, String time) {
    return '추첨 $days $time (현지 시각)';
  }

  @override
  String get alarmUnsupported => '이 기기에서는 알림을 지원하지 않습니다. 휴대폰 앱에서 이용해 주세요.';

  @override
  String get alarmDenied => '알림 권한이 꺼져 있습니다. 휴대폰 설정에서 이 앱의 알림을 허용해 주세요.';

  @override
  String alarmOn(String game) {
    return '$game 추첨 3시간 전에 알려 드릴게요.';
  }

  @override
  String alarmOff(String game) {
    return '$game 알림을 껐습니다.';
  }

  @override
  String notifyTitle(String game) {
    return '오늘 $game 추첨일!';
  }

  @override
  String get notifyBody => '3시간 뒤 추첨이 있습니다. 로또대장에서 번호를 만들어 보세요.';

  @override
  String get notifyChannel => '추첨일 알림';

  @override
  String get winPending => '추첨 대기 중';

  @override
  String winDrawOf(String date) {
    return '$date 추첨 결과와 비교';
  }

  @override
  String winRank(String rank) {
    return '$rank등';
  }

  @override
  String winBest(String rank) {
    return '최고 $rank';
  }

  @override
  String get winNone => '낙첨';

  @override
  String winMatch(String main) {
    return '$main개 일치';
  }

  @override
  String winMatchPlus(String main, String bonus) {
    return '$main+$bonus 일치';
  }

  @override
  String winMatchBonus(String main) {
    return '$main개 + 보너스 일치';
  }

  @override
  String get winPendingHint =>
      '추첨 결과가 들어오면 자동으로 비교합니다. 결과가 늦으면 설정 → 당첨번호 직접 입력을 이용하세요.';

  @override
  String get statsTitle => '번호 통계';

  @override
  String statsRecent(String n) {
    return '최근 $n회';
  }

  @override
  String get statsAll => '전체';

  @override
  String get statsMain => '당첨번호';

  @override
  String get statsSortNumber => '번호순';

  @override
  String get statsSortMost => '많이 나온 순';

  @override
  String get statsSortLeast => '적게 나온 순';

  @override
  String get statsSortGap => '오래 안 나온 순';

  @override
  String statsAnalyzed(int n) {
    return '최근 $n회 추첨 기준';
  }

  @override
  String get statsHot => '자주 나온 번호';

  @override
  String get statsCold => '오래 안 나온 번호';

  @override
  String statsCount(String n) {
    return '$n회';
  }

  @override
  String statsGap(int n) {
    return '$n회 전';
  }

  @override
  String get statsGapLatest => '지난 추첨';

  @override
  String get statsGapNever => '기간 내 없음';

  @override
  String get statsOddEven => '홀수·짝수 비율';

  @override
  String statsOddLabel(String odd, String even) {
    return '홀 $odd : 짝 $even';
  }

  @override
  String get statsDisclaimer => '지난 추첨 기록일 뿐이며 다음 추첨 결과를 예측하지 않습니다.';

  @override
  String get backupExport => '기록 백업하기';

  @override
  String get backupImport => '백업 불러오기';

  @override
  String get backupShareText =>
      '로또대장 기록 백업 파일입니다. 새 휴대폰의 설정 → 백업 불러오기에서 이 파일을 고르세요.';

  @override
  String get backupEmpty => '백업할 기록이 아직 없습니다.';

  @override
  String get backupFailed => '백업 파일을 만들지 못했습니다. 잠시 후 다시 시도해 주세요.';

  @override
  String get backupImportConfirm =>
      '백업 파일의 기록을 지금 기기의 기록과 합칩니다. 닉네임과 가입일은 백업 파일 기준으로 바뀝니다. 계속할까요?';

  @override
  String backupImportDone(String history, String manual) {
    return '불러오기 완료: 추출 기록 $history건, 직접 입력 당첨번호 $manual건을 추가했습니다.';
  }

  @override
  String get backupInvalid => '로또대장 백업 파일이 아니거나 파일이 손상되었습니다.';

  @override
  String get backupTooLarge => '파일이 너무 큽니다. 로또대장 백업 파일을 골라 주세요.';

  @override
  String get continueButton => '계속';

  @override
  String get colon => ': ';

  @override
  String fSum(String lo, String hi) {
    return '번호 합계 $lo~$hi 밖 제외';
  }

  @override
  String hSum(String lo, String hi) {
    return '메인 번호를 모두 더한 값이 $lo보다 작거나 $hi보다 큰 조합을 제외합니다. 전체 조합의 약 95%가 이 범위 안에 있습니다.';
  }

  @override
  String get fBirthday => '모두 31 이하인 조합 제외 (생일 번호)';

  @override
  String get hBirthday =>
      '1~31(날짜에 쓰이는 숫자)로만 된 조합을 제외합니다. 생일로 번호를 고르는 사람이 많아, 1등이 되더라도 당첨금을 여러 명이 나눌 가능성이 높은 조합입니다. 당첨 확률 자체는 다른 조합과 같습니다.';

  @override
  String get fLowHigh => '전부 낮은 번호 또는 전부 높은 번호 제외';

  @override
  String hLowHigh(String half, String next, String max) {
    return '모든 번호가 1~$half 안에 있거나, 모두 $next~$max 안에 있는 조합을 제외합니다.';
  }

  @override
  String get fDecade4 => '같은 10번대 4개 이상 제외';

  @override
  String get hDecade4 =>
      '41, 43, 45, 48처럼 같은 10번대(1~9, 10~19, 20~29 …)에 번호가 4개 이상 몰린 조합을 제외합니다.';

  @override
  String get fRepeatLast => '직전 회차 번호 2개 이상 포함 제외';

  @override
  String get hRepeatLast => '바로 전 추첨의 메인 번호가 2개 이상 다시 들어간 조합을 제외합니다.';

  @override
  String fBonusRecent(String n, String label) {
    return '최근 $n회 나온 $label 제외';
  }

  @override
  String hBonusRecent(String n, String label) {
    return '최근 $n회 추첨에 나온 $label 번호는 고르지 않습니다.';
  }

  @override
  String fBonusPairRecent(String n, String label) {
    return '최근 $n회 나온 $label 두 개 조합 제외';
  }

  @override
  String hBonusPairRecent(String n, String label) {
    return '최근 $n회 추첨과 똑같은 $label 두 개 조합은 고르지 않습니다.';
  }

  @override
  String fBonusConsec(String label) {
    return '$label 연속 번호 제외 (예: 3·4)';
  }

  @override
  String hBonusConsec(String label) {
    return '$label 두 개가 3·4처럼 이어진 번호인 조합은 고르지 않습니다.';
  }

  @override
  String fBonusParity(String label) {
    return '$label 둘 다 홀수 또는 둘 다 짝수 제외';
  }

  @override
  String hBonusParity(String label) {
    return '$label 두 개가 모두 홀수이거나 모두 짝수인 조합은 고르지 않습니다.';
  }

  @override
  String get filtersOverseas => '해외 복권 추가 필터';

  @override
  String filtersBonus(String label) {
    return '$label 필터';
  }
}
