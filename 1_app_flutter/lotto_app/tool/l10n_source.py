"""번역 원본 표 → lib/l10n/app_*.arb 생성

번역을 고칠 때는 이 표를 수정한 뒤 `python tool/l10n_source.py` 를 실행하세요.
그다음 `flutter gen-l10n` (또는 flutter run/build) 이 Dart 코드를 다시 만듭니다.
열 순서: ko, en, es, fr, de. {이름} 은 자리표시자(문자열)입니다.
일본어·베트남어는 tool/l10n_ja_vi.py 에 따로 있고, 생성할 때 같은 키로 합칩니다.
"""
import json
import re
from pathlib import Path

BASE_LANGS = ["ko", "en", "es", "fr", "de"]
LANGS = BASE_LANGS + ["ja", "vi"]

# 단수·복수(ICU plural)를 쓰는 키: 자리표시자가 int 이고, 코드에서 숫자를 그대로 넘깁니다.
PLURAL_KEYS = {"historyStats", "historyTickets", "historyFilters", "statsGap", "statsAnalyzed"}

T = {
    # ---- 공통 ----
    "appTitle": ["로또대장", "Lotto Leader", "Lotto Leader", "Lotto Leader", "Lotto Leader"],
    "close": ["닫기", "Close", "Cerrar", "Fermer", "Schließen"],
    "apply": ["적 용", "Apply", "Aplicar", "Appliquer", "Anwenden"],
    "lookup": ["조 회", "View", "Ver", "Voir", "Anzeigen"],
    "calculating": ["계산중", "Calculating…", "Calculando…", "Calcul…", "Berechnung…"],
    "extracting": ["추출중...", "Generating…", "Generando…", "Génération…", "Erzeuge…"],
    "extractButton": ["번호추출", "Generate", "Generar", "Générer", "Erzeugen"],
    "countHint": ["갯수입력", "Qty", "Cant.", "Nb", "Anz."],
    "remainingCombos": ["남은 조합 수", "Remaining combinations", "Combinaciones restantes", "Combinaisons restantes", "Verbleibende Kombinationen"],

    # ---- 하단 메뉴·설정 ----
    "menuResults": ["당첨번호", "Results", "Resultados", "Résultats", "Ergebnisse"],
    "menuReset": ["새로고침", "Reset", "Reiniciar", "Réinitialiser", "Zurücksetzen"],
    "menuAlarm": ["알람", "Alerts", "Alertas", "Alertes", "Erinnerung"],
    "menuSettings": ["설정", "Settings", "Ajustes", "Réglages", "Einstellungen"],
    "privacyPolicy": ["개인정보처리방침", "Privacy policy", "Política de privacidad", "Politique de confidentialité", "Datenschutzerklärung"],
    "disclaimer": ["면책고지", "Disclaimer", "Aviso legal", "Avertissement", "Haftungsausschluss"],
    "contact": ["문의하기", "Contact", "Contacto", "Contact", "Kontakt"],
    "versionLabel": ["버전정보", "Version", "Versión", "Version", "Version"],
    "currentVersion": ["현재 앱 버전 {version}", "Current app version {version}", "Versión actual de la app {version}", "Version actuelle de l'app {version}", "Aktuelle App-Version {version}"],
    "language": ["언어", "Language", "Idioma", "Langue", "Sprache"],
    "languageSystem": ["기기 설정 따르기", "Use device language", "Idioma del dispositivo", "Langue de l'appareil", "Gerätesprache verwenden"],
    "drawAlarm": ["{game} 추첨일 알람", "{game} draw-day reminder", "Aviso del día de sorteo de {game}", "Rappel du jour de tirage {game}", "Erinnerung am Ziehungstag ({game})"],
    "resetDone": ["처음 시작값으로 초기화했습니다.", "Reset to default settings.", "Se restablecieron los valores iniciales.", "Paramètres réinitialisés.", "Auf Standardeinstellungen zurückgesetzt."],

    "privacyText": [
        "본 앱은 무료로 이용할 수 있으며, 처음 실행할 때 닉네임만으로 간단히 가입합니다. 닉네임과 번호 추출 기록은 이 기기에만 저장되고 운영자에게 전송되지 않으며, 설정 → 탈퇴로 언제든 삭제할 수 있습니다.\n\n본 앱은 사용자의 이름, 전화번호, 이메일 등 직접 식별 가능한 개인정보를 앱 내부에서 별도로 수집하지 않습니다.\n\n본 앱은 광고 제공을 위해 Google AdMob을 사용하며, 이 과정에서 광고 ID, 기기 정보, 앱 사용 정보 등이 Google에 수집될 수 있습니다. 유럽 등 동의가 필요한 지역에서는 처음 실행할 때 동의 여부를 묻고, 설정 → 광고 개인정보 설정에서 언제든 바꿀 수 있습니다.\n\n수집 및 이용되는 정보는 광고 제공, 앱 품질 개선, 부정 이용 방지 목적으로 사용될 수 있습니다.",
        "This app is free. On first launch you create a simple profile with just a nickname. Your nickname and generation history are stored only on this device, are never sent to the operator, and can be deleted at any time in Settings → Delete account.\n\nThe app itself does not collect personally identifying information such as your name, phone number or email address.\n\nThe app uses Google AdMob to show ads. In that process, the advertising ID, device information and app usage information may be collected by Google. Where consent is required (e.g. in the EEA and UK), you are asked on first launch and can change your choice at any time in Settings → Ad privacy settings.\n\nThis information may be used to deliver ads, improve app quality and prevent abuse.",
        "Esta app es gratuita. Al iniciarla por primera vez creas un perfil sencillo solo con un apodo. Tu apodo y tu historial se guardan solo en este dispositivo, nunca se envían al responsable y puedes borrarlos en Ajustes → Eliminar cuenta.\n\nLa app no recopila por sí misma datos personales que te identifiquen, como tu nombre, teléfono o correo electrónico.\n\nLa app usa Google AdMob para mostrar anuncios. En ese proceso, Google puede recopilar el ID de publicidad, información del dispositivo y datos de uso de la app. Donde se requiere consentimiento (p. ej., en el EEE y el Reino Unido), se te pregunta en el primer inicio y puedes cambiar tu elección en Ajustes → Privacidad de anuncios.\n\nEsta información puede utilizarse para mostrar anuncios, mejorar la calidad de la app y prevenir usos fraudulentos.",
        "Cette application est gratuite. Au premier lancement, vous créez un profil simple avec un pseudo. Votre pseudo et votre historique restent sur cet appareil, ne sont jamais envoyés à l'éditeur et peuvent être supprimés dans Réglages → Supprimer le compte.\n\nL'application ne collecte elle-même aucune donnée permettant de vous identifier, comme votre nom, votre numéro de téléphone ou votre adresse e-mail.\n\nL'application utilise Google AdMob pour afficher des annonces. Dans ce cadre, l'identifiant publicitaire, des informations sur l'appareil et des données d'utilisation peuvent être collectés par Google. Là où un consentement est requis (par ex. dans l'EEE et au Royaume-Uni), il vous est demandé au premier lancement et vous pouvez le modifier à tout moment dans Réglages → Confidentialité des annonces.\n\nCes informations peuvent servir à diffuser des annonces, améliorer la qualité de l'application et prévenir les abus.",
        "Diese App ist kostenlos. Beim ersten Start legen Sie ein einfaches Profil nur mit einem Spitznamen an. Spitzname und Verlauf werden nur auf diesem Gerät gespeichert, nie an den Verantwortlichen gesendet und können unter Einstellungen → Konto löschen jederzeit gelöscht werden.\n\nDie App selbst erhebt keine personenbezogenen Daten wie Name, Telefonnummer oder E-Mail-Adresse.\n\nDie App nutzt Google AdMob zur Anzeige von Werbung. Dabei können die Werbe-ID, Geräteinformationen und Nutzungsdaten von Google erfasst werden. Wo eine Einwilligung erforderlich ist (z. B. im EWR und im Vereinigten Königreich), werden Sie beim ersten Start gefragt und können Ihre Wahl jederzeit unter Einstellungen → Datenschutz für Werbung ändern.\n\nDiese Informationen können zur Auslieferung von Werbung, zur Verbesserung der App und zur Missbrauchsvermeidung verwendet werden.",
    ],
    "disclaimerText": [
        "본 앱은 과거 로또 당첨번호를 기반으로 통계 분석 및 번호 조합 참고 기능을 제공하는 도구입니다.\n\n모든 복권은 번호 조합마다 1등 당첨 확률이 동일합니다(예: 로또 6/45는 1/8,145,060, 파워볼은 1/292,201,338). 본 앱의 필터와 통계는 당첨 확률을 높이지 않습니다. 번호 선택의 재미와 참고용으로만 이용해주세요.\n\n본 앱은 각 복권 운영사(동행복권, Powerball, Mega Millions, Lotto 6/49, EuroMillions, Eurojackpot, 로토6, Irish Lotto, Vietlott 등)와 관련이 없는 독립 앱입니다.\n\n본 앱은 당첨을 보장하지 않으며, 복권 구매 및 이용에 대한 모든 책임은 사용자 본인에게 있습니다.\n\n본 앱은 복권 구매, 베팅, 현금성 보상, 도박 서비스를 제공하지 않습니다.",
        "This app is a tool that offers statistics on past winning numbers and helps you build number combinations.\n\nIn every lottery, each combination has exactly the same chance of winning the jackpot (e.g. 1 in 8,145,060 for Korea's Lotto 6/45 and 1 in 292,201,338 for Powerball). The filters and statistics in this app do not improve your odds. Please use them for fun and reference only.\n\nThis is an independent app and is not affiliated with any lottery operator (including Dong-hang Lottery, Powerball, Mega Millions, Lotto 6/49, EuroMillions, Eurojackpot, Loto 6, Irish Lotto or Vietlott).\n\nThe app does not guarantee any winnings. You are solely responsible for buying and playing lottery tickets.\n\nThe app does not sell tickets and offers no betting, cash rewards or gambling services.",
        "Esta app es una herramienta que ofrece estadísticas de números ganadores anteriores y ayuda a crear combinaciones.\n\nEn todas las loterías, cada combinación tiene exactamente la misma probabilidad de ganar el premio mayor (p. ej., 1 entre 8.145.060 en la Lotto 6/45 de Corea y 1 entre 292.201.338 en Powerball). Los filtros y estadísticas de esta app no aumentan tus probabilidades. Úsalos solo como entretenimiento y referencia.\n\nEsta es una app independiente y no está afiliada a ningún operador de lotería (incluidos Dong-hang Lottery, Powerball, Mega Millions, Lotto 6/49, EuroMillones, Eurojackpot, Loto 6, Irish Lotto o Vietlott).\n\nLa app no garantiza ningún premio. Eres el único responsable de comprar y jugar a la lotería.\n\nLa app no vende boletos ni ofrece apuestas, recompensas en efectivo ni servicios de juego.",
        "Cette application est un outil qui propose des statistiques sur les numéros gagnants passés et aide à composer des combinaisons.\n\nDans toutes les loteries, chaque combinaison a exactement la même chance de remporter le jackpot (par ex. 1 sur 8 145 060 pour le Lotto 6/45 coréen et 1 sur 292 201 338 pour le Powerball). Les filtres et statistiques de cette application n'augmentent pas vos chances. Utilisez-les uniquement pour le plaisir et à titre indicatif.\n\nCette application est indépendante et n'est affiliée à aucun opérateur de loterie (dont Dong-hang Lottery, Powerball, Mega Millions, Lotto 6/49, EuroMillions, Eurojackpot, Loto 6, Irish Lotto ou Vietlott).\n\nL'application ne garantit aucun gain. Vous êtes seul responsable de l'achat et de l'utilisation de billets de loterie.\n\nL'application ne vend pas de billets et ne propose ni paris, ni récompenses en argent, ni services de jeux d'argent.",
        "Diese App ist ein Werkzeug, das Statistiken zu früheren Gewinnzahlen bietet und beim Zusammenstellen von Zahlenkombinationen hilft.\n\nBei jeder Lotterie hat jede Kombination genau dieselbe Chance auf den Jackpot (z. B. 1 zu 8.145.060 beim koreanischen Lotto 6/45 und 1 zu 292.201.338 bei Powerball). Die Filter und Statistiken dieser App erhöhen Ihre Gewinnchancen nicht. Bitte nutzen Sie sie nur zur Unterhaltung und Orientierung.\n\nDies ist eine unabhängige App und steht in keiner Verbindung zu Lotteriebetreibern (u. a. Dong-hang Lottery, Powerball, Mega Millions, Lotto 6/49, EuroMillions, Eurojackpot, Loto 6, Irish Lotto oder Vietlott).\n\nDie App garantiert keine Gewinne. Für den Kauf und das Spielen von Lotterielosen sind Sie selbst verantwortlich.\n\nDie App verkauft keine Lose und bietet weder Wetten noch Geldprämien oder Glücksspieldienste an.",
    ],
    "contactText": [
        "앱 이용 중 궁금한 점이나 오류, 제안이 있으면 아래 이메일로 보내 주세요.\n\n운영자: 한지성\n이메일: jnhteamsoft@gmail.com\n\n보통 3영업일 안에 답변드립니다.",
        "If you have questions, find a bug or have a suggestion, please email us.\n\nOperator: 한지성\nEmail: jnhteamsoft@gmail.com\n\nWe usually reply within 3 business days.",
        "Si tienes dudas, encuentras un error o quieres hacer una sugerencia, escríbenos.\n\nResponsable: 한지성\nCorreo: jnhteamsoft@gmail.com\n\nSolemos responder en un plazo de 3 días hábiles.",
        "Pour toute question, erreur ou suggestion, écrivez-nous.\n\nÉditeur : 한지성\nE-mail : jnhteamsoft@gmail.com\n\nNous répondons généralement sous 3 jours ouvrés.",
        "Bei Fragen, Fehlern oder Vorschlägen schreiben Sie uns gerne.\n\nVerantwortlich: 한지성\nE-Mail: jnhteamsoft@gmail.com\n\nWir antworten in der Regel innerhalb von 3 Werktagen.",
    ],

    # ---- 복권 선택 ----
    "chooseLottery": ["복권 선택", "Choose lottery", "Elegir lotería", "Choisir une loterie", "Lotterie wählen"],
    "gameRule": ["번호 {count}개(1~{max})", "{count} numbers (1–{max})", "{count} números (1–{max})", "{count} numéros (1–{max})", "{count} Zahlen (1–{max})"],
    "gameRuleBonus": [" + {label} {count}개(1~{max})", " + {count} {label} (1–{max})", " + {count} {label} (1–{max})", " + {count} {label} (1–{max})", " + {count} {label} (1–{max})"],
    "jackpotOdds": ["1등 확률 1/{odds}", "Jackpot odds 1 in {odds}", "Probabilidad del bote: 1 entre {odds}", "Chances du jackpot : 1 sur {odds}", "Jackpot-Chance: 1 zu {odds}"],
    "drawCount": ["당첨번호 {count}회", "{count} past draws", "{count} sorteos", "{count} tirages", "{count} Ziehungen"],
    "drawsPending": ["당첨번호 준비 중", "Results coming soon", "Resultados próximamente", "Résultats bientôt disponibles", "Ergebnisse folgen"],

    # ---- 당첨번호 보기 ----
    "drawRoundPrefix": ["제 ", "Draw #", "Sorteo n.º ", "Tirage n° ", "Ziehung Nr. "],
    "drawRoundSuffix": ["회 추첨 결과", "", "", "", ""],
    "drawResultPrefix": ["", "", "Resultados de ", "Résultats ", "Ergebnisse "],
    "drawResultSuffix": [" 추첨 결과", " results", "", "", ""],
    "drawDate": ["{date} 추첨", "Drawn on {date}", "Sorteo del {date}", "Tirage du {date}", "Ziehung vom {date}"],
    "noDrawDate": ["추첨일 정보 없음", "Draw date unknown", "Fecha del sorteo desconocida", "Date du tirage inconnue", "Ziehungsdatum unbekannt"],
    "noResultsStored": ["저장된 당첨번호가 없습니다.\n(이 복권은 당첨번호 데이터를 준비 중입니다)", "No past results yet.\n(Results for this lottery are coming soon.)", "Aún no hay resultados.\n(Los resultados de esta lotería llegarán pronto).", "Aucun résultat pour le moment.\n(Les résultats de cette loterie arrivent bientôt.)", "Noch keine Ergebnisse.\n(Die Ergebnisse dieser Lotterie folgen in Kürze.)"],
    "dbLoading": ["당첨번호 DB를 불러오는 중입니다. 잠시 후 다시 시도해주세요.", "Loading past results. Please try again in a moment.", "Cargando resultados. Inténtalo de nuevo en un momento.", "Chargement des résultats. Réessayez dans un instant.", "Ergebnisse werden geladen. Bitte gleich erneut versuchen."],
    "dbLoadingShort": ["당첨번호 DB를 불러오는 중입니다.", "Loading past results…", "Cargando resultados…", "Chargement des résultats…", "Ergebnisse werden geladen…"],
    "dbLoadFailed": ["당첨번호 DB를 불러오지 못했습니다. DB/CSV asset을 확인해주세요.", "Could not load past results.", "No se pudieron cargar los resultados.", "Impossible de charger les résultats.", "Ergebnisse konnten nicht geladen werden."],

    # ---- 빈도 ----
    "freqPrefix": ["최근 [", "Last [", "Últimos [", "Derniers [", "Letzte ["],
    "freqSuffix": ["]회 최다 | 최저 당첨번호 숫자", "] draws: most | least drawn", "] sorteos: más | menos salidos", "] tirages : plus | moins sortis", "] Ziehungen: häufigste | seltenste"],
    "freqHint": ["입력", "all", "todos", "tous", "alle"],
    "mostDrawn": ["최다추첨번호", "Most drawn", "Más salidos", "Plus sortis", "Häufigste"],
    "leastDrawn": ["최저추첨번호", "Least drawn", "Menos salidos", "Moins sortis", "Seltenste"],
    "noDrawData": ["이 복권은 아직 당첨번호 데이터가 없습니다.", "No past results for this lottery yet.", "Aún no hay resultados para esta lotería.", "Pas encore de résultats pour cette loterie.", "Für diese Lotterie gibt es noch keine Ergebnisse."],
    "recentTooLarge": ["입력한 회차가 전체 저장 회차보다 커서 전회차 기준으로 조회합니다.", "That's more draws than are stored, so all draws are used.", "Hay menos sorteos guardados; se usan todos.", "Moins de tirages enregistrés : tous sont utilisés.", "Weniger Ziehungen gespeichert – alle werden verwendet."],
    "freqError": ["빈도 계산 중 오류가 발생했습니다.", "Could not calculate frequencies.", "No se pudieron calcular las frecuencias.", "Impossible de calculer les fréquences.", "Häufigkeiten konnten nicht berechnet werden."],

    # ---- 포함·제외 ----
    "includeExcludeHeader": ["포함[최대 {maxInc}개] | 제외[최대 18개] 숫자 지정", "Include (max {maxInc}) | Exclude (max 18)", "Incluir (máx. {maxInc}) | Excluir (máx. 18)", "Inclure (max {maxInc}) | Exclure (max 18)", "Rein (max. {maxInc}) | Raus (max. 18)"],
    "includeRow": ["포함할 숫자", "Include", "Incluir", "Inclure", "Einschließen"],
    "excludeRow": ["제외할 숫자", "Exclude", "Excluir", "Exclure", "Ausschließen"],
    "includeBonusRow": ["포함할 번호", "Include", "Incluir", "Inclure", "Einschließen"],
    "excludeBonusRow": ["제외할 번호", "Exclude", "Excluir", "Exclure", "Ausschließen"],
    "bonusHeader": ["{label} 지정 (1~{max}, 포함 최대 {inc}개 · 제외 최대 {exc}개)", "{label} (1–{max}, include up to {inc} · exclude up to {exc})", "{label} (1–{max}, incluir hasta {inc} · excluir hasta {exc})", "{label} (1–{max}, inclure jusqu'à {inc} · exclure jusqu'à {exc})", "{label} (1–{max}, bis zu {inc} rein · bis zu {exc} raus)"],
    "numbersWord": ["숫자", "numbers", "números", "numéros", "Zahlen"],
    "pickerInclude": ["포함 {kind} 지정", "Include {kind}", "Incluir {kind}", "Inclure : {kind}", "{kind} einschließen"],
    "pickerExclude": ["제외 {kind} 지정", "Exclude {kind}", "Excluir {kind}", "Exclure : {kind}", "{kind} ausschließen"],
    "pickerConflict": ["포함 숫자와 제외 숫자가 중복됩니다: {number}", "{number} is already in the other list.", "{number} ya está en la otra lista.", "{number} est déjà dans l'autre liste.", "{number} ist bereits in der anderen Liste."],
    "pickerMax": ["최대 {max}개까지만 선택할 수 있습니다.", "You can select up to {max}.", "Puedes elegir hasta {max}.", "Vous pouvez en choisir jusqu'à {max}.", "Sie können bis zu {max} auswählen."],
    "includeLabel": ["포함 숫자", "Included numbers", "Números incluidos", "Numéros inclus", "Eingeschlossene Zahlen"],
    "excludeLabel": ["제외 숫자", "Excluded numbers", "Números excluidos", "Numéros exclus", "Ausgeschlossene Zahlen"],
    "includeBonusLabel": ["포함 {label}", "Included {label}", "{label} incluidos", "{label} inclus", "Eingeschlossene {label}"],
    "excludeBonusLabel": ["제외 {label}", "Excluded {label}", "{label} excluidos", "{label} exclus", "Ausgeschlossene {label}"],
    "notNumber": ["{label}에 숫자가 아닌 값이 입력되었습니다: {raw}", "{label}: \"{raw}\" is not a number.", "{label}: \"{raw}\" no es un número.", "{label} : « {raw} » n'est pas un nombre.", "{label}: „{raw}“ ist keine Zahl."],
    "outOfRange": ["{label}: 1부터 {max}까지의 숫자만 입력할 수 있습니다.", "{label} must be between 1 and {max}.", "{label}: solo números del 1 al {max}.", "{label} : uniquement des nombres de 1 à {max}.", "{label}: nur Zahlen von 1 bis {max}."],
    "dupInclude": ["포함할 숫자에 중복이 있습니다.", "Included numbers contain duplicates.", "Hay números incluidos repetidos.", "Des numéros inclus sont en double.", "Eingeschlossene Zahlen enthalten Duplikate."],
    "dupExclude": ["제외할 숫자에 중복이 있습니다.", "Excluded numbers contain duplicates.", "Hay números excluidos repetidos.", "Des numéros exclus sont en double.", "Ausgeschlossene Zahlen enthalten Duplikate."],
    "conflict": ["포함 숫자와 제외 숫자가 중복됩니다: {numbers}", "These numbers are both included and excluded: {numbers}", "Estos números están incluidos y excluidos a la vez: {numbers}", "Ces numéros sont à la fois inclus et exclus : {numbers}", "Diese Zahlen sind ein- und ausgeschlossen: {numbers}"],

    # ---- 계산·추출 ----
    "calcError": ["연산 중 오류가 발생했습니다. 필터를 다시 확인해주세요.", "Calculation failed. Please check your filters.", "Error en el cálculo. Revisa los filtros.", "Erreur de calcul. Vérifiez vos filtres.", "Berechnungsfehler. Bitte Filter prüfen."],
    "busy": ["계산 중입니다. 잠시만 기다려주세요!", "Still calculating. Please wait!", "Calculando. ¡Espera un momento!", "Calcul en cours. Patientez !", "Berechnung läuft. Bitte warten!"],
    "noResults": ["결과가 없습니다. 조건을 다시 설정해주세요.", "No combinations left. Please change your settings.", "No quedan combinaciones. Cambia los ajustes.", "Aucune combinaison restante. Modifiez vos réglages.", "Keine Kombinationen übrig. Bitte Einstellungen ändern."],
    "tooMany": ["남은 조합 수보다 요청 개수가 많아 {count}개만 추출합니다.", "Only {count} combinations remain, so {count} will be generated.", "Solo quedan {count} combinaciones; se generarán {count}.", "Il ne reste que {count} combinaisons ; {count} seront générées.", "Nur {count} Kombinationen übrig – es werden {count} erzeugt."],
    "noExtract": ["추출 가능한 조합이 없습니다. 조건을 다시 설정해주세요.", "No combinations available. Please change your settings.", "No hay combinaciones disponibles. Cambia los ajustes.", "Aucune combinaison disponible. Modifiez vos réglages.", "Keine Kombinationen verfügbar. Bitte Einstellungen ändern."],
    "extractError": ["번호 추출 중 오류가 발생했습니다. 조건을 다시 확인해주세요.", "Could not generate numbers. Please check your settings.", "No se pudieron generar los números. Revisa los ajustes.", "Impossible de générer les numéros. Vérifiez vos réglages.", "Zahlen konnten nicht erzeugt werden. Bitte Einstellungen prüfen."],
    "resultsTitle": ["추출된 조합", "Your combinations", "Tus combinaciones", "Vos combinaisons", "Ihre Kombinationen"],
    "copied": ["번호가 복사되었습니다.", "Numbers copied.", "Números copiados.", "Numéros copiés.", "Zahlen kopiert."],
    "copyButton": ["추출번호복사", "Copy", "Copiar", "Copier", "Kopieren"],
    "shareButton": ["추출번호보내기", "Share", "Compartir", "Partager", "Teilen"],
    "shareHeader": ["🍀나의 {game} 조합 번호🍀", "🍀My {game} numbers🍀", "🍀Mis números de {game}🍀", "🍀Mes numéros {game}🍀", "🍀Meine {game}-Zahlen🍀"],
    "shareSubject": ["로또 조합 번호 공유", "My lottery numbers", "Mis números de lotería", "Mes numéros de loterie", "Meine Lottozahlen"],
    "noHelp": ["설명이 준비되지 않았습니다.", "No description available.", "No hay descripción disponible.", "Aucune description disponible.", "Keine Beschreibung verfügbar."],

    # ---- 처음 실행 (언어 선택·간단 가입) ----
    "obWelcome": ["로또대장에 오신 것을 환영합니다", "Welcome to Lotto Leader", "Te damos la bienvenida a Lotto Leader", "Bienvenue dans Lotto Leader", "Willkommen bei Lotto Leader"],
    "obChooseLanguage": ["사용할 언어를 선택하세요. 나중에 설정에서 바꿀 수 있습니다.", "Choose your language. You can change it later in Settings.", "Elige tu idioma. Puedes cambiarlo más tarde en Ajustes.", "Choisissez votre langue. Vous pourrez la modifier dans Réglages.", "Wählen Sie Ihre Sprache. Sie können sie später in den Einstellungen ändern."],
    "obNext": ["다음", "Next", "Siguiente", "Suivant", "Weiter"],
    "obBack": ["이전", "Back", "Atrás", "Retour", "Zurück"],
    "obProfileTitle": ["간단 가입", "Quick sign-up", "Registro rápido", "Inscription rapide", "Schnelle Anmeldung"],
    "obProfileBody": ["닉네임만 정하면 바로 시작할 수 있어요.\n가입 정보와 이용 기록은 이 기기에만 저장됩니다.", "Just pick a nickname to get started.\nYour profile and history are stored only on this device.", "Solo elige un apodo para empezar.\nTu perfil y tu historial se guardan solo en este dispositivo.", "Choisissez simplement un pseudo pour commencer.\nVotre profil et votre historique restent sur cet appareil.", "Wählen Sie einfach einen Spitznamen.\nProfil und Verlauf werden nur auf diesem Gerät gespeichert."],
    "obNickname": ["닉네임", "Nickname", "Apodo", "Pseudo", "Spitzname"],
    "obNicknameHint": ["2~12자", "2–12 characters", "2–12 caracteres", "2 à 12 caractères", "2–12 Zeichen"],
    "obNicknameError": ["닉네임은 2~12자로 입력해 주세요.", "Please enter a nickname of 2–12 characters.", "Introduce un apodo de 2 a 12 caracteres.", "Saisissez un pseudo de 2 à 12 caractères.", "Bitte einen Spitznamen mit 2–12 Zeichen eingeben."],
    "obAge": ["복권을 구매할 수 있는 나이입니다 (한국 만 19세 이상)", "I am of legal age to play the lottery in my country", "Tengo la edad legal para jugar a la lotería en mi país", "J'ai l'âge légal pour jouer à la loterie dans mon pays", "Ich habe das gesetzliche Mindestalter für Lotterien in meinem Land"],
    "obAgree": ["개인정보처리방침과 면책고지에 동의합니다", "I agree to the Privacy Policy and Disclaimer", "Acepto la Política de privacidad y el Aviso legal", "J'accepte la Politique de confidentialité et l'Avertissement", "Ich stimme der Datenschutzerklärung und dem Haftungsausschluss zu"],
    "obView": ["보기", "View", "Ver", "Voir", "Ansehen"],
    "obStart": ["시작하기", "Get started", "Empezar", "Commencer", "Loslegen"],
    "obNeedChecks": ["필수 항목에 모두 동의해 주세요.", "Please confirm all required items.", "Confirma todos los elementos obligatorios.", "Veuillez confirmer tous les éléments obligatoires.", "Bitte bestätigen Sie alle Pflichtangaben."],

    # ---- 내 기록 ----
    "menuHistory": ["내 기록", "My history", "Mi historial", "Historique", "Verlauf"],
    "historyJoined": ["{date} 가입", "Joined {date}", "Registro: {date}", "Inscrit le {date}", "Dabei seit {date}"],
    "historyStats": ["번호 추출 {count}회", "{count, plural, one{{count} generation} other{{count} generations}}", "{count, plural, one{{count} generación} other{{count} generaciones}}", "{count, plural, one{{count} génération} other{{count} générations}}", "{count}-mal erzeugt"],
    "historyEmpty": ["아직 추출한 기록이 없습니다.\n번호를 추출하면 여기에 저장됩니다.", "No history yet.\nCombinations you generate will appear here.", "Aún no hay historial.\nLas combinaciones que generes aparecerán aquí.", "Aucun historique pour l'instant.\nVos combinaisons générées apparaîtront ici.", "Noch kein Verlauf.\nErzeugte Kombinationen erscheinen hier."],
    "historyTickets": ["{count}개 조합", "{count, plural, one{{count} combination} other{{count} combinations}}", "{count, plural, one{{count} combinación} other{{count} combinaciones}}", "{count, plural, one{{count} combinaison} other{{count} combinaisons}}", "{count, plural, one{{count} Kombination} other{{count} Kombinationen}}"],
    "historyFilters": ["필터 {count}개", "{count, plural, one{{count} filter} other{{count} filters}}", "{count, plural, one{{count} filtro} other{{count} filtros}}", "{count, plural, one{{count} filtre} other{{count} filtres}}", "{count} Filter"],
    "historyClearAll": ["기록 모두 지우기", "Clear all history", "Borrar todo el historial", "Effacer tout l'historique", "Gesamten Verlauf löschen"],
    "historyClearConfirm": ["추출 기록을 모두 지울까요?", "Delete all generation history?", "¿Borrar todo el historial de generación?", "Effacer tout l'historique des générations ?", "Gesamten Verlauf löschen?"],
    "historyDeleted": ["기록을 삭제했습니다.", "Entry deleted.", "Registro eliminado.", "Entrée supprimée.", "Eintrag gelöscht."],
    "delete": ["삭제", "Delete", "Eliminar", "Supprimer", "Löschen"],
    "cancel": ["취소", "Cancel", "Cancelar", "Annuler", "Abbrechen"],
    "confirm": ["확인", "OK", "Aceptar", "OK", "OK"],
    "profileNickname": ["닉네임: {name}", "Nickname: {name}", "Apodo: {name}", "Pseudo : {name}", "Spitzname: {name}"],
    "withdraw": ["탈퇴 (가입 정보·기록 삭제)", "Delete account (profile & history)", "Eliminar cuenta (perfil e historial)", "Supprimer le compte (profil et historique)", "Konto löschen (Profil und Verlauf)"],
    "withdrawConfirm": ["가입 정보와 추출 기록을 이 기기에서 모두 삭제하고 처음 화면으로 돌아갑니다. 계속할까요?", "Your profile and history will be deleted from this device and you'll return to the start screen. Continue?", "Se eliminarán tu perfil y tu historial de este dispositivo y volverás a la pantalla inicial. ¿Continuar?", "Votre profil et votre historique seront supprimés de cet appareil et vous reviendrez à l'écran d'accueil. Continuer ?", "Profil und Verlauf werden von diesem Gerät gelöscht und Sie kehren zum Startbildschirm zurück. Fortfahren?"],

    # ---- 당첨번호 직접 입력 ----
    "manualEntry": ["당첨번호 직접 입력", "Enter results manually", "Introducir resultados", "Saisir les résultats", "Ergebnisse eingeben"],
    "manualHelp": ["자동 갱신이 되지 않을 때 공식 발표를 보고 입력하세요. 나중에 같은 날짜의 공식 데이터가 들어오면 공식 데이터가 우선합니다.", "Use this when automatic updates aren't working, based on the official results. Official data for the same date will replace your entry later.", "Úsalo cuando la actualización automática no funcione, según los resultados oficiales. Los datos oficiales de la misma fecha reemplazarán tu entrada.", "À utiliser si la mise à jour automatique ne fonctionne pas, d'après les résultats officiels. Les données officielles de la même date remplaceront votre saisie.", "Verwenden Sie dies, wenn die automatische Aktualisierung nicht funktioniert – nach den offiziellen Ergebnissen. Offizielle Daten desselben Datums ersetzen Ihren Eintrag später."],
    "manualRound": ["회차", "Draw no.", "N.º de sorteo", "N° de tirage", "Ziehung Nr."],
    "manualDate": ["추첨일", "Draw date", "Fecha del sorteo", "Date du tirage", "Ziehungsdatum"],
    "manualMain": ["당첨번호 {count}개", "{count} winning numbers", "{count} números ganadores", "{count} numéros gagnants", "{count} Gewinnzahlen"],
    "manualBonus": ["{label} {count}개", "{label}: {count}", "{label}: {count}", "{label} : {count}", "{label}: {count}"],
    "manualSave": ["저장", "Save", "Guardar", "Enregistrer", "Speichern"],
    "manualSaved": ["직접 입력한 당첨번호를 저장했습니다.", "Results saved.", "Resultados guardados.", "Résultats enregistrés.", "Ergebnisse gespeichert."],
    "manualList": ["직접 입력한 기록", "Your entries", "Tus entradas", "Vos saisies", "Ihre Einträge"],
    "manualNone": ["직접 입력한 기록이 없습니다.", "No manual entries.", "No hay entradas manuales.", "Aucune saisie manuelle.", "Keine manuellen Einträge."],
    "manualTag": ["직접 입력", "Manual", "Manual", "Manuel", "Manuell"],
    "mErrRound": ["회차를 확인해 주세요.", "Please check the draw number.", "Revisa el número de sorteo.", "Vérifiez le numéro de tirage.", "Bitte Ziehungsnummer prüfen."],
    "mErrMain": ["당첨번호를 {count}개 골라 주세요.", "Please select {count} winning numbers.", "Elige {count} números ganadores.", "Choisissez {count} numéros gagnants.", "Bitte {count} Gewinnzahlen wählen."],
    "mErrBonus": ["{label}: {count}개를 골라 주세요.", "{label}: please select {count}.", "{label}: elige {count}.", "{label} : choisissez-en {count}.", "{label}: bitte {count} wählen."],
    "mErrBonusOverlap": ["보너스 번호는 당첨번호와 겹칠 수 없습니다.", "The bonus number can't be one of the winning numbers.", "El número complementario no puede ser uno de los ganadores.", "Le complémentaire ne peut pas être un des numéros gagnants.", "Die Zusatzzahl darf keine der Gewinnzahlen sein."],
    "mErrDate": ["추첨일을 확인해 주세요. 미래 날짜, 추첨 요일이 아닌 날, 현재 규칙 이전 날짜는 입력할 수 없습니다.", "Please check the date. Future dates, non-draw days and dates before the current rules aren't allowed.", "Revisa la fecha. No se permiten fechas futuras, días sin sorteo ni fechas anteriores a las reglas actuales.", "Vérifiez la date. Les dates futures, les jours sans tirage et les dates antérieures aux règles actuelles ne sont pas acceptés.", "Bitte Datum prüfen. Zukünftige Daten, Tage ohne Ziehung und Daten vor den aktuellen Regeln sind nicht erlaubt."],
    "mErrExists": ["같은 날짜(회차)의 당첨번호가 이미 있습니다.", "Results for this date (draw) already exist.", "Ya existen resultados para esta fecha (sorteo).", "Des résultats existent déjà pour cette date (tirage).", "Für dieses Datum (diese Ziehung) gibt es bereits Ergebnisse."],

    # ---- 광고 ----
    "adPrivacyOptions": ["광고 개인정보 설정", "Ad privacy settings", "Privacidad de anuncios", "Confidentialité des annonces", "Datenschutz für Werbung"],
    "rewardTitle": ["{count}개 추출", "Generate {count} combinations", "Generar {count} combinaciones", "Générer {count} combinaisons", "{count} Kombinationen erzeugen"],
    "rewardBody": ["한 번에 {free}개까지는 바로 추출됩니다.\n짧은 광고를 보면 {count}개를 모두 추출합니다.", "Up to {free} combinations are free.\nWatch a short ad to generate all {count}.", "Hasta {free} combinaciones son gratis.\nMira un anuncio breve para generar las {count}.", "Jusqu'à {free} combinaisons sont gratuites.\nRegardez une courte annonce pour en générer {count}.", "Bis zu {free} Kombinationen sind kostenlos.\nSehen Sie eine kurze Werbung, um alle {count} zu erzeugen."],
    "rewardWatch": ["광고 보고 {count}개", "Watch ad for {count}", "Ver anuncio: {count}", "Annonce : {count}", "Werbung: {count}"],
    "rewardFreeOnly": ["{free}개만 추출", "Just {free}", "Solo {free}", "Seulement {free}", "Nur {free}"],
    "rewardNotEarned": ["광고를 끝까지 보지 않아 {free}개만 추출합니다.", "The ad wasn't finished, so {free} combinations will be generated.", "No se terminó el anuncio; se generarán {free} combinaciones.", "L'annonce n'a pas été terminée : {free} combinaisons seront générées.", "Die Werbung wurde nicht beendet – es werden {free} Kombinationen erzeugt."],

    # ---- 패턴 필터 ----
    "patternFilters": ["패턴 제외 필터", "Pattern filters", "Filtros de patrones", "Filtres de motifs", "Musterfilter"],
    "pastPending": [" (당첨번호 준비 중)", " (results coming soon)", " (resultados próximamente)", " (résultats bientôt)", " (Ergebnisse folgen)"],

    # 한국 6/45 전용 표기 (한국어 화면에서 한국 로또일 때만 사용)
    "fKr1st": ["역대 1등 당첨번호 패턴 제외", "Exclude past jackpot combinations", "Excluir combinaciones ganadoras anteriores", "Exclure les combinaisons gagnantes passées", "Frühere Gewinnkombinationen ausschließen"],
    "hKr1st": ["1회차부터 최근 회차까지 1등 당첨번호와 완전히 동일한 조합을 제외합니다.", "Excludes combinations identical to any past jackpot result.", "Excluye las combinaciones idénticas a cualquier resultado ganador anterior.", "Exclut les combinaisons identiques à un résultat gagnant passé.", "Schließt Kombinationen aus, die einem früheren Gewinnergebnis entsprechen."],
    "fKr23": ["역대 2/3등 당첨번호 패턴 제외", "Exclude 5-number matches with past draws", "Excluir coincidencias de 5 números con sorteos anteriores", "Exclure 5 numéros communs avec un tirage passé", "5 Treffer mit früheren Ziehungen ausschließen"],
    "hKr23": ["과거 1등 당첨번호 6개 중 5개가 동일하게 포함되는 조합을 제외합니다.", "Excludes combinations sharing 5 of the 6 numbers of any past draw.", "Excluye combinaciones que comparten 5 de los 6 números de un sorteo anterior.", "Exclut les combinaisons ayant 5 des 6 numéros d'un tirage passé.", "Schließt Kombinationen aus, die 5 der 6 Zahlen einer früheren Ziehung enthalten."],
    "fKr4th": ["역대 4등 당첨번호 조합 패턴 제외", "Exclude 4-number matches (last 100 draws)", "Excluir coincidencias de 4 números (últimos 100 sorteos)", "Exclure 4 numéros communs (100 derniers tirages)", "4 Treffer ausschließen (letzte 100 Ziehungen)"],
    "hKr4th": ["최근 100회차의 1등 당첨번호에서 만들어지는 4개 번호 조합이 포함된 경우 제외합니다.", "Excludes combinations sharing 4 numbers with any of the last 100 draws.", "Excluye combinaciones que comparten 4 números con alguno de los últimos 100 sorteos.", "Exclut les combinaisons ayant 4 numéros en commun avec l'un des 100 derniers tirages.", "Schließt Kombinationen aus, die 4 Zahlen mit einer der letzten 100 Ziehungen teilen."],
    "fKr5th": ["역대 5등 당첨번호 중 연속 이어진 조합 제외", "Exclude consecutive triples seen in past draws", "Excluir tríos consecutivos de sorteos anteriores", "Exclure les suites de 3 déjà sorties", "Frühere 3er-Folgen ausschließen"],
    "hKr5th": ["과거 당첨번호 안에 포함되었던 3연속 번호 묶음이 포함된 조합을 제외합니다.", "Excludes combinations containing a run of 3 consecutive numbers that appeared in a past draw.", "Excluye combinaciones con 3 números consecutivos que ya salieron en un sorteo anterior.", "Exclut les combinaisons contenant une suite de 3 numéros déjà sortie.", "Schließt Kombinationen mit einer Folge von 3 Zahlen aus, die schon gezogen wurde."],
    "fKrRange": ["10구간 내 올인 제외 (n6-n1 > 9)", "Exclude narrow spreads (max − min ≤ 9)", "Excluir rangos estrechos (máx. − mín. ≤ 9)", "Exclure les écarts étroits (max − min ≤ 9)", "Enge Spannen ausschließen (Max − Min ≤ 9)"],
    "hKrRange": ["가장 낮은 숫자와 가장 높은 숫자의 차이가 9 이하인 좁은 구간 조합을 제외합니다.", "Excludes combinations whose highest and lowest numbers are 9 or less apart.", "Excluye combinaciones cuya diferencia entre el número mayor y el menor es de 9 o menos.", "Exclut les combinaisons dont l'écart entre le plus grand et le plus petit numéro est de 9 ou moins.", "Schließt Kombinationen aus, bei denen höchste und niedrigste Zahl höchstens 9 auseinanderliegen."],

    # 복권 공통 표기
    "fPastFull": ["역대 당첨 메인 번호 {k}개 일치 제외", "Exclude past winning sets ({k} matches)", "Excluir combinaciones ganadoras ({k} aciertos)", "Exclure les combinaisons gagnantes ({k} numéros)", "Gewinnkombinationen ausschließen ({k} Treffer)"],
    "hPastFull": ["현재 규칙이 시작된 뒤 나온 당첨 메인 번호 {k}개와 완전히 같은 조합을 제외합니다.", "Excludes combinations identical to the {k} main numbers of any draw under the current rules.", "Excluye combinaciones idénticas a los {k} números principales de cualquier sorteo con las reglas actuales.", "Exclut les combinaisons identiques aux {k} numéros principaux d'un tirage selon les règles actuelles.", "Schließt Kombinationen aus, die den {k} Hauptzahlen einer Ziehung nach den aktuellen Regeln entsprechen."],
    "fPastMinus1": ["역대 당첨 메인 번호 {m}개 일치 제외", "Exclude {m}-number matches with past draws", "Excluir coincidencias de {m} números con sorteos anteriores", "Exclure {m} numéros communs avec un tirage passé", "{m} Treffer mit früheren Ziehungen ausschließen"],
    "hPastMinus1": ["과거 당첨 메인 번호 {k}개 중 {m}개가 같은 조합을 제외합니다.", "Excludes combinations sharing {m} of the {k} main numbers of any past draw.", "Excluye combinaciones que comparten {m} de los {k} números principales de un sorteo anterior.", "Exclut les combinaisons ayant {m} des {k} numéros principaux d'un tirage passé.", "Schließt Kombinationen aus, die {m} der {k} Hauptzahlen einer früheren Ziehung enthalten."],
    "fPastMinus2": ["최근 {r}회 메인 번호 {m}개 일치 제외", "Exclude {m}-number matches (last {r} draws)", "Excluir coincidencias de {m} números (últimos {r} sorteos)", "Exclure {m} numéros communs ({r} derniers tirages)", "{m} Treffer ausschließen (letzte {r} Ziehungen)"],
    "hPastMinus2": ["최근 {r}회 당첨 메인 번호 중 {m}개가 같은 조합을 제외합니다.", "Excludes combinations sharing {m} main numbers with any of the last {r} draws.", "Excluye combinaciones que comparten {m} números principales con alguno de los últimos {r} sorteos.", "Exclut les combinaisons ayant {m} numéros principaux en commun avec l'un des {r} derniers tirages.", "Schließt Kombinationen aus, die {m} Hauptzahlen mit einer der letzten {r} Ziehungen teilen."],
    "fPastConsec": ["역대 당첨번호의 연속 3개 묶음 제외", "Exclude consecutive triples seen in past draws", "Excluir tríos consecutivos de sorteos anteriores", "Exclure les suites de 3 déjà sorties", "Frühere 3er-Folgen ausschließen"],
    "hPastConsec": ["과거 당첨번호에 들어 있던 연속 3개 번호 묶음(예: 7, 8, 9)이 포함된 조합을 제외합니다.", "Excludes combinations containing a run of 3 consecutive numbers (e.g. 7, 8, 9) that appeared in a past draw.", "Excluye combinaciones con 3 números consecutivos (p. ej., 7, 8, 9) que ya salieron en un sorteo anterior.", "Exclut les combinaisons contenant une suite de 3 numéros (ex. 7, 8, 9) déjà sortie.", "Schließt Kombinationen mit einer Folge von 3 Zahlen (z. B. 7, 8, 9) aus, die schon gezogen wurde."],
    "fNarrow": ["좁은 구간 올인 제외 (최대-최소 ≤ {n})", "Exclude narrow spreads (max − min ≤ {n})", "Excluir rangos estrechos (máx. − mín. ≤ {n})", "Exclure les écarts étroits (max − min ≤ {n})", "Enge Spannen ausschließen (Max − Min ≤ {n})"],
    "hNarrow": ["가장 낮은 숫자와 가장 높은 숫자의 차이가 {n} 이하인 좁은 구간 조합을 제외합니다.", "Excludes combinations whose highest and lowest numbers are {n} or less apart.", "Excluye combinaciones cuya diferencia entre el número mayor y el menor es de {n} o menos.", "Exclut les combinaisons dont l'écart entre le plus grand et le plus petit numéro est de {n} ou moins.", "Schließt Kombinationen aus, bei denen höchste und niedrigste Zahl höchstens {n} auseinanderliegen."],
    "f3Consec": ["연속 이어진 숫자 3개 패턴 제외", "Exclude 3 consecutive numbers", "Excluir 3 números consecutivos", "Exclure 3 numéros consécutifs", "3 aufeinanderfolgende Zahlen ausschließen"],
    "h3Consec": ["1, 2, 3 또는 33, 34, 35처럼 연속 3개의 숫자가 이어지는 경우 제외합니다.", "Excludes combinations with 3 consecutive numbers, such as 1, 2, 3 or 33, 34, 35.", "Excluye combinaciones con 3 números consecutivos, como 1, 2, 3 o 33, 34, 35.", "Exclut les combinaisons avec 3 numéros consécutifs, comme 1, 2, 3 ou 33, 34, 35.", "Schließt Kombinationen mit 3 aufeinanderfolgenden Zahlen aus, z. B. 1, 2, 3 oder 33, 34, 35."],
    "fSkip1": ["1개씩 건너뛴 3자리이상 패턴 제외", "Exclude 3 numbers in steps of 2", "Excluir 3 números de 2 en 2", "Exclure 3 numéros de 2 en 2", "3 Zahlen im Abstand 2 ausschließen"],
    "hSkip1": ["1, 3, 5 또는 15, 17, 19처럼 숫자 차이가 2인 패턴이 3개 연속 포함되는 경우 제외합니다.", "Excludes combinations with 3 numbers spaced by 2, such as 1, 3, 5 or 15, 17, 19.", "Excluye combinaciones con 3 números separados por 2, como 1, 3, 5 o 15, 17, 19.", "Exclut les combinaisons avec 3 numéros espacés de 2, comme 1, 3, 5 ou 15, 17, 19.", "Schließt Kombinationen mit 3 Zahlen im Abstand 2 aus, z. B. 1, 3, 5 oder 15, 17, 19."],
    "fSkip2": ["2개씩 건너뛴 3자리이상 패턴 제외", "Exclude 3 numbers in steps of 3", "Excluir 3 números de 3 en 3", "Exclure 3 numéros de 3 en 3", "3 Zahlen im Abstand 3 ausschließen"],
    "hSkip2": ["1, 4, 7 또는 15, 18, 21처럼 숫자 차이가 3인 패턴이 3개 연속 포함되는 경우 제외합니다.", "Excludes combinations with 3 numbers spaced by 3, such as 1, 4, 7 or 15, 18, 21.", "Excluye combinaciones con 3 números separados por 3, como 1, 4, 7 o 15, 18, 21.", "Exclut les combinaisons avec 3 numéros espacés de 3, comme 1, 4, 7 ou 15, 18, 21.", "Schließt Kombinationen mit 3 Zahlen im Abstand 3 aus, z. B. 1, 4, 7 oder 15, 18, 21."],
    "fSkip3": ["3개씩 건너뛴 3자리이상 패턴 제외", "Exclude 3 numbers in steps of 4", "Excluir 3 números de 4 en 4", "Exclure 3 numéros de 4 en 4", "3 Zahlen im Abstand 4 ausschließen"],
    "hSkip3": ["1, 5, 9 또는 15, 19, 23처럼 숫자 차이가 4인 패턴이 3개 연속 포함되는 경우 제외합니다.", "Excludes combinations with 3 numbers spaced by 4, such as 1, 5, 9 or 15, 19, 23.", "Excluye combinaciones con 3 números separados por 4, como 1, 5, 9 o 15, 19, 23.", "Exclut les combinaisons avec 3 numéros espacés de 4, comme 1, 5, 9 ou 15, 19, 23.", "Schließt Kombinationen mit 3 Zahlen im Abstand 4 aus, z. B. 1, 5, 9 oder 15, 19, 23."],
    "f2Pairs": ["2쌍 이상의 연속 번호 패턴 제외", "Exclude 2+ consecutive pairs", "Excluir 2 o más parejas consecutivas", "Exclure 2 paires consécutives ou plus", "2+ aufeinanderfolgende Paare ausschließen"],
    "h2Pairs": ["1, 2와 15, 16처럼 연속된 번호 쌍이 2개 이상 포함되는 경우 제외합니다.", "Excludes combinations with two or more consecutive pairs, such as 1, 2 and 15, 16.", "Excluye combinaciones con dos o más parejas consecutivas, como 1, 2 y 15, 16.", "Exclut les combinaisons avec au moins deux paires consécutives, comme 1, 2 et 15, 16.", "Schließt Kombinationen mit zwei oder mehr aufeinanderfolgenden Paaren aus, z. B. 1, 2 und 15, 16."],
    "fAllOdd": ["'홀수' {k}개로 구성된 패턴 제외", "Exclude all odd ({k} odd numbers)", "Excluir todos impares ({k} impares)", "Exclure tout impair ({k} impairs)", "Nur ungerade ausschließen ({k} ungerade)"],
    "hAllOdd": ["{k}개의 숫자가 모두 홀수인 경우 제외합니다.", "Excludes combinations where all {k} numbers are odd.", "Excluye combinaciones en las que los {k} números son impares.", "Exclut les combinaisons dont les {k} numéros sont impairs.", "Schließt Kombinationen aus, bei denen alle {k} Zahlen ungerade sind."],
    "fAllEven": ["'짝수' {k}개로 구성된 패턴 제외", "Exclude all even ({k} even numbers)", "Excluir todos pares ({k} pares)", "Exclure tout pair ({k} pairs)", "Nur gerade ausschließen ({k} gerade)"],
    "hAllEven": ["{k}개의 숫자가 모두 짝수인 경우 제외합니다.", "Excludes combinations where all {k} numbers are even.", "Excluye combinaciones en las que los {k} números son pares.", "Exclut les combinaisons dont les {k} numéros sont pairs.", "Schließt Kombinationen aus, bei denen alle {k} Zahlen gerade sind."],
    "fOE1": ["'홀짝홀짝홀짝', '짝홀짝홀짝홀' 패턴 제외", "Exclude O-E-O-E-O-E / E-O-E-O-E-O", "Excluir I-P-I-P-I-P / P-I-P-I-P-I", "Exclure I-P-I-P-I-P / P-I-P-I-P-I", "U-G-U-G-U-G / G-U-G-U-G-U ausschließen"],
    "fOE2": ["'짝짝홀홀짝짝', '홀홀짝짝홀홀' 패턴 제외", "Exclude E-E-O-O-E-E / O-O-E-E-O-O", "Excluir P-P-I-I-P-P / I-I-P-P-I-I", "Exclure P-P-I-I-P-P / I-I-P-P-I-I", "G-G-U-U-G-G / U-U-G-G-U-U ausschließen"],
    "fOE3": ["'짝짝짝짝짝홀', '홀홀홀홀홀짝' 패턴 제외", "Exclude E-E-E-E-E-O / O-O-O-O-O-E", "Excluir P-P-P-P-P-I / I-I-I-I-I-P", "Exclure P-P-P-P-P-I / I-I-I-I-I-P", "G-G-G-G-G-U / U-U-U-U-U-G ausschließen"],
    "fOE4": ["'짝짝짝짝홀홀', '홀홀홀홀짝짝' 패턴 제외", "Exclude E-E-E-E-O-O / O-O-O-O-E-E", "Excluir P-P-P-P-I-I / I-I-I-I-P-P", "Exclure P-P-P-P-I-I / I-I-I-I-P-P", "G-G-G-G-U-U / U-U-U-U-G-G ausschließen"],
    "fOE5": ["'짝짝짝홀홀홀', '홀홀홀짝짝짝' 패턴 제외", "Exclude E-E-E-O-O-O / O-O-O-E-E-E", "Excluir P-P-P-I-I-I / I-I-I-P-P-P", "Exclure P-P-P-I-I-I / I-I-I-P-P-P", "G-G-G-U-U-U / U-U-U-G-G-G ausschließen"],
    "hOE": ["정렬된 6개 숫자의 홀짝 순서가 {pattern}인 경우 제외합니다.", "Excludes combinations whose 6 sorted numbers follow the odd(O)/even(E) order {pattern}.", "Excluye combinaciones cuyos 6 números ordenados siguen el orden impar(I)/par(P) {pattern}.", "Exclut les combinaisons dont les 6 numéros triés suivent l'ordre impair(I)/pair(P) {pattern}.", "Schließt Kombinationen aus, deren 6 sortierte Zahlen der Folge ungerade(U)/gerade(G) {pattern} folgen."],
    "fSameDigit": ["같은 끝수 3개 이상 제외", "Exclude 3+ numbers with the same last digit", "Excluir 3+ números con la misma terminación", "Exclure 3+ numéros finissant par le même chiffre", "3+ Zahlen mit gleicher Endziffer ausschließen"],
    "hSameDigit": ["1, 11, 21, 31처럼 같은 끝수를 가진 숫자가 3개 이상 포함된 조합을 제외합니다.", "Excludes combinations with 3 or more numbers ending in the same digit, such as 1, 11, 21, 31.", "Excluye combinaciones con 3 o más números que terminan en la misma cifra, como 1, 11, 21, 31.", "Exclut les combinaisons avec au moins 3 numéros se terminant par le même chiffre, comme 1, 11, 21, 31.", "Schließt Kombinationen mit 3 oder mehr Zahlen mit gleicher Endziffer aus, z. B. 1, 11, 21, 31."],
    "fTripleMult": ["3연속 배수 조합 패턴 제외", "Exclude 3 consecutive multiples", "Excluir 3 múltiplos consecutivos", "Exclure 3 multiples consécutifs", "3 aufeinanderfolgende Vielfache ausschließen"],
    "hTripleMult": ["2, 4, 6 또는 4, 8, 12처럼 같은 기준수의 3연속 배수가 포함된 조합을 제외합니다.", "Excludes combinations containing 3 consecutive multiples of the same number, such as 2, 4, 6 or 4, 8, 12.", "Excluye combinaciones con 3 múltiplos consecutivos del mismo número, como 2, 4, 6 o 4, 8, 12.", "Exclut les combinaisons contenant 3 multiples consécutifs d'un même nombre, comme 2, 4, 6 ou 4, 8, 12.", "Schließt Kombinationen mit 3 aufeinanderfolgenden Vielfachen derselben Zahl aus, z. B. 2, 4, 6 oder 4, 8, 12."],

    # ---- 추첨일 알림 ----
    "alarmIntro": ["켜 둔 복권은 추첨 3시간 전에 휴대폰 알림을 보내 드립니다.", "You'll get a phone notification 3 hours before each draw of the lotteries you turn on.", "Recibirás una notificación 3 horas antes de cada sorteo de las loterías que actives.", "Vous recevrez une notification 3 heures avant chaque tirage des loteries activées.", "Sie erhalten 3 Stunden vor jeder Ziehung der aktivierten Lotterien eine Benachrichtigung."],
    "alarmDrawAt": ["추첨 {days} {time} (현지 시각)", "Draws {days} {time} (local time)", "Sorteos {days} {time} (hora local)", "Tirages {days} {time} (heure locale)", "Ziehung {days} {time} (Ortszeit)"],
    "alarmUnsupported": ["이 기기에서는 알림을 지원하지 않습니다. 휴대폰 앱에서 이용해 주세요.", "Notifications aren't supported on this device. Please use the phone app.", "Las notificaciones no son compatibles con este dispositivo. Usa la app del móvil.", "Les notifications ne sont pas prises en charge sur cet appareil. Utilisez l'app mobile.", "Benachrichtigungen werden auf diesem Gerät nicht unterstützt. Bitte nutzen Sie die Handy-App."],
    "alarmDenied": ["알림 권한이 꺼져 있습니다. 휴대폰 설정에서 이 앱의 알림을 허용해 주세요.", "Notifications are turned off. Please allow notifications for this app in your phone settings.", "Las notificaciones están desactivadas. Permítelas para esta app en los ajustes del móvil.", "Les notifications sont désactivées. Autorisez-les pour cette app dans les réglages du téléphone.", "Benachrichtigungen sind deaktiviert. Bitte erlauben Sie sie für diese App in den Handy-Einstellungen."],
    "alarmOn": ["{game} 추첨 3시간 전에 알려 드릴게요.", "We'll remind you 3 hours before each {game} draw.", "Te avisaremos 3 horas antes de cada sorteo de {game}.", "Nous vous préviendrons 3 heures avant chaque tirage {game}.", "Wir erinnern Sie 3 Stunden vor jeder Ziehung von {game}."],
    "alarmOff": ["{game} 알림을 껐습니다.", "{game} reminders turned off.", "Avisos de {game} desactivados.", "Rappels {game} désactivés.", "Erinnerungen für {game} deaktiviert."],
    "notifyTitle": ["오늘 {game} 추첨일!", "{game} draw today!", "¡Hoy hay sorteo de {game}!", "Tirage {game} aujourd'hui !", "Heute {game}-Ziehung!"],
    "notifyBody": ["3시간 뒤 추첨이 있습니다. 로또대장에서 번호를 만들어 보세요.", "The draw is in 3 hours. Generate your numbers in Lotto Leader.", "El sorteo es en 3 horas. Genera tus números en Lotto Leader.", "Le tirage a lieu dans 3 heures. Générez vos numéros dans Lotto Leader.", "Die Ziehung ist in 3 Stunden. Erzeugen Sie Ihre Zahlen in Lotto Leader."],
    "notifyChannel": ["추첨일 알림", "Draw reminders", "Avisos de sorteo", "Rappels de tirage", "Ziehungserinnerungen"],

    # ---- 당첨 확인 ----
    "winPending": ["추첨 대기 중", "Awaiting draw", "Pendiente de sorteo", "En attente du tirage", "Ziehung ausstehend"],
    "winDrawOf": ["{date} 추첨 결과와 비교", "Compared with the {date} draw", "Comparado con el sorteo del {date}", "Comparé au tirage du {date}", "Verglichen mit der Ziehung vom {date}"],
    "winRank": ["{rank}등", "Tier {rank}", "Categoría {rank}", "Rang {rank}", "Gewinnklasse {rank}"],
    "winBest": ["최고 {rank}", "Best: {rank}", "Mejor: {rank}", "Meilleur : {rank}", "Beste: {rank}"],
    "winNone": ["낙첨", "No win", "Sin premio", "Non gagnant", "Kein Gewinn"],
    "winMatch": ["{main}개 일치", "{main} matched", "{main} aciertos", "{main} bons numéros", "{main} Richtige"],
    "winMatchPlus": ["{main}+{bonus} 일치", "{main}+{bonus} matched", "{main}+{bonus} aciertos", "{main}+{bonus} bons numéros", "{main}+{bonus} Richtige"],
    "winMatchBonus": ["{main}개 + 보너스 일치", "{main} + bonus matched", "{main} aciertos + complementario", "{main} bons numéros + complémentaire", "{main} Richtige + Zusatzzahl"],
    "winPendingHint": ["추첨 결과가 들어오면 자동으로 비교합니다. 결과가 늦으면 설정 → 당첨번호 직접 입력을 이용하세요.", "Results are compared automatically once the draw is in. If it's late, use Settings → Enter results manually.", "Se compara automáticamente cuando llega el resultado. Si se retrasa, usa Ajustes → Introducir resultados.", "La comparaison se fait automatiquement dès que le résultat arrive. En cas de retard, utilisez Réglages → Saisir les résultats.", "Der Vergleich erfolgt automatisch, sobald das Ergebnis vorliegt. Bei Verzögerung: Einstellungen → Ergebnisse eingeben."],

    # ---- 번호 통계 ----
    "statsTitle": ["번호 통계", "Number stats", "Estadísticas", "Statistiques", "Statistik"],
    "statsRecent": ["최근 {n}회", "Last {n}", "Últimos {n}", "{n} derniers", "Letzte {n}"],
    "statsAll": ["전체", "All", "Todos", "Tous", "Alle"],
    "statsMain": ["당첨번호", "Main numbers", "Números", "Numéros", "Zahlen"],
    "statsSortNumber": ["번호순", "By number", "Por número", "Par numéro", "Nach Zahl"],
    "statsSortMost": ["많이 나온 순", "Most drawn", "Más salidos", "Plus sortis", "Am häufigsten"],
    "statsSortLeast": ["적게 나온 순", "Least drawn", "Menos salidos", "Moins sortis", "Am seltensten"],
    "statsSortGap": ["오래 안 나온 순", "Longest absent", "Más tiempo sin salir", "Absents depuis longtemps", "Am längsten nicht gezogen"],
    "statsAnalyzed": ["최근 {n}회 추첨 기준", "{n, plural, one{Based on the last draw} other{Based on the last {n} draws}}", "{n, plural, one{Según el último sorteo} other{Según los últimos {n} sorteos}}", "{n, plural, one{Sur le dernier tirage} other{Sur les {n} derniers tirages}}", "{n, plural, one{Basierend auf der letzten Ziehung} other{Basierend auf den letzten {n} Ziehungen}}"],
    "statsHot": ["자주 나온 번호", "Hot numbers", "Más frecuentes", "Numéros chauds", "Heiße Zahlen"],
    "statsCold": ["오래 안 나온 번호", "Cold numbers", "Números fríos", "Numéros froids", "Kalte Zahlen"],
    "statsCount": ["{n}회", "{n}×", "{n}×", "{n}×", "{n}×"],
    "statsGap": ["{n}회 전", "{n, plural, one{{n} draw ago} other{{n} draws ago}}", "{n, plural, one{hace {n} sorteo} other{hace {n} sorteos}}", "{n, plural, one{il y a {n} tirage} other{il y a {n} tirages}}", "{n, plural, one{vor {n} Ziehung} other{vor {n} Ziehungen}}"],
    "statsGapLatest": ["지난 추첨", "Last draw", "Último sorteo", "Dernier tirage", "Letzte Ziehung"],
    "statsGapNever": ["기간 내 없음", "Not drawn", "Sin salir", "Jamais sorti", "Nicht gezogen"],
    "statsOddEven": ["홀수·짝수 비율", "Odd / even split", "Reparto pares / impares", "Répartition pairs / impairs", "Verteilung gerade / ungerade"],
    "statsOddLabel": ["홀 {odd} : 짝 {even}", "{odd} odd : {even} even", "{odd} impares : {even} pares", "{odd} impairs : {even} pairs", "{odd} ungerade : {even} gerade"],
    "statsDisclaimer": ["지난 추첨 기록일 뿐이며 다음 추첨 결과를 예측하지 않습니다.", "These are past results only and don't predict future draws.", "Son solo resultados pasados y no predicen sorteos futuros.", "Ce sont uniquement des résultats passés, qui ne prédisent pas les tirages futurs.", "Dies sind nur vergangene Ergebnisse und sagen keine künftigen Ziehungen voraus."],

    # ---- 백업·복원 ----
    "backupExport": ["기록 백업하기", "Back up history", "Hacer copia de seguridad", "Sauvegarder l'historique", "Verlauf sichern"],
    "backupImport": ["백업 불러오기", "Restore from backup", "Restaurar copia", "Restaurer une sauvegarde", "Sicherung wiederherstellen"],
    "backupShareText": ["로또대장 기록 백업 파일입니다. 새 휴대폰의 설정 → 백업 불러오기에서 이 파일을 고르세요.", "Lotto Leader backup file. On your new phone, open Settings → Restore from backup and choose this file.", "Copia de seguridad de Lotto Leader. En tu nuevo móvil, abre Ajustes → Restaurar copia y elige este archivo.", "Sauvegarde Lotto Leader. Sur votre nouveau téléphone, ouvrez Réglages → Restaurer une sauvegarde et choisissez ce fichier.", "Lotto Leader-Sicherung. Öffnen Sie auf dem neuen Handy Einstellungen → Sicherung wiederherstellen und wählen Sie diese Datei."],
    "backupEmpty": ["백업할 기록이 아직 없습니다.", "There's nothing to back up yet.", "Aún no hay nada que copiar.", "Rien à sauvegarder pour l'instant.", "Noch nichts zu sichern."],
    "backupFailed": ["백업 파일을 만들지 못했습니다. 잠시 후 다시 시도해 주세요.", "Couldn't create the backup file. Please try again later.", "No se pudo crear la copia. Inténtalo más tarde.", "Impossible de créer la sauvegarde. Réessayez plus tard.", "Sicherung konnte nicht erstellt werden. Bitte später erneut versuchen."],
    "backupImportConfirm": ["백업 파일의 기록을 지금 기기의 기록과 합칩니다. 닉네임과 가입일은 백업 파일 기준으로 바뀝니다. 계속할까요?", "The backup will be merged with the history on this device. Your nickname and sign-up date will be taken from the backup. Continue?", "La copia se combinará con el historial de este dispositivo. El apodo y la fecha de registro se tomarán de la copia. ¿Continuar?", "La sauvegarde sera fusionnée avec l'historique de cet appareil. Le pseudo et la date d'inscription seront repris de la sauvegarde. Continuer ?", "Die Sicherung wird mit dem Verlauf auf diesem Gerät zusammengeführt. Spitzname und Anmeldedatum werden aus der Sicherung übernommen. Fortfahren?"],
    "backupImportDone": ["불러오기 완료: 추출 기록 {history}건, 직접 입력 당첨번호 {manual}건을 추가했습니다.", "Restore complete. Added: history {history} · manual results {manual}", "Restauración completa. Añadido: historial {history} · resultados manuales {manual}", "Restauration terminée. Ajouté : historique {history} · résultats saisis {manual}", "Wiederherstellung abgeschlossen. Hinzugefügt: Verlauf {history} · manuelle Ergebnisse {manual}"],
    "backupInvalid": ["로또대장 백업 파일이 아니거나 파일이 손상되었습니다.", "This isn't a Lotto Leader backup file, or the file is damaged.", "No es una copia de Lotto Leader o el archivo está dañado.", "Ce n'est pas une sauvegarde Lotto Leader ou le fichier est endommagé.", "Keine Lotto Leader-Sicherung oder die Datei ist beschädigt."],
    "backupTooLarge": ["파일이 너무 큽니다. 로또대장 백업 파일을 골라 주세요.", "The file is too large. Please choose a Lotto Leader backup file.", "El archivo es demasiado grande. Elige una copia de Lotto Leader.", "Le fichier est trop volumineux. Choisissez une sauvegarde Lotto Leader.", "Die Datei ist zu groß. Bitte wählen Sie eine Lotto Leader-Sicherung."],
    "continueButton": ["계속", "Continue", "Continuar", "Continuer", "Fortfahren"],
    "colon": [": ", ": ", ": ", " : ", ": "],

    # ---- 해외 복권용 추가 필터 ----
    "fSum": ["번호 합계 {lo}~{hi} 밖 제외", "Exclude sums outside {lo}–{hi}", "Excluir sumas fuera de {lo}–{hi}", "Exclure les sommes hors {lo}–{hi}", "Summen außerhalb {lo}–{hi} ausschließen"],
    "hSum": ["메인 번호를 모두 더한 값이 {lo}보다 작거나 {hi}보다 큰 조합을 제외합니다. 전체 조합의 약 95%가 이 범위 안에 있습니다.", "Excludes combinations whose main numbers add up to less than {lo} or more than {hi}. About 95% of all combinations fall within this range.", "Excluye combinaciones cuyos números principales suman menos de {lo} o más de {hi}. Alrededor del 95% de las combinaciones está en este rango.", "Exclut les combinaisons dont la somme des numéros principaux est inférieure à {lo} ou supérieure à {hi}. Environ 95 % des combinaisons se trouvent dans cette plage.", "Schließt Kombinationen aus, deren Hauptzahlen zusammen weniger als {lo} oder mehr als {hi} ergeben. Etwa 95 % aller Kombinationen liegen in diesem Bereich."],
    "fBirthday": ["모두 31 이하인 조합 제외 (생일 번호)", "Exclude all-31-or-lower sets (birthday numbers)", "Excluir combinaciones solo hasta 31 (fechas)", "Exclure les combinaisons ≤ 31 (dates)", "Nur Zahlen bis 31 ausschließen (Geburtstage)"],
    "hBirthday": ["1~31(날짜에 쓰이는 숫자)로만 된 조합을 제외합니다. 생일로 번호를 고르는 사람이 많아, 1등이 되더라도 당첨금을 여러 명이 나눌 가능성이 높은 조합입니다. 당첨 확률 자체는 다른 조합과 같습니다.", "Excludes combinations made only of 1–31 (numbers used in dates). Many people pick birthdays, so a jackpot on these numbers is more likely to be shared. The chance of winning is the same as any other combination.", "Excluye combinaciones formadas solo por 1–31 (números de fechas). Mucha gente elige cumpleaños, así que un bote con estos números tiene más probabilidades de repartirse. La probabilidad de ganar es la misma que con cualquier otra combinación.", "Exclut les combinaisons composées uniquement de 1 à 31 (numéros de dates). Beaucoup de joueurs choisissent des anniversaires : un jackpot sur ces numéros a plus de chances d'être partagé. La probabilité de gagner reste la même que pour toute autre combinaison.", "Schließt Kombinationen nur aus 1–31 (Zahlen aus Datumsangaben) aus. Viele tippen Geburtstage, daher wird ein Jackpot mit diesen Zahlen eher geteilt. Die Gewinnchance ist dieselbe wie bei jeder anderen Kombination."],
    "fLowHigh": ["전부 낮은 번호 또는 전부 높은 번호 제외", "Exclude all-low or all-high sets", "Excluir todos bajos o todos altos", "Exclure tout bas ou tout haut", "Nur niedrige oder nur hohe Zahlen ausschließen"],
    "hLowHigh": ["모든 번호가 1~{half} 안에 있거나, 모두 {next}~{max} 안에 있는 조합을 제외합니다.", "Excludes combinations whose numbers are all within 1–{half}, or all within {next}–{max}.", "Excluye combinaciones con todos los números entre 1 y {half}, o todos entre {next} y {max}.", "Exclut les combinaisons dont tous les numéros sont entre 1 et {half}, ou tous entre {next} et {max}.", "Schließt Kombinationen aus, deren Zahlen alle zwischen 1 und {half} oder alle zwischen {next} und {max} liegen."],
    "fDecade4": ["같은 10번대 4개 이상 제외", "Exclude 4+ numbers in the same decade", "Excluir 4+ números en la misma decena", "Exclure 4+ numéros dans la même dizaine", "4+ Zahlen im selben Zehnerbereich ausschließen"],
    "hDecade4": ["41, 43, 45, 48처럼 같은 10번대(1~9, 10~19, 20~29 …)에 번호가 4개 이상 몰린 조합을 제외합니다.", "Excludes combinations with 4 or more numbers in the same group of ten (1–9, 10–19, 20–29 …), such as 41, 43, 45, 48.", "Excluye combinaciones con 4 o más números en la misma decena (1–9, 10–19, 20–29 …), como 41, 43, 45, 48.", "Exclut les combinaisons ayant au moins 4 numéros dans la même dizaine (1–9, 10–19, 20–29 …), comme 41, 43, 45, 48.", "Schließt Kombinationen mit 4 oder mehr Zahlen im selben Zehnerbereich (1–9, 10–19, 20–29 …) aus, z. B. 41, 43, 45, 48."],
    "fRepeatLast": ["직전 회차 번호 2개 이상 포함 제외", "Exclude 2+ numbers from the last draw", "Excluir 2+ números del último sorteo", "Exclure 2+ numéros du dernier tirage", "2+ Zahlen der letzten Ziehung ausschließen"],
    "hRepeatLast": ["바로 전 추첨의 메인 번호가 2개 이상 다시 들어간 조합을 제외합니다.", "Excludes combinations that repeat 2 or more main numbers from the most recent draw.", "Excluye combinaciones que repiten 2 o más números principales del último sorteo.", "Exclut les combinaisons qui reprennent au moins 2 numéros principaux du dernier tirage.", "Schließt Kombinationen aus, die 2 oder mehr Hauptzahlen der letzten Ziehung wiederholen."],
    "fBonusRecent": ["최근 {n}회 나온 {label} 제외", "Exclude {label} from the last {n} draws", "Excluir {label} de los últimos {n} sorteos", "Exclure les {label} des {n} derniers tirages", "{label} der letzten {n} Ziehungen ausschließen"],
    "hBonusRecent": ["최근 {n}회 추첨에 나온 {label} 번호는 고르지 않습니다.", "{label} numbers drawn in the last {n} draws won't be picked.", "No se elegirán números de {label} salidos en los últimos {n} sorteos.", "Les numéros {label} tirés lors des {n} derniers tirages ne seront pas choisis.", "{label}-Zahlen aus den letzten {n} Ziehungen werden nicht gewählt."],
    "fBonusPairRecent": ["최근 {n}회 나온 {label} 두 개 조합 제외", "Exclude {label} pairs from the last {n} draws", "Excluir parejas de {label} de los últimos {n} sorteos", "Exclure les paires {label} des {n} derniers tirages", "{label}-Paare der letzten {n} Ziehungen ausschließen"],
    "hBonusPairRecent": ["최근 {n}회 추첨과 똑같은 {label} 두 개 조합은 고르지 않습니다.", "A {label} pair identical to one of the last {n} draws won't be picked.", "No se elegirá una pareja de {label} igual a la de alguno de los últimos {n} sorteos.", "Une paire {label} identique à l'un des {n} derniers tirages ne sera pas choisie.", "Ein {label}-Paar, das einer der letzten {n} Ziehungen entspricht, wird nicht gewählt."],
    "fBonusConsec": ["{label} 연속 번호 제외 (예: 3·4)", "Exclude consecutive {label} (e.g. 3·4)", "Excluir {label} consecutivos (p. ej., 3·4)", "Exclure les {label} consécutifs (ex. 3·4)", "Aufeinanderfolgende {label} ausschließen (z. B. 3·4)"],
    "hBonusConsec": ["{label} 두 개가 3·4처럼 이어진 번호인 조합은 고르지 않습니다.", "{label} pairs of consecutive numbers, such as 3·4, won't be picked.", "No se elegirán {label} consecutivos, como 3·4.", "Les {label} consécutifs, comme 3·4, ne seront pas choisis.", "Aufeinanderfolgende {label} wie 3·4 werden nicht gewählt."],
    "fBonusParity": ["{label} 둘 다 홀수 또는 둘 다 짝수 제외", "Exclude {label} both odd or both even", "Excluir {label} ambos impares o ambos pares", "Exclure les {label} tous deux pairs ou impairs", "{label} beide gerade oder beide ungerade ausschließen"],
    "hBonusParity": ["{label} 두 개가 모두 홀수이거나 모두 짝수인 조합은 고르지 않습니다.", "{label} pairs that are both odd or both even won't be picked.", "No se elegirán {label} que sean ambos impares o ambos pares.", "Les {label} tous deux impairs ou tous deux pairs ne seront pas choisis.", "{label}, die beide ungerade oder beide gerade sind, werden nicht gewählt."],
    "filtersOverseas": ["해외 복권 추가 필터", "Extra filters for this lottery", "Filtros adicionales de esta lotería", "Filtres supplémentaires de cette loterie", "Zusätzliche Filter dieser Lotterie"],
    "filtersBonus": ["{label} 필터", "{label} filters", "Filtros de {label}", "Filtres {label}", "{label}-Filter"],
}


