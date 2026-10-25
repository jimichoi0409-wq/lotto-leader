import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lotto_app/l10n/app_localizations.dart';

void main() {
  AppLocalizations l(String code) => lookupAppLocalizations(Locale(code));

  test('개수가 1이면 단수, 2 이상이면 복수', () {
    expect(l('en').historyTickets(1), '1 combination');
    expect(l('en').historyTickets(12), '12 combinations');
    expect(l('es').historyTickets(1), '1 combinación');
    expect(l('fr').historyTickets(1), '1 combinaison');
    expect(l('de').historyTickets(1), '1 Kombination');
    expect(l('de').historyTickets(2), '2 Kombinationen');
    expect(l('ko').historyTickets(1), '1개 조합');
    expect(l('en').statsGap(1), '1 draw ago');
    expect(l('fr').statsGap(3), 'il y a 3 tirages');
    expect(l('es').statsAnalyzed(1), 'Según el último sorteo');
    expect(l('en').historyStats(1), '1 generation');
  });

  test('프랑스어는 콜론 앞을 띄어 씀', () {
    expect(l('fr').colon, ' : ');
    expect(l('ko').colon, ': ');
    expect(l('de').colon, ': ');
  });
}
