// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'Lotto Leader';

  @override
  String get close => 'Cerrar';

  @override
  String get apply => 'Aplicar';

  @override
  String get lookup => 'Ver';

  @override
  String get calculating => 'Calculando…';

  @override
  String get extracting => 'Generando…';

  @override
  String get extractButton => 'Generar';

  @override
  String get countHint => 'Cant.';

  @override
  String get remainingCombos => 'Combinaciones restantes';

  @override
  String get menuResults => 'Resultados';

  @override
  String get menuReset => 'Reiniciar';

  @override
  String get menuAlarm => 'Alertas';

  @override
  String get menuSettings => 'Ajustes';

  @override
  String get privacyPolicy => 'Política de privacidad';

  @override
  String get disclaimer => 'Aviso legal';

  @override
  String get contact => 'Contacto';

  @override
  String get versionLabel => 'Versión';

  @override
  String currentVersion(String version) {
    return 'Versión actual de la app $version';
  }

  @override
  String get language => 'Idioma';

  @override
  String get languageSystem => 'Idioma del dispositivo';

  @override
  String drawAlarm(String game) {
    return 'Aviso del día de sorteo de $game';
  }

  @override
  String get resetDone => 'Se restablecieron los valores iniciales.';

  @override
  String get privacyText =>
      'Esta app es gratuita. Al iniciarla por primera vez creas un perfil sencillo solo con un apodo. Tu apodo y tu historial se guardan solo en este dispositivo, nunca se envían al responsable y puedes borrarlos en Ajustes → Eliminar cuenta.\n\nLa app no recopila por sí misma datos personales que te identifiquen, como tu nombre, teléfono o correo electrónico.\n\nLa app usa Google AdMob para mostrar anuncios. En ese proceso, Google puede recopilar el ID de publicidad, información del dispositivo y datos de uso de la app. Donde se requiere consentimiento (p. ej., en el EEE y el Reino Unido), se te pregunta en el primer inicio y puedes cambiar tu elección en Ajustes → Privacidad de anuncios.\n\nEsta información puede utilizarse para mostrar anuncios, mejorar la calidad de la app y prevenir usos fraudulentos.';

  @override
  String get disclaimerText =>
      'Esta app es una herramienta que ofrece estadísticas de números ganadores anteriores y ayuda a crear combinaciones.\n\nEn todas las loterías, cada combinación tiene exactamente la misma probabilidad de ganar el premio mayor (p. ej., 1 entre 8.145.060 en la Lotto 6/45 de Corea y 1 entre 292.201.338 en Powerball). Los filtros y estadísticas de esta app no aumentan tus probabilidades. Úsalos solo como entretenimiento y referencia.\n\nEsta es una app independiente y no está afiliada a ningún operador de lotería (incluidos Dong-hang Lottery, Powerball, Mega Millions, Lotto 6/49, EuroMillones, Eurojackpot, Loto 6, Irish Lotto o Vietlott).\n\nLa app no garantiza ningún premio. Eres el único responsable de comprar y jugar a la lotería.\n\nLa app no vende boletos ni ofrece apuestas, recompensas en efectivo ni servicios de juego.';

  @override
  String get contactText =>
      'Si tienes dudas, encuentras un error o quieres hacer una sugerencia, escríbenos.\n\nResponsable: 한지성\nCorreo: jnhteamsoft@gmail.com\n\nSolemos responder en un plazo de 3 días hábiles.';

  @override
  String get chooseLottery => 'Elegir lotería';

  @override
  String gameRule(String count, String max) {
    return '$count números (1–$max)';
  }

  @override
  String gameRuleBonus(String label, String count, String max) {
    return ' + $count $label (1–$max)';
  }

  @override
  String jackpotOdds(String odds) {
    return 'Probabilidad del bote: 1 entre $odds';
  }

  @override
  String drawCount(String count) {
    return '$count sorteos';
  }

  @override
  String get drawsPending => 'Resultados próximamente';

  @override
  String get drawRoundPrefix => 'Sorteo n.º ';

  @override
  String get drawRoundSuffix => '';

  @override
  String get drawResultPrefix => 'Resultados de ';

  @override
  String get drawResultSuffix => '';

  @override
  String drawDate(String date) {
    return 'Sorteo del $date';
  }

  @override
  String get noDrawDate => 'Fecha del sorteo desconocida';

  @override
  String get noResultsStored =>
      'Aún no hay resultados.\n(Los resultados de esta lotería llegarán pronto).';

  @override
  String get dbLoading =>
      'Cargando resultados. Inténtalo de nuevo en un momento.';

  @override
  String get dbLoadingShort => 'Cargando resultados…';

  @override
  String get dbLoadFailed => 'No se pudieron cargar los resultados.';

  @override
  String get freqPrefix => 'Últimos [';

  @override
  String get freqSuffix => '] sorteos: más | menos salidos';

  @override
  String get freqHint => 'todos';

  @override
  String get mostDrawn => 'Más salidos';

  @override
  String get leastDrawn => 'Menos salidos';

  @override
  String get noDrawData => 'Aún no hay resultados para esta lotería.';

  @override
  String get recentTooLarge => 'Hay menos sorteos guardados; se usan todos.';

  @override
  String get freqError => 'No se pudieron calcular las frecuencias.';

  @override
  String includeExcludeHeader(String maxInc) {
    return 'Incluir (máx. $maxInc) | Excluir (máx. 18)';
  }

  @override
  String get includeRow => 'Incluir';

  @override
  String get excludeRow => 'Excluir';

  @override
  String get includeBonusRow => 'Incluir';

  @override
  String get excludeBonusRow => 'Excluir';

  @override
  String bonusHeader(String label, String max, String inc, String exc) {
    return '$label (1–$max, incluir hasta $inc · excluir hasta $exc)';
  }

  @override
  String get numbersWord => 'números';

  @override
  String pickerInclude(String kind) {
    return 'Incluir $kind';
  }

  @override
  String pickerExclude(String kind) {
    return 'Excluir $kind';
  }

  @override
  String pickerConflict(String number) {
    return '$number ya está en la otra lista.';
  }

  @override
  String pickerMax(String max) {
    return 'Puedes elegir hasta $max.';
  }

  @override
  String get includeLabel => 'Números incluidos';

  @override
  String get excludeLabel => 'Números excluidos';

  @override
  String includeBonusLabel(String label) {
    return '$label incluidos';
  }

  @override
  String excludeBonusLabel(String label) {
    return '$label excluidos';
  }

  @override
  String notNumber(String label, String raw) {
    return '$label: \"$raw\" no es un número.';
  }

  @override
  String outOfRange(String label, String max) {
    return '$label: solo números del 1 al $max.';
  }

  @override
  String get dupInclude => 'Hay números incluidos repetidos.';

  @override
  String get dupExclude => 'Hay números excluidos repetidos.';

  @override
  String conflict(String numbers) {
    return 'Estos números están incluidos y excluidos a la vez: $numbers';
  }

  @override
  String get calcError => 'Error en el cálculo. Revisa los filtros.';

  @override
  String get busy => 'Calculando. ¡Espera un momento!';

  @override
  String get noResults => 'No quedan combinaciones. Cambia los ajustes.';

  @override
  String tooMany(String count) {
    return 'Solo quedan $count combinaciones; se generarán $count.';
  }

  @override
  String get noExtract =>
      'No hay combinaciones disponibles. Cambia los ajustes.';

  @override
  String get extractError =>
      'No se pudieron generar los números. Revisa los ajustes.';

  @override
  String get resultsTitle => 'Tus combinaciones';

  @override
  String get copied => 'Números copiados.';

  @override
  String get copyButton => 'Copiar';

  @override
  String get shareButton => 'Compartir';

  @override
  String shareHeader(String game) {
    return '🍀Mis números de $game🍀';
  }

  @override
  String get shareSubject => 'Mis números de lotería';

  @override
  String get noHelp => 'No hay descripción disponible.';

  @override
  String get obWelcome => 'Te damos la bienvenida a Lotto Leader';

  @override
  String get obChooseLanguage =>
      'Elige tu idioma. Puedes cambiarlo más tarde en Ajustes.';

  @override
  String get obNext => 'Siguiente';

  @override
  String get obBack => 'Atrás';

  @override
  String get obProfileTitle => 'Registro rápido';

  @override
  String get obProfileBody =>
      'Solo elige un apodo para empezar.\nTu perfil y tu historial se guardan solo en este dispositivo.';

  @override
  String get obNickname => 'Apodo';

  @override
  String get obNicknameHint => '2–12 caracteres';

  @override
  String get obNicknameError => 'Introduce un apodo de 2 a 12 caracteres.';

  @override
  String get obAge => 'Tengo la edad legal para jugar a la lotería en mi país';

  @override
  String get obAgree => 'Acepto la Política de privacidad y el Aviso legal';

  @override
  String get obView => 'Ver';

  @override
  String get obStart => 'Empezar';

  @override
  String get obNeedChecks => 'Confirma todos los elementos obligatorios.';

  @override
  String get menuHistory => 'Mi historial';

  @override
  String historyJoined(String date) {
    return 'Registro: $date';
  }

  @override
  String historyStats(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count generaciones',
      one: '$count generación',
    );
    return '$_temp0';
  }

  @override
  String get historyEmpty =>
      'Aún no hay historial.\nLas combinaciones que generes aparecerán aquí.';

  @override
  String historyTickets(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count combinaciones',
      one: '$count combinación',
    );
    return '$_temp0';
  }

  @override
  String historyFilters(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count filtros',
      one: '$count filtro',
    );
    return '$_temp0';
  }

  @override
  String get historyClearAll => 'Borrar todo el historial';

  @override
  String get historyClearConfirm => '¿Borrar todo el historial de generación?';

  @override
  String get historyDeleted => 'Registro eliminado.';

  @override
  String get delete => 'Eliminar';

  @override
  String get cancel => 'Cancelar';

  @override
  String get confirm => 'Aceptar';

  @override
  String profileNickname(String name) {
    return 'Apodo: $name';
  }

  @override
  String get withdraw => 'Eliminar cuenta (perfil e historial)';

  @override
  String get withdrawConfirm =>
      'Se eliminarán tu perfil y tu historial de este dispositivo y volverás a la pantalla inicial. ¿Continuar?';

  @override
  String get manualEntry => 'Introducir resultados';

  @override
  String get manualHelp =>
      'Úsalo cuando la actualización automática no funcione, según los resultados oficiales. Los datos oficiales de la misma fecha reemplazarán tu entrada.';

  @override
  String get manualRound => 'N.º de sorteo';

  @override
  String get manualDate => 'Fecha del sorteo';

  @override
  String manualMain(String count) {
    return '$count números ganadores';
  }

  @override
  String manualBonus(String label, String count) {
    return '$label: $count';
  }

  @override
  String get manualSave => 'Guardar';

  @override
  String get manualSaved => 'Resultados guardados.';

  @override
  String get manualList => 'Tus entradas';

  @override
  String get manualNone => 'No hay entradas manuales.';

  @override
  String get manualTag => 'Manual';

  @override
  String get mErrRound => 'Revisa el número de sorteo.';

  @override
  String mErrMain(String count) {
    return 'Elige $count números ganadores.';
  }

  @override
  String mErrBonus(String label, String count) {
    return '$label: elige $count.';
  }

  @override
  String get mErrBonusOverlap =>
      'El número complementario no puede ser uno de los ganadores.';

  @override
  String get mErrDate =>
      'Revisa la fecha. No se permiten fechas futuras, días sin sorteo ni fechas anteriores a las reglas actuales.';

  @override
  String get mErrExists => 'Ya existen resultados para esta fecha (sorteo).';

  @override
  String get adPrivacyOptions => 'Privacidad de anuncios';

  @override
  String rewardTitle(String count) {
    return 'Generar $count combinaciones';
  }

  @override
  String rewardBody(String free, String count) {
    return 'Hasta $free combinaciones son gratis.\nMira un anuncio breve para generar las $count.';
  }

  @override
  String rewardWatch(String count) {
    return 'Ver anuncio: $count';
  }

  @override
  String rewardFreeOnly(String free) {
    return 'Solo $free';
  }

  @override
  String rewardNotEarned(String free) {
    return 'No se terminó el anuncio; se generarán $free combinaciones.';
  }

  @override
  String get patternFilters => 'Filtros de patrones';

  @override
  String get pastPending => ' (resultados próximamente)';

  @override
  String get fKr1st => 'Excluir combinaciones ganadoras anteriores';

  @override
  String get hKr1st =>
      'Excluye las combinaciones idénticas a cualquier resultado ganador anterior.';

  @override
  String get fKr23 =>
      'Excluir coincidencias de 5 números con sorteos anteriores';

  @override
  String get hKr23 =>
      'Excluye combinaciones que comparten 5 de los 6 números de un sorteo anterior.';

  @override
  String get fKr4th =>
      'Excluir coincidencias de 4 números (últimos 100 sorteos)';

  @override
  String get hKr4th =>
      'Excluye combinaciones que comparten 4 números con alguno de los últimos 100 sorteos.';

  @override
  String get fKr5th => 'Excluir tríos consecutivos de sorteos anteriores';

  @override
  String get hKr5th =>
      'Excluye combinaciones con 3 números consecutivos que ya salieron en un sorteo anterior.';

  @override
  String get fKrRange => 'Excluir rangos estrechos (máx. − mín. ≤ 9)';

  @override
  String get hKrRange =>
      'Excluye combinaciones cuya diferencia entre el número mayor y el menor es de 9 o menos.';

  @override
  String fPastFull(String k) {
    return 'Excluir combinaciones ganadoras ($k aciertos)';
  }

  @override
  String hPastFull(String k) {
    return 'Excluye combinaciones idénticas a los $k números principales de cualquier sorteo con las reglas actuales.';
  }

  @override
  String fPastMinus1(String m) {
    return 'Excluir coincidencias de $m números con sorteos anteriores';
  }

  @override
  String hPastMinus1(String k, String m) {
    return 'Excluye combinaciones que comparten $m de los $k números principales de un sorteo anterior.';
  }

  @override
  String fPastMinus2(String r, String m) {
    return 'Excluir coincidencias de $m números (últimos $r sorteos)';
  }

  @override
  String hPastMinus2(String r, String m) {
    return 'Excluye combinaciones que comparten $m números principales con alguno de los últimos $r sorteos.';
  }

  @override
  String get fPastConsec => 'Excluir tríos consecutivos de sorteos anteriores';

  @override
  String get hPastConsec =>
      'Excluye combinaciones con 3 números consecutivos (p. ej., 7, 8, 9) que ya salieron en un sorteo anterior.';

  @override
  String fNarrow(String n) {
    return 'Excluir rangos estrechos (máx. − mín. ≤ $n)';
  }

  @override
  String hNarrow(String n) {
    return 'Excluye combinaciones cuya diferencia entre el número mayor y el menor es de $n o menos.';
  }

  @override
  String get f3Consec => 'Excluir 3 números consecutivos';

  @override
  String get h3Consec =>
      'Excluye combinaciones con 3 números consecutivos, como 1, 2, 3 o 33, 34, 35.';

  @override
  String get fSkip1 => 'Excluir 3 números de 2 en 2';

  @override
  String get hSkip1 =>
      'Excluye combinaciones con 3 números separados por 2, como 1, 3, 5 o 15, 17, 19.';

  @override
  String get fSkip2 => 'Excluir 3 números de 3 en 3';

  @override
  String get hSkip2 =>
      'Excluye combinaciones con 3 números separados por 3, como 1, 4, 7 o 15, 18, 21.';

  @override
  String get fSkip3 => 'Excluir 3 números de 4 en 4';

  @override
  String get hSkip3 =>
      'Excluye combinaciones con 3 números separados por 4, como 1, 5, 9 o 15, 19, 23.';

  @override
  String get f2Pairs => 'Excluir 2 o más parejas consecutivas';

  @override
  String get h2Pairs =>
      'Excluye combinaciones con dos o más parejas consecutivas, como 1, 2 y 15, 16.';

  @override
  String fAllOdd(String k) {
    return 'Excluir todos impares ($k impares)';
  }

  @override
  String hAllOdd(String k) {
    return 'Excluye combinaciones en las que los $k números son impares.';
  }

  @override
  String fAllEven(String k) {
    return 'Excluir todos pares ($k pares)';
  }

  @override
  String hAllEven(String k) {
    return 'Excluye combinaciones en las que los $k números son pares.';
  }

  @override
  String get fOE1 => 'Excluir I-P-I-P-I-P / P-I-P-I-P-I';

  @override
  String get fOE2 => 'Excluir P-P-I-I-P-P / I-I-P-P-I-I';

  @override
  String get fOE3 => 'Excluir P-P-P-P-P-I / I-I-I-I-I-P';

  @override
  String get fOE4 => 'Excluir P-P-P-P-I-I / I-I-I-I-P-P';

  @override
  String get fOE5 => 'Excluir P-P-P-I-I-I / I-I-I-P-P-P';

  @override
  String hOE(String pattern) {
    return 'Excluye combinaciones cuyos 6 números ordenados siguen el orden impar(I)/par(P) $pattern.';
  }

  @override
  String get fSameDigit => 'Excluir 3+ números con la misma terminación';

  @override
  String get hSameDigit =>
      'Excluye combinaciones con 3 o más números que terminan en la misma cifra, como 1, 11, 21, 31.';

  @override
  String get fTripleMult => 'Excluir 3 múltiplos consecutivos';

  @override
  String get hTripleMult =>
      'Excluye combinaciones con 3 múltiplos consecutivos del mismo número, como 2, 4, 6 o 4, 8, 12.';

  @override
  String get alarmIntro =>
      'Recibirás una notificación 3 horas antes de cada sorteo de las loterías que actives.';

  @override
  String alarmDrawAt(String days, String time) {
    return 'Sorteos $days $time (hora local)';
  }

  @override
  String get alarmUnsupported =>
      'Las notificaciones no son compatibles con este dispositivo. Usa la app del móvil.';

  @override
  String get alarmDenied =>
      'Las notificaciones están desactivadas. Permítelas para esta app en los ajustes del móvil.';

  @override
  String alarmOn(String game) {
    return 'Te avisaremos 3 horas antes de cada sorteo de $game.';
  }

  @override
  String alarmOff(String game) {
    return 'Avisos de $game desactivados.';
  }

  @override
  String notifyTitle(String game) {
    return '¡Hoy hay sorteo de $game!';
  }

  @override
  String get notifyBody =>
      'El sorteo es en 3 horas. Genera tus números en Lotto Leader.';

  @override
  String get notifyChannel => 'Avisos de sorteo';

  @override
  String get winPending => 'Pendiente de sorteo';

  @override
  String winDrawOf(String date) {
    return 'Comparado con el sorteo del $date';
  }

  @override
  String winRank(String rank) {
    return 'Categoría $rank';
  }

  @override
  String winBest(String rank) {
    return 'Mejor: $rank';
  }

  @override
  String get winNone => 'Sin premio';

  @override
  String winMatch(String main) {
    return '$main aciertos';
  }

  @override
  String winMatchPlus(String main, String bonus) {
    return '$main+$bonus aciertos';
  }

  @override
  String winMatchBonus(String main) {
    return '$main aciertos + complementario';
  }

  @override
  String get winPendingHint =>
      'Se compara automáticamente cuando llega el resultado. Si se retrasa, usa Ajustes → Introducir resultados.';

  @override
  String get statsTitle => 'Estadísticas';

  @override
  String statsRecent(String n) {
    return 'Últimos $n';
  }

  @override
  String get statsAll => 'Todos';

  @override
  String get statsMain => 'Números';

  @override
  String get statsSortNumber => 'Por número';

  @override
  String get statsSortMost => 'Más salidos';

  @override
  String get statsSortLeast => 'Menos salidos';

  @override
  String get statsSortGap => 'Más tiempo sin salir';

  @override
  String statsAnalyzed(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: 'Según los últimos $n sorteos',
      one: 'Según el último sorteo',
    );
    return '$_temp0';
  }

  @override
  String get statsHot => 'Más frecuentes';

  @override
  String get statsCold => 'Números fríos';

  @override
  String statsCount(String n) {
    return '$n×';
  }

  @override
  String statsGap(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: 'hace $n sorteos',
      one: 'hace $n sorteo',
    );
    return '$_temp0';
  }

  @override
  String get statsGapLatest => 'Último sorteo';

  @override
  String get statsGapNever => 'Sin salir';

  @override
  String get statsOddEven => 'Reparto pares / impares';

  @override
  String statsOddLabel(String odd, String even) {
    return '$odd impares : $even pares';
  }

  @override
  String get statsDisclaimer =>
      'Son solo resultados pasados y no predicen sorteos futuros.';

  @override
  String get backupExport => 'Hacer copia de seguridad';

  @override
  String get backupImport => 'Restaurar copia';

  @override
  String get backupShareText =>
      'Copia de seguridad de Lotto Leader. En tu nuevo móvil, abre Ajustes → Restaurar copia y elige este archivo.';

  @override
  String get backupEmpty => 'Aún no hay nada que copiar.';

  @override
  String get backupFailed => 'No se pudo crear la copia. Inténtalo más tarde.';

  @override
  String get backupImportConfirm =>
      'La copia se combinará con el historial de este dispositivo. El apodo y la fecha de registro se tomarán de la copia. ¿Continuar?';

  @override
  String backupImportDone(String history, String manual) {
    return 'Restauración completa. Añadido: historial $history · resultados manuales $manual';
  }

  @override
  String get backupInvalid =>
      'No es una copia de Lotto Leader o el archivo está dañado.';

  @override
  String get backupTooLarge =>
      'El archivo es demasiado grande. Elige una copia de Lotto Leader.';

  @override
  String get continueButton => 'Continuar';

  @override
  String get colon => ': ';

  @override
  String fSum(String lo, String hi) {
    return 'Excluir sumas fuera de $lo–$hi';
  }

  @override
  String hSum(String lo, String hi) {
    return 'Excluye combinaciones cuyos números principales suman menos de $lo o más de $hi. Alrededor del 95% de las combinaciones está en este rango.';
  }

  @override
  String get fBirthday => 'Excluir combinaciones solo hasta 31 (fechas)';

  @override
  String get hBirthday =>
      'Excluye combinaciones formadas solo por 1–31 (números de fechas). Mucha gente elige cumpleaños, así que un bote con estos números tiene más probabilidades de repartirse. La probabilidad de ganar es la misma que con cualquier otra combinación.';

  @override
  String get fLowHigh => 'Excluir todos bajos o todos altos';

  @override
  String hLowHigh(String half, String next, String max) {
    return 'Excluye combinaciones con todos los números entre 1 y $half, o todos entre $next y $max.';
  }

  @override
  String get fDecade4 => 'Excluir 4+ números en la misma decena';

  @override
  String get hDecade4 =>
      'Excluye combinaciones con 4 o más números en la misma decena (1–9, 10–19, 20–29 …), como 41, 43, 45, 48.';

  @override
  String get fRepeatLast => 'Excluir 2+ números del último sorteo';

  @override
  String get hRepeatLast =>
      'Excluye combinaciones que repiten 2 o más números principales del último sorteo.';

  @override
  String fBonusRecent(String n, String label) {
    return 'Excluir $label de los últimos $n sorteos';
  }

  @override
  String hBonusRecent(String n, String label) {
    return 'No se elegirán números de $label salidos en los últimos $n sorteos.';
  }

  @override
  String fBonusPairRecent(String n, String label) {
    return 'Excluir parejas de $label de los últimos $n sorteos';
  }

  @override
  String hBonusPairRecent(String n, String label) {
    return 'No se elegirá una pareja de $label igual a la de alguno de los últimos $n sorteos.';
  }

  @override
  String fBonusConsec(String label) {
    return 'Excluir $label consecutivos (p. ej., 3·4)';
  }

  @override
  String hBonusConsec(String label) {
    return 'No se elegirán $label consecutivos, como 3·4.';
  }

  @override
  String fBonusParity(String label) {
    return 'Excluir $label ambos impares o ambos pares';
  }

  @override
  String hBonusParity(String label) {
    return 'No se elegirán $label que sean ambos impares o ambos pares.';
  }

  @override
  String get filtersOverseas => 'Filtros adicionales de esta lotería';

  @override
  String filtersBonus(String label) {
    return 'Filtros de $label';
  }
}
