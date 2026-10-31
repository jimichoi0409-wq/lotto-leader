// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get appTitle => 'Lotto Leader';

  @override
  String get close => '閉じる';

  @override
  String get apply => '適用';

  @override
  String get lookup => '表示';

  @override
  String get calculating => '計算中…';

  @override
  String get extracting => '生成中…';

  @override
  String get extractButton => '番号生成';

  @override
  String get countHint => '数量';

  @override
  String get remainingCombos => '残りの組み合わせ数';

  @override
  String get menuResults => '当選番号';

  @override
  String get menuReset => 'リセット';

  @override
  String get menuAlarm => '通知';

  @override
  String get menuSettings => '設定';

  @override
  String get privacyPolicy => 'プライバシーポリシー';

  @override
  String get disclaimer => '免責事項';

  @override
  String get contact => 'お問い合わせ';

  @override
  String get versionLabel => 'バージョン';

  @override
  String currentVersion(String version) {
    return '現在のアプリバージョン $version';
  }

  @override
  String get language => '言語';

  @override
  String get languageSystem => '端末の言語を使う';

  @override
  String drawAlarm(String game) {
    return '$game 抽選日のお知らせ';
  }

  @override
  String get resetDone => '初期設定に戻しました。';

  @override
  String get privacyText =>
      'このアプリは無料です。初回起動時にニックネームだけで簡単な登録を行います。ニックネームと番号生成の履歴はこの端末にのみ保存され、運営者に送信されることはなく、設定 → アカウント削除でいつでも削除できます。\n\nアプリ自体が、氏名・電話番号・メールアドレスなど個人を特定できる情報を収集することはありません。\n\nアプリは広告表示のために Google AdMob を使用します。その過程で、広告ID・端末情報・アプリの利用情報が Google に収集される場合があります。同意が必要な地域(EEA・英国など)では初回起動時に確認し、設定 → 広告のプライバシー設定でいつでも変更できます。\n\nこれらの情報は、広告の配信、アプリ品質の改善、不正利用の防止に使われることがあります。';

  @override
  String get disclaimerText =>
      'このアプリは、過去の当選番号の統計を提供し、番号の組み合わせ作りを手助けするツールです。\n\nどの宝くじでも、すべての組み合わせの1等当選確率はまったく同じです(例:韓国ロト6/45は8,145,060分の1、パワーボールは292,201,338分の1)。このアプリのフィルターや統計で当選確率が上がることはありません。楽しみと参考のためにのみご利用ください。\n\nこのアプリは独立したアプリであり、宝くじの運営会社(Dong-hang Lottery、Powerball、Mega Millions、Lotto 6/49、EuroMillions、Eurojackpot、ロト6、Irish Lotto、Vietlott など)とは一切関係ありません。\n\nアプリは当選を保証しません。宝くじの購入と参加はご自身の責任で行ってください。\n\nアプリはくじの販売を行わず、賭け・現金報酬・ギャンブルサービスも提供しません。';

  @override
  String get contactText =>
      'ご質問・不具合・ご提案がありましたら、下記メールまでお送りください。\n\n運営者:한지성\nメール:jnhteamsoft@gmail.com\n\n通常3営業日以内に返信いたします。';

  @override
  String get chooseLottery => '宝くじを選択';

  @override
  String gameRule(String count, String max) {
    return '番号$count個(1〜$max)';
  }

  @override
  String gameRuleBonus(String label, String count, String max) {
    return ' + $label$count個(1〜$max)';
  }

  @override
  String jackpotOdds(String odds) {
    return '1等確率 $odds分の1';
  }

  @override
  String drawCount(String count) {
    return '当選番号$count回分';
  }

  @override
  String get drawsPending => '当選番号準備中';

  @override
  String get drawRoundPrefix => '第';

  @override
  String get drawRoundSuffix => '回 抽選結果';

  @override
  String get drawResultPrefix => '';

  @override
  String get drawResultSuffix => ' 抽選結果';

  @override
  String drawDate(String date) {
    return '$date 抽選';
  }

  @override
  String get noDrawDate => '抽選日不明';

  @override
  String get noResultsStored => '過去の当選番号はまだありません。\n(この宝くじの当選番号は準備中です)';

  @override
  String get dbLoading => '当選番号を読み込んでいます。少し待ってからもう一度お試しください。';

  @override
  String get dbLoadingShort => '当選番号を読み込み中…';

  @override
  String get dbLoadFailed => '当選番号を読み込めませんでした。';

  @override
  String get freqPrefix => '直近 [';

  @override
  String get freqSuffix => ']回 最多 | 最少当選番号';

  @override
  String get freqHint => '全';

  @override
  String get mostDrawn => '最多出現番号';

  @override
  String get leastDrawn => '最少出現番号';

  @override
  String get noDrawData => 'この宝くじにはまだ当選番号データがありません。';

  @override
  String get recentTooLarge => '保存されている回数より多いため、全回を対象にします。';

  @override
  String get freqError => '出現回数を計算できませんでした。';

  @override
  String includeExcludeHeader(String maxInc) {
    return '含める(最大$maxInc個) | 除外(最大18個)';
  }

  @override
  String get includeRow => '含める数字';

  @override
  String get excludeRow => '除外する数字';

  @override
  String get includeBonusRow => '含める番号';

  @override
  String get excludeBonusRow => '除外する番号';

  @override
  String bonusHeader(String label, String max, String inc, String exc) {
    return '$label指定(1〜$max、含める最大$inc個・除外最大$exc個)';
  }

  @override
  String get numbersWord => '数字';

  @override
  String pickerInclude(String kind) {
    return '含める$kind';
  }

  @override
  String pickerExclude(String kind) {
    return '除外する$kind';
  }

  @override
  String pickerConflict(String number) {
    return '$number はもう一方のリストに入っています。';
  }

  @override
  String pickerMax(String max) {
    return '最大$max個まで選べます。';
  }

  @override
  String get includeLabel => '含める数字';

  @override
  String get excludeLabel => '除外する数字';

  @override
  String includeBonusLabel(String label) {
    return '含める$label';
  }

  @override
  String excludeBonusLabel(String label) {
    return '除外する$label';
  }

  @override
  String notNumber(String label, String raw) {
    return '$label:「$raw」は数字ではありません。';
  }

  @override
  String outOfRange(String label, String max) {
    return '$labelは1〜$maxの範囲で入力してください。';
  }

  @override
  String get dupInclude => '含める数字が重複しています。';

  @override
  String get dupExclude => '除外する数字が重複しています。';

  @override
  String conflict(String numbers) {
    return '含める・除外の両方に入っている数字があります:$numbers';
  }

  @override
  String get calcError => '計算に失敗しました。フィルターを確認してください。';

  @override
  String get busy => '計算中です。少しお待ちください!';

  @override
  String get noResults => '残りの組み合わせがありません。設定を変更してください。';

  @override
  String tooMany(String count) {
    return '残りの組み合わせが$count個のため、$count個生成します。';
  }

  @override
  String get noExtract => '生成できる組み合わせがありません。設定を変更してください。';

  @override
  String get extractError => '番号を生成できませんでした。設定を確認してください。';

  @override
  String get resultsTitle => '生成された組み合わせ';

  @override
  String get copied => '番号をコピーしました。';

  @override
  String get copyButton => 'コピー';

  @override
  String get shareButton => '共有';

  @override
  String shareHeader(String game) {
    return '🍀私の$game番号🍀';
  }

  @override
  String get shareSubject => '私の宝くじ番号';

  @override
  String get noHelp => '説明はありません。';

  @override
  String get obWelcome => 'Lotto Leaderへようこそ';

  @override
  String get obChooseLanguage => '使用する言語を選んでください。あとで設定から変更できます。';

  @override
  String get obNext => '次へ';

  @override
  String get obBack => '戻る';

  @override
  String get obProfileTitle => 'かんたん登録';

  @override
  String get obProfileBody => 'ニックネームを決めるだけで始められます。\nプロフィールと履歴はこの端末にのみ保存されます。';

  @override
  String get obNickname => 'ニックネーム';

  @override
  String get obNicknameHint => '2〜12文字';

  @override
  String get obNicknameError => 'ニックネームは2〜12文字で入力してください。';

  @override
  String get obAge => '居住国で宝くじを購入できる年齢です';

  @override
  String get obAgree => 'プライバシーポリシーと免責事項に同意します';

  @override
  String get obView => '表示';

  @override
  String get obStart => 'はじめる';

  @override
  String get obNeedChecks => '必須項目をすべて確認してください。';

  @override
  String get menuHistory => 'マイ履歴';

  @override
  String historyJoined(String date) {
    return '$date 登録';
  }

  @override
  String historyStats(int count) {
    return '番号生成 $count回';
  }

  @override
  String get historyEmpty => 'まだ履歴がありません。\n生成した組み合わせがここに表示されます。';

  @override
  String historyTickets(int count) {
    return '$count個の組み合わせ';
  }

  @override
  String historyFilters(int count) {
    return 'フィルター$count個';
  }

  @override
  String get historyClearAll => '履歴をすべて削除';

  @override
  String get historyClearConfirm => '番号生成の履歴をすべて削除しますか?';

  @override
  String get historyDeleted => '履歴を削除しました。';

  @override
  String get delete => '削除';

  @override
  String get cancel => 'キャンセル';

  @override
  String get confirm => 'OK';

  @override
  String profileNickname(String name) {
    return 'ニックネーム:$name';
  }

  @override
  String get withdraw => 'アカウント削除(プロフィール・履歴)';

  @override
  String get withdrawConfirm => 'プロフィールと履歴をこの端末から削除し、最初の画面に戻ります。続けますか?';

  @override
  String get manualEntry => '当選番号を手動入力';

  @override
  String get manualHelp =>
      '自動更新がうまくいかないときに、公式発表をもとに入力してください。同じ日付の公式データが届くと、そちらに置き換わります。';

  @override
  String get manualRound => '回号';

  @override
  String get manualDate => '抽選日';

  @override
  String manualMain(String count) {
    return '当選番号$count個';
  }

  @override
  String manualBonus(String label, String count) {
    return '$label$count個';
  }

  @override
  String get manualSave => '保存';

  @override
  String get manualSaved => '入力した当選番号を保存しました。';

  @override
  String get manualList => '手動入力の記録';

  @override
  String get manualNone => '手動入力の記録はありません。';

  @override
  String get manualTag => '手動入力';

  @override
  String get mErrRound => '回号を確認してください。';

  @override
  String mErrMain(String count) {
    return '当選番号を$count個選んでください。';
  }

  @override
  String mErrBonus(String label, String count) {
    return '$labelを$count個選んでください。';
  }

  @override
  String get mErrBonusOverlap => 'ボーナス数字は当選番号と重複できません。';

  @override
  String get mErrDate => '日付を確認してください。未来の日付、抽選日以外、現行ルール開始前の日付は入力できません。';

  @override
  String get mErrExists => 'この日付(回号)の当選番号はすでにあります。';

  @override
  String get adPrivacyOptions => '広告のプライバシー設定';

  @override
  String rewardTitle(String count) {
    return '$count個の組み合わせを生成';
  }

  @override
  String rewardBody(String free, String count) {
    return '$free個までは無料です。\n短い広告を見ると$count個すべて生成できます。';
  }

  @override
  String rewardWatch(String count) {
    return '広告を見て$count個';
  }

  @override
  String rewardFreeOnly(String free) {
    return '$free個だけ';
  }

  @override
  String rewardNotEarned(String free) {
    return '広告が最後まで再生されなかったため、$free個を生成します。';
  }

  @override
  String get patternFilters => 'パターン除外フィルター';

  @override
  String get pastPending => ' (当選番号準備中)';

  @override
  String get fKr1st => '過去の1等当選番号を除外';

  @override
  String get hKr1st => '過去の1等当選番号と同じ組み合わせを除外します。';

  @override
  String get fKr23 => '過去の当選番号と5個一致を除外';

  @override
  String get hKr23 => '過去の当選番号6個のうち5個が同じ組み合わせを除外します。';

  @override
  String get fKr4th => '直近100回と4個一致を除外';

  @override
  String get hKr4th => '直近100回の当選番号のうち4個が同じ組み合わせを除外します。';

  @override
  String get fKr5th => '過去の当選番号の3連続を除外';

  @override
  String get hKr5th => '過去の当選番号に含まれていた3連続の数字を含む組み合わせを除外します。';

  @override
  String get fKrRange => '狭い範囲の集中を除外(最大−最小 ≤ 9)';

  @override
  String get hKrRange => '最大の数字と最小の数字の差が9以下の組み合わせを除外します。';

  @override
  String fPastFull(String k) {
    return '過去の当選番号と$k個一致を除外';
  }

  @override
  String hPastFull(String k) {
    return '現行ルールでのいずれかの回の本数字$k個と同じ組み合わせを除外します。';
  }

  @override
  String fPastMinus1(String m) {
    return '過去の当選番号と$m個一致を除外';
  }

  @override
  String hPastMinus1(String k, String m) {
    return '過去の当選番号の本数字$k個のうち$m個が同じ組み合わせを除外します。';
  }

  @override
  String fPastMinus2(String r, String m) {
    return '直近$r回と$m個一致を除外';
  }

  @override
  String hPastMinus2(String r, String m) {
    return '直近$r回の当選番号と本数字が$m個同じ組み合わせを除外します。';
  }

  @override
  String get fPastConsec => '過去の当選番号の3連続を除外';

  @override
  String get hPastConsec => '過去の当選番号に含まれていた3連続の数字(例:7, 8, 9)を含む組み合わせを除外します。';

  @override
  String fNarrow(String n) {
    return '狭い範囲の集中を除外(最大−最小 ≤ $n)';
  }

  @override
  String hNarrow(String n) {
    return '最大の数字と最小の数字の差が$n以下の組み合わせを除外します。';
  }

  @override
  String get f3Consec => '3連続の数字を除外';

  @override
  String get h3Consec => '1, 2, 3 や 33, 34, 35 のような3連続の数字を含む組み合わせを除外します。';

  @override
  String get fDouble3Consec => '3連続＋3連続の数字を除外';

  @override
  String get hDouble3Consec =>
      '1, 2, 3, 20, 21, 22 のように3連続の数字が2組ある組み合わせを除外します。';

  @override
  String get fSkip1 => '2つおきの3数字を除外';

  @override
  String get hSkip1 => '1, 3, 5 や 15, 17, 19 のように2ずつ離れた3つの数字を含む組み合わせを除外します。';

  @override
  String get fSkip2 => '3つおきの3数字を除外';

  @override
  String get hSkip2 => '1, 4, 7 や 15, 18, 21 のように3ずつ離れた3つの数字を含む組み合わせを除外します。';

  @override
  String get fSkip3 => '4つおきの3数字を除外';

  @override
  String get hSkip3 => '1, 5, 9 や 15, 19, 23 のように4ずつ離れた3つの数字を含む組み合わせを除外します。';

  @override
  String get f2Pairs => '連続ペア2組以上を除外';

  @override
  String get h2Pairs => '1, 2 と 15, 16 のように連続した数字のペアが2組以上ある組み合わせを除外します。';

  @override
  String fAllOdd(String k) {
    return 'すべて奇数($k個)を除外';
  }

  @override
  String hAllOdd(String k) {
    return '$k個すべてが奇数の組み合わせを除外します。';
  }

  @override
  String fAllEven(String k) {
    return 'すべて偶数($k個)を除外';
  }

  @override
  String hAllEven(String k) {
    return '$k個すべてが偶数の組み合わせを除外します。';
  }

  @override
  String get fOE1 => '奇偶奇偶奇偶・偶奇偶奇偶奇を除外';

  @override
  String get fOE2 => '偶偶奇奇偶偶・奇奇偶偶奇奇を除外';

  @override
  String get fOE3 => '偶偶偶偶偶奇・奇奇奇奇奇偶を除外';

  @override
  String get fOE4 => '偶偶偶偶奇奇・奇奇奇奇偶偶を除外';

  @override
  String get fOE5 => '偶偶偶奇奇奇・奇奇奇偶偶偶を除外';

  @override
  String hOE(String pattern) {
    return '小さい順に並べた6個の数字の奇数(奇)・偶数(偶)の並びが $pattern の組み合わせを除外します。';
  }

  @override
  String get fSameDigit => '同じ下一桁が3個以上を除外';

  @override
  String get hSameDigit => '1, 11, 21, 31 のように下一桁が同じ数字を3個以上含む組み合わせを除外します。';

  @override
  String get fTripleMult => '3連続の倍数を除外';

  @override
  String get hTripleMult =>
      '2, 4, 6 や 4, 8, 12 のように同じ数の連続した倍数3個を含む組み合わせを除外します。';

  @override
  String get alarmIntro => 'オンにした宝くじは、抽選の3時間前にスマホへ通知します。';

  @override
  String alarmDrawAt(String days, String time) {
    return '抽選 $days $time(現地時間)';
  }

  @override
  String get alarmUnsupported => 'この端末では通知に対応していません。スマホアプリでご利用ください。';

  @override
  String get alarmDenied => '通知がオフになっています。スマホの設定でこのアプリの通知を許可してください。';

  @override
  String alarmOn(String game) {
    return '$gameの抽選3時間前にお知らせします。';
  }

  @override
  String alarmOff(String game) {
    return '$gameの通知をオフにしました。';
  }

  @override
  String notifyTitle(String game) {
    return '今日は$gameの抽選日!';
  }

  @override
  String get notifyBody => '3時間後に抽選があります。Lotto Leaderで番号を作ってみましょう。';

  @override
  String get notifyChannel => '抽選日のお知らせ';

  @override
  String get winPending => '抽選待ち';

  @override
  String winDrawOf(String date) {
    return '$dateの抽選結果と比較';
  }

  @override
  String winRank(String rank) {
    return '$rank等';
  }

  @override
  String winBest(String rank) {
    return '最高 $rank';
  }

  @override
  String get winNone => 'はずれ';

  @override
  String winMatch(String main) {
    return '$main個一致';
  }

  @override
  String winMatchPlus(String main, String bonus) {
    return '$main+$bonus 一致';
  }

  @override
  String winMatchBonus(String main) {
    return '$main個 + ボーナス一致';
  }

  @override
  String get winPendingHint =>
      '抽選結果が届くと自動で比較します。遅れる場合は 設定 → 当選番号を手動入力 をご利用ください。';

  @override
  String get statsTitle => '番号統計';

  @override
  String statsRecent(String n) {
    return '直近$n回';
  }

  @override
  String get statsAll => '全体';

  @override
  String get statsMain => '本数字';

  @override
  String get statsSortNumber => '番号順';

  @override
  String get statsSortMost => '多い順';

  @override
  String get statsSortLeast => '少ない順';

  @override
  String get statsSortGap => '長く出ていない順';

  @override
  String statsAnalyzed(int n) {
    return '直近$n回の抽選が対象';
  }

  @override
  String get statsHot => 'よく出る番号';

  @override
  String get statsCold => '長く出ていない番号';

  @override
  String statsCount(String n) {
    return '$n回';
  }

  @override
  String statsGap(int n) {
    return '$n回前';
  }

  @override
  String get statsGapLatest => '前回';

  @override
  String get statsGapNever => '期間内なし';

  @override
  String get statsOddEven => '奇数・偶数の割合';

  @override
  String statsOddLabel(String odd, String even) {
    return '奇$odd : 偶$even';
  }

  @override
  String get statsDisclaimer => '過去の抽選記録であり、次回の結果を予測するものではありません。';

  @override
  String get backupExport => '履歴をバックアップ';

  @override
  String get backupImport => 'バックアップから復元';

  @override
  String get backupShareText =>
      'Lotto Leaderのバックアップファイルです。新しいスマホで 設定 → バックアップから復元 を開き、このファイルを選んでください。';

  @override
  String get backupEmpty => 'バックアップする履歴がまだありません。';

  @override
  String get backupFailed => 'バックアップファイルを作成できませんでした。しばらくしてからお試しください。';

  @override
  String get backupImportConfirm =>
      'バックアップの履歴をこの端末の履歴と統合します。ニックネームと登録日はバックアップの内容に変わります。続けますか?';

  @override
  String backupImportDone(String history, String manual) {
    return '復元完了。追加:履歴 $history · 手動入力 $manual';
  }

  @override
  String get backupInvalid => 'Lotto Leaderのバックアップファイルではないか、ファイルが壊れています。';

  @override
  String get backupTooLarge => 'ファイルが大きすぎます。Lotto Leaderのバックアップファイルを選んでください。';

  @override
  String get continueButton => '続ける';

  @override
  String get colon => ':';

  @override
  String fSum(String lo, String hi) {
    return '合計 $lo〜$hi の範囲外を除外';
  }

  @override
  String hSum(String lo, String hi) {
    return '本数字の合計が$lo未満または$hiを超える組み合わせを除外します。全組み合わせの約95%がこの範囲に入ります。';
  }

  @override
  String get fBirthday => 'すべて31以下の組み合わせを除外(誕生日番号)';

  @override
  String get hBirthday =>
      '1〜31(日付に使われる数字)だけの組み合わせを除外します。誕生日で番号を選ぶ人が多いため、1等になっても当選金を分け合う可能性が高い組み合わせです。当選確率そのものは他の組み合わせと同じです。';

  @override
  String get fLowHigh => 'すべて小さい番号・すべて大きい番号を除外';

  @override
  String hLowHigh(String half, String next, String max) {
    return 'すべての数字が1〜$half、またはすべて$next〜$maxにある組み合わせを除外します。';
  }

  @override
  String get fDecade4 => '同じ10番台に4個以上を除外';

  @override
  String get hDecade4 =>
      '41, 43, 45, 48 のように同じ10番台(1〜9, 10〜19, 20〜29 …)に4個以上集まった組み合わせを除外します。';

  @override
  String get fRepeatLast => '前回の当選番号を2個以上含む組み合わせを除外';

  @override
  String get hRepeatLast => '直前の抽選の本数字を2個以上含む組み合わせを除外します。';

  @override
  String fBonusRecent(String n, String label) {
    return '直近$n回に出た$labelを除外';
  }

  @override
  String hBonusRecent(String n, String label) {
    return '直近$n回の抽選で出た$labelの番号は選びません。';
  }

  @override
  String fBonusPairRecent(String n, String label) {
    return '直近$n回に出た$labelの2個の組み合わせを除外';
  }

  @override
  String hBonusPairRecent(String n, String label) {
    return '直近$n回の抽選と同じ${label}2個の組み合わせは選びません。';
  }

  @override
  String fBonusConsec(String label) {
    return '$labelの連続番号を除外(例:3・4)';
  }

  @override
  String hBonusConsec(String label) {
    return '${label}2個が3・4のように連続した番号の組み合わせは選びません。';
  }

  @override
  String fBonusParity(String label) {
    return '$labelが両方奇数・両方偶数を除外';
  }

  @override
  String hBonusParity(String label) {
    return '${label}2個が両方奇数、または両方偶数の組み合わせは選びません。';
  }

  @override
  String get filtersOverseas => 'この宝くじの追加フィルター';

  @override
  String filtersBonus(String label) {
    return '$labelフィルター';
  }
}
