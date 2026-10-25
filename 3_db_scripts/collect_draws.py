"""복권 당첨번호 수집·검증·배포 스크립트

사용법:
  python collect_draws.py                       # 전체 수집 후 docs/draws 에 배포 파일 생성
  python collect_draws.py kr645 powerball       # 일부만 수집 (배포 파일도 갱신)
  python collect_draws.py --import eurojackpot 받은파일.csv   # 직접 구한 CSV 검증 후 저장

결과
  2_data/<복권id>.csv     (열: draw_no,draw_date,main,bonus)
    - main/bonus 는 공백으로 구분한 오름차순 번호. 예) "5 12 23 41 60", "3 11"
    - 현재 규칙이 시작된 날(games.json 의 ruleSince) 이후 추첨만 저장합니다.
    - draw_no: 한국 6/45 는 공식 회차, 해외는 ruleSince 이후 1부터 매긴 일련번호.
  docs/draws/<복권id>.csv + manifest.json
    - GitHub Pages 로 공개되는 앱 동기화용 파일 (앱은 manifest 를 보고 바뀐 복권만 내려받음)
  한국 6/45 는 추가로 2_data/lotto.csv 를 갱신하고 create_lotto_db.py 로 앱 내장 DB 도 다시 만듭니다.

출처 (2026-10-14 확인):
  kr645        동행복권 추첨결과 페이지가 쓰는 조회 주소 /lt645/selectPstLt645InfoNew.do (한 번에 10회차)
               ※ 기존 주소(common.do?method=getLottoNumber)는 2026년 사이트 개편으로 폐지됨
               ※ 공식 공개 API 가 아니므로 바뀔 수 있음. 실패하면 검증에서 걸러지고 기존 데이터 유지
  powerball    https://data.ny.gov  데이터셋 d6yy-54nr (뉴욕주 공공데이터, 2010년~)
  megamillions https://data.ny.gov  데이터셋 5xaw-6ayf
  euromillions https://www.fdj.fr/jeux-de-tirage/euromillions-my-million/historique (FDJ 공식 ZIP)
  eurojackpot  에스토니아 공식 운영사 Eesti Loto API (api.eestiloto.ee, 최근 120회만 제공)
               → 기존 2_data 에 새 회차를 쌓아 가는 방식 (2026-10-25 추가)
  jp_loto6     くじしるべ 全回CSV (kujishirube.info/loto6/csv/) — 사이트가 영리·비영리 재배포를 명시적으로 허락
               (CSVの利用条件 2026年10月13日版). 공식 미즈호은행은 해외 접속 차단
  vn_mega645   NhanAZ-Data/vietlott-research (Vietlott 공식 결과 PDF 대조 기록 포함) 를 기본으로,
               vietvudanh/vietlott-data 와 겹치는 회차를 서로 대조해 하나라도 다르면 실패 처리.
               공식 vietlott.vn 은 해외 접속 차단. 데이터 이용 조건은 원 출처(Vietlott)를 따름
  ca649        자동 출처 없음. 과거분은 Kaggle "Lotto 6/49 Historical Dataset" (CC0) 를 --import 로 넣음 (2026-10-25,
               WCLC 공식 페이지 74회 대조 일치). 새 회차는 관리자 입력 양식(admin_entry.py)
  ie_lotto     자동 출처 없음. lottery.ie 는 한국 접속 차단(미국 GitHub 서버에서는 열림)이지만 약관이
               추출·재이용·상업적 이용을 금지(Terms and conditions v10, 2026-08) → 관리자 입력 양식만 사용
"""
import csv
import datetime as dt
import hashlib
import io
import json
import sys
import urllib.request
import zipfile
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
GAMES_JSON = ROOT / "1_app_flutter" / "lotto_app" / "assets" / "games" / "games.json"
DATA_DIR = ROOT / "2_data"
APP_DRAWS_DIR = ROOT / "1_app_flutter" / "lotto_app" / "assets" / "draws"
PUBLISH_DIR = ROOT / "docs" / "draws"
KR_CSV = DATA_DIR / "lotto.csv"  # 한국 6/45 원본 (create_lotto_db.py 입력)

