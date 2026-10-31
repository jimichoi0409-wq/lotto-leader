// 서버(GitHub Pages)의 manifest.json 을 보고, 기기보다 회차가 많은 복권만 내려받습니다.
// 받은 데이터는 검증을 통과해야만 앱 저장 공간에 보관하고, 실패하면 아무것도 바꾸지 않습니다.

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../games/draw_record.dart';
import '../games/game_config.dart';
import 'draw_validation.dart';
import 'sync_config.dart';

class DrawSync {
  DrawSync._();

  static bool get enabled =>
      drawsBaseUrl.isNotEmpty &&
      !kIsWeb &&
      (Platform.isAndroid || Platform.isIOS);

  static const _prefKey = 'drawSyncAt';

  /// 복권별로 마지막으로 받은 관리자 정정 번호 (서버 manifest 의 revision)
  static String _revKey(String gameId) => 'drawRevision.$gameId';

  static Future<Directory> _cacheDir() async {
    final dir = Directory(
      '${(await getApplicationSupportDirectory()).path}/draws',
    );
    if (!await dir.exists()) await dir.create(recursive: true);
    return dir;
  }

  /// 이전에 내려받아 둔 당첨번호 (없으면 null). 시작할 때 내장 데이터보다 최신이면 이것을 씁니다.
  static Future<List<DrawRecord>?> cached(GameConfig game) async {
    if (!enabled) return null;
    try {
      final file = File('${(await _cacheDir()).path}/${game.id}.csv');
      if (!await file.exists()) return null;
      return validateRemoteDraws(game, await file.readAsString(), const []);
    } catch (e) {
      debugPrint('당첨번호 캐시 읽기 실패 (${game.id}): $e');
      return null;
    }
  }

  /// 새 회차가 있는 복권만 {복권id: 전체 당첨번호(최신이 앞)} 로 돌려줍니다.
  /// [local] 은 지금 앱이 쓰고 있는 당첨번호 (검증 기준).
  /// [force] 가 true 면 마지막 확인 시각과 상관없이 확인합니다 (앱 실행 시).
  static Future<Map<String, List<DrawRecord>>> run(
    List<GameConfig> games,
    Map<String, List<DrawRecord>> local, {
    bool force = false,
  }) async {
    if (!enabled) return {};
    final updates = <String, List<DrawRecord>>{};
    try {
      final prefs = await SharedPreferences.getInstance();
      final last = prefs.getInt(_prefKey);
      final now = DateTime.now().millisecondsSinceEpoch;
      if (!force &&
          last != null &&
          now - last < drawSyncInterval.inMilliseconds) {
        return {};
      }

      final manifest =
          jsonDecode(await _get('manifest.json')) as Map<String, dynamic>;
      final remoteGames = (manifest['games'] as Map<String, dynamic>?) ?? {};
      final dir = await _cacheDir();

      for (final game in games) {
        final info = remoteGames[game.id] as Map<String, dynamic>?;
        if (info == null) continue;
        final mine = local[game.id] ?? const <DrawRecord>[];
        final remoteRev = info['revision'] as int? ?? 0;
        final corrected = remoteRev > (prefs.getInt(_revKey(game.id)) ?? 0);
        if (!corrected && (info['count'] as int? ?? 0) <= mine.length) {
          continue;
        }

        final text = await _get(info['file'] as String);
        final draws = validateRemoteDraws(
          game,
          text,
          mine,
          allowCorrection: corrected,
        );
        if (draws == null) {
          debugPrint('당첨번호 검증 실패, 무시함 (${game.id})');
          continue;
        }
        await File(
          '${dir.path}/${game.id}.csv',
        ).writeAsString(text, flush: true);
        await prefs.setInt(_revKey(game.id), remoteRev);
        updates[game.id] = draws;
      }
      await prefs.setInt(_prefKey, now);
    } catch (e) {
      // 오프라인·서버 오류 등: 다음 실행 때 다시 시도
      debugPrint('당첨번호 자동 갱신 실패: $e');
    }
    return updates;
  }

  static Future<String> _get(String name) async {
    final client = HttpClient()
      ..connectionTimeout = const Duration(seconds: 10);
    try {
      // GitHub Pages 는 파일을 최대 10분 캐시합니다 (주소에 ?t= 를 붙여도 캐시를 건너뛰지 않음).
      final req = await client.getUrl(Uri.parse('$drawsBaseUrl$name'));
      final res = await req.close().timeout(const Duration(seconds: 20));
      if (res.statusCode != 200) {
        throw HttpException('HTTP ${res.statusCode}: $name');
      }
      return await res.transform(utf8.decoder).join();
    } finally {
      client.close();
    }
  }
}
