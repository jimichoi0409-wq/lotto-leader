// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'Lotto Leader';

  @override
  String get close => 'Fermer';

  @override
  String get apply => 'Appliquer';

  @override
  String get lookup => 'Voir';

  @override
  String get calculating => 'Calcul…';

  @override
  String get extracting => 'Génération…';

  @override
  String get extractButton => 'Générer';

  @override
  String get countHint => 'Nb';

  @override
  String get remainingCombos => 'Combinaisons restantes';

  @override
  String get menuResults => 'Résultats';

  @override
  String get menuReset => 'Réinitialiser';

  @override
  String get menuAlarm => 'Alertes';

  @override
  String get menuSettings => 'Réglages';

  @override
  String get privacyPolicy => 'Politique de confidentialité';

  @override
  String get disclaimer => 'Avertissement';

  @override
  String get contact => 'Contact';

  @override
  String get versionLabel => 'Version';

  @override
  String currentVersion(String version) {
    return 'Version actuelle de l\'app $version';
  }

  @override
  String get language => 'Langue';

  @override
  String get languageSystem => 'Langue de l\'appareil';

  @override
  String drawAlarm(String game) {
    return 'Rappel du jour de tirage $game';
  }

  @override
  String get resetDone => 'Paramètres réinitialisés.';

  @override
  String get privacyText =>
      'Cette application est gratuite. Au premier lancement, vous créez un profil simple avec un pseudo. Votre pseudo et votre historique restent sur cet appareil, ne sont jamais envoyés à l\'éditeur et peuvent être supprimés dans Réglages → Supprimer le compte.\n\nL\'application ne collecte elle-même aucune donnée permettant de vous identifier, comme votre nom, votre numéro de téléphone ou votre adresse e-mail.\n\nL\'application utilise Google AdMob pour afficher des annonces. Dans ce cadre, l\'identifiant publicitaire, des informations sur l\'appareil et des données d\'utilisation peuvent être collectés par Google. Là où un consentement est requis (par ex. dans l\'EEE et au Royaume-Uni), il vous est demandé au premier lancement et vous pouvez le modifier à tout moment dans Réglages → Confidentialité des annonces.\n\nCes informations peuvent servir à diffuser des annonces, améliorer la qualité de l\'application et prévenir les abus.';

  @override
  String get disclaimerText =>
      'Cette application est un outil qui propose des statistiques sur les numéros gagnants passés et aide à composer des combinaisons.\n\nDans toutes les loteries, chaque combinaison a exactement la même chance de remporter le jackpot (par ex. 1 sur 8 145 060 pour le Lotto 6/45 coréen et 1 sur 292 201 338 pour le Powerball). Les filtres et statistiques de cette application n\'augmentent pas vos chances. Utilisez-les uniquement pour le plaisir et à titre indicatif.\n\nCette application est indépendante et n\'est affiliée à aucun opérateur de loterie (dont Dong-hang Lottery, Powerball, Mega Millions, Lotto 6/49, EuroMillions, Eurojackpot, Loto 6, Irish Lotto ou Vietlott).\n\nL\'application ne garantit aucun gain. Vous êtes seul responsable de l\'achat et de l\'utilisation de billets de loterie.\n\nL\'application ne vend pas de billets et ne propose ni paris, ni récompenses en argent, ni services de jeux d\'argent.';

  @override
  String get contactText =>
      'Pour toute question, erreur ou suggestion, écrivez-nous.\n\nÉditeur : 한지성\nE-mail : jnhteamsoft@gmail.com\n\nNous répondons généralement sous 3 jours ouvrés.';

  @override
  String get chooseLottery => 'Choisir une loterie';

  @override
  String gameRule(String count, String max) {
    return '$count numéros (1–$max)';
  }

  @override
  String gameRuleBonus(String label, String count, String max) {
    return ' + $count $label (1–$max)';
  }

  @override
  String jackpotOdds(String odds) {
    return 'Chances du jackpot : 1 sur $odds';
  }

  @override
  String drawCount(String count) {
    return '$count tirages';
  }

  @override
  String get drawsPending => 'Résultats bientôt disponibles';

  @override
  String get drawRoundPrefix => 'Tirage n° ';

  @override
  String get drawRoundSuffix => '';

  @override
  String get drawResultPrefix => 'Résultats ';

  @override
  String get drawResultSuffix => '';

  @override
  String drawDate(String date) {
    return 'Tirage du $date';
  }

  @override
  String get noDrawDate => 'Date du tirage inconnue';

  @override
  String get noResultsStored =>
      'Aucun résultat pour le moment.\n(Les résultats de cette loterie arrivent bientôt.)';

  @override
  String get dbLoading =>
      'Chargement des résultats. Réessayez dans un instant.';

  @override
  String get dbLoadingShort => 'Chargement des résultats…';

  @override
  String get dbLoadFailed => 'Impossible de charger les résultats.';

  @override
  String get freqPrefix => 'Derniers [';

  @override
  String get freqSuffix => '] tirages : plus | moins sortis';

  @override
  String get freqHint => 'tous';

  @override
  String get mostDrawn => 'Plus sortis';

  @override
  String get leastDrawn => 'Moins sortis';

  @override
  String get noDrawData => 'Pas encore de résultats pour cette loterie.';

  @override
  String get recentTooLarge =>
      'Moins de tirages enregistrés : tous sont utilisés.';

  @override
  String get freqError => 'Impossible de calculer les fréquences.';

  @override
  String includeExcludeHeader(String maxInc) {
    return 'Inclure (max $maxInc) | Exclure (max 18)';
  }

  @override
  String get includeRow => 'Inclure';

  @override
  String get excludeRow => 'Exclure';

  @override
  String get includeBonusRow => 'Inclure';

  @override
  String get excludeBonusRow => 'Exclure';

  @override
  String bonusHeader(String label, String max, String inc, String exc) {
    return '$label (1–$max, inclure jusqu\'à $inc · exclure jusqu\'à $exc)';
  }

  @override
  String get numbersWord => 'numéros';

  @override
  String pickerInclude(String kind) {
    return 'Inclure : $kind';
  }

  @override
  String pickerExclude(String kind) {
    return 'Exclure : $kind';
  }

  @override
  String pickerConflict(String number) {
    return '$number est déjà dans l\'autre liste.';
  }

  @override
  String pickerMax(String max) {
    return 'Vous pouvez en choisir jusqu\'à $max.';
  }

  @override
  String get includeLabel => 'Numéros inclus';

  @override
  String get excludeLabel => 'Numéros exclus';

  @override
  String includeBonusLabel(String label) {
    return '$label inclus';
  }

  @override
  String excludeBonusLabel(String label) {
    return '$label exclus';
  }

  @override
  String notNumber(String label, String raw) {
    return '$label : « $raw » n\'est pas un nombre.';
  }

  @override
  String outOfRange(String label, String max) {
    return '$label : uniquement des nombres de 1 à $max.';
  }

  @override
  String get dupInclude => 'Des numéros inclus sont en double.';

  @override
  String get dupExclude => 'Des numéros exclus sont en double.';

  @override
  String conflict(String numbers) {
    return 'Ces numéros sont à la fois inclus et exclus : $numbers';
  }

  @override
  String get calcError => 'Erreur de calcul. Vérifiez vos filtres.';

  @override
  String get busy => 'Calcul en cours. Patientez !';

  @override
  String get noResults => 'Aucune combinaison restante. Modifiez vos réglages.';

  @override
  String tooMany(String count) {
    return 'Il ne reste que $count combinaisons ; $count seront générées.';
  }

  @override
  String get noExtract =>
      'Aucune combinaison disponible. Modifiez vos réglages.';

  @override
  String get extractError =>
      'Impossible de générer les numéros. Vérifiez vos réglages.';

  @override
  String get resultsTitle => 'Vos combinaisons';

  @override
  String get copied => 'Numéros copiés.';

  @override
  String get copyButton => 'Copier';

  @override
  String get shareButton => 'Partager';

  @override
  String shareHeader(String game) {
    return '🍀Mes numéros $game🍀';
  }

  @override
  String get shareSubject => 'Mes numéros de loterie';

  @override
  String get noHelp => 'Aucune description disponible.';

  @override
  String get obWelcome => 'Bienvenue dans Lotto Leader';

  @override
  String get obChooseLanguage =>
      'Choisissez votre langue. Vous pourrez la modifier dans Réglages.';

  @override
  String get obNext => 'Suivant';

  @override
  String get obBack => 'Retour';

  @override
  String get obProfileTitle => 'Inscription rapide';

  @override
  String get obProfileBody =>
      'Choisissez simplement un pseudo pour commencer.\nVotre profil et votre historique restent sur cet appareil.';

  @override
  String get obNickname => 'Pseudo';

  @override
  String get obNicknameHint => '2 à 12 caractères';

  @override
  String get obNicknameError => 'Saisissez un pseudo de 2 à 12 caractères.';

  @override
  String get obAge =>
      'J\'ai l\'âge légal pour jouer à la loterie dans mon pays';

  @override
  String get obAgree =>
      'J\'accepte la Politique de confidentialité et l\'Avertissement';

  @override
  String get obView => 'Voir';

  @override
  String get obStart => 'Commencer';

  @override
  String get obNeedChecks =>
      'Veuillez confirmer tous les éléments obligatoires.';

  @override
  String get menuHistory => 'Historique';

  @override
  String historyJoined(String date) {
    return 'Inscrit le $date';
  }

  @override
  String historyStats(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count générations',
      one: '$count génération',
    );
    return '$_temp0';
  }

  @override
  String get historyEmpty =>
      'Aucun historique pour l\'instant.\nVos combinaisons générées apparaîtront ici.';

  @override
  String historyTickets(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count combinaisons',
      one: '$count combinaison',
    );
    return '$_temp0';
  }

  @override
  String historyFilters(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count filtres',
      one: '$count filtre',
    );
    return '$_temp0';
  }

  @override
  String get historyClearAll => 'Effacer tout l\'historique';

  @override
  String get historyClearConfirm =>
      'Effacer tout l\'historique des générations ?';

  @override
  String get historyDeleted => 'Entrée supprimée.';

  @override
  String get delete => 'Supprimer';

  @override
  String get cancel => 'Annuler';

  @override
  String get confirm => 'OK';

  @override
  String profileNickname(String name) {
    return 'Pseudo : $name';
  }

  @override
  String get withdraw => 'Supprimer le compte (profil et historique)';

  @override
  String get withdrawConfirm =>
      'Votre profil et votre historique seront supprimés de cet appareil et vous reviendrez à l\'écran d\'accueil. Continuer ?';

  @override
  String get manualEntry => 'Saisir les résultats';

  @override
  String get manualHelp =>
      'À utiliser si la mise à jour automatique ne fonctionne pas, d\'après les résultats officiels. Les données officielles de la même date remplaceront votre saisie.';

  @override
  String get manualRound => 'N° de tirage';

  @override
  String get manualDate => 'Date du tirage';

  @override
  String manualMain(String count) {
    return '$count numéros gagnants';
  }

  @override
  String manualBonus(String label, String count) {
    return '$label : $count';
  }

  @override
  String get manualSave => 'Enregistrer';

  @override
  String get manualSaved => 'Résultats enregistrés.';

  @override
  String get manualList => 'Vos saisies';

  @override
  String get manualNone => 'Aucune saisie manuelle.';

  @override
  String get manualTag => 'Manuel';

  @override
  String get mErrRound => 'Vérifiez le numéro de tirage.';

  @override
  String mErrMain(String count) {
    return 'Choisissez $count numéros gagnants.';
  }

  @override
  String mErrBonus(String label, String count) {
    return '$label : choisissez-en $count.';
  }

  @override
  String get mErrBonusOverlap =>
      'Le complémentaire ne peut pas être un des numéros gagnants.';

  @override
  String get mErrDate =>
      'Vérifiez la date. Les dates futures, les jours sans tirage et les dates antérieures aux règles actuelles ne sont pas acceptés.';

  @override
  String get mErrExists =>
      'Des résultats existent déjà pour cette date (tirage).';

  @override
  String get adPrivacyOptions => 'Confidentialité des annonces';

  @override
  String rewardTitle(String count) {
    return 'Générer $count combinaisons';
  }

  @override
  String rewardBody(String free, String count) {
    return 'Jusqu\'à $free combinaisons sont gratuites.\nRegardez une courte annonce pour en générer $count.';
  }

  @override
  String rewardWatch(String count) {
    return 'Annonce : $count';
  }

  @override
  String rewardFreeOnly(String free) {
    return 'Seulement $free';
  }

  @override
  String rewardNotEarned(String free) {
    return 'L\'annonce n\'a pas été terminée : $free combinaisons seront générées.';
  }

  @override
  String get patternFilters => 'Filtres de motifs';

  @override
  String get pastPending => ' (résultats bientôt)';

  @override
  String get fKr1st => 'Exclure les combinaisons gagnantes passées';

  @override
  String get hKr1st =>
      'Exclut les combinaisons identiques à un résultat gagnant passé.';

  @override
  String get fKr23 => 'Exclure 5 numéros communs avec un tirage passé';

  @override
  String get hKr23 =>
      'Exclut les combinaisons ayant 5 des 6 numéros d\'un tirage passé.';

  @override
  String get fKr4th => 'Exclure 4 numéros communs (100 derniers tirages)';

  @override
  String get hKr4th =>
      'Exclut les combinaisons ayant 4 numéros en commun avec l\'un des 100 derniers tirages.';

  @override
  String get fKr5th => 'Exclure les suites de 3 déjà sorties';

  @override
  String get hKr5th =>
      'Exclut les combinaisons contenant une suite de 3 numéros déjà sortie.';

  @override
  String get fKrRange => 'Exclure les écarts étroits (max − min ≤ 9)';

  @override
  String get hKrRange =>
      'Exclut les combinaisons dont l\'écart entre le plus grand et le plus petit numéro est de 9 ou moins.';

  @override
  String fPastFull(String k) {
    return 'Exclure les combinaisons gagnantes ($k numéros)';
  }

  @override
  String hPastFull(String k) {
    return 'Exclut les combinaisons identiques aux $k numéros principaux d\'un tirage selon les règles actuelles.';
  }

  @override
  String fPastMinus1(String m) {
    return 'Exclure $m numéros communs avec un tirage passé';
  }

  @override
  String hPastMinus1(String k, String m) {
    return 'Exclut les combinaisons ayant $m des $k numéros principaux d\'un tirage passé.';
  }

  @override
  String fPastMinus2(String r, String m) {
    return 'Exclure $m numéros communs ($r derniers tirages)';
  }

  @override
  String hPastMinus2(String r, String m) {
    return 'Exclut les combinaisons ayant $m numéros principaux en commun avec l\'un des $r derniers tirages.';
  }

  @override
  String get fPastConsec => 'Exclure les suites de 3 déjà sorties';

  @override
  String get hPastConsec =>
      'Exclut les combinaisons contenant une suite de 3 numéros (ex. 7, 8, 9) déjà sortie.';

  @override
  String fNarrow(String n) {
    return 'Exclure les écarts étroits (max − min ≤ $n)';
  }

  @override
  String hNarrow(String n) {
    return 'Exclut les combinaisons dont l\'écart entre le plus grand et le plus petit numéro est de $n ou moins.';
  }

  @override
  String get f3Consec => 'Exclure 3 numéros consécutifs';

  @override
  String get h3Consec =>
      'Exclut les combinaisons avec 3 numéros consécutifs, comme 1, 2, 3 ou 33, 34, 35.';

  @override
  String get fSkip1 => 'Exclure 3 numéros de 2 en 2';

  @override
  String get hSkip1 =>
      'Exclut les combinaisons avec 3 numéros espacés de 2, comme 1, 3, 5 ou 15, 17, 19.';

  @override
  String get fSkip2 => 'Exclure 3 numéros de 3 en 3';

  @override
  String get hSkip2 =>
      'Exclut les combinaisons avec 3 numéros espacés de 3, comme 1, 4, 7 ou 15, 18, 21.';

  @override
  String get fSkip3 => 'Exclure 3 numéros de 4 en 4';

  @override
  String get hSkip3 =>
      'Exclut les combinaisons avec 3 numéros espacés de 4, comme 1, 5, 9 ou 15, 19, 23.';

  @override
  String get f2Pairs => 'Exclure 2 paires consécutives ou plus';

  @override
  String get h2Pairs =>
      'Exclut les combinaisons avec au moins deux paires consécutives, comme 1, 2 et 15, 16.';

  @override
  String fAllOdd(String k) {
    return 'Exclure tout impair ($k impairs)';
  }

  @override
  String hAllOdd(String k) {
    return 'Exclut les combinaisons dont les $k numéros sont impairs.';
  }

  @override
  String fAllEven(String k) {
    return 'Exclure tout pair ($k pairs)';
  }

  @override
  String hAllEven(String k) {
    return 'Exclut les combinaisons dont les $k numéros sont pairs.';
  }

  @override
  String get fOE1 => 'Exclure I-P-I-P-I-P / P-I-P-I-P-I';

  @override
  String get fOE2 => 'Exclure P-P-I-I-P-P / I-I-P-P-I-I';

  @override
  String get fOE3 => 'Exclure P-P-P-P-P-I / I-I-I-I-I-P';

  @override
  String get fOE4 => 'Exclure P-P-P-P-I-I / I-I-I-I-P-P';

  @override
  String get fOE5 => 'Exclure P-P-P-I-I-I / I-I-I-P-P-P';

  @override
  String hOE(String pattern) {
    return 'Exclut les combinaisons dont les 6 numéros triés suivent l\'ordre impair(I)/pair(P) $pattern.';
  }

  @override
  String get fSameDigit => 'Exclure 3+ numéros finissant par le même chiffre';

  @override
  String get hSameDigit =>
      'Exclut les combinaisons avec au moins 3 numéros se terminant par le même chiffre, comme 1, 11, 21, 31.';

  @override
  String get fTripleMult => 'Exclure 3 multiples consécutifs';

  @override
  String get hTripleMult =>
      'Exclut les combinaisons contenant 3 multiples consécutifs d\'un même nombre, comme 2, 4, 6 ou 4, 8, 12.';

  @override
  String get alarmIntro =>
      'Vous recevrez une notification 3 heures avant chaque tirage des loteries activées.';

  @override
  String alarmDrawAt(String days, String time) {
    return 'Tirages $days $time (heure locale)';
  }

  @override
  String get alarmUnsupported =>
      'Les notifications ne sont pas prises en charge sur cet appareil. Utilisez l\'app mobile.';

  @override
  String get alarmDenied =>
      'Les notifications sont désactivées. Autorisez-les pour cette app dans les réglages du téléphone.';

  @override
  String alarmOn(String game) {
    return 'Nous vous préviendrons 3 heures avant chaque tirage $game.';
  }

  @override
  String alarmOff(String game) {
    return 'Rappels $game désactivés.';
  }

  @override
  String notifyTitle(String game) {
    return 'Tirage $game aujourd\'hui !';
  }

  @override
  String get notifyBody =>
      'Le tirage a lieu dans 3 heures. Générez vos numéros dans Lotto Leader.';

  @override
  String get notifyChannel => 'Rappels de tirage';

  @override
  String get winPending => 'En attente du tirage';

  @override
  String winDrawOf(String date) {
    return 'Comparé au tirage du $date';
  }

  @override
  String winRank(String rank) {
    return 'Rang $rank';
  }

  @override
  String winBest(String rank) {
    return 'Meilleur : $rank';
  }

  @override
  String get winNone => 'Non gagnant';

  @override
  String winMatch(String main) {
    return '$main bons numéros';
  }

  @override
  String winMatchPlus(String main, String bonus) {
    return '$main+$bonus bons numéros';
  }

  @override
  String winMatchBonus(String main) {
    return '$main bons numéros + complémentaire';
  }

  @override
  String get winPendingHint =>
      'La comparaison se fait automatiquement dès que le résultat arrive. En cas de retard, utilisez Réglages → Saisir les résultats.';

  @override
  String get statsTitle => 'Statistiques';

  @override
  String statsRecent(String n) {
    return '$n derniers';
  }

  @override
  String get statsAll => 'Tous';

  @override
  String get statsMain => 'Numéros';

  @override
  String get statsSortNumber => 'Par numéro';

  @override
  String get statsSortMost => 'Plus sortis';

  @override
  String get statsSortLeast => 'Moins sortis';

  @override
  String get statsSortGap => 'Absents depuis longtemps';

  @override
  String statsAnalyzed(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: 'Sur les $n derniers tirages',
      one: 'Sur le dernier tirage',
    );
    return '$_temp0';
  }

  @override
  String get statsHot => 'Numéros chauds';

  @override
  String get statsCold => 'Numéros froids';

  @override
  String statsCount(String n) {
    return '$n×';
  }

  @override
  String statsGap(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: 'il y a $n tirages',
      one: 'il y a $n tirage',
    );
    return '$_temp0';
  }

  @override
  String get statsGapLatest => 'Dernier tirage';

  @override
  String get statsGapNever => 'Jamais sorti';

  @override
  String get statsOddEven => 'Répartition pairs / impairs';

  @override
  String statsOddLabel(String odd, String even) {
    return '$odd impairs : $even pairs';
  }

  @override
  String get statsDisclaimer =>
      'Ce sont uniquement des résultats passés, qui ne prédisent pas les tirages futurs.';

  @override
  String get backupExport => 'Sauvegarder l\'historique';

  @override
  String get backupImport => 'Restaurer une sauvegarde';

  @override
  String get backupShareText =>
      'Sauvegarde Lotto Leader. Sur votre nouveau téléphone, ouvrez Réglages → Restaurer une sauvegarde et choisissez ce fichier.';

  @override
  String get backupEmpty => 'Rien à sauvegarder pour l\'instant.';

  @override
  String get backupFailed =>
      'Impossible de créer la sauvegarde. Réessayez plus tard.';

  @override
  String get backupImportConfirm =>
      'La sauvegarde sera fusionnée avec l\'historique de cet appareil. Le pseudo et la date d\'inscription seront repris de la sauvegarde. Continuer ?';

  @override
  String backupImportDone(String history, String manual) {
    return 'Restauration terminée. Ajouté : historique $history · résultats saisis $manual';
  }

  @override
  String get backupInvalid =>
      'Ce n\'est pas une sauvegarde Lotto Leader ou le fichier est endommagé.';

  @override
  String get backupTooLarge =>
      'Le fichier est trop volumineux. Choisissez une sauvegarde Lotto Leader.';

  @override
  String get continueButton => 'Continuer';

  @override
  String get colon => ' : ';

  @override
  String fSum(String lo, String hi) {
    return 'Exclure les sommes hors $lo–$hi';
  }

  @override
  String hSum(String lo, String hi) {
    return 'Exclut les combinaisons dont la somme des numéros principaux est inférieure à $lo ou supérieure à $hi. Environ 95 % des combinaisons se trouvent dans cette plage.';
  }

  @override
  String get fBirthday => 'Exclure les combinaisons ≤ 31 (dates)';

  @override
  String get hBirthday =>
      'Exclut les combinaisons composées uniquement de 1 à 31 (numéros de dates). Beaucoup de joueurs choisissent des anniversaires : un jackpot sur ces numéros a plus de chances d\'être partagé. La probabilité de gagner reste la même que pour toute autre combinaison.';

  @override
  String get fLowHigh => 'Exclure tout bas ou tout haut';

  @override
  String hLowHigh(String half, String next, String max) {
    return 'Exclut les combinaisons dont tous les numéros sont entre 1 et $half, ou tous entre $next et $max.';
  }

  @override
  String get fDecade4 => 'Exclure 4+ numéros dans la même dizaine';

  @override
  String get hDecade4 =>
      'Exclut les combinaisons ayant au moins 4 numéros dans la même dizaine (1–9, 10–19, 20–29 …), comme 41, 43, 45, 48.';

  @override
  String get fRepeatLast => 'Exclure 2+ numéros du dernier tirage';

  @override
  String get hRepeatLast =>
      'Exclut les combinaisons qui reprennent au moins 2 numéros principaux du dernier tirage.';

  @override
  String fBonusRecent(String n, String label) {
    return 'Exclure les $label des $n derniers tirages';
  }

  @override
  String hBonusRecent(String n, String label) {
    return 'Les numéros $label tirés lors des $n derniers tirages ne seront pas choisis.';
  }

  @override
  String fBonusPairRecent(String n, String label) {
    return 'Exclure les paires $label des $n derniers tirages';
  }

  @override
  String hBonusPairRecent(String n, String label) {
    return 'Une paire $label identique à l\'un des $n derniers tirages ne sera pas choisie.';
  }

  @override
  String fBonusConsec(String label) {
    return 'Exclure les $label consécutifs (ex. 3·4)';
  }

  @override
  String hBonusConsec(String label) {
    return 'Les $label consécutifs, comme 3·4, ne seront pas choisis.';
  }

  @override
  String fBonusParity(String label) {
    return 'Exclure les $label tous deux pairs ou impairs';
  }

  @override
  String hBonusParity(String label) {
    return 'Les $label tous deux impairs ou tous deux pairs ne seront pas choisis.';
  }

  @override
  String get filtersOverseas => 'Filtres supplémentaires de cette loterie';

  @override
  String filtersBonus(String label) {
    return 'Filtres $label';
  }
}