# 한국 6/45: 앱은 내장 SQLite 를 쓰므로 assets/draws 에는 넣지 않습니다.
NOT_BUNDLED = {"kr645"}

USER_AGENT = "LottoLeader-DataCollector/1.0"
WEEKDAYS = ["MON", "TUE", "WED", "THU", "FRI", "SAT", "SUN"]

FDJ_EUROMILLIONS_ZIPS = [
    # 2016-09 이후(럭키스타 1~12)만 필요하므로 그 이전 파일은 받지 않습니다.
    "https://www.sto.api.fdj.fr/anonymous/service-draw-info/v3/documentations/1a2b3c4d-9876-4562-b3fc-2c963f66afc6",  # 2016-09 ~ 2019-02
    "https://www.sto.api.fdj.fr/anonymous/service-draw-info/v3/documentations/1a2b3c4d-9876-4562-b3fc-2c963f66afd6",  # 2019-03 ~ 2020-02
    "https://www.sto.api.fdj.fr/anonymous/service-draw-info/v3/documentations/1a2b3c4d-9876-4562-b3fc-2c963f66afe6",  # 2020-02 ~ 현재
]


def load_games():
    with GAMES_JSON.open(encoding="utf-8") as f:
        return {g["id"]: g for g in json.load(f)["games"]}


def http_get(url):
    req = urllib.request.Request(url, headers={"User-Agent": USER_AGENT})
    with urllib.request.urlopen(req, timeout=60) as resp:
        return resp.read()


def nums(text):
    return sorted(int(x) for x in str(text).replace(",", " ").split())


# ---------------------------------------------------------------- 수집기
def fetch_ny_open_data(dataset_id):
    url = f"https://data.ny.gov/resource/{dataset_id}.json?$limit=50000&$order=draw_date"
    return json.loads(http_get(url))


def collect_powerball():
    draws = []
    for r in fetch_ny_open_data("d6yy-54nr"):
        balls = [int(x) for x in r["winning_numbers"].split()]
        if len(balls) != 6:
            raise ValueError(f"Powerball 번호 형식 오류: {r}")
        draws.append((r["draw_date"][:10], sorted(balls[:5]), [balls[5]]))
    return draws


def collect_megamillions():
    draws = []
    for r in fetch_ny_open_data("5xaw-6ayf"):
        draws.append((r["draw_date"][:10], nums(r["winning_numbers"]), [int(r["mega_ball"])]))
    return draws


def parse_fdj_date(text):
    text = text.strip()
    for fmt in ("%d/%m/%Y", "%Y%m%d", "%d/%m/%y", "%Y-%m-%d"):
        try:
            return dt.datetime.strptime(text, fmt).date().isoformat()
        except ValueError:
            pass
    raise ValueError(f"FDJ 날짜 형식을 알 수 없습니다: {text}")


def collect_euromillions():
    draws = []
    for url in FDJ_EUROMILLIONS_ZIPS:
        with zipfile.ZipFile(io.BytesIO(http_get(url))) as z:
            for name in z.namelist():
                if not name.lower().endswith(".csv"):
                    continue
                text = z.read(name).decode("utf-8-sig", errors="replace")
                for row in csv.DictReader(io.StringIO(text), delimiter=";"):
                    row = {k.strip().lower(): (v or "").strip() for k, v in row.items() if k}
                    main = sorted(int(row[f"boule_{i}"]) for i in range(1, 6))
                    stars = sorted(int(row[f"etoile_{i}"]) for i in range(1, 3))
                    draws.append((parse_fdj_date(row["date_de_tirage"]), main, stars))
    return draws


