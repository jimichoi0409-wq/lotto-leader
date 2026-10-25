"""관리자 당첨번호 입력 처리 (GitHub 이슈 양식 → 검사 → 저장 → docs/draws 배포)

GitHub Actions(admin-draw-entry.yml)가 이슈 본문을 환경 변수 ISSUE_BODY 로 넘겨 실행합니다.
이 PC에서 직접 시험할 때:
  python -X utf8 3_db_scripts/admin_entry.py --body 본문.txt [--dry-run]

결과 메시지는 RESULT_FILE(기본 admin_result.md)에 쓰고, 실패하면 종료 코드 1.
- 추가: 해당 날짜가 없어야 함
- 정정: 해당 날짜가 있어야 함. 정정하면 그 복권의 revision 이 1 올라가고,
        앱은 revision 이 오른 것을 보고 이미 받은 회차도 고친 번호로 바꿉니다.
"""
import csv
import datetime as dt
import json
import os
import re
import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))
import collect_draws as cd  # noqa: E402

REVISIONS = cd.DATA_DIR / "revisions.json"


class EntryError(Exception):
    pass


def parse_form(body):
    """GitHub 이슈 양식 본문: '### 라벨\\n\\n값' 반복"""
    fields = {}
    for block in re.split(r"^###\s+", body or "", flags=re.M)[1:]:
        label, _, value = block.partition("\n")
        value = value.strip()
        if value == "_No response_":
            value = ""
        fields[label.strip()] = value
    try:
        game = fields["복권"].split("·")[0].strip()
        action = "correct" if fields["작업"].startswith("정정") else "add"
        date = fields["추첨일"].strip()
        main = cd.nums(fields["당첨번호"])
        bonus = cd.nums(fields.get("보너스·보조 번호", ""))
    except KeyError as e:
        raise EntryError(f"양식 항목이 없습니다: {e}") from None
    except ValueError:
        raise EntryError("번호는 숫자를 공백으로 구분해 입력하세요.") from None
    if not re.fullmatch(r"\d{4}-\d{2}-\d{2}", date):
        raise EntryError(f"추첨일 형식이 YYYY-MM-DD 가 아닙니다: {date}")
    return game, action, date, main, bonus


def load_existing(game_id):
    path = cd.DATA_DIR / f"{game_id}.csv"
    if not path.exists():
        return []
    with path.open(encoding="utf-8", newline="") as f:
        return [(r["draw_date"], cd.nums(r["main"]), cd.nums(r["bonus"])) for r in csv.DictReader(f)]


def load_revisions():
    if REVISIONS.exists():
        return json.loads(REVISIONS.read_text(encoding="utf-8"))
    return {}


def apply_entry(game_id, action, date, main, bonus):
    """검사만 하고 저장할 목록을 돌려줍니다. 문제가 있으면 EntryError."""
    games = cd.load_games()
    if game_id not in games:
        raise EntryError(f"모르는 복권입니다: {game_id}")
    game = games[game_id]
    # 미래 날짜 방지 (세계에서 가장 이른 시간대 UTC+14 기준으로도 아직 오지 않은 날)
    latest_possible = (dt.datetime.now(dt.timezone.utc) + dt.timedelta(hours=14)).date().isoformat()
    if date > latest_possible:
        raise EntryError(f"{date} 는 아직 오지 않은 날짜입니다.")
    if game["ruleSince"] and date < game["ruleSince"]:
        raise EntryError(f"{date} 는 현재 규칙 시작일({game['ruleSince']}) 이전입니다.")

    existing = load_existing(game_id)
    by_date = {d: (sorted(m), sorted(b)) for d, m, b in existing}
    if action == "add" and date in by_date:
        old = by_date[date]
        raise EntryError(f"{date} 회차가 이미 있습니다 ({' '.join(map(str, old[0]))} + {' '.join(map(str, old[1]))}). 고치려면 '정정'을 고르세요.")
    if action == "correct" and date not in by_date:
        raise EntryError(f"{date} 회차가 없습니다. 새 회차면 '추가'를 고르세요.")
    if action == "correct" and by_date[date] == (sorted(main), sorted(bonus)):
        raise EntryError("기존 번호와 같아서 고칠 것이 없습니다.")

    by_date[date] = (sorted(main), sorted(bonus))
    raw = [(d, m, b) for d, (m, b) in sorted(by_date.items())]
    errors, draws = cd.validate(game, raw)
    # 이번에 넣은 회차의 오류만 보여 줍니다 (기존 데이터는 이미 검사를 통과한 것)
    mine = [e for e in errors if date in e]
    if errors:
        raise EntryError("검사 실패:\n" + "\n".join(f"- {e}" for e in (mine or errors)[:10]))
    no = [i for i, d in enumerate(draws, start=1) if d[0] == date][0]
    return game, draws, no


def main(argv):
    body = os.environ.get("ISSUE_BODY", "")
    dry = "--dry-run" in argv
    if "--body" in argv:
        body = Path(argv[argv.index("--body") + 1]).read_text(encoding="utf-8")
    result_file = Path(os.environ.get("RESULT_FILE", "admin_result.md"))

    try:
        game_id, action, date, main, bonus = parse_form(body)
        game, draws, no = apply_entry(game_id, action, date, main, bonus)
    except EntryError as e:
        msg = f"❌ 처리하지 않았습니다.\n\n{e}\n\n이슈 본문을 고쳐서 저장하면 다시 검사합니다."
        result_file.write_text(msg, encoding="utf-8")
        print(msg)
        return 1

    name = game["name"].get("ko", game_id)
    nums = " ".join(map(str, sorted(main))) + (f" + {' '.join(map(str, sorted(bonus)))}" if bonus else "")
    if dry:
        msg = f"(시험) {name} {no}회 {date}: {nums} — 검사 통과, 저장하지 않음"
        result_file.write_text(msg, encoding="utf-8")
        print(msg)
        return 0

    cd.save(game_id, draws)
    if game_id == "kr645":
        cd._kr_write_source(draws)
    rev = load_revisions()
    if action == "correct":
        rev[game_id] = rev.get(game_id, 0) + 1
        REVISIONS.write_text(json.dumps(rev, ensure_ascii=False, indent=2) + "\n", encoding="utf-8", newline="\n")
    cd.publish()

    verb = "정정" if action == "correct" else "추가"
    msg = (f"✅ {name} {no}회 ({date}) {verb} 완료: **{nums}**\n\n"
           f"앱 사용자에게는 다음 확인 때(최대 1시간, 앱을 다시 열 때) 반영됩니다."
           + (f"\n\n정정 번호(revision) {rev[game_id]} — 이미 받은 사용자도 고친 번호로 바뀝니다." if action == "correct" else ""))
    result_file.write_text(msg, encoding="utf-8")
    print(msg)
    return 0


if __name__ == "__main__":
    sys.exit(main(sys.argv[1:]))
