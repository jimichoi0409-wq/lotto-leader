"""당첨번호 지연 감지: 추첨 후 일정 시간이 지났는데 새 회차가 없으면 실패(종료 코드 1)로 알립니다.

GitHub Actions(update-draws.yml)가 매일 실행합니다. 실패하면 GitHub 가 관리자에게 메일을 보내므로,
메일을 받으면 관리자 입력 양식(Issues → 당첨번호 입력)으로 빠진 회차를 넣으면 됩니다.

  python -X utf8 3_db_scripts/check_stale.py            # 지금 기준
  python -X utf8 3_db_scripts/check_stale.py --now 2026-10-19T12:00:00Z

- 당첨번호 데이터가 아예 없는 복권(준비 중)은 '안내'만 하고 실패로 치지 않습니다.
- 추첨 시각 + GRACE_HOURS 가 지난 추첨만 '들어와 있어야 할 회차'로 봅니다.
"""
import datetime as dt
import json
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
GAMES_JSON = ROOT / "1_app_flutter" / "lotto_app" / "assets" / "games" / "games.json"
MANIFEST = ROOT / "docs" / "draws" / "manifest.json"
WEEKDAYS = ["MON", "TUE", "WED", "THU", "FRI", "SAT", "SUN"]

# 추첨 후 이만큼 지나도 없으면 지연으로 봅니다 (출처 반영 지연 여유)
GRACE_HOURS = 18

# 시간대 DB 가 없는 PC(Windows)에서 시험할 때만 쓰는 표준시 (서머타임 무시)
_FALLBACK_OFFSETS = {
    "Asia/Seoul": 9, "Asia/Tokyo": 9, "Asia/Ho_Chi_Minh": 7,
    "America/New_York": -5, "America/Toronto": -5,
    "Europe/Paris": 1, "Europe/Helsinki": 2, "Europe/Dublin": 0,
}


def tz_of(name):
    try:
        from zoneinfo import ZoneInfo
        return ZoneInfo(name)
    except Exception:
        return dt.timezone(dt.timedelta(hours=_FALLBACK_OFFSETS.get(name, 0)))


def expected_latest(game, now_utc):
    """지금 기준으로 이미 들어와 있어야 할 가장 최근 추첨일 (현지 날짜)"""
    tz = tz_of(game["timezone"])
    hh, mm = map(int, game.get("drawTime", "20:00").split(":"))
    local_now = now_utc.astimezone(tz)
    for back in range(0, 15):
        day = (local_now - dt.timedelta(days=back)).date()
        if WEEKDAYS[day.weekday()] not in game["drawDays"]:
            continue
        draw_at = dt.datetime(day.year, day.month, day.day, hh, mm, tzinfo=tz)
        if draw_at + dt.timedelta(hours=GRACE_HOURS) <= local_now:
            return day
    return None


def check(now_utc):
    games = json.loads(GAMES_JSON.read_text(encoding="utf-8"))["games"]
    manifest = json.loads(MANIFEST.read_text(encoding="utf-8")) if MANIFEST.exists() else {"games": {}}
    stale, pending, ok = [], [], []
    for g in games:
        info = manifest["games"].get(g["id"])
        name = g["name"].get("ko", g["id"])
        if not info:
            pending.append(name)
            continue
        want = expected_latest(g, now_utc)
        have = dt.date.fromisoformat(info["latestDate"])
        if want and have < want:
            stale.append(f"{name}: 최신 {have}, 들어와 있어야 할 회차 {want}")
        else:
            ok.append(f"{name} ({have})")
    return stale, pending, ok


def main(argv):
    now = dt.datetime.now(dt.timezone.utc)
    if "--now" in argv:
        now = dt.datetime.fromisoformat(argv[argv.index("--now") + 1].replace("Z", "+00:00"))
    stale, pending, ok = check(now)
    print("[정상] " + (", ".join(ok) or "없음"))
    if pending:
        print("[안내] 당첨번호 데이터 준비 중(감시 안 함): " + ", ".join(pending))
    if stale:
        print("::error::새 회차가 들어오지 않았습니다. 관리자 입력 양식으로 넣어 주세요.")
        for s in stale:
            print(f"::error::{s}")
        return 1
    return 0


if __name__ == "__main__":
    sys.exit(main(sys.argv[1:]))