KR_FIRST_DRAW = dt.date(2002, 12, 7)
KR_API = "https://www.dhlottery.co.kr/lt645/selectPstLt645InfoNew.do?srchDir=center&srchLtEpsd={}"


def _kr_existing():
    """2_data/lotto.csv (회차,추첨일,번호1~6,보너스) → {회차: (날짜, 메인, 보너스)}"""
    draws = {}
    with KR_CSV.open(encoding="utf-8-sig", newline="") as f:
        for r in csv.DictReader(f):
            no = int(r["회차"])
            draws[no] = (r["추첨일"], sorted(int(r[f"번호{i}"]) for i in range(1, 7)), [int(r["보너스"])])
    return draws


def collect_kr645():
    """기존 데이터 + 동행복권에서 새 회차만 받아 합칩니다 (보통 요청 1~2번)."""
    draws = _kr_existing()
    last = max(draws)
    # 오늘까지 나왔어야 하는 최신 회차 (토요일 추첨, 한국 시간 기준)
    today_kst = (dt.datetime.now(dt.timezone.utc) + dt.timedelta(hours=9)).date()
    expected = (today_kst - KR_FIRST_DRAW).days // 7 + 1

    want = last + 1
    while want <= expected:
        data = json.loads(http_get(KR_API.format(want)))
        rows = (data.get("data") or {}).get("list") or []
        got = 0
        for r in rows:
            no = int(r["ltEpsd"])
            ymd = str(r["ltRflYmd"])
            date = f"{ymd[:4]}-{ymd[4:6]}-{ymd[6:]}"
            main = sorted(int(r[f"tm{i}WnNo"]) for i in range(1, 7))
            entry = (date, main, [int(r["bnsWnNo"])])
            if no in draws and draws[no] != entry:
                raise ValueError(f"kr645 {no}회: 기존 데이터와 동행복권 응답이 다릅니다 {draws[no]} / {entry}")
            if no not in draws:
                draws[no] = entry
                got += 1
        if not got:
            break  # 아직 추첨 전이거나 응답에 새 회차가 없음
        want = max(draws) + 1

    missing = set(range(1, max(draws) + 1)) - set(draws)
    if missing:
        raise ValueError(f"kr645 빠진 회차: {sorted(missing)[:10]}")
    return [draws[k] for k in sorted(draws)]


def _kr_write_source(draws):
    """한국 원본 CSV(최신 회차가 위) 갱신 후 앱 내장 DB·CSV 재생성"""
    with KR_CSV.open("w", encoding="utf-8", newline="") as f:
        w = csv.writer(f, lineterminator="\n")
        w.writerow(["회차", "추첨일", "번호1", "번호2", "번호3", "번호4", "번호5", "번호6", "보너스"])
        for no in range(len(draws), 0, -1):
            date, main, bonus = draws[no - 1]
            w.writerow([no, date, *main, *bonus])
    sys.path.insert(0, str(Path(__file__).resolve().parent))
    import create_lotto_db
    create_lotto_db.main()


def import_file(path):
    """직접 구한 CSV. 필요한 열: draw_date(YYYY-MM-DD), main, bonus (번호는 공백 또는 쉼표 구분)"""
    with open(path, encoding="utf-8-sig", newline="") as f:
        return [(r["draw_date"].strip(), nums(r["main"]), nums(r.get("bonus", "")))
                for r in csv.DictReader(f)]


def _existing(game_id):
    """2_data/<id>.csv 의 기존 기록 [(날짜, 메인, 보조)]"""
    path = DATA_DIR / f"{game_id}.csv"
    if not path.exists():
        return []
    with path.open(encoding="utf-8", newline="") as f:
        return [(r["draw_date"], nums(r["main"]), nums(r["bonus"])) for r in csv.DictReader(f)]


