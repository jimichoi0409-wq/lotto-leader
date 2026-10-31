// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get appTitle => 'Lotto Leader';

  @override
  String get close => 'Schließen';

  @override
  String get apply => 'Anwenden';

  @override
  String get lookup => 'Anzeigen';

  @override
  String get calculating => 'Berechnung…';

  @override
  String get extracting => 'Erzeuge…';

  @override
  String get extractButton => 'Erzeugen';

  @override
  String get countHint => 'Anz.';

  @override
  String get remainingCombos => 'Verbleibende Kombinationen';

  @override
  String get menuResults => 'Ergebnisse';

  @override
  String get menuReset => 'Zurücksetzen';

  @override
  String get menuAlarm => 'Erinnerung';

  @override
  String get menuSettings => 'Einstellungen';

  @override
  String get privacyPolicy => 'Datenschutzerklärung';

  @override
  String get disclaimer => 'Haftungsausschluss';

  @override
  String get contact => 'Kontakt';

  @override
  String get versionLabel => 'Version';

  @override
  String currentVersion(String version) {
    return 'Aktuelle App-Version $version';
  }

  @override
  String get language => 'Sprache';

  @override
  String get languageSystem => 'Gerätesprache verwenden';

  @override
  String drawAlarm(String game) {
    return 'Erinnerung am Ziehungstag ($game)';
  }

  @override
  String get resetDone => 'Auf Standardeinstellungen zurückgesetzt.';

  @override
  String get privacyText =>
      'Diese App ist kostenlos. Beim ersten Start legen Sie ein einfaches Profil nur mit einem Spitznamen an. Spitzname und Verlauf werden nur auf diesem Gerät gespeichert, nie an den Verantwortlichen gesendet und können unter Einstellungen → Konto löschen jederzeit gelöscht werden.\n\nDie App selbst erhebt keine personenbezogenen Daten wie Name, Telefonnummer oder E-Mail-Adresse.\n\nDie App nutzt Google AdMob zur Anzeige von Werbung. Dabei können die Werbe-ID, Geräteinformationen und Nutzungsdaten von Google erfasst werden. Wo eine Einwilligung erforderlich ist (z. B. im EWR und im Vereinigten Königreich), werden Sie beim ersten Start gefragt und können Ihre Wahl jederzeit unter Einstellungen → Datenschutz für Werbung ändern.\n\nDiese Informationen können zur Auslieferung von Werbung, zur Verbesserung der App und zur Missbrauchsvermeidung verwendet werden.';

  @override
  String get disclaimerText =>
      'Diese App ist ein Werkzeug, das Statistiken zu früheren Gewinnzahlen bietet und beim Zusammenstellen von Zahlenkombinationen hilft.\n\nBei jeder Lotterie hat jede Kombination genau dieselbe Chance auf den Jackpot (z. B. 1 zu 8.145.060 beim koreanischen Lotto 6/45 und 1 zu 292.201.338 bei Powerball). Die Filter und Statistiken dieser App erhöhen Ihre Gewinnchancen nicht. Bitte nutzen Sie sie nur zur Unterhaltung und Orientierung.\n\nDies ist eine unabhängige App und steht in keiner Verbindung zu Lotteriebetreibern (u. a. Dong-hang Lottery, Powerball, Mega Millions, Lotto 6/49, EuroMillions, Eurojackpot, Loto 6, Irish Lotto oder Vietlott).\n\nDie App garantiert keine Gewinne. Für den Kauf und das Spielen von Lotterielosen sind Sie selbst verantwortlich.\n\nDie App verkauft keine Lose und bietet weder Wetten noch Geldprämien oder Glücksspieldienste an.';

  @override
  String get contactText =>
      'Bei Fragen, Fehlern oder Vorschlägen schreiben Sie uns gerne.\n\nVerantwortlich: 한지성\nE-Mail: jnhteamsoft@gmail.com\n\nWir antworten in der Regel innerhalb von 3 Werktagen.';

  @override
  String get chooseLottery => 'Lotterie wählen';

  @override
  String gameRule(String count, String max) {
    return '$count Zahlen (1–$max)';
  }

  @override
  String gameRuleBonus(String label, String count, String max) {
    return ' + $count $label (1–$max)';
  }

  @override
  String jackpotOdds(String odds) {
    return 'Jackpot-Chance: 1 zu $odds';
  }

  @override
  String drawCount(String count) {
    return '$count Ziehungen';
  }

  @override
  String get drawsPending => 'Ergebnisse folgen';

  @override
  String get drawRoundPrefix => 'Ziehung Nr. ';

  @override
  String get drawRoundSuffix => '';

  @override
  String get drawResultPrefix => 'Ergebnisse ';

  @override
  String get drawResultSuffix => '';

  @override
  String drawDate(String date) {
    return 'Ziehung vom $date';
  }

  @override
  String get noDrawDate => 'Ziehungsdatum unbekannt';

  @override
  String get noResultsStored =>
      'Noch keine Ergebnisse.\n(Die Ergebnisse dieser Lotterie folgen in Kürze.)';

  @override
  String get dbLoading =>
      'Ergebnisse werden geladen. Bitte gleich erneut versuchen.';

  @override
  String get dbLoadingShort => 'Ergebnisse werden geladen…';

  @override
  String get dbLoadFailed => 'Ergebnisse konnten nicht geladen werden.';

  @override
  String get freqPrefix => 'Letzte [';

  @override
  String get freqSuffix => '] Ziehungen: häufigste | seltenste';

  @override
  String get freqHint => 'alle';

  @override
  String get mostDrawn => 'Häufigste';

  @override
  String get leastDrawn => 'Seltenste';

  @override
  String get noDrawData => 'Für diese Lotterie gibt es noch keine Ergebnisse.';

  @override
  String get recentTooLarge =>
      'Weniger Ziehungen gespeichert – alle werden verwendet.';

  @override
  String get freqError => 'Häufigkeiten konnten nicht berechnet werden.';

  @override
  String includeExcludeHeader(String maxInc) {
    return 'Rein (max. $maxInc) | Raus (max. 18)';
  }

  @override
  String get includeRow => 'Einschließen';

  @override
  String get excludeRow => 'Ausschließen';

  @override
  String get includeBonusRow => 'Einschließen';

  @override
  String get excludeBonusRow => 'Ausschließen';

  @override
  String bonusHeader(String label, String max, String inc, String exc) {
    return '$label (1–$max, bis zu $inc rein · bis zu $exc raus)';
  }

  @override
  String get numbersWord => 'Zahlen';

  @override
  String pickerInclude(String kind) {
    return '$kind einschließen';
  }

  @override
  String pickerExclude(String kind) {
    return '$kind ausschließen';
  }

  @override
  String pickerConflict(String number) {
    return '$number ist bereits in der anderen Liste.';
  }

  @override
  String pickerMax(String max) {
    return 'Sie können bis zu $max auswählen.';
  }

  @override
  String get includeLabel => 'Eingeschlossene Zahlen';

  @override
  String get excludeLabel => 'Ausgeschlossene Zahlen';

  @override
  String includeBonusLabel(String label) {
    return 'Eingeschlossene $label';
  }

  @override
  String excludeBonusLabel(String label) {
    return 'Ausgeschlossene $label';
  }

  @override
  String notNumber(String label, String raw) {
    return '$label: „$raw“ ist keine Zahl.';
  }

  @override
  String outOfRange(String label, String max) {
    return '$label: nur Zahlen von 1 bis $max.';
  }

  @override
  String get dupInclude => 'Eingeschlossene Zahlen enthalten Duplikate.';

  @override
  String get dupExclude => 'Ausgeschlossene Zahlen enthalten Duplikate.';

  @override
  String conflict(String numbers) {
    return 'Diese Zahlen sind ein- und ausgeschlossen: $numbers';
  }

  @override
  String get calcError => 'Berechnungsfehler. Bitte Filter prüfen.';

  @override
  String get busy => 'Berechnung läuft. Bitte warten!';

  @override
  String get noResults =>
      'Keine Kombinationen übrig. Bitte Einstellungen ändern.';

  @override
  String tooMany(String count) {
    return 'Nur $count Kombinationen übrig – es werden $count erzeugt.';
  }

  @override
  String get noExtract =>
      'Keine Kombinationen verfügbar. Bitte Einstellungen ändern.';

  @override
  String get extractError =>
      'Zahlen konnten nicht erzeugt werden. Bitte Einstellungen prüfen.';

  @override
  String get resultsTitle => 'Ihre Kombinationen';

  @override
  String get copied => 'Zahlen kopiert.';

  @override
  String get copyButton => 'Kopieren';

  @override
  String get shareButton => 'Teilen';

  @override
  String shareHeader(String game) {
    return '🍀Meine $game-Zahlen🍀';
  }

  @override
  String get shareSubject => 'Meine Lottozahlen';

  @override
  String get noHelp => 'Keine Beschreibung verfügbar.';

  @override
  String get obWelcome => 'Willkommen bei Lotto Leader';

  @override
  String get obChooseLanguage =>
      'Wählen Sie Ihre Sprache. Sie können sie später in den Einstellungen ändern.';

  @override
  String get obNext => 'Weiter';

  @override
  String get obBack => 'Zurück';

  @override
  String get obProfileTitle => 'Schnelle Anmeldung';

  @override
  String get obProfileBody =>
      'Wählen Sie einfach einen Spitznamen.\nProfil und Verlauf werden nur auf diesem Gerät gespeichert.';

  @override
  String get obNickname => 'Spitzname';

  @override
  String get obNicknameHint => '2–12 Zeichen';

  @override
  String get obNicknameError =>
      'Bitte einen Spitznamen mit 2–12 Zeichen eingeben.';

  @override
  String get obAge =>
      'Ich habe das gesetzliche Mindestalter für Lotterien in meinem Land';

  @override
  String get obAgree =>
      'Ich stimme der Datenschutzerklärung und dem Haftungsausschluss zu';

  @override
  String get obView => 'Ansehen';

  @override
  String get obStart => 'Loslegen';

  @override
  String get obNeedChecks => 'Bitte bestätigen Sie alle Pflichtangaben.';

  @override
  String get menuHistory => 'Verlauf';

  @override
  String historyJoined(String date) {
    return 'Dabei seit $date';
  }

  @override
  String historyStats(int count) {
    return '$count-mal erzeugt';
  }

  @override
  String get historyEmpty =>
      'Noch kein Verlauf.\nErzeugte Kombinationen erscheinen hier.';

  @override
  String historyTickets(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Kombinationen',
      one: '$count Kombination',
    );
    return '$_temp0';
  }

  @override
  String historyFilters(int count) {
    return '$count Filter';
  }

  @override
  String get historyClearAll => 'Gesamten Verlauf löschen';

  @override
  String get historyClearConfirm => 'Gesamten Verlauf löschen?';

  @override
  String get historyDeleted => 'Eintrag gelöscht.';

  @override
  String get delete => 'Löschen';

  @override
  String get cancel => 'Abbrechen';

  @override
  String get confirm => 'OK';

  @override
  String profileNickname(String name) {
    return 'Spitzname: $name';
  }

  @override
  String get withdraw => 'Konto löschen (Profil und Verlauf)';

  @override
  String get withdrawConfirm =>
      'Profil und Verlauf werden von diesem Gerät gelöscht und Sie kehren zum Startbildschirm zurück. Fortfahren?';

  @override
  String get manualEntry => 'Ergebnisse eingeben';

  @override
  String get manualHelp =>
      'Verwenden Sie dies, wenn die automatische Aktualisierung nicht funktioniert – nach den offiziellen Ergebnissen. Offizielle Daten desselben Datums ersetzen Ihren Eintrag später.';

  @override
  String get manualRound => 'Ziehung Nr.';

  @override
  String get manualDate => 'Ziehungsdatum';

  @override
  String manualMain(String count) {
    return '$count Gewinnzahlen';
  }

  @override
  String manualBonus(String label, String count) {
    return '$label: $count';
  }

  @override
  String get manualSave => 'Speichern';

  @override
  String get manualSaved => 'Ergebnisse gespeichert.';

  @override
  String get manualList => 'Ihre Einträge';

  @override
  String get manualNone => 'Keine manuellen Einträge.';

  @override
  String get manualTag => 'Manuell';

  @override
  String get mErrRound => 'Bitte Ziehungsnummer prüfen.';

  @override
  String mErrMain(String count) {
    return 'Bitte $count Gewinnzahlen wählen.';
  }

  @override
  String mErrBonus(String label, String count) {
    return '$label: bitte $count wählen.';
  }

  @override
  String get mErrBonusOverlap =>
      'Die Zusatzzahl darf keine der Gewinnzahlen sein.';

  @override
  String get mErrDate =>
      'Bitte Datum prüfen. Zukünftige Daten, Tage ohne Ziehung und Daten vor den aktuellen Regeln sind nicht erlaubt.';

  @override
  String get mErrExists =>
      'Für dieses Datum (diese Ziehung) gibt es bereits Ergebnisse.';

  @override
  String get adPrivacyOptions => 'Datenschutz für Werbung';

  @override
  String rewardTitle(String count) {
    return '$count Kombinationen erzeugen';
  }

  @override
  String rewardBody(String free, String count) {
    return 'Bis zu $free Kombinationen sind kostenlos.\nSehen Sie eine kurze Werbung, um alle $count zu erzeugen.';
  }

  @override
  String rewardWatch(String count) {
    return 'Werbung: $count';
  }

  @override
  String rewardFreeOnly(String free) {
    return 'Nur $free';
  }

  @override
  String rewardNotEarned(String free) {
    return 'Die Werbung wurde nicht beendet – es werden $free Kombinationen erzeugt.';
  }

  @override
  String get patternFilters => 'Musterfilter';

  @override
  String get pastPending => ' (Ergebnisse folgen)';

  @override
  String get fKr1st => 'Frühere Gewinnkombinationen ausschließen';

  @override
  String get hKr1st =>
      'Schließt Kombinationen aus, die einem früheren Gewinnergebnis entsprechen.';

  @override
  String get fKr23 => '5 Treffer mit früheren Ziehungen ausschließen';

  @override
  String get hKr23 =>
      'Schließt Kombinationen aus, die 5 der 6 Zahlen einer früheren Ziehung enthalten.';

  @override
  String get fKr4th => '4 Treffer ausschließen (letzte 100 Ziehungen)';

  @override
  String get hKr4th =>
      'Schließt Kombinationen aus, die 4 Zahlen mit einer der letzten 100 Ziehungen teilen.';

  @override
  String get fKr5th => 'Frühere 3er-Folgen ausschließen';

  @override
  String get hKr5th =>
      'Schließt Kombinationen mit einer Folge von 3 Zahlen aus, die schon gezogen wurde.';

  @override
  String get fKrRange => 'Enge Spannen ausschließen (Max − Min ≤ 9)';

  @override
  String get hKrRange =>
      'Schließt Kombinationen aus, bei denen höchste und niedrigste Zahl höchstens 9 auseinanderliegen.';

  @override
  String fPastFull(String k) {
    return 'Gewinnkombinationen ausschließen ($k Treffer)';
  }

  @override
  String hPastFull(String k) {
    return 'Schließt Kombinationen aus, die den $k Hauptzahlen einer Ziehung nach den aktuellen Regeln entsprechen.';
  }

  @override
  String fPastMinus1(String m) {
    return '$m Treffer mit früheren Ziehungen ausschließen';
  }

  @override
  String hPastMinus1(String k, String m) {
    return 'Schließt Kombinationen aus, die $m der $k Hauptzahlen einer früheren Ziehung enthalten.';
  }

  @override
  String fPastMinus2(String r, String m) {
    return '$m Treffer ausschließen (letzte $r Ziehungen)';
  }

  @override
  String hPastMinus2(String r, String m) {
    return 'Schließt Kombinationen aus, die $m Hauptzahlen mit einer der letzten $r Ziehungen teilen.';
  }

  @override
  String get fPastConsec => 'Frühere 3er-Folgen ausschließen';

  @override
  String get hPastConsec =>
      'Schließt Kombinationen mit einer Folge von 3 Zahlen (z. B. 7, 8, 9) aus, die schon gezogen wurde.';

  @override
  String fNarrow(String n) {
    return 'Enge Spannen ausschließen (Max − Min ≤ $n)';
  }

  @override
  String hNarrow(String n) {
    return 'Schließt Kombinationen aus, bei denen höchste und niedrigste Zahl höchstens $n auseinanderliegen.';
  }

  @override
  String get f3Consec => '3 aufeinanderfolgende Zahlen ausschließen';

  @override
  String get h3Consec =>
      'Schließt Kombinationen mit 3 aufeinanderfolgenden Zahlen aus, z. B. 1, 2, 3 oder 33, 34, 35.';

  @override
  String get fDouble3Consec =>
      'Zwei Reihen mit je 3 aufeinanderfolgenden Zahlen ausschließen';

  @override
  String get hDouble3Consec =>
      'Schließt Kombinationen aus zwei Reihen mit je 3 aufeinanderfolgenden Zahlen aus, z. B. 1, 2, 3, 20, 21, 22.';

  @override
  String get fSkip1 => '3 Zahlen im Abstand 2 ausschließen';

  @override
  String get hSkip1 =>
      'Schließt Kombinationen mit 3 Zahlen im Abstand 2 aus, z. B. 1, 3, 5 oder 15, 17, 19.';

  @override
  String get fSkip2 => '3 Zahlen im Abstand 3 ausschließen';

  @override
  String get hSkip2 =>
      'Schließt Kombinationen mit 3 Zahlen im Abstand 3 aus, z. B. 1, 4, 7 oder 15, 18, 21.';

  @override
  String get fSkip3 => '3 Zahlen im Abstand 4 ausschließen';

  @override
  String get hSkip3 =>
      'Schließt Kombinationen mit 3 Zahlen im Abstand 4 aus, z. B. 1, 5, 9 oder 15, 19, 23.';

  @override
  String get f2Pairs => '2+ aufeinanderfolgende Paare ausschließen';

  @override
  String get h2Pairs =>
      'Schließt Kombinationen mit zwei oder mehr aufeinanderfolgenden Paaren aus, z. B. 1, 2 und 15, 16.';

  @override
  String fAllOdd(String k) {
    return 'Nur ungerade ausschließen ($k ungerade)';
  }

  @override
  String hAllOdd(String k) {
    return 'Schließt Kombinationen aus, bei denen alle $k Zahlen ungerade sind.';
  }

  @override
  String fAllEven(String k) {
    return 'Nur gerade ausschließen ($k gerade)';
  }

  @override
  String hAllEven(String k) {
    return 'Schließt Kombinationen aus, bei denen alle $k Zahlen gerade sind.';
  }

  @override
  String get fOE1 => 'U-G-U-G-U-G / G-U-G-U-G-U ausschließen';

  @override
  String get fOE2 => 'G-G-U-U-G-G / U-U-G-G-U-U ausschließen';

  @override
  String get fOE3 => 'G-G-G-G-G-U / U-U-U-U-U-G ausschließen';

  @override
  String get fOE4 => 'G-G-G-G-U-U / U-U-U-U-G-G ausschließen';

  @override
  String get fOE5 => 'G-G-G-U-U-U / U-U-U-G-G-G ausschließen';

  @override
  String hOE(String pattern) {
    return 'Schließt Kombinationen aus, deren 6 sortierte Zahlen der Folge ungerade(U)/gerade(G) $pattern folgen.';
  }

  @override
  String get fSameDigit => '3+ Zahlen mit gleicher Endziffer ausschließen';

  @override
  String get hSameDigit =>
      'Schließt Kombinationen mit 3 oder mehr Zahlen mit gleicher Endziffer aus, z. B. 1, 11, 21, 31.';

  @override
  String get fTripleMult => '3 aufeinanderfolgende Vielfache ausschließen';

  @override
  String get hTripleMult =>
      'Schließt Kombinationen mit 3 aufeinanderfolgenden Vielfachen derselben Zahl aus, z. B. 2, 4, 6 oder 4, 8, 12.';

  @override
  String get alarmIntro =>
      'Sie erhalten 3 Stunden vor jeder Ziehung der aktivierten Lotterien eine Benachrichtigung.';

  @override
  String alarmDrawAt(String days, String time) {
    return 'Ziehung $days $time (Ortszeit)';
  }

  @override
  String get alarmUnsupported =>
      'Benachrichtigungen werden auf diesem Gerät nicht unterstützt. Bitte nutzen Sie die Handy-App.';

  @override
  String get alarmDenied =>
      'Benachrichtigungen sind deaktiviert. Bitte erlauben Sie sie für diese App in den Handy-Einstellungen.';

  @override
  String alarmOn(String game) {
    return 'Wir erinnern Sie 3 Stunden vor jeder Ziehung von $game.';
  }

  @override
  String alarmOff(String game) {
    return 'Erinnerungen für $game deaktiviert.';
  }

  @override
  String notifyTitle(String game) {
    return 'Heute $game-Ziehung!';
  }

  @override
  String get notifyBody =>
      'Die Ziehung ist in 3 Stunden. Erzeugen Sie Ihre Zahlen in Lotto Leader.';

  @override
  String get notifyChannel => 'Ziehungserinnerungen';

  @override
  String get winPending => 'Ziehung ausstehend';

  @override
  String winDrawOf(String date) {
    return 'Verglichen mit der Ziehung vom $date';
  }

  @override
  String winRank(String rank) {
    return 'Gewinnklasse $rank';
  }

  @override
  String winBest(String rank) {
    return 'Beste: $rank';
  }

  @override
  String get winNone => 'Kein Gewinn';

  @override
  String winMatch(String main) {
    return '$main Richtige';
  }

  @override
  String winMatchPlus(String main, String bonus) {
    return '$main+$bonus Richtige';
  }

  @override
  String winMatchBonus(String main) {
    return '$main Richtige + Zusatzzahl';
  }

  @override
  String get winPendingHint =>
      'Der Vergleich erfolgt automatisch, sobald das Ergebnis vorliegt. Bei Verzögerung: Einstellungen → Ergebnisse eingeben.';

  @override
  String get statsTitle => 'Statistik';

  @override
  String statsRecent(String n) {
    return 'Letzte $n';
  }

  @override
  String get statsAll => 'Alle';

  @override
  String get statsMain => 'Zahlen';

  @override
  String get statsSortNumber => 'Nach Zahl';

  @override
  String get statsSortMost => 'Am häufigsten';

  @override
  String get statsSortLeast => 'Am seltensten';

  @override
  String get statsSortGap => 'Am längsten nicht gezogen';

  @override
  String statsAnalyzed(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: 'Basierend auf den letzten $n Ziehungen',
      one: 'Basierend auf der letzten Ziehung',
    );
    return '$_temp0';
  }

  @override
  String get statsHot => 'Heiße Zahlen';

  @override
  String get statsCold => 'Kalte Zahlen';

  @override
  String statsCount(String n) {
    return '$n×';
  }

  @override
  String statsGap(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: 'vor $n Ziehungen',
      one: 'vor $n Ziehung',
    );
    return '$_temp0';
  }

  @override
  String get statsGapLatest => 'Letzte Ziehung';

  @override
  String get statsGapNever => 'Nicht gezogen';

  @override
  String get statsOddEven => 'Verteilung gerade / ungerade';

  @override
  String statsOddLabel(String odd, String even) {
    return '$odd ungerade : $even gerade';
  }

  @override
  String get statsDisclaimer =>
      'Dies sind nur vergangene Ergebnisse und sagen keine künftigen Ziehungen voraus.';

  @override
  String get backupExport => 'Verlauf sichern';

  @override
  String get backupImport => 'Sicherung wiederherstellen';

  @override
  String get backupShareText =>
      'Lotto Leader-Sicherung. Öffnen Sie auf dem neuen Handy Einstellungen → Sicherung wiederherstellen und wählen Sie diese Datei.';

  @override
  String get backupEmpty => 'Noch nichts zu sichern.';

  @override
  String get backupFailed =>
      'Sicherung konnte nicht erstellt werden. Bitte später erneut versuchen.';

  @override
  String get backupImportConfirm =>
      'Die Sicherung wird mit dem Verlauf auf diesem Gerät zusammengeführt. Spitzname und Anmeldedatum werden aus der Sicherung übernommen. Fortfahren?';

  @override
  String backupImportDone(String history, String manual) {
    return 'Wiederherstellung abgeschlossen. Hinzugefügt: Verlauf $history · manuelle Ergebnisse $manual';
  }

  @override
  String get backupInvalid =>
      'Keine Lotto Leader-Sicherung oder die Datei ist beschädigt.';

  @override
  String get backupTooLarge =>
      'Die Datei ist zu groß. Bitte wählen Sie eine Lotto Leader-Sicherung.';

  @override
  String get continueButton => 'Fortfahren';

  @override
  String get colon => ': ';

  @override
  String fSum(String lo, String hi) {
    return 'Summen außerhalb $lo–$hi ausschließen';
  }

  @override
  String hSum(String lo, String hi) {
    return 'Schließt Kombinationen aus, deren Hauptzahlen zusammen weniger als $lo oder mehr als $hi ergeben. Etwa 95 % aller Kombinationen liegen in diesem Bereich.';
  }

  @override
  String get fBirthday => 'Nur Zahlen bis 31 ausschließen (Geburtstage)';

  @override
  String get hBirthday =>
      'Schließt Kombinationen nur aus 1–31 (Zahlen aus Datumsangaben) aus. Viele tippen Geburtstage, daher wird ein Jackpot mit diesen Zahlen eher geteilt. Die Gewinnchance ist dieselbe wie bei jeder anderen Kombination.';

  @override
  String get fLowHigh => 'Nur niedrige oder nur hohe Zahlen ausschließen';

  @override
  String hLowHigh(String half, String next, String max) {
    return 'Schließt Kombinationen aus, deren Zahlen alle zwischen 1 und $half oder alle zwischen $next und $max liegen.';
  }

  @override
  String get fDecade4 => '4+ Zahlen im selben Zehnerbereich ausschließen';

  @override
  String get hDecade4 =>
      'Schließt Kombinationen mit 4 oder mehr Zahlen im selben Zehnerbereich (1–9, 10–19, 20–29 …) aus, z. B. 41, 43, 45, 48.';

  @override
  String get fRepeatLast => '2+ Zahlen der letzten Ziehung ausschließen';

  @override
  String get hRepeatLast =>
      'Schließt Kombinationen aus, die 2 oder mehr Hauptzahlen der letzten Ziehung wiederholen.';

  @override
  String fBonusRecent(String n, String label) {
    return '$label der letzten $n Ziehungen ausschließen';
  }

  @override
  String hBonusRecent(String n, String label) {
    return '$label-Zahlen aus den letzten $n Ziehungen werden nicht gewählt.';
  }

  @override
  String fBonusPairRecent(String n, String label) {
    return '$label-Paare der letzten $n Ziehungen ausschließen';
  }

  @override
  String hBonusPairRecent(String n, String label) {
    return 'Ein $label-Paar, das einer der letzten $n Ziehungen entspricht, wird nicht gewählt.';
  }

  @override
  String fBonusConsec(String label) {
    return 'Aufeinanderfolgende $label ausschließen (z. B. 3·4)';
  }

  @override
  String hBonusConsec(String label) {
    return 'Aufeinanderfolgende $label wie 3·4 werden nicht gewählt.';
  }

  @override
  String fBonusParity(String label) {
    return '$label beide gerade oder beide ungerade ausschließen';
  }

  @override
  String hBonusParity(String label) {
    return '$label, die beide ungerade oder beide gerade sind, werden nicht gewählt.';
  }

  @override
  String get filtersOverseas => 'Zusätzliche Filter dieser Lotterie';

  @override
  String filtersBonus(String label) {
    return '$label-Filter';
  }
}
