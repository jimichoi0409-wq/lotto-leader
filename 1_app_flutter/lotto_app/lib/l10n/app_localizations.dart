import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_ja.dart';
import 'app_localizations_ko.dart';
import 'app_localizations_vi.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('de'),
    Locale('en'),
    Locale('es'),
    Locale('fr'),
    Locale('ja'),
    Locale('ko'),
    Locale('vi'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Lotto Leader'**
  String get appTitle;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @apply.
  ///
  /// In en, this message translates to:
  /// **'Apply'**
  String get apply;

  /// No description provided for @lookup.
  ///
  /// In en, this message translates to:
  /// **'View'**
  String get lookup;

  /// No description provided for @calculating.
  ///
  /// In en, this message translates to:
  /// **'Calculating…'**
  String get calculating;

  /// No description provided for @extracting.
  ///
  /// In en, this message translates to:
  /// **'Generating…'**
  String get extracting;

  /// No description provided for @extractButton.
  ///
  /// In en, this message translates to:
  /// **'Generate'**
  String get extractButton;

  /// No description provided for @countHint.
  ///
  /// In en, this message translates to:
  /// **'Qty'**
  String get countHint;

  /// No description provided for @remainingCombos.
  ///
  /// In en, this message translates to:
  /// **'Remaining combinations'**
  String get remainingCombos;

  /// No description provided for @menuResults.
  ///
  /// In en, this message translates to:
  /// **'Results'**
  String get menuResults;

  /// No description provided for @menuReset.
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get menuReset;

  /// No description provided for @menuAlarm.
  ///
  /// In en, this message translates to:
  /// **'Alerts'**
  String get menuAlarm;

  /// No description provided for @menuSettings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get menuSettings;

  /// No description provided for @privacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy policy'**
  String get privacyPolicy;

  /// No description provided for @disclaimer.
  ///
  /// In en, this message translates to:
  /// **'Disclaimer'**
  String get disclaimer;

  /// No description provided for @contact.
  ///
  /// In en, this message translates to:
  /// **'Contact'**
  String get contact;

  /// No description provided for @versionLabel.
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get versionLabel;

  /// No description provided for @currentVersion.
  ///
  /// In en, this message translates to:
  /// **'Current app version {version}'**
  String currentVersion(String version);

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @languageSystem.
  ///
  /// In en, this message translates to:
  /// **'Use device language'**
  String get languageSystem;

  /// No description provided for @drawAlarm.
  ///
  /// In en, this message translates to:
  /// **'{game} draw-day reminder'**
  String drawAlarm(String game);

  /// No description provided for @resetDone.
  ///
  /// In en, this message translates to:
  /// **'Reset to default settings.'**
  String get resetDone;

  /// No description provided for @privacyText.
  ///
  /// In en, this message translates to:
  /// **'This app is free. On first launch you create a simple profile with just a nickname. Your nickname and generation history are stored only on this device, are never sent to the operator, and can be deleted at any time in Settings → Delete account.\n\nThe app itself does not collect personally identifying information such as your name, phone number or email address.\n\nThe app uses Google AdMob to show ads. In that process, the advertising ID, device information and app usage information may be collected by Google. Where consent is required (e.g. in the EEA and UK), you are asked on first launch and can change your choice at any time in Settings → Ad privacy settings.\n\nThis information may be used to deliver ads, improve app quality and prevent abuse.'**
  String get privacyText;

  /// No description provided for @disclaimerText.
  ///
  /// In en, this message translates to:
  /// **'This app is a tool that offers statistics on past winning numbers and helps you build number combinations.\n\nIn every lottery, each combination has exactly the same chance of winning the jackpot (e.g. 1 in 8,145,060 for Korea\'s Lotto 6/45 and 1 in 292,201,338 for Powerball). The filters and statistics in this app do not improve your odds. Please use them for fun and reference only.\n\nThis is an independent app and is not affiliated with any lottery operator (including Dong-hang Lottery, Powerball, Mega Millions, Lotto 6/49, EuroMillions, Eurojackpot, Loto 6, Irish Lotto or Vietlott).\n\nThe app does not guarantee any winnings. You are solely responsible for buying and playing lottery tickets.\n\nThe app does not sell tickets and offers no betting, cash rewards or gambling services.'**
  String get disclaimerText;

  /// No description provided for @contactText.
  ///
  /// In en, this message translates to:
  /// **'If you have questions, find a bug or have a suggestion, please email us.\n\nOperator: 한지성\nEmail: jnhteamsoft@gmail.com\n\nWe usually reply within 3 business days.'**
  String get contactText;

  /// No description provided for @chooseLottery.
  ///
  /// In en, this message translates to:
  /// **'Choose lottery'**
  String get chooseLottery;

  /// No description provided for @gameRule.
  ///
  /// In en, this message translates to:
  /// **'{count} numbers (1–{max})'**
  String gameRule(String count, String max);

  /// No description provided for @gameRuleBonus.
  ///
  /// In en, this message translates to:
  /// **' + {count} {label} (1–{max})'**
  String gameRuleBonus(String label, String count, String max);

  /// No description provided for @jackpotOdds.
  ///
  /// In en, this message translates to:
  /// **'Jackpot odds 1 in {odds}'**
  String jackpotOdds(String odds);

  /// No description provided for @drawCount.
  ///
  /// In en, this message translates to:
  /// **'{count} past draws'**
  String drawCount(String count);

  /// No description provided for @drawsPending.
  ///
  /// In en, this message translates to:
  /// **'Results coming soon'**
  String get drawsPending;

  /// No description provided for @drawRoundPrefix.
  ///
  /// In en, this message translates to:
  /// **'Draw #'**
  String get drawRoundPrefix;

  /// No description provided for @drawRoundSuffix.
  ///
  /// In en, this message translates to:
  /// **''**
  String get drawRoundSuffix;

  /// No description provided for @drawResultPrefix.
  ///
  /// In en, this message translates to:
  /// **''**
  String get drawResultPrefix;

  /// No description provided for @drawResultSuffix.
  ///
  /// In en, this message translates to:
  /// **' results'**
  String get drawResultSuffix;

  /// No description provided for @drawDate.
  ///
  /// In en, this message translates to:
  /// **'Drawn on {date}'**
  String drawDate(String date);

  /// No description provided for @noDrawDate.
  ///
  /// In en, this message translates to:
  /// **'Draw date unknown'**
  String get noDrawDate;

  /// No description provided for @noResultsStored.
  ///
  /// In en, this message translates to:
  /// **'No past results yet.\n(Results for this lottery are coming soon.)'**
  String get noResultsStored;

  /// No description provided for @dbLoading.
  ///
  /// In en, this message translates to:
  /// **'Loading past results. Please try again in a moment.'**
  String get dbLoading;

  /// No description provided for @dbLoadingShort.
  ///
  /// In en, this message translates to:
  /// **'Loading past results…'**
  String get dbLoadingShort;

  /// No description provided for @dbLoadFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not load past results.'**
  String get dbLoadFailed;

  /// No description provided for @freqPrefix.
  ///
  /// In en, this message translates to:
  /// **'Last ['**
  String get freqPrefix;

  /// No description provided for @freqSuffix.
  ///
  /// In en, this message translates to:
  /// **'] draws: most | least drawn'**
  String get freqSuffix;

  /// No description provided for @freqHint.
  ///
  /// In en, this message translates to:
  /// **'all'**
  String get freqHint;

  /// No description provided for @mostDrawn.
  ///
  /// In en, this message translates to:
  /// **'Most drawn'**
  String get mostDrawn;

  /// No description provided for @leastDrawn.
  ///
  /// In en, this message translates to:
  /// **'Least drawn'**
  String get leastDrawn;

  /// No description provided for @noDrawData.
  ///
  /// In en, this message translates to:
  /// **'No past results for this lottery yet.'**
  String get noDrawData;

  /// No description provided for @recentTooLarge.
  ///
  /// In en, this message translates to:
  /// **'That\'s more draws than are stored, so all draws are used.'**
  String get recentTooLarge;

  /// No description provided for @freqError.
  ///
  /// In en, this message translates to:
  /// **'Could not calculate frequencies.'**
  String get freqError;

  /// No description provided for @includeExcludeHeader.
  ///
  /// In en, this message translates to:
  /// **'Include (max {maxInc}) | Exclude (max 18)'**
  String includeExcludeHeader(String maxInc);

  /// No description provided for @includeRow.
  ///
  /// In en, this message translates to:
  /// **'Include'**
  String get includeRow;

  /// No description provided for @excludeRow.
  ///
  /// In en, this message translates to:
  /// **'Exclude'**
  String get excludeRow;

  /// No description provided for @includeBonusRow.
  ///
  /// In en, this message translates to:
  /// **'Include'**
  String get includeBonusRow;

  /// No description provided for @excludeBonusRow.
  ///
  /// In en, this message translates to:
  /// **'Exclude'**
  String get excludeBonusRow;

  /// No description provided for @bonusHeader.
  ///
  /// In en, this message translates to:
  /// **'{label} (1–{max}, include up to {inc} · exclude up to {exc})'**
  String bonusHeader(String label, String max, String inc, String exc);

  /// No description provided for @numbersWord.
  ///
  /// In en, this message translates to:
  /// **'numbers'**
  String get numbersWord;

  /// No description provided for @pickerInclude.
  ///
  /// In en, this message translates to:
  /// **'Include {kind}'**
  String pickerInclude(String kind);

  /// No description provided for @pickerExclude.
  ///
  /// In en, this message translates to:
  /// **'Exclude {kind}'**
  String pickerExclude(String kind);

  /// No description provided for @pickerConflict.
  ///
  /// In en, this message translates to:
  /// **'{number} is already in the other list.'**
  String pickerConflict(String number);

  /// No description provided for @pickerMax.
  ///
  /// In en, this message translates to:
  /// **'You can select up to {max}.'**
  String pickerMax(String max);

  /// No description provided for @includeLabel.
  ///
  /// In en, this message translates to:
  /// **'Included numbers'**
  String get includeLabel;

  /// No description provided for @excludeLabel.
  ///
  /// In en, this message translates to:
  /// **'Excluded numbers'**
  String get excludeLabel;

  /// No description provided for @includeBonusLabel.
  ///
  /// In en, this message translates to:
  /// **'Included {label}'**
  String includeBonusLabel(String label);

  /// No description provided for @excludeBonusLabel.
  ///
  /// In en, this message translates to:
  /// **'Excluded {label}'**
  String excludeBonusLabel(String label);

  /// No description provided for @notNumber.
  ///
  /// In en, this message translates to:
  /// **'{label}: \"{raw}\" is not a number.'**
  String notNumber(String label, String raw);

  /// No description provided for @outOfRange.
  ///
  /// In en, this message translates to:
  /// **'{label} must be between 1 and {max}.'**
  String outOfRange(String label, String max);

  /// No description provided for @dupInclude.
  ///
  /// In en, this message translates to:
  /// **'Included numbers contain duplicates.'**
  String get dupInclude;

  /// No description provided for @dupExclude.
  ///
  /// In en, this message translates to:
  /// **'Excluded numbers contain duplicates.'**
  String get dupExclude;

  /// No description provided for @conflict.
  ///
  /// In en, this message translates to:
  /// **'These numbers are both included and excluded: {numbers}'**
  String conflict(String numbers);

  /// No description provided for @calcError.
  ///
  /// In en, this message translates to:
  /// **'Calculation failed. Please check your filters.'**
  String get calcError;

  /// No description provided for @busy.
  ///
  /// In en, this message translates to:
  /// **'Still calculating. Please wait!'**
  String get busy;

  /// No description provided for @noResults.
  ///
  /// In en, this message translates to:
  /// **'No combinations left. Please change your settings.'**
  String get noResults;

  /// No description provided for @tooMany.
  ///
  /// In en, this message translates to:
  /// **'Only {count} combinations remain, so {count} will be generated.'**
  String tooMany(String count);

  /// No description provided for @noExtract.
  ///
  /// In en, this message translates to:
  /// **'No combinations available. Please change your settings.'**
  String get noExtract;

  /// No description provided for @extractError.
  ///
  /// In en, this message translates to:
  /// **'Could not generate numbers. Please check your settings.'**
  String get extractError;

  /// No description provided for @resultsTitle.
  ///
  /// In en, this message translates to:
  /// **'Your combinations'**
  String get resultsTitle;

  /// No description provided for @copied.
  ///
  /// In en, this message translates to:
  /// **'Numbers copied.'**
  String get copied;

  /// No description provided for @copyButton.
  ///
  /// In en, this message translates to:
  /// **'Copy'**
  String get copyButton;

  /// No description provided for @shareButton.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get shareButton;

  /// No description provided for @shareHeader.
  ///
  /// In en, this message translates to:
  /// **'🍀My {game} numbers🍀'**
  String shareHeader(String game);

  /// No description provided for @shareSubject.
  ///
  /// In en, this message translates to:
  /// **'My lottery numbers'**
  String get shareSubject;

  /// No description provided for @noHelp.
  ///
  /// In en, this message translates to:
  /// **'No description available.'**
  String get noHelp;

  /// No description provided for @obWelcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome to Lotto Leader'**
  String get obWelcome;

  /// No description provided for @obChooseLanguage.
  ///
  /// In en, this message translates to:
  /// **'Choose your language. You can change it later in Settings.'**
  String get obChooseLanguage;

  /// No description provided for @obNext.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get obNext;

  /// No description provided for @obBack.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get obBack;

  /// No description provided for @obProfileTitle.
  ///
  /// In en, this message translates to:
  /// **'Quick sign-up'**
  String get obProfileTitle;

  /// No description provided for @obProfileBody.
  ///
  /// In en, this message translates to:
  /// **'Just pick a nickname to get started.\nYour profile and history are stored only on this device.'**
  String get obProfileBody;

  /// No description provided for @obNickname.
  ///
  /// In en, this message translates to:
  /// **'Nickname'**
  String get obNickname;

  /// No description provided for @obNicknameHint.
  ///
  /// In en, this message translates to:
  /// **'2–12 characters'**
  String get obNicknameHint;

  /// No description provided for @obNicknameError.
  ///
  /// In en, this message translates to:
  /// **'Please enter a nickname of 2–12 characters.'**
  String get obNicknameError;

  /// No description provided for @obAge.
  ///
  /// In en, this message translates to:
  /// **'I am of legal age to play the lottery in my country'**
  String get obAge;

  /// No description provided for @obAgree.
  ///
  /// In en, this message translates to:
  /// **'I agree to the Privacy Policy and Disclaimer'**
  String get obAgree;

  /// No description provided for @obView.
  ///
  /// In en, this message translates to:
  /// **'View'**
  String get obView;

  /// No description provided for @obStart.
  ///
  /// In en, this message translates to:
  /// **'Get started'**
  String get obStart;

  /// No description provided for @obNeedChecks.
  ///
  /// In en, this message translates to:
  /// **'Please confirm all required items.'**
  String get obNeedChecks;

  /// No description provided for @menuHistory.
  ///
  /// In en, this message translates to:
  /// **'My history'**
  String get menuHistory;

  /// No description provided for @historyJoined.
  ///
  /// In en, this message translates to:
  /// **'Joined {date}'**
  String historyJoined(String date);

  /// No description provided for @historyStats.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, one{{count} generation} other{{count} generations}}'**
  String historyStats(int count);

  /// No description provided for @historyEmpty.
  ///
  /// In en, this message translates to:
  /// **'No history yet.\nCombinations you generate will appear here.'**
  String get historyEmpty;

  /// No description provided for @historyTickets.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, one{{count} combination} other{{count} combinations}}'**
  String historyTickets(int count);

  /// No description provided for @historyFilters.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, one{{count} filter} other{{count} filters}}'**
  String historyFilters(int count);

  /// No description provided for @historyClearAll.
  ///
  /// In en, this message translates to:
  /// **'Clear all history'**
  String get historyClearAll;

  /// No description provided for @historyClearConfirm.
  ///
  /// In en, this message translates to:
  /// **'Delete all generation history?'**
  String get historyClearConfirm;

  /// No description provided for @historyDeleted.
  ///
  /// In en, this message translates to:
  /// **'Entry deleted.'**
  String get historyDeleted;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get confirm;

  /// No description provided for @profileNickname.
  ///
  /// In en, this message translates to:
  /// **'Nickname: {name}'**
  String profileNickname(String name);

  /// No description provided for @withdraw.
  ///
  /// In en, this message translates to:
  /// **'Delete account (profile & history)'**
  String get withdraw;

  /// No description provided for @withdrawConfirm.
  ///
  /// In en, this message translates to:
  /// **'Your profile and history will be deleted from this device and you\'ll return to the start screen. Continue?'**
  String get withdrawConfirm;

  /// No description provided for @manualEntry.
  ///
  /// In en, this message translates to:
  /// **'Enter results manually'**
  String get manualEntry;

  /// No description provided for @manualHelp.
  ///
  /// In en, this message translates to:
  /// **'Use this when automatic updates aren\'t working, based on the official results. Official data for the same date will replace your entry later.'**
  String get manualHelp;

  /// No description provided for @manualRound.
  ///
  /// In en, this message translates to:
  /// **'Draw no.'**
  String get manualRound;

  /// No description provided for @manualDate.
  ///
  /// In en, this message translates to:
  /// **'Draw date'**
  String get manualDate;

  /// No description provided for @manualMain.
  ///
  /// In en, this message translates to:
  /// **'{count} winning numbers'**
  String manualMain(String count);

  /// No description provided for @manualBonus.
  ///
  /// In en, this message translates to:
  /// **'{label}: {count}'**
  String manualBonus(String label, String count);

  /// No description provided for @manualSave.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get manualSave;

  /// No description provided for @manualSaved.
  ///
  /// In en, this message translates to:
  /// **'Results saved.'**
  String get manualSaved;

  /// No description provided for @manualList.
  ///
  /// In en, this message translates to:
  /// **'Your entries'**
  String get manualList;

  /// No description provided for @manualNone.
  ///
  /// In en, this message translates to:
  /// **'No manual entries.'**
  String get manualNone;

  /// No description provided for @manualTag.
  ///
  /// In en, this message translates to:
  /// **'Manual'**
  String get manualTag;

  /// No description provided for @mErrRound.
  ///
  /// In en, this message translates to:
  /// **'Please check the draw number.'**
  String get mErrRound;

  /// No description provided for @mErrMain.
  ///
  /// In en, this message translates to:
  /// **'Please select {count} winning numbers.'**
  String mErrMain(String count);

  /// No description provided for @mErrBonus.
  ///
  /// In en, this message translates to:
  /// **'{label}: please select {count}.'**
  String mErrBonus(String label, String count);

  /// No description provided for @mErrBonusOverlap.
  ///
  /// In en, this message translates to:
  /// **'The bonus number can\'t be one of the winning numbers.'**
  String get mErrBonusOverlap;

  /// No description provided for @mErrDate.
  ///
  /// In en, this message translates to:
  /// **'Please check the date. Future dates, non-draw days and dates before the current rules aren\'t allowed.'**
  String get mErrDate;

  /// No description provided for @mErrExists.
  ///
  /// In en, this message translates to:
  /// **'Results for this date (draw) already exist.'**
  String get mErrExists;

  /// No description provided for @adPrivacyOptions.
  ///
  /// In en, this message translates to:
  /// **'Ad privacy settings'**
  String get adPrivacyOptions;

  /// No description provided for @rewardTitle.
  ///
  /// In en, this message translates to:
  /// **'Generate {count} combinations'**
  String rewardTitle(String count);

  /// No description provided for @rewardBody.
  ///
  /// In en, this message translates to:
  /// **'Up to {free} combinations are free.\nWatch a short ad to generate all {count}.'**
  String rewardBody(String free, String count);

  /// No description provided for @rewardWatch.
  ///
  /// In en, this message translates to:
  /// **'Watch ad for {count}'**
  String rewardWatch(String count);

  /// No description provided for @rewardFreeOnly.
  ///
  /// In en, this message translates to:
  /// **'Just {free}'**
  String rewardFreeOnly(String free);

  /// No description provided for @rewardNotEarned.
  ///
  /// In en, this message translates to:
  /// **'The ad wasn\'t finished, so {free} combinations will be generated.'**
  String rewardNotEarned(String free);

  /// No description provided for @patternFilters.
  ///
  /// In en, this message translates to:
  /// **'Pattern filters'**
  String get patternFilters;

  /// No description provided for @pastPending.
  ///
  /// In en, this message translates to:
  /// **' (results coming soon)'**
  String get pastPending;

  /// No description provided for @fKr1st.
  ///
  /// In en, this message translates to:
  /// **'Exclude past jackpot combinations'**
  String get fKr1st;

  /// No description provided for @hKr1st.
  ///
  /// In en, this message translates to:
  /// **'Excludes combinations identical to any past jackpot result.'**
  String get hKr1st;

  /// No description provided for @fKr23.
  ///
  /// In en, this message translates to:
  /// **'Exclude 5-number matches with past draws'**
  String get fKr23;

  /// No description provided for @hKr23.
  ///
  /// In en, this message translates to:
  /// **'Excludes combinations sharing 5 of the 6 numbers of any past draw.'**
  String get hKr23;

  /// No description provided for @fKr4th.
  ///
  /// In en, this message translates to:
  /// **'Exclude 4-number matches (last 100 draws)'**
  String get fKr4th;

  /// No description provided for @hKr4th.
  ///
  /// In en, this message translates to:
  /// **'Excludes combinations sharing 4 numbers with any of the last 100 draws.'**
  String get hKr4th;

  /// No description provided for @fKr5th.
  ///
  /// In en, this message translates to:
  /// **'Exclude consecutive triples seen in past draws'**
  String get fKr5th;

  /// No description provided for @hKr5th.
  ///
  /// In en, this message translates to:
  /// **'Excludes combinations containing a run of 3 consecutive numbers that appeared in a past draw.'**
  String get hKr5th;

  /// No description provided for @fKrRange.
  ///
  /// In en, this message translates to:
  /// **'Exclude narrow spreads (max − min ≤ 9)'**
  String get fKrRange;

  /// No description provided for @hKrRange.
  ///
  /// In en, this message translates to:
  /// **'Excludes combinations whose highest and lowest numbers are 9 or less apart.'**
  String get hKrRange;

  /// No description provided for @fPastFull.
  ///
  /// In en, this message translates to:
  /// **'Exclude past winning sets ({k} matches)'**
  String fPastFull(String k);

  /// No description provided for @hPastFull.
  ///
  /// In en, this message translates to:
  /// **'Excludes combinations identical to the {k} main numbers of any draw under the current rules.'**
  String hPastFull(String k);

  /// No description provided for @fPastMinus1.
  ///
  /// In en, this message translates to:
  /// **'Exclude {m}-number matches with past draws'**
  String fPastMinus1(String m);

  /// No description provided for @hPastMinus1.
  ///
  /// In en, this message translates to:
  /// **'Excludes combinations sharing {m} of the {k} main numbers of any past draw.'**
  String hPastMinus1(String k, String m);

  /// No description provided for @fPastMinus2.
  ///
  /// In en, this message translates to:
  /// **'Exclude {m}-number matches (last {r} draws)'**
  String fPastMinus2(String r, String m);

  /// No description provided for @hPastMinus2.
  ///
  /// In en, this message translates to:
  /// **'Excludes combinations sharing {m} main numbers with any of the last {r} draws.'**
  String hPastMinus2(String r, String m);

  /// No description provided for @fPastConsec.
  ///
  /// In en, this message translates to:
  /// **'Exclude consecutive triples seen in past draws'**
  String get fPastConsec;

  /// No description provided for @hPastConsec.
  ///
  /// In en, this message translates to:
  /// **'Excludes combinations containing a run of 3 consecutive numbers (e.g. 7, 8, 9) that appeared in a past draw.'**
  String get hPastConsec;

  /// No description provided for @fNarrow.
  ///
  /// In en, this message translates to:
  /// **'Exclude narrow spreads (max − min ≤ {n})'**
  String fNarrow(String n);

  /// No description provided for @hNarrow.
  ///
  /// In en, this message translates to:
  /// **'Excludes combinations whose highest and lowest numbers are {n} or less apart.'**
  String hNarrow(String n);

  /// No description provided for @f3Consec.
  ///
  /// In en, this message translates to:
  /// **'Exclude 3 consecutive numbers'**
  String get f3Consec;

  /// No description provided for @h3Consec.
  ///
  /// In en, this message translates to:
  /// **'Excludes combinations with 3 consecutive numbers, such as 1, 2, 3 or 33, 34, 35.'**
  String get h3Consec;

  /// No description provided for @fDouble3Consec.
  ///
  /// In en, this message translates to:
  /// **'Exclude two runs of 3 consecutive numbers'**
  String get fDouble3Consec;

  /// No description provided for @hDouble3Consec.
  ///
  /// In en, this message translates to:
  /// **'Excludes combinations made of two runs of 3 consecutive numbers, such as 1, 2, 3, 20, 21, 22.'**
  String get hDouble3Consec;

  /// No description provided for @fSkip1.
  ///
  /// In en, this message translates to:
  /// **'Exclude 3 numbers in steps of 2'**
  String get fSkip1;

  /// No description provided for @hSkip1.
  ///
  /// In en, this message translates to:
  /// **'Excludes combinations with 3 numbers spaced by 2, such as 1, 3, 5 or 15, 17, 19.'**
  String get hSkip1;

  /// No description provided for @fSkip2.
  ///
  /// In en, this message translates to:
  /// **'Exclude 3 numbers in steps of 3'**
  String get fSkip2;

  /// No description provided for @hSkip2.
  ///
  /// In en, this message translates to:
  /// **'Excludes combinations with 3 numbers spaced by 3, such as 1, 4, 7 or 15, 18, 21.'**
  String get hSkip2;

  /// No description provided for @fSkip3.
  ///
  /// In en, this message translates to:
  /// **'Exclude 3 numbers in steps of 4'**
  String get fSkip3;

  /// No description provided for @hSkip3.
  ///
  /// In en, this message translates to:
  /// **'Excludes combinations with 3 numbers spaced by 4, such as 1, 5, 9 or 15, 19, 23.'**
  String get hSkip3;

  /// No description provided for @f2Pairs.
  ///
  /// In en, this message translates to:
  /// **'Exclude 2+ consecutive pairs'**
  String get f2Pairs;

  /// No description provided for @h2Pairs.
  ///
  /// In en, this message translates to:
  /// **'Excludes combinations with two or more consecutive pairs, such as 1, 2 and 15, 16.'**
  String get h2Pairs;

  /// No description provided for @fAllOdd.
  ///
  /// In en, this message translates to:
  /// **'Exclude all odd ({k} odd numbers)'**
  String fAllOdd(String k);

  /// No description provided for @hAllOdd.
  ///
  /// In en, this message translates to:
  /// **'Excludes combinations where all {k} numbers are odd.'**
  String hAllOdd(String k);

  /// No description provided for @fAllEven.
  ///
  /// In en, this message translates to:
  /// **'Exclude all even ({k} even numbers)'**
  String fAllEven(String k);

  /// No description provided for @hAllEven.
  ///
  /// In en, this message translates to:
  /// **'Excludes combinations where all {k} numbers are even.'**
  String hAllEven(String k);

  /// No description provided for @fOE1.
  ///
  /// In en, this message translates to:
  /// **'Exclude O-E-O-E-O-E / E-O-E-O-E-O'**
  String get fOE1;

  /// No description provided for @fOE2.
  ///
  /// In en, this message translates to:
  /// **'Exclude E-E-O-O-E-E / O-O-E-E-O-O'**
  String get fOE2;

  /// No description provided for @fOE3.
  ///
  /// In en, this message translates to:
  /// **'Exclude E-E-E-E-E-O / O-O-O-O-O-E'**
  String get fOE3;

  /// No description provided for @fOE4.
  ///
  /// In en, this message translates to:
  /// **'Exclude E-E-E-E-O-O / O-O-O-O-E-E'**
  String get fOE4;

  /// No description provided for @fOE5.
  ///
  /// In en, this message translates to:
  /// **'Exclude E-E-E-O-O-O / O-O-O-E-E-E'**
  String get fOE5;

  /// No description provided for @hOE.
  ///
  /// In en, this message translates to:
  /// **'Excludes combinations whose 6 sorted numbers follow the odd(O)/even(E) order {pattern}.'**
  String hOE(String pattern);

  /// No description provided for @fSameDigit.
  ///
  /// In en, this message translates to:
  /// **'Exclude 3+ numbers with the same last digit'**
  String get fSameDigit;

  /// No description provided for @hSameDigit.
  ///
  /// In en, this message translates to:
  /// **'Excludes combinations with 3 or more numbers ending in the same digit, such as 1, 11, 21, 31.'**
  String get hSameDigit;

  /// No description provided for @fTripleMult.
  ///
  /// In en, this message translates to:
  /// **'Exclude 3 consecutive multiples'**
  String get fTripleMult;

  /// No description provided for @hTripleMult.
  ///
  /// In en, this message translates to:
  /// **'Excludes combinations containing 3 consecutive multiples of the same number, such as 2, 4, 6 or 4, 8, 12.'**
  String get hTripleMult;

  /// No description provided for @alarmIntro.
  ///
  /// In en, this message translates to:
  /// **'You\'ll get a phone notification 3 hours before each draw of the lotteries you turn on.'**
  String get alarmIntro;

  /// No description provided for @alarmDrawAt.
  ///
  /// In en, this message translates to:
  /// **'Draws {days} {time} (local time)'**
  String alarmDrawAt(String days, String time);

  /// No description provided for @alarmUnsupported.
  ///
  /// In en, this message translates to:
  /// **'Notifications aren\'t supported on this device. Please use the phone app.'**
  String get alarmUnsupported;

  /// No description provided for @alarmDenied.
  ///
  /// In en, this message translates to:
  /// **'Notifications are turned off. Please allow notifications for this app in your phone settings.'**
  String get alarmDenied;

  /// No description provided for @alarmOn.
  ///
  /// In en, this message translates to:
  /// **'We\'ll remind you 3 hours before each {game} draw.'**
  String alarmOn(String game);

  /// No description provided for @alarmOff.
  ///
  /// In en, this message translates to:
  /// **'{game} reminders turned off.'**
  String alarmOff(String game);

  /// No description provided for @notifyTitle.
  ///
  /// In en, this message translates to:
  /// **'{game} draw today!'**
  String notifyTitle(String game);

  /// No description provided for @notifyBody.
  ///
  /// In en, this message translates to:
  /// **'The draw is in 3 hours. Generate your numbers in Lotto Leader.'**
  String get notifyBody;

  /// No description provided for @notifyChannel.
  ///
  /// In en, this message translates to:
  /// **'Draw reminders'**
  String get notifyChannel;

  /// No description provided for @winPending.
  ///
  /// In en, this message translates to:
  /// **'Awaiting draw'**
  String get winPending;

  /// No description provided for @winDrawOf.
  ///
  /// In en, this message translates to:
  /// **'Compared with the {date} draw'**
  String winDrawOf(String date);

  /// No description provided for @winRank.
  ///
  /// In en, this message translates to:
  /// **'Tier {rank}'**
  String winRank(String rank);

  /// No description provided for @winBest.
  ///
  /// In en, this message translates to:
  /// **'Best: {rank}'**
  String winBest(String rank);

  /// No description provided for @winNone.
  ///
  /// In en, this message translates to:
  /// **'No win'**
  String get winNone;

  /// No description provided for @winMatch.
  ///
  /// In en, this message translates to:
  /// **'{main} matched'**
  String winMatch(String main);

  /// No description provided for @winMatchPlus.
  ///
  /// In en, this message translates to:
  /// **'{main}+{bonus} matched'**
  String winMatchPlus(String main, String bonus);

  /// No description provided for @winMatchBonus.
  ///
  /// In en, this message translates to:
  /// **'{main} + bonus matched'**
  String winMatchBonus(String main);

  /// No description provided for @winPendingHint.
  ///
  /// In en, this message translates to:
  /// **'Results are compared automatically once the draw is in. If it\'s late, use Settings → Enter results manually.'**
  String get winPendingHint;

  /// No description provided for @statsTitle.
  ///
  /// In en, this message translates to:
  /// **'Number stats'**
  String get statsTitle;

  /// No description provided for @statsRecent.
  ///
  /// In en, this message translates to:
  /// **'Last {n}'**
  String statsRecent(String n);

  /// No description provided for @statsAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get statsAll;

  /// No description provided for @statsMain.
  ///
  /// In en, this message translates to:
  /// **'Main numbers'**
  String get statsMain;

  /// No description provided for @statsSortNumber.
  ///
  /// In en, this message translates to:
  /// **'By number'**
  String get statsSortNumber;

  /// No description provided for @statsSortMost.
  ///
  /// In en, this message translates to:
  /// **'Most drawn'**
  String get statsSortMost;

  /// No description provided for @statsSortLeast.
  ///
  /// In en, this message translates to:
  /// **'Least drawn'**
  String get statsSortLeast;

  /// No description provided for @statsSortGap.
  ///
  /// In en, this message translates to:
  /// **'Longest absent'**
  String get statsSortGap;

  /// No description provided for @statsAnalyzed.
  ///
  /// In en, this message translates to:
  /// **'{n, plural, one{Based on the last draw} other{Based on the last {n} draws}}'**
  String statsAnalyzed(int n);

  /// No description provided for @statsHot.
  ///
  /// In en, this message translates to:
  /// **'Hot numbers'**
  String get statsHot;

  /// No description provided for @statsCold.
  ///
  /// In en, this message translates to:
  /// **'Cold numbers'**
  String get statsCold;

  /// No description provided for @statsCount.
  ///
  /// In en, this message translates to:
  /// **'{n}×'**
  String statsCount(String n);

  /// No description provided for @statsGap.
  ///
  /// In en, this message translates to:
  /// **'{n, plural, one{{n} draw ago} other{{n} draws ago}}'**
  String statsGap(int n);

  /// No description provided for @statsGapLatest.
  ///
  /// In en, this message translates to:
  /// **'Last draw'**
  String get statsGapLatest;

  /// No description provided for @statsGapNever.
  ///
  /// In en, this message translates to:
  /// **'Not drawn'**
  String get statsGapNever;

  /// No description provided for @statsOddEven.
  ///
  /// In en, this message translates to:
  /// **'Odd / even split'**
  String get statsOddEven;

  /// No description provided for @statsOddLabel.
  ///
  /// In en, this message translates to:
  /// **'{odd} odd : {even} even'**
  String statsOddLabel(String odd, String even);

  /// No description provided for @statsDisclaimer.
  ///
  /// In en, this message translates to:
  /// **'These are past results only and don\'t predict future draws.'**
  String get statsDisclaimer;

  /// No description provided for @backupExport.
  ///
  /// In en, this message translates to:
  /// **'Back up history'**
  String get backupExport;

  /// No description provided for @backupImport.
  ///
  /// In en, this message translates to:
  /// **'Restore from backup'**
  String get backupImport;

  /// No description provided for @backupShareText.
  ///
  /// In en, this message translates to:
  /// **'Lotto Leader backup file. On your new phone, open Settings → Restore from backup and choose this file.'**
  String get backupShareText;

  /// No description provided for @backupEmpty.
  ///
  /// In en, this message translates to:
  /// **'There\'s nothing to back up yet.'**
  String get backupEmpty;

  /// No description provided for @backupFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t create the backup file. Please try again later.'**
  String get backupFailed;

  /// No description provided for @backupImportConfirm.
  ///
  /// In en, this message translates to:
  /// **'The backup will be merged with the history on this device. Your nickname and sign-up date will be taken from the backup. Continue?'**
  String get backupImportConfirm;

  /// No description provided for @backupImportDone.
  ///
  /// In en, this message translates to:
  /// **'Restore complete. Added: history {history} · manual results {manual}'**
  String backupImportDone(String history, String manual);

  /// No description provided for @backupInvalid.
  ///
  /// In en, this message translates to:
  /// **'This isn\'t a Lotto Leader backup file, or the file is damaged.'**
  String get backupInvalid;

  /// No description provided for @backupTooLarge.
  ///
  /// In en, this message translates to:
  /// **'The file is too large. Please choose a Lotto Leader backup file.'**
  String get backupTooLarge;

  /// No description provided for @continueButton.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueButton;

  /// No description provided for @colon.
  ///
  /// In en, this message translates to:
  /// **': '**
  String get colon;

  /// No description provided for @fSum.
  ///
  /// In en, this message translates to:
  /// **'Exclude sums outside {lo}–{hi}'**
  String fSum(String lo, String hi);

  /// No description provided for @hSum.
  ///
  /// In en, this message translates to:
  /// **'Excludes combinations whose main numbers add up to less than {lo} or more than {hi}. About 95% of all combinations fall within this range.'**
  String hSum(String lo, String hi);

  /// No description provided for @fBirthday.
  ///
  /// In en, this message translates to:
  /// **'Exclude all-31-or-lower sets (birthday numbers)'**
  String get fBirthday;

  /// No description provided for @hBirthday.
  ///
  /// In en, this message translates to:
  /// **'Excludes combinations made only of 1–31 (numbers used in dates). Many people pick birthdays, so a jackpot on these numbers is more likely to be shared. The chance of winning is the same as any other combination.'**
  String get hBirthday;

  /// No description provided for @fLowHigh.
  ///
  /// In en, this message translates to:
  /// **'Exclude all-low or all-high sets'**
  String get fLowHigh;

  /// No description provided for @hLowHigh.
  ///
  /// In en, this message translates to:
  /// **'Excludes combinations whose numbers are all within 1–{half}, or all within {next}–{max}.'**
  String hLowHigh(String half, String next, String max);

  /// No description provided for @fDecade4.
  ///
  /// In en, this message translates to:
  /// **'Exclude 4+ numbers in the same decade'**
  String get fDecade4;

  /// No description provided for @hDecade4.
  ///
  /// In en, this message translates to:
  /// **'Excludes combinations with 4 or more numbers in the same group of ten (1–9, 10–19, 20–29 …), such as 41, 43, 45, 48.'**
  String get hDecade4;

  /// No description provided for @fRepeatLast.
  ///
  /// In en, this message translates to:
  /// **'Exclude 2+ numbers from the last draw'**
  String get fRepeatLast;

  /// No description provided for @hRepeatLast.
  ///
  /// In en, this message translates to:
  /// **'Excludes combinations that repeat 2 or more main numbers from the most recent draw.'**
  String get hRepeatLast;

  /// No description provided for @fBonusRecent.
  ///
  /// In en, this message translates to:
  /// **'Exclude {label} from the last {n} draws'**
  String fBonusRecent(String n, String label);

  /// No description provided for @hBonusRecent.
  ///
  /// In en, this message translates to:
  /// **'{label} numbers drawn in the last {n} draws won\'t be picked.'**
  String hBonusRecent(String n, String label);

  /// No description provided for @fBonusPairRecent.
  ///
  /// In en, this message translates to:
  /// **'Exclude {label} pairs from the last {n} draws'**
  String fBonusPairRecent(String n, String label);

  /// No description provided for @hBonusPairRecent.
  ///
  /// In en, this message translates to:
  /// **'A {label} pair identical to one of the last {n} draws won\'t be picked.'**
  String hBonusPairRecent(String n, String label);

  /// No description provided for @fBonusConsec.
  ///
  /// In en, this message translates to:
  /// **'Exclude consecutive {label} (e.g. 3·4)'**
  String fBonusConsec(String label);

  /// No description provided for @hBonusConsec.
  ///
  /// In en, this message translates to:
  /// **'{label} pairs of consecutive numbers, such as 3·4, won\'t be picked.'**
  String hBonusConsec(String label);

  /// No description provided for @fBonusParity.
  ///
  /// In en, this message translates to:
  /// **'Exclude {label} both odd or both even'**
  String fBonusParity(String label);

  /// No description provided for @hBonusParity.
  ///
  /// In en, this message translates to:
  /// **'{label} pairs that are both odd or both even won\'t be picked.'**
  String hBonusParity(String label);

  /// No description provided for @filtersOverseas.
  ///
  /// In en, this message translates to:
  /// **'Extra filters for this lottery'**
  String get filtersOverseas;

  /// No description provided for @filtersBonus.
  ///
  /// In en, this message translates to:
  /// **'{label} filters'**
  String filtersBonus(String label);
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[
    'de',
    'en',
    'es',
    'fr',
    'ja',
    'ko',
    'vi',
  ].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'fr':
      return AppLocalizationsFr();
    case 'ja':
      return AppLocalizationsJa();
    case 'ko':
      return AppLocalizationsKo();
    case 'vi':
      return AppLocalizationsVi();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