def _merge(game_id, fresh):
    """기존 기록 + 새로 받은 기록. 같은 날짜인데 번호가 다르면 출처 이상으로 보고 중단."""
    by_date = {d: (m, b) for d, m, b in _existing(game_id)}
    for d, m, b in fresh:
        if d in by_date and by_date[d] != (m, b):
            raise RuntimeError(f"{game_id} {d}: 기존 {by_date[d]} 와 새 출처 {(m, b)} 가 다름 — 확인 필요")
        by_date[d] = (m, b)
    return [(d, *by_date[d]) for d in sorted(by_date)]


# ---------------------------------------------------------------- 유로잭팟 (Eesti Loto 공식 API)
EESTI_API = "https://api.eestiloto.ee/api/v1"


def _eesti_get(path, params=None):
    url = EESTI_API + path
    if params:
        url += "?" + "&".join(f"{k}={v}" for k, v in params.items())
    req = urllib.request.Request(url, headers={"User-Agent": USER_AGENT, "Accept": "application/json"})
    with urllib.request.urlopen(req, timeout=60) as resp:
        return json.loads(resp.read())


def collect_eurojackpot():
    game_id = next(g["id"] for g in _eesti_get("/games") if (g.get("gameCode") or "").upper() == "EUROJACKPOT")
    known = {d for d, _, _ in _existing("eurojackpot")}
    fresh, page = [], 1
    while True:
        data = _eesti_get("/draws", {"status": "DRAW_COMPLETED", "gameId": game_id,
                                      "page": page, "size": 30, "sort": "dateTime:desc"})
        items = data.get("content") or []
        new_items = [x for x in items if x["dateTime"][:10] not in known]
        for item in new_items:
            detail = _eesti_get(f"/draws/{item['id']}")
            stages = {s.get("code"): s.get("winningNumbers") or [] for s in (detail.get("results") or {}).get("stages") or []}
            fresh.append((item["dateTime"][:10], sorted(stages.get("MAIN-NUMBERS", [])),
                          sorted(stages.get("ADDITIONAL-NUMBERS", []))))
        total = (data.get("page") or {}).get("totalPages") or 1
        if not new_items or page >= total:
            break
        page += 1
    return _merge("eurojackpot", fresh)


# ---------------------------------------------------------------- 일본 로토6 (くじしるべ, 재배포 허락)
KUJISHIRUBE_LOTO6 = "https://kujishirube.info/loto6/csv/loto6-all.csv"


def collect_jp_loto6():
    text = http_get(KUJISHIRUBE_LOTO6).decode("utf-8-sig")
    rows = list(csv.reader(io.StringIO(text)))
    head, body = rows[0], rows[1:]
    if head[:9] != ["回号", "抽選日", "本数字1", "本数字2", "本数字3", "本数字4", "本数字5", "本数字6", "ボーナス数字1"]:
        raise RuntimeError(f"jp_loto6: CSV 형식이 바뀜 {head[:9]}")
    draws = []
    for i, r in enumerate(body, start=1):
        if int(r[0]) != i:
            raise RuntimeError(f"jp_loto6: 회차가 빠지거나 순서가 다름 (줄 {i}, 회차 {r[0]})")
        draws.append((r[1], sorted(int(x) for x in r[2:8]), [int(r[8])]))
    _check_official("jp_loto6", draws)
    return _merge("jp_loto6", draws)


def _check_official(game_id, draws):
    """2_data/official_checks/<id>_*.csv (사람이 공식 사이트에서 확인한 값)와 하나라도 다르면 중단"""
    by_date = {d: (m, b) for d, m, b in draws}
    for path in sorted((DATA_DIR / "official_checks").glob(f"{game_id}_*.csv")):
        with path.open(encoding="utf-8", newline="") as f:
            for r in csv.DictReader(f):
                want = (nums(r["main"]), nums(r["bonus"]))
                if r["draw_date"] not in by_date:
                    raise RuntimeError(f"{game_id} {r['draw_date']}: 공식 확인 회차가 수집 데이터에 없음 ({path.name})")
                if by_date[r["draw_date"]] != want:
                    raise RuntimeError(f"{game_id} {r['draw_date']}: 공식 {want} ≠ 수집 {by_date[r['draw_date']]} ({path.name})")


