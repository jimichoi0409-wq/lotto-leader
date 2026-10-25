// 여러 화면이 함께 쓰는 글꼴·색·국기·번호 공

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// 한국어는 브랜드 글꼴(이사만루)을 씁니다. 이사만루에는 악센트 문자(ä, é, ñ 등)가 없어서
/// 다른 언어는 기기 기본 글꼴(null)을 씁니다. 화면을 그릴 때 현재 언어로 정해집니다.
String? appFont = 'Esamanru';

/// 휴대폰 기본 글꼴 이름. 테마 글꼴(이사만루)을 덮어써야 할 때 씁니다.
String get systemFont => switch (defaultTargetPlatform) {
  TargetPlatform.iOS || TargetPlatform.macOS => 'CupertinoSystemText',
  _ => 'Roboto',
};

/// 언어 이름 글꼴: 한국어는 이사만루, 나머지는 기기 기본 글꼴
/// (이사만루에는 ñ·ç·ä 같은 악센트 문자가 없어 그 글자만 다른 모양으로 보이는 문제 방지)
String languageNameFont(String? code) => code == 'ko' ? 'Esamanru' : systemFont;

const Color brandYellow = Color(0xFFFDE046);
const Color brandYellowDark = Color(0xFFE9D52B);
const Color pageGray = Color(0xFFF3F2F2);

/// 복권 로고 대신 쓰는 국가 국기 (games.json 의 country)
const Map<String, String> _countryFlags = {
  'KR': '🇰🇷',
  'US': '🇺🇸',
  'CA': '🇨🇦',
  'EU': '🇪🇺',
  'JP': '🇯🇵',
  'IE': '🇮🇪',
  'VN': '🇻🇳',
};

String flagOf(String country) => _countryFlags[country] ?? '🌐';

/// 언어를 대표하는 국기 (언어 선택 목록용). 영어는 1차 출시국 기준 미국 국기.
const Map<String, String> languageFlags = {
  'ko': '🇰🇷',
  'en': '🇺🇸',
  'es': '🇪🇸',
  'fr': '🇫🇷',
  'de': '🇩🇪',
  'ja': '🇯🇵',
  'vi': '🇻🇳',
};

/// 언어 앞에 붙이는 국기. null(기기 설정 따르기)이면 휴대폰 아이콘.
class LanguageFlag extends StatelessWidget {
  final String? code;
  final double size;

  const LanguageFlag(this.code, {super.key, this.size = 24});

  @override
  Widget build(BuildContext context) => SizedBox(
    width: size * 1.35,
    child: Center(
      child: code == null
          ? Icon(
              Icons.smartphone_rounded,
              size: size,
              color: const Color(0xFF777777),
            )
          : Text(languageFlags[code] ?? '🌐', style: TextStyle(fontSize: size)),
    ),
  );
}

Color ballColor(int n) {
  if (n <= 10) return const Color(0xFFFFC107);
  if (n <= 20) return const Color(0xFF29B6F6);
  if (n <= 30) return const Color(0xFFFA7A2C);
  if (n <= 40) return const Color(0xFF9E9E9E);
  if (n <= 50) return const Color(0xFF4CAF50);
  return const Color(0xFFB39DDB);
}

class LottoBall extends StatelessWidget {
  final int number;
  final double size;
  final bool bonus;

  /// 당첨 확인에서 맞히지 못한 번호는 흐리게
  final bool dimmed;

  const LottoBall(
    this.number, {
    super.key,
    this.size = 28,
    this.bonus = false,
    this.dimmed = false,
  });

  @override
  Widget build(BuildContext context) {
    final fontSize = size * 0.43;
    final ball = Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: bonus ? Colors.white : ballColor(number),
        border: bonus
            ? Border.all(color: const Color(0xFFE53935), width: 2.4)
            : null,
      ),
      child: Text(
        '$number',
        style: TextStyle(
          fontFamily: appFont,
          fontSize: fontSize,
          fontWeight: bonus ? FontWeight.w700 : FontWeight.w500,
          color: bonus ? const Color(0xFFE53935) : Colors.black,
        ),
      ),
    );
    return dimmed ? Opacity(opacity: 0.28, child: ball) : ball;
  }
}

/// 메인 번호 + (있으면) 보조 번호 한 줄
class TicketRow extends StatelessWidget {
  final List<int> main;
  final List<int> bonus;
  final double size;

  /// 당첨 확인용: 주어지면 여기 없는 번호를 흐리게 표시합니다.
  final Set<int>? mainHits;
  final Set<int>? bonusHits;

  const TicketRow(
    this.main,
    this.bonus, {
    super.key,
    this.size = 28,
    this.mainHits,
    this.bonusHits,
  });

  @override
  Widget build(BuildContext context) {
    final gap = main.length + bonus.length > 6 ? 5.0 : 8.0;
    return FittedBox(
      fit: BoxFit.scaleDown,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (final (i, n) in main.indexed) ...[
            if (i > 0) SizedBox(width: gap),
            LottoBall(
              n,
              size: size,
              dimmed:
                  mainHits != null &&
                  !mainHits!.contains(n) &&
                  !(bonusHits?.contains(n) ?? false),
            ),
          ],
          if (bonus.isNotEmpty) ...[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6),
              child: Text(
                '+',
                style: TextStyle(
                  fontSize: size * 0.6,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF555555),
                ),
              ),
            ),
            for (final (i, n) in bonus.indexed) ...[
              if (i > 0) SizedBox(width: gap),
              LottoBall(
                n,
                size: size,
                bonus: true,
                dimmed: bonusHits != null && !bonusHits!.contains(n),
              ),
            ],
          ],
        ],
      ),
    );
  }
}
