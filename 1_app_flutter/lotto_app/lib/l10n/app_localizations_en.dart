// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Lotto Leader';

  @override
  String get close => 'Close';

  @override
  String get apply => 'Apply';

  @override
  String get lookup => 'View';

  @override
  String get calculating => 'Calculating…';

  @override
  String get extracting => 'Generating…';

  @override
  String get extractButton => 'Generate';

  @override
  String get countHint => 'Qty';

  @override
  String get remainingCombos => 'Remaining combinations';

  @override
  String get menuResults => 'Results';

  @override
  String get menuReset => 'Reset';

  @override
  String get menuAlarm => 'Alerts';

  @override
  String get menuSettings => 'Settings';

  @override
  String get privacyPolicy => 'Privacy policy';

  @override
  String get disclaimer => 'Disclaimer';

  @override
  String get contact => 'Contact';

  @override
  String get versionLabel => 'Version';

  @override
  String currentVersion(String version) {
    return 'Current app version $version';
  }

  @override
  String get language => 'Language';

  @override
  String get languageSystem => 'Use device language';

  @override
  String drawAlarm(String game) {
    return '$game draw-day reminder';
  }

  @override
  String get resetDone => 'Reset to default settings.';

  @override
  String get privacyText =>
      'This app is free. On first launch you create a simple profile with just a nickname. Your nickname and generation history are stored only on this device, are never sent to the operator, and can be deleted at any time in Settings → Delete account.\n\nThe app itself does not collect personally identifying information such as your name, phone number or email address.\n\nThe app uses Google AdMob to show ads. In that process, the advertising ID, device information and app usage information may be collected by Google. Where consent is required (e.g. in the EEA and UK), you are asked on first launch and can change your choice at any time in Settings → Ad privacy settings.\n\nThis information may be used to deliver ads, improve app quality and prevent abuse.';

  @override
  String get disclaimerText =>
      'This app is a tool that offers statistics on past winning numbers and helps you build number combinations.\n\nIn every lottery, each combination has exactly the same chance of winning the jackpot (e.g. 1 in 8,145,060 for Korea\'s Lotto 6/45 and 1 in 292,201,338 for Powerball). The filters and statistics in this app do not improve your odds. Please use them for fun and reference only.\n\nThis is an independent app and is not affiliated with any lottery operator (including Dong-hang Lottery, Powerball, Mega Millions, Lotto 6/49, EuroMillions, Eurojackpot, Loto 6, Irish Lotto or Vietlott).\n\nThe app does not guarantee any winnings. You are solely responsible for buying and playing lottery tickets.\n\nThe app does not sell tickets and offers no betting, cash rewards or gambling services.';

  @override
  String get contactText =>
      'If you have questions, find a bug or have a suggestion, please email us.\n\nOperator: 한지성\nEmail: jnhteamsoft@gmail.com\n\nWe usually reply within 3 business days.';

  @override
  String get chooseLottery => 'Choose lottery';

  @override
  String gameRule(String count, String max) {
    return '$count numbers (1–$max)';
  }

  @override
  String gameRuleBonus(String label, String count, String max) {
    return ' + $count $label (1–$max)';
  }

  @override
  String jackpotOdds(String odds) {
    return 'Jackpot odds 1 in $odds';
  }

  @override
  String drawCount(String count) {
    return '$count past draws';
  }

  @override
  String get drawsPending => 'Results coming soon';

  @override
  String get drawRoundPrefix => 'Draw #';

  @override
  String get drawRoundSuffix => '';

  @override
  String get drawResultPrefix => '';

  @override
  String get drawResultSuffix => ' results';

  @override
  String drawDate(String date) {
    return 'Drawn on $date';
  }

  @override
  String get noDrawDate => 'Draw date unknown';

  @override
  String get noResultsStored =>
      'No past results yet.\n(Results for this lottery are coming soon.)';

  @override
  String get dbLoading => 'Loading past results. Please try again in a moment.';

  @override
  String get dbLoadingShort => 'Loading past results…';

  @override
  String get dbLoadFailed => 'Could not load past results.';

  @override
  String get freqPrefix => 'Last [';

  @override
  String get freqSuffix => '] draws: most | least drawn';

  @override
  String get freqHint => 'all';

  @override
  String get mostDrawn => 'Most drawn';

  @override
  String get leastDrawn => 'Least drawn';

  @override
  String get noDrawData => 'No past results for this lottery yet.';

  @override
  String get recentTooLarge =>
      'That\'s more draws than are stored, so all draws are used.';

  @override
  String get freqError => 'Could not calculate frequencies.';

  @override
  String includeExcludeHeader(String maxInc) {
    return 'Include (max $maxInc) | Exclude (max 18)';
  }

  @override
  String get includeRow => 'Include';

  @override
  String get excludeRow => 'Exclude';

  @override
  String get includeBonusRow => 'Include';

  @override
  String get excludeBonusRow => 'Exclude';

  @override
  String bonusHeader(String label, String max, String inc, String exc) {
    return '$label (1–$max, include up to $inc · exclude up to $exc)';
  }

  @override
  String get numbersWord => 'numbers';

  @override
  String pickerInclude(String kind) {
    return 'Include $kind';
  }

  @override
  String pickerExclude(String kind) {
    return 'Exclude $kind';
  }

  @override
  String pickerConflict(String number) {
    return '$number is already in the other list.';
  }

  @override
  String pickerMax(String max) {
    return 'You can select up to $max.';
  }

  @override
  String get includeLabel => 'Included numbers';

  @override
  String get excludeLabel => 'Excluded numbers';

  @override
  String includeBonusLabel(String label) {
    return 'Included $label';
  }

  @override
  String excludeBonusLabel(String label) {
    return 'Excluded $label';
  }

  @override
  String notNumber(String label, String raw) {
    return '$label: \"$raw\" is not a number.';
  }

  @override
  String outOfRange(String label, String max) {
    return '$label must be between 1 and $max.';
  }

  @override
  String get dupInclude => 'Included numbers contain duplicates.';

  @override
  String get dupExclude => 'Excluded numbers contain duplicates.';

  @override
  String conflict(String numbers) {
    return 'These numbers are both included and excluded: $numbers';
  }

  @override
  String get calcError => 'Calculation failed. Please check your filters.';

  @override
  String get busy => 'Still calculating. Please wait!';

  @override
  String get noResults => 'No combinations left. Please change your settings.';

  @override
  String tooMany(String count) {
    return 'Only $count combinations remain, so $count will be generated.';
  }

  @override
  String get noExtract =>
      'No combinations available. Please change your settings.';

  @override
  String get extractError =>
      'Could not generate numbers. Please check your settings.';

  @override
  String get resultsTitle => 'Your combinations';

  @override
  String get copied => 'Numbers copied.';

  @override
  String get copyButton => 'Copy';

  @override
  String get shareButton => 'Share';

  @override
  String shareHeader(String game) {
    return '🍀My $game numbers🍀';
  }

  @override
  String get shareSubject => 'My lottery numbers';

  @override
  String get noHelp => 'No description available.';

  @override
  String get obWelcome => 'Welcome to Lotto Leader';

  @override
  String get obChooseLanguage =>
      'Choose your language. You can change it later in Settings.';

  @override
  String get obNext => 'Next';

  @override
  String get obBack => 'Back';

  @override
  String get obProfileTitle => 'Quick sign-up';

  @override
  String get obProfileBody =>
      'Just pick a nickname to get started.\nYour profile and history are stored only on this device.';

  @override
  String get obNickname => 'Nickname';

  @override
  String get obNicknameHint => '2–12 characters';

  @override
  String get obNicknameError => 'Please enter a nickname of 2–12 characters.';

  @override
  String get obAge => 'I am of legal age to play the lottery in my country';

  @override
  String get obAgree => 'I agree to the Privacy Policy and Disclaimer';

  @override
  String get obView => 'View';

  @override
  String get obStart => 'Get started';

  @override
  String get obNeedChecks => 'Please confirm all required items.';

  @override
  String get menuHistory => 'My history';

  @override
  String historyJoined(String date) {
    return 'Joined $date';
  }

  @override
  String historyStats(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count generations',
      one: '$count generation',
    );
    return '$_temp0';
  }

  @override
  String get historyEmpty =>
      'No history yet.\nCombinations you generate will appear here.';

  @override
  String historyTickets(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count combinations',
      one: '$count combination',
    );
    return '$_temp0';
  }

  @override
  String historyFilters(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count filters',
      one: '$count filter',
    );
    return '$_temp0';
  }

  @override
  String get historyClearAll => 'Clear all history';

  @override
  String get historyClearConfirm => 'Delete all generation history?';

  @override
  String get historyDeleted => 'Entry deleted.';

  @override
  String get delete => 'Delete';

  @override
  String get cancel => 'Cancel';

  @override
  String get exitTitle => 'Exit app';

  @override
  String get exitConfirm => 'Do you want to exit Lotto Leader?';

  @override
  String get exitButton => 'Exit';

  @override
  String get confirm => 'OK';

  @override
  String profileNickname(String name) {
    return 'Nickname: $name';
  }

  @override
  String get withdraw => 'Delete account (profile & history)';

  @override
  String get withdrawConfirm =>
      'Your profile and history will be deleted from this device and you\'ll return to the start screen. Continue?';

  @override
  String get manualEntry => 'Enter results manually';

  @override
  String get manualHelp =>
      'Use this when automatic updates aren\'t working, based on the official results. Official data for the same date will replace your entry later.';

  @override
  String get manualRound => 'Draw no.';

  @override
  String get manualDate => 'Draw date';

  @override
  String manualMain(String count) {
    return '$count winning numbers';
  }

  @override
  String manualBonus(String label, String count) {
    return '$label: $count';
  }

  @override
  String get manualSave => 'Save';

  @override
  String get manualSaved => 'Results saved.';

  @override
  String get manualList => 'Your entries';

  @override
  String get manualNone => 'No manual entries.';

  @override
  String get manualTag => 'Manual';

  @override
  String get mErrRound => 'Please check the draw number.';

  @override
  String mErrMain(String count) {
    return 'Please select $count winning numbers.';
  }

  @override
  String mErrBonus(String label, String count) {
    return '$label: please select $count.';
  }

  @override
  String get mErrBonusOverlap =>
      'The bonus number can\'t be one of the winning numbers.';

  @override
  String get mErrDate =>
      'Please check the date. Future dates, non-draw days and dates before the current rules aren\'t allowed.';

  @override
  String get mErrExists => 'Results for this date (draw) already exist.';

  @override
  String get adPrivacyOptions => 'Ad privacy settings';

  @override
  String rewardTitle(String count) {
    return 'Generate $count combinations';
  }

  @override
  String rewardBody(String free, String count) {
    return 'Up to $free combinations are free.\nWatch a short ad to generate all $count.';
  }

  @override
  String rewardWatch(String count) {
    return 'Watch ad for $count';
  }

  @override
  String rewardFreeOnly(String free) {
    return 'Just $free';
  }

  @override
  String rewardNotEarned(String free) {
    return 'The ad wasn\'t finished, so $free combinations will be generated.';
  }

  @override
  String get patternFilters => 'Pattern filters';

  @override
  String get pastPending => ' (results coming soon)';

  @override
  String get fKr1st => 'Exclude past jackpot combinations';

  @override
  String get hKr1st =>
      'Excludes combinations identical to any past jackpot result.';

  @override
  String get fKr23 => 'Exclude 5-number matches with past draws';

  @override
  String get hKr23 =>
      'Excludes combinations sharing 5 of the 6 numbers of any past draw.';

  @override
  String get fKr4th => 'Exclude 4-number matches (last 100 draws)';

  @override
  String get hKr4th =>
      'Excludes combinations sharing 4 numbers with any of the last 100 draws.';

  @override
  String get fKr5th => 'Exclude consecutive triples seen in past draws';

  @override
  String get hKr5th =>
      'Excludes combinations containing a run of 3 consecutive numbers that appeared in a past draw.';

  @override
  String get fKrRange => 'Exclude narrow spreads (max − min ≤ 9)';

  @override
  String get hKrRange =>
      'Excludes combinations whose highest and lowest numbers are 9 or less apart.';

  @override
  String fPastFull(String k) {
    return 'Exclude past winning sets ($k matches)';
  }

  @override
  String hPastFull(String k) {
    return 'Excludes combinations identical to the $k main numbers of any draw under the current rules.';
  }

  @override
  String fPastMinus1(String m) {
    return 'Exclude $m-number matches with past draws';
  }

  @override
  String hPastMinus1(String k, String m) {
    return 'Excludes combinations sharing $m of the $k main numbers of any past draw.';
  }

  @override
  String fPastMinus2(String r, String m) {
    return 'Exclude $m-number matches (last $r draws)';
  }

  @override
  String hPastMinus2(String r, String m) {
    return 'Excludes combinations sharing $m main numbers with any of the last $r draws.';
  }

  @override
  String get fPastConsec => 'Exclude consecutive triples seen in past draws';

  @override
  String get hPastConsec =>
      'Excludes combinations containing a run of 3 consecutive numbers (e.g. 7, 8, 9) that appeared in a past draw.';

  @override
  String fNarrow(String n) {
    return 'Exclude narrow spreads (max − min ≤ $n)';
  }

  @override
  String hNarrow(String n) {
    return 'Excludes combinations whose highest and lowest numbers are $n or less apart.';
  }

  @override
  String get f3Consec => 'Exclude 3 consecutive numbers';

  @override
  String get h3Consec =>
      'Excludes combinations with 3 consecutive numbers, such as 1, 2, 3 or 33, 34, 35.';

  @override
  String get fDouble3Consec => 'Exclude two runs of 3 consecutive numbers';

  @override
  String get hDouble3Consec =>
      'Excludes combinations made of two runs of 3 consecutive numbers, such as 1, 2, 3, 20, 21, 22.';

  @override
  String get fSkip1 => 'Exclude 3 numbers in steps of 2';

  @override
  String get hSkip1 =>
      'Excludes combinations with 3 numbers spaced by 2, such as 1, 3, 5 or 15, 17, 19.';

  @override
  String get fSkip2 => 'Exclude 3 numbers in steps of 3';

  @override
  String get hSkip2 =>
      'Excludes combinations with 3 numbers spaced by 3, such as 1, 4, 7 or 15, 18, 21.';

  @override
  String get fSkip3 => 'Exclude 3 numbers in steps of 4';

  @override
  String get hSkip3 =>
      'Excludes combinations with 3 numbers spaced by 4, such as 1, 5, 9 or 15, 19, 23.';

  @override
  String get f2Pairs => 'Exclude 2+ consecutive pairs';

  @override
  String get h2Pairs =>
      'Excludes combinations with two or more consecutive pairs, such as 1, 2 and 15, 16.';

  @override
  String fAllOdd(String k) {
    return 'Exclude all odd ($k odd numbers)';
  }

  @override
  String hAllOdd(String k) {
    return 'Excludes combinations where all $k numbers are odd.';
  }

  @override
  String fAllEven(String k) {
    return 'Exclude all even ($k even numbers)';
  }

  @override
  String hAllEven(String k) {
    return 'Excludes combinations where all $k numbers are even.';
  }

  @override
  String get fOE1 => 'Exclude O-E-O-E-O-E / E-O-E-O-E-O';

  @override
  String get fOE2 => 'Exclude E-E-O-O-E-E / O-O-E-E-O-O';

  @override
  String get fOE3 => 'Exclude E-E-E-E-E-O / O-O-O-O-O-E';

  @override
  String get fOE4 => 'Exclude E-E-E-E-O-O / O-O-O-O-E-E';

  @override
  String get fOE5 => 'Exclude E-E-E-O-O-O / O-O-O-E-E-E';

  @override
  String hOE(String pattern) {
    return 'Excludes combinations whose 6 sorted numbers follow the odd(O)/even(E) order $pattern.';
  }

  @override
  String get fSameDigit => 'Exclude 3+ numbers with the same last digit';

  @override
  String get hSameDigit =>
      'Excludes combinations with 3 or more numbers ending in the same digit, such as 1, 11, 21, 31.';

  @override
  String get fTripleMult => 'Exclude 3 consecutive multiples';

  @override
  String get hTripleMult =>
      'Excludes combinations containing 3 consecutive multiples of the same number, such as 2, 4, 6 or 4, 8, 12.';

  @override
  String get alarmIntro =>
      'You\'ll get a phone notification 3 hours before each draw of the lotteries you turn on.';

  @override
  String alarmDrawAt(String days, String time) {
    return 'Draws $days $time (local time)';
  }

  @override
  String get alarmUnsupported =>
      'Notifications aren\'t supported on this device. Please use the phone app.';

  @override
  String get alarmDenied =>
      'Notifications are turned off. Please allow notifications for this app in your phone settings.';

  @override
  String alarmOn(String game) {
    return 'We\'ll remind you 3 hours before each $game draw.';
  }

  @override
  String alarmOff(String game) {
    return '$game reminders turned off.';
  }

  @override
  String notifyTitle(String game) {
    return '$game draw today!';
  }

  @override
  String get notifyBody =>
      'The draw is in 3 hours. Generate your numbers in Lotto Leader.';

  @override
  String get notifyChannel => 'Draw reminders';

  @override
  String get winPending => 'Awaiting draw';

  @override
  String winDrawOf(String date) {
    return 'Compared with the $date draw';
  }

  @override
  String winRank(String rank) {
    return 'Tier $rank';
  }

  @override
  String winBest(String rank) {
    return 'Best: $rank';
  }

  @override
  String get winNone => 'No win';

  @override
  String winMatch(String main) {
    return '$main matched';
  }

  @override
  String winMatchPlus(String main, String bonus) {
    return '$main+$bonus matched';
  }

  @override
  String winMatchBonus(String main) {
    return '$main + bonus matched';
  }

  @override
  String get winPendingHint =>
      'Results are compared automatically once the draw is in. If it\'s late, use Settings → Enter results manually.';

  @override
  String get statsTitle => 'Number stats';

  @override
  String statsRecent(String n) {
    return 'Last $n';
  }

  @override
  String get statsAll => 'All';

  @override
  String get statsMain => 'Main numbers';

  @override
  String get statsSortNumber => 'By number';

  @override
  String get statsSortMost => 'Most drawn';

  @override
  String get statsSortLeast => 'Least drawn';

  @override
  String get statsSortGap => 'Longest absent';

  @override
  String statsAnalyzed(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: 'Based on the last $n draws',
      one: 'Based on the last draw',
    );
    return '$_temp0';
  }

  @override
  String get statsHot => 'Hot numbers';

  @override
  String get statsCold => 'Cold numbers';

  @override
  String statsCount(String n) {
    return '$n×';
  }

  @override
  String statsGap(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n draws ago',
      one: '$n draw ago',
    );
    return '$_temp0';
  }

  @override
  String get statsGapLatest => 'Last draw';

  @override
  String get statsGapNever => 'Not drawn';

  @override
  String get statsOddEven => 'Odd / even split';

  @override
  String statsOddLabel(String odd, String even) {
    return '$odd odd : $even even';
  }

  @override
  String get statsDisclaimer =>
      'These are past results only and don\'t predict future draws.';

  @override
  String get backupExport => 'Back up history';

  @override
  String get backupImport => 'Restore from backup';

  @override
  String get backupShareText =>
      'Lotto Leader backup file. On your new phone, open Settings → Restore from backup and choose this file.';

  @override
  String get backupEmpty => 'There\'s nothing to back up yet.';

  @override
  String get backupFailed =>
      'Couldn\'t create the backup file. Please try again later.';

  @override
  String get backupImportConfirm =>
      'The backup will be merged with the history on this device. Your nickname and sign-up date will be taken from the backup. Continue?';

  @override
  String backupImportDone(String history, String manual) {
    return 'Restore complete. Added: history $history · manual results $manual';
  }

  @override
  String get backupInvalid =>
      'This isn\'t a Lotto Leader backup file, or the file is damaged.';

  @override
  String get backupTooLarge =>
      'The file is too large. Please choose a Lotto Leader backup file.';

  @override
  String get continueButton => 'Continue';

  @override
  String get colon => ': ';

  @override
  String fSum(String lo, String hi) {
    return 'Exclude sums outside $lo–$hi';
  }

  @override
  String hSum(String lo, String hi) {
    return 'Excludes combinations whose main numbers add up to less than $lo or more than $hi. About 95% of all combinations fall within this range.';
  }

  @override
  String get fBirthday => 'Exclude all-31-or-lower sets (birthday numbers)';

  @override
  String get hBirthday =>
      'Excludes combinations made only of 1–31 (numbers used in dates). Many people pick birthdays, so a jackpot on these numbers is more likely to be shared. The chance of winning is the same as any other combination.';

  @override
  String get fLowHigh => 'Exclude all-low or all-high sets';

  @override
  String hLowHigh(String half, String next, String max) {
    return 'Excludes combinations whose numbers are all within 1–$half, or all within $next–$max.';
  }

  @override
  String get fDecade4 => 'Exclude 4+ numbers in the same decade';

  @override
  String get hDecade4 =>
      'Excludes combinations with 4 or more numbers in the same group of ten (1–9, 10–19, 20–29 …), such as 41, 43, 45, 48.';

  @override
  String get fRepeatLast => 'Exclude 2+ numbers from the last draw';

  @override
  String get hRepeatLast =>
      'Excludes combinations that repeat 2 or more main numbers from the most recent draw.';

  @override
  String fBonusRecent(String n, String label) {
    return 'Exclude $label from the last $n draws';
  }

  @override
  String hBonusRecent(String n, String label) {
    return '$label numbers drawn in the last $n draws won\'t be picked.';
  }

  @override
  String fBonusPairRecent(String n, String label) {
    return 'Exclude $label pairs from the last $n draws';
  }

  @override
  String hBonusPairRecent(String n, String label) {
    return 'A $label pair identical to one of the last $n draws won\'t be picked.';
  }

  @override
  String fBonusConsec(String label) {
    return 'Exclude consecutive $label (e.g. 3·4)';
  }

  @override
  String hBonusConsec(String label) {
    return '$label pairs of consecutive numbers, such as 3·4, won\'t be picked.';
  }

  @override
  String fBonusParity(String label) {
    return 'Exclude $label both odd or both even';
  }

  @override
  String hBonusParity(String label) {
    return '$label pairs that are both odd or both even won\'t be picked.';
  }

  @override
  String get filtersOverseas => 'Extra filters for this lottery';

  @override
  String filtersBonus(String label) {
    return '$label filters';
  }
}