# ---------------------------------------------------------------- 베트남 메가 6/45 (공개 저장소 2곳 대조)
VN_PRIMARY = "https://raw.githubusercontent.com/NhanAZ-Data/vietlott-research/main/datasets/draws/mega645/all.csv"
VN_SECONDARY = "https://raw.githubusercontent.com/vietvudanh/vietlott-data/main/data/power645.jsonl"


def collect_vn_mega645():
    primary = {}
    for r in csv.DictReader(io.StringIO(http_get(VN_PRIMARY).decode("utf-8"))):
        if r["draw_status"] != "confirmed":
            continue
        res = json.loads(r["result_json"])
        if res.get("special_numbers"):
            raise RuntimeError(f"vn_mega645 {r['draw_date']}: 보너스 번호가 있음 (규칙 변경?)")
        primary[r["draw_date"]] = (int(r["draw_id"]), sorted(res["numbers"]))
    secondary = {}
    for line in http_get(VN_SECONDARY).decode("utf-8").splitlines():
        if line.strip():
            x = json.loads(line)
            secondary[x["date"]] = (int(x["id"]), sorted(x["result"]))
    diff = [d for d in set(primary) & set(secondary) if primary[d] != secondary[d]]
    if diff:
        raise RuntimeError(f"vn_mega645: 두 출처가 다른 회차 {sorted(diff)[:5]} — 확인 필요")
    ids = [primary[d][0] for d in sorted(primary)]
    if ids != list(range(1, len(ids) + 1)):
        raise RuntimeError("vn_mega645: 회차 번호가 연속되지 않음")
    return _merge("vn_mega645", [(d, primary[d][1], []) for d in sorted(primary)])


COLLECTORS = {
    "kr645": collect_kr645,
    "powerball": collect_powerball,
    "megamillions": collect_megamillions,
    "euromillions": collect_euromillions,
    "eurojackpot": collect_eurojackpot,
    "jp_loto6": collect_jp_loto6,
    "vn_mega645": collect_vn_mega645,
}


# ---------------------------------------------------------------- 검증·저장
def validate(game, draws):
    """현재 규칙 이후 추첨만 남기고, 규칙 위반이 하나라도 있으면 저장하지 않습니다."""
    since = game["ruleSince"] or "0000-00-00"
    main_cfg, bonus_cfg = game["main"], game["bonus"]
    expect_bonus = bonus_cfg["count"]
    errors, kept, seen = [], {}, set()

    for date, main, bonus in draws:
        if date < since:
            continue
        where = f"{game['id']} {date}"
        weekday = WEEKDAYS[dt.date.fromisoformat(date).weekday()]
        if weekday not in game["drawDays"]:
            errors.append(f"{where}: 추첨 요일이 아님 ({weekday})")
        if len(main) != main_cfg["count"] or len(set(main)) != len(main):
            errors.append(f"{where}: 메인 번호 개수/중복 오류 {main}")
        if any(not 1 <= n <= main_cfg["max"] for n in main):
            errors.append(f"{where}: 메인 번호 범위 오류 {main}")
        if len(bonus) != expect_bonus or len(set(bonus)) != len(bonus):
            errors.append(f"{where}: 보조 번호 개수/중복 오류 {bonus}")
        if any(not 1 <= n <= bonus_cfg["max"] for n in bonus):
            errors.append(f"{where}: 보조 번호 범위 오류 {bonus}")
        if not bonus_cfg["playerPicks"] and set(bonus) & set(main):
            errors.append(f"{where}: 보너스 번호가 메인 번호와 중복 {bonus}")
        if date in seen:
            if kept[date] != (main, bonus):
                errors.append(f"{where}: 같은 날짜에 다른 번호가 두 번 나옴")
            continue
        seen.add(date)
        kept[date] = (main, bonus)

    return errors, [(d, *kept[d]) for d in sorted(kept)]


