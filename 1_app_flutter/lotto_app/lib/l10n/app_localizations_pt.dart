// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get appTitle => 'Lotto Leader';

  @override
  String get close => 'Fechar';

  @override
  String get apply => 'Aplicar';

  @override
  String get lookup => 'Ver';

  @override
  String get calculating => 'Calculando…';

  @override
  String get extracting => 'Gerando…';

  @override
  String get extractButton => 'Gerar';

  @override
  String get countHint => 'Qtd.';

  @override
  String get remainingCombos => 'Combinações restantes';

  @override
  String get menuResults => 'Resultados';

  @override
  String get menuReset => 'Redefinir';

  @override
  String get menuAlarm => 'Alertas';

  @override
  String get menuSettings => 'Ajustes';

  @override
  String get privacyPolicy => 'Política de privacidade';

  @override
  String get disclaimer => 'Aviso legal';

  @override
  String get contact => 'Contato';

  @override
  String get versionLabel => 'Versão';

  @override
  String currentVersion(String version) {
    return 'Versão atual do app $version';
  }

  @override
  String get language => 'Idioma';

  @override
  String get languageSystem => 'Usar o idioma do aparelho';

  @override
  String drawAlarm(String game) {
    return 'Lembrete do dia de sorteio: $game';
  }

  @override
  String get resetDone => 'Configurações padrão restauradas.';

  @override
  String get privacyText =>
      'Este app é gratuito. Na primeira abertura, você cria um perfil simples, apenas com um apelido. O apelido e o histórico de combinações ficam guardados somente neste aparelho, nunca são enviados ao desenvolvedor e podem ser apagados a qualquer momento em Ajustes → Excluir conta.\n\nO app em si não coleta dados que identifiquem você, como nome, telefone ou e-mail.\n\nO app usa o Google AdMob para exibir anúncios. Nesse processo, o ID de publicidade, informações do aparelho e de uso do app podem ser coletados pelo Google. Onde o consentimento é exigido (por exemplo, no EEE e no Reino Unido), ele é solicitado na primeira abertura e pode ser alterado a qualquer momento em Ajustes → Privacidade de anúncios.\n\nEssas informações podem ser usadas para exibir anúncios, melhorar a qualidade do app e evitar abusos.';

  @override
  String get disclaimerText =>
      'Este app é uma ferramenta que mostra estatísticas de resultados anteriores e ajuda você a montar combinações de números.\n\nEm toda loteria, cada combinação tem exatamente a mesma chance de ganhar o prêmio principal (por exemplo, 1 em 8.145.060 na Lotto 6/45 da Coreia e 1 em 50.063.860 na Mega-Sena). Os filtros e as estatísticas deste app não aumentam suas chances. Use-os apenas por diversão e como referência.\n\nEste é um app independente, sem vínculo com nenhuma operadora de loteria (incluindo Dong-hang Lottery, Powerball, Mega Millions, Lotto 6/49, EuroMillions, Eurojackpot, FDJ Loto, Caixa Mega-Sena, Loto 6, Loto 7 e Vietlott).\n\nO app não garante nenhum prêmio. A compra e o uso de bilhetes de loteria são de sua inteira responsabilidade.\n\nO app não vende bilhetes e não oferece apostas, recompensas em dinheiro nem serviços de jogos de azar.\n\nFonte dos resultados da Mega-Sena: conjunto de dados do ValorFinal (valorfinal.com.br/dados/loteria-megasena), licença CC BY 4.0 (creativecommons.org/licenses/by/4.0), convertido para o formato do app.';

  @override
  String get contactText =>
      'Se tiver dúvidas, encontrar um erro ou quiser dar uma sugestão, envie um e-mail para nós.\n\nResponsável: 한지성\nE-mail: jnhteamsoft@gmail.com\n\nNormalmente respondemos em até 3 dias úteis.';

  @override
  String get chooseLottery => 'Escolher loteria';

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
    return 'Chance do prêmio principal: 1 em $odds';
  }

  @override
  String drawCount(String count) {
    return '$count sorteios anteriores';
  }

  @override
  String get drawsPending => 'Resultados em breve';

  @override
  String get drawRoundPrefix => 'Concurso nº ';

  @override
  String get drawRoundSuffix => '';

  @override
  String get drawResultPrefix => 'Resultado do ';

  @override
  String get drawResultSuffix => '';

  @override
  String drawDate(String date) {
    return 'Sorteado em $date';
  }

  @override
  String get noDrawDate => 'Data do sorteio desconhecida';

  @override
  String get noResultsStored =>
      'Ainda não há resultados anteriores.\n(Os resultados desta loteria chegarão em breve.)';

  @override
  String get dbLoading =>
      'Carregando resultados anteriores. Tente novamente em instantes.';

  @override
  String get dbLoadingShort => 'Carregando resultados anteriores…';

  @override
  String get dbLoadFailed =>
      'Não foi possível carregar os resultados anteriores.';

  @override
  String get freqPrefix => 'Últimos [';

  @override
  String get freqSuffix => '] sorteios: mais | menos sorteados';

  @override
  String get freqHint => 'todos';

  @override
  String get mostDrawn => 'Mais sorteados';

  @override
  String get leastDrawn => 'Menos sorteados';

  @override
  String get noDrawData => 'Ainda não há resultados anteriores desta loteria.';

  @override
  String get recentTooLarge =>
      'São mais sorteios do que os guardados, então todos serão usados.';

  @override
  String get freqError => 'Não foi possível calcular as frequências.';

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
    return '$label (1–$max, incluir até $inc · excluir até $exc)';
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
    return 'O $number já está na outra lista.';
  }

  @override
  String pickerMax(String max) {
    return 'Você pode escolher até $max.';
  }

  @override
  String get includeLabel => 'Números incluídos';

  @override
  String get excludeLabel => 'Números excluídos';

  @override
  String includeBonusLabel(String label) {
    return '$label incluídos';
  }

  @override
  String excludeBonusLabel(String label) {
    return '$label excluídos';
  }

  @override
  String notNumber(String label, String raw) {
    return '$label: \"$raw\" não é um número.';
  }

  @override
  String outOfRange(String label, String max) {
    return '$label deve estar entre 1 e $max.';
  }

  @override
  String get dupInclude => 'Há números repetidos entre os incluídos.';

  @override
  String get dupExclude => 'Há números repetidos entre os excluídos.';

  @override
  String conflict(String numbers) {
    return 'Estes números estão incluídos e excluídos ao mesmo tempo: $numbers';
  }

  @override
  String get calcError => 'O cálculo falhou. Verifique os filtros.';

  @override
  String get busy => 'Ainda calculando. Aguarde um pouco!';

  @override
  String get noResults =>
      'Não sobrou nenhuma combinação. Altere as configurações.';

  @override
  String tooMany(String count) {
    return 'Restam apenas $count combinações, então serão geradas $count.';
  }

  @override
  String get noExtract =>
      'Não há combinações disponíveis. Altere as configurações.';

  @override
  String get extractError =>
      'Não foi possível gerar os números. Verifique as configurações.';

  @override
  String get resultsTitle => 'Suas combinações';

  @override
  String get copied => 'Números copiados.';

  @override
  String get copyButton => 'Copiar';

  @override
  String get shareButton => 'Compartilhar';

  @override
  String shareHeader(String game) {
    return '🍀Meus números – $game🍀';
  }

  @override
  String get shareSubject => 'Meus números da loteria';

  @override
  String get noHelp => 'Sem descrição disponível.';

  @override
  String get obWelcome => 'Bem-vindo ao Lotto Leader';

  @override
  String get obChooseLanguage =>
      'Escolha o idioma. Você pode mudar depois em Ajustes.';

  @override
  String get obNext => 'Avançar';

  @override
  String get obBack => 'Voltar';

  @override
  String get obProfileTitle => 'Cadastro rápido';

  @override
  String get obProfileBody =>
      'Basta escolher um apelido para começar.\nSeu perfil e histórico ficam guardados somente neste aparelho.';

  @override
  String get obNickname => 'Apelido';

  @override
  String get obNicknameHint => '2 a 12 caracteres';

  @override
  String get obNicknameError => 'Digite um apelido de 2 a 12 caracteres.';

  @override
  String get obAge => 'Tenho a idade mínima para jogar na loteria no meu país';

  @override
  String get obAgree =>
      'Concordo com a Política de privacidade e o Aviso legal';

  @override
  String get obView => 'Ver';

  @override
  String get obStart => 'Começar';

  @override
  String get obNeedChecks => 'Confirme todos os itens obrigatórios.';

  @override
  String get menuHistory => 'Meu histórico';

  @override
  String historyJoined(String date) {
    return 'Cadastro em $date';
  }

  @override
  String historyStats(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count gerações',
      one: '$count geração',
    );
    return '$_temp0';
  }

  @override
  String get historyEmpty =>
      'Ainda não há histórico.\nAs combinações geradas aparecerão aqui.';

  @override
  String historyTickets(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count combinações',
      one: '$count combinação',
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
  String get historyClearAll => 'Apagar todo o histórico';

  @override
  String get historyClearConfirm => 'Apagar todo o histórico de gerações?';

  @override
  String get historyDeleted => 'Registro apagado.';

  @override
  String get delete => 'Apagar';

  @override
  String get cancel => 'Cancelar';

  @override
  String get exitTitle => 'Sair do app';

  @override
  String get exitConfirm => 'Deseja sair do Lotto Leader?';

  @override
  String get exitButton => 'Sair';

  @override
  String get confirm => 'OK';

  @override
  String profileNickname(String name) {
    return 'Apelido: $name';
  }

  @override
  String get withdraw => 'Excluir conta (perfil e histórico)';

  @override
  String get withdrawConfirm =>
      'Seu perfil e histórico serão apagados deste aparelho e você voltará à tela inicial. Continuar?';

  @override
  String get manualEntry => 'Inserir resultados manualmente';

  @override
  String get manualHelp =>
      'Use quando a atualização automática não estiver funcionando, com base nos resultados oficiais. Depois, os dados oficiais da mesma data substituirão o que você inseriu.';

  @override
  String get manualRound => 'Nº do concurso';

  @override
  String get manualDate => 'Data do sorteio';

  @override
  String manualMain(String count) {
    return '$count números sorteados';
  }

  @override
  String manualBonus(String label, String count) {
    return '$label: $count';
  }

  @override
  String get manualSave => 'Salvar';

  @override
  String get manualSaved => 'Resultado salvo.';

  @override
  String get manualList => 'Seus registros';

  @override
  String get manualNone => 'Nenhum registro manual.';

  @override
  String get manualTag => 'Manual';

  @override
  String get mErrRound => 'Verifique o número do concurso.';

  @override
  String mErrMain(String count) {
    return 'Escolha $count números sorteados.';
  }

  @override
  String mErrBonus(String label, String count) {
    return '$label: escolha $count.';
  }

  @override
  String get mErrBonusOverlap =>
      'O número bônus não pode ser um dos números sorteados.';

  @override
  String get mErrDate =>
      'Verifique a data. Datas futuras, dias sem sorteio e datas anteriores às regras atuais não são permitidos.';

  @override
  String get mErrExists => 'Já existe um resultado para esta data (concurso).';

  @override
  String get adPrivacyOptions => 'Privacidade de anúncios';

  @override
  String rewardTitle(String count) {
    return 'Gerar $count combinações';
  }

  @override
  String rewardBody(String free, String count) {
    return 'Até $free combinações são gratuitas.\nAssista a um anúncio curto para gerar todas as $count.';
  }

  @override
  String rewardWatch(String count) {
    return 'Ver anúncio e gerar $count';
  }

  @override
  String rewardFreeOnly(String free) {
    return 'Só $free';
  }

  @override
  String rewardNotEarned(String free) {
    return 'O anúncio não foi até o fim, então serão geradas $free combinações.';
  }

  @override
  String get patternFilters => 'Filtros de padrão';

  @override
  String get pastPending => ' (resultados em breve)';

  @override
  String get fKr1st => 'Excluir combinações que já ganharam o prêmio principal';

  @override
  String get hKr1st =>
      'Exclui combinações iguais a qualquer resultado do prêmio principal já sorteado.';

  @override
  String get fKr23 => 'Excluir 5 acertos com sorteios anteriores';

  @override
  String get hKr23 =>
      'Exclui combinações que têm 5 dos 6 números de qualquer sorteio anterior.';

  @override
  String get fKr4th => 'Excluir 4 acertos (últimos 100 sorteios)';

  @override
  String get hKr4th =>
      'Exclui combinações que têm 4 números em comum com algum dos últimos 100 sorteios.';

  @override
  String get fKr5th => 'Excluir trincas seguidas já sorteadas';

  @override
  String get hKr5th =>
      'Exclui combinações com uma sequência de 3 números seguidos que já apareceu em um sorteio anterior.';

  @override
  String get fKrRange => 'Excluir faixas estreitas (maior − menor ≤ 9)';

  @override
  String get hKrRange =>
      'Exclui combinações em que a diferença entre o maior e o menor número é 9 ou menos.';

  @override
  String fPastFull(String k) {
    return 'Excluir combinações já sorteadas ($k acertos)';
  }

  @override
  String hPastFull(String k) {
    return 'Exclui combinações iguais aos $k números principais de qualquer sorteio das regras atuais.';
  }

  @override
  String fPastMinus1(String m) {
    return 'Excluir $m acertos com sorteios anteriores';
  }

  @override
  String hPastMinus1(String k, String m) {
    return 'Exclui combinações que têm $m dos $k números principais de qualquer sorteio anterior.';
  }

  @override
  String fPastMinus2(String r, String m) {
    return 'Excluir $m acertos (últimos $r sorteios)';
  }

  @override
  String hPastMinus2(String r, String m) {
    return 'Exclui combinações que têm $m números principais em comum com algum dos últimos $r sorteios.';
  }

  @override
  String get fPastConsec => 'Excluir trincas seguidas já sorteadas';

  @override
  String get hPastConsec =>
      'Exclui combinações com uma sequência de 3 números seguidos (por exemplo 7, 8, 9) que já apareceu em um sorteio anterior.';

  @override
  String fNarrow(String n) {
    return 'Excluir faixas estreitas (maior − menor ≤ $n)';
  }

  @override
  String hNarrow(String n) {
    return 'Exclui combinações em que a diferença entre o maior e o menor número é $n ou menos.';
  }

  @override
  String get f3Consec => 'Excluir 3 números seguidos';

  @override
  String get h3Consec =>
      'Exclui combinações com 3 números seguidos, como 1, 2, 3 ou 33, 34, 35.';

  @override
  String get fDouble3Consec => 'Excluir duas sequências de 3 números seguidos';

  @override
  String get hDouble3Consec =>
      'Exclui combinações formadas por duas sequências de 3 números seguidos, como 1, 2, 3, 20, 21, 22.';

  @override
  String get fSkip1 => 'Excluir 3 números de 2 em 2';

  @override
  String get hSkip1 =>
      'Exclui combinações com 3 números espaçados de 2 em 2, como 1, 3, 5 ou 15, 17, 19.';

  @override
  String get fSkip2 => 'Excluir 3 números de 3 em 3';

  @override
  String get hSkip2 =>
      'Exclui combinações com 3 números espaçados de 3 em 3, como 1, 4, 7 ou 15, 18, 21.';

  @override
  String get fSkip3 => 'Excluir 3 números de 4 em 4';

  @override
  String get hSkip3 =>
      'Exclui combinações com 3 números espaçados de 4 em 4, como 1, 5, 9 ou 15, 19, 23.';

  @override
  String get f2Pairs => 'Excluir 2 ou mais pares seguidos';

  @override
  String get h2Pairs =>
      'Exclui combinações com dois ou mais pares de números seguidos, como 1, 2 e 15, 16.';

  @override
  String fAllOdd(String k) {
    return 'Excluir todos ímpares ($k números ímpares)';
  }

  @override
  String hAllOdd(String k) {
    return 'Exclui combinações em que os $k números são todos ímpares.';
  }

  @override
  String fAllEven(String k) {
    return 'Excluir todos pares ($k números pares)';
  }

  @override
  String hAllEven(String k) {
    return 'Exclui combinações em que os $k números são todos pares.';
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
    return 'Exclui combinações cujos 6 números, em ordem crescente, seguem a sequência ímpar(I)/par(P) $pattern.';
  }

  @override
  String get fSameDigit => 'Excluir 3 ou mais números com o mesmo final';

  @override
  String get hSameDigit =>
      'Exclui combinações com 3 ou mais números terminados no mesmo algarismo, como 1, 11, 21, 31.';

  @override
  String get fTripleMult => 'Excluir 3 múltiplos seguidos';

  @override
  String get hTripleMult =>
      'Exclui combinações com 3 múltiplos seguidos do mesmo número, como 2, 4, 6 ou 4, 8, 12.';

  @override
  String get alarmIntro =>
      'Você receberá uma notificação no celular 3 horas antes de cada sorteio das loterias que ativar.';

  @override
  String alarmDrawAt(String days, String time) {
    return 'Sorteios $days $time (horário local)';
  }

  @override
  String get alarmUnsupported =>
      'Este aparelho não aceita notificações. Use o app no celular.';

  @override
  String get alarmDenied =>
      'As notificações estão desativadas. Permita notificações para este app nos ajustes do celular.';

  @override
  String alarmOn(String game) {
    return 'Vamos lembrar você 3 horas antes de cada sorteio ($game).';
  }

  @override
  String alarmOff(String game) {
    return 'Lembretes desativados: $game.';
  }

  @override
  String notifyTitle(String game) {
    return 'Hoje tem sorteio: $game!';
  }

  @override
  String get notifyBody =>
      'O sorteio é daqui a 3 horas. Gere seus números no Lotto Leader.';

  @override
  String get notifyChannel => 'Lembretes de sorteio';

  @override
  String get winPending => 'Aguardando sorteio';

  @override
  String winDrawOf(String date) {
    return 'Comparado com o sorteio de $date';
  }

  @override
  String winRank(String rank) {
    return 'Faixa $rank';
  }

  @override
  String winBest(String rank) {
    return 'Melhor: $rank';
  }

  @override
  String get winNone => 'Sem prêmio';

  @override
  String winMatch(String main) {
    return '$main acertos';
  }

  @override
  String winMatchPlus(String main, String bonus) {
    return '$main+$bonus acertos';
  }

  @override
  String winMatchBonus(String main) {
    return '$main + bônus';
  }

  @override
  String get winPendingHint =>
      'Os resultados são comparados automaticamente quando o sorteio chegar. Se atrasar, use Ajustes → Inserir resultados manualmente.';

  @override
  String get statsTitle => 'Estatísticas';

  @override
  String statsRecent(String n) {
    return 'Últimos $n';
  }

  @override
  String get statsAll => 'Todos';

  @override
  String get statsMain => 'Números principais';

  @override
  String get statsSortNumber => 'Por número';

  @override
  String get statsSortMost => 'Mais sorteados';

  @override
  String get statsSortLeast => 'Menos sorteados';

  @override
  String get statsSortGap => 'Há mais tempo sem sair';

  @override
  String statsAnalyzed(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: 'Com base nos últimos $n sorteios',
      one: 'Com base no último sorteio',
    );
    return '$_temp0';
  }

  @override
  String get statsHot => 'Números quentes';

  @override
  String get statsCold => 'Números frios';

  @override
  String statsCount(String n) {
    return '$n×';
  }

  @override
  String statsGap(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: 'há $n sorteios',
      one: 'há $n sorteio',
    );
    return '$_temp0';
  }

  @override
  String get statsGapLatest => 'Último sorteio';

  @override
  String get statsGapNever => 'Nunca saiu';

  @override
  String get statsOddEven => 'Ímpares / pares';

  @override
  String statsOddLabel(String odd, String even) {
    return '$odd ímpares : $even pares';
  }

  @override
  String get statsDisclaimer =>
      'São apenas resultados anteriores e não preveem sorteios futuros.';

  @override
  String get backupExport => 'Fazer backup do histórico';

  @override
  String get backupImport => 'Restaurar backup';

  @override
  String get backupShareText =>
      'Arquivo de backup do Lotto Leader. No celular novo, abra Ajustes → Restaurar backup e escolha este arquivo.';

  @override
  String get backupEmpty => 'Ainda não há nada para salvar.';

  @override
  String get backupFailed =>
      'Não foi possível criar o arquivo de backup. Tente novamente mais tarde.';

  @override
  String get backupImportConfirm =>
      'O backup será combinado com o histórico deste aparelho. O apelido e a data de cadastro virão do backup. Continuar?';

  @override
  String backupImportDone(String history, String manual) {
    return 'Restauração concluída. Adicionados: histórico $history · resultados manuais $manual';
  }

  @override
  String get backupInvalid =>
      'Este não é um arquivo de backup do Lotto Leader, ou o arquivo está danificado.';

  @override
  String get backupTooLarge =>
      'O arquivo é grande demais. Escolha um arquivo de backup do Lotto Leader.';

  @override
  String get continueButton => 'Continuar';

  @override
  String get colon => ': ';

  @override
  String fSum(String lo, String hi) {
    return 'Excluir somas fora de $lo–$hi';
  }

  @override
  String hSum(String lo, String hi) {
    return 'Exclui combinações cujos números principais somam menos de $lo ou mais de $hi. Cerca de 95% das combinações ficam dentro dessa faixa.';
  }

  @override
  String get fBirthday =>
      'Excluir combinações só até 31 (datas de aniversário)';

  @override
  String get hBirthday =>
      'Exclui combinações formadas só por números de 1 a 31 (usados em datas). Muita gente escolhe aniversários, então um prêmio com esses números tem mais chance de ser dividido. A chance de ganhar é a mesma de qualquer outra combinação.';

  @override
  String get fLowHigh => 'Excluir todos baixos ou todos altos';

  @override
  String hLowHigh(String half, String next, String max) {
    return 'Exclui combinações com todos os números entre 1 e $half, ou todos entre $next e $max.';
  }

  @override
  String get fDecade4 => 'Excluir 4 ou mais números na mesma dezena';

  @override
  String get hDecade4 =>
      'Exclui combinações com 4 ou mais números no mesmo grupo de dez (1–9, 10–19, 20–29 …), como 41, 43, 45, 48.';

  @override
  String get fRepeatLast => 'Excluir 2 ou mais números do último sorteio';

  @override
  String get hRepeatLast =>
      'Exclui combinações que repetem 2 ou mais números principais do sorteio mais recente.';

  @override
  String fBonusRecent(String n, String label) {
    return 'Excluir $label dos últimos $n sorteios';
  }

  @override
  String hBonusRecent(String n, String label) {
    return 'Números de $label sorteados nos últimos $n sorteios não serão escolhidos.';
  }

  @override
  String fBonusPairRecent(String n, String label) {
    return 'Excluir pares de $label dos últimos $n sorteios';
  }

  @override
  String hBonusPairRecent(String n, String label) {
    return 'Um par de $label igual ao de algum dos últimos $n sorteios não será escolhido.';
  }

  @override
  String fBonusConsec(String label) {
    return 'Excluir $label seguidos (ex.: 3·4)';
  }

  @override
  String hBonusConsec(String label) {
    return 'Pares de $label com números seguidos, como 3·4, não serão escolhidos.';
  }

  @override
  String fBonusParity(String label) {
    return 'Excluir $label ambos ímpares ou ambos pares';
  }

  @override
  String hBonusParity(String label) {
    return 'Pares de $label em que os dois são ímpares ou os dois são pares não serão escolhidos.';
  }

  @override
  String get filtersOverseas => 'Filtros extras desta loteria';

  @override
  String filtersBonus(String label) {
    return 'Filtros de $label';
  }
}