def _load_ja_vi():
    """tool/l10n_ja_vi.py (python -I 로 실행해도 읽히도록 경로로 불러옴)"""
    import importlib.util
    path = Path(__file__).resolve().parent / "l10n_ja_vi.py"
    spec = importlib.util.spec_from_file_location("l10n_ja_vi", path)
    mod = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(mod)
    return mod.JA_VI


def _rows():
    extra = _load_ja_vi()
    missing = sorted(set(T) - set(extra))
    unknown = sorted(set(extra) - set(T))
    assert not missing, ("ja/vi 번역 없음", missing)
    assert not unknown, ("ja/vi 에만 있는 키", unknown)
    rows = {}
    for key, values in T.items():
        assert len(values) == len(BASE_LANGS), key
        rows[key] = list(values) + list(extra[key])
    return rows


def main():
    out_dir = Path(__file__).resolve().parent.parent / "lib" / "l10n"
    out_dir.mkdir(parents=True, exist_ok=True)
    for i, lang in enumerate(LANGS):
        arb = {"@@locale": lang}
        for key, values in _rows().items():
            assert len(values) == len(LANGS), key
            text = values[i]
            arb[key] = text
            # 자리표시자는 템플릿(en)에만 메타데이터로 선언.
            # 순서 = 한국어 원문에 처음 나오는 순서 → 생성되는 Dart 함수의 인자 순서가 됩니다.
            ordered = list(dict.fromkeys(re.findall(r"\{(\w+)\}", values[0])))
            others = set(re.findall(r"\{(\w+)\}", text))
            assert set(ordered) == others, (key, lang, ordered, others)
            if lang == "en" and ordered:
                kind = "int" if key in PLURAL_KEYS else "String"
                arb["@" + key] = {"placeholders": {n: {"type": kind} for n in ordered}}
        path = out_dir / f"app_{lang}.arb"
        path.write_text(json.dumps(arb, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
        print(f"{path.name}: {len(T)} keys")


if __name__ == "__main__":
    main()