def save(game_id, draws):
    """2_data 에 저장하고, 앱에 내장할 수 있게 assets/draws 에도 같은 파일을 씁니다."""
    path = DATA_DIR / f"{game_id}.csv"
    targets = [path] if game_id in NOT_BUNDLED else [path, APP_DRAWS_DIR / f"{game_id}.csv"]
    for target in targets:
        target.parent.mkdir(parents=True, exist_ok=True)
        with target.open("w", encoding="utf-8", newline="") as f:
            w = csv.writer(f, lineterminator="\n")
            w.writerow(["draw_no", "draw_date", "main", "bonus"])
            for no, (date, main, bonus) in enumerate(draws, start=1):
                w.writerow([no, date, " ".join(map(str, main)), " ".join(map(str, bonus))])
    return path


def run(game_id, raw):
    game = load_games()[game_id]
    errors, draws = validate(game, raw)
    if errors:
        print(f"[실패] {game_id}: 검증 실패 {len(errors)}건 — 저장하지 않았습니다.")
        for e in errors[:20]:
            print("   ", e)
        return False
    path = save(game_id, draws)
    if game_id == "kr645":
        _kr_write_source(draws)
    first, last = draws[0], draws[-1]
    print(f"[완료] {game_id}: {len(draws)}회 ({first[0]} ~ {last[0]}), "
          f"최신 {' '.join(map(str, last[1]))} + {' '.join(map(str, last[2]))} → {path.name}")
    return True


def publish():
    """2_data/<id>.csv 를 docs/draws 로 복사하고 manifest.json 을 만듭니다 (GitHub Pages 로 공개)."""
    PUBLISH_DIR.mkdir(parents=True, exist_ok=True)
    # 관리자가 정정할 때마다 1 씩 오르는 번호 (앱은 이 값이 오르면 이미 받은 회차도 고친 번호로 교체)
    rev_path = DATA_DIR / "revisions.json"
    revisions = json.loads(rev_path.read_text(encoding="utf-8")) if rev_path.exists() else {}
    games = {}
    for game_id in load_games():
        src = DATA_DIR / f"{game_id}.csv"
        if not src.exists():
            continue
        body = src.read_bytes()
        (PUBLISH_DIR / f"{game_id}.csv").write_bytes(body)
        rows = [l for l in body.decode("utf-8").splitlines()[1:] if l.strip()]
        games[game_id] = {
            "file": f"{game_id}.csv",
            "count": len(rows),
            "latestDate": rows[-1].split(",")[1],
            "sha256": hashlib.sha256(body).hexdigest(),
            "revision": revisions.get(game_id, 0),
        }
    manifest = {"version": 1, "games": games}
    old = PUBLISH_DIR / "manifest.json"
    text = json.dumps(manifest, ensure_ascii=False, indent=2) + "\n"
    if not old.exists() or old.read_text(encoding="utf-8") != text:
        old.write_text(text, encoding="utf-8", newline="\n")
    print(f"[배포] docs/draws: {', '.join(f'{k} {v['count']}회' for k, v in games.items())}")


def main(argv):
    if len(argv) == 3 and argv[0] == "--import":
        ok = run(argv[1], import_file(argv[2]))
    else:
        targets = argv or list(COLLECTORS)
        results = []
        for g in targets:
            try:
                results.append(run(g, COLLECTORS[g]()))
            except Exception as e:  # 한 출처가 실패해도 나머지는 계속 (기존 데이터 유지)
                print(f"[실패] {g}: {e}")
                results.append(False)
        ok = all(results)
    publish()
    sys.exit(0 if ok else 1)


if __name__ == "__main__":
    main(sys.argv[1:])
