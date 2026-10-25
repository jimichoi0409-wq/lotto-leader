"""당첨번호 CSV → 앱용 DB(lotto.db) 생성 스크립트

매주 사용법:
  1) 2_data/lotto.csv 에 새 회차 한 줄 추가 (추첨일은 비워도 자동 계산)
  2) python create_lotto_db.py 실행

하는 일:
  - CSV를 UTF-8(BOM 없음)로 정규화하고 추첨일을 채워서
    2_data/lotto.csv 와 앱의 assets/lotto.csv 에 함께 저장
  - 앱의 assets/db/lotto.db 를 past_winners 테이블만으로 새로 생성

※ 폴더 이름은 영문을 유지하세요. 경로에 한글이 있으면 Windows에서 Android 빌드가 실패합니다.
"""
import csv
import datetime
import io
import sqlite3
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
CSV_PATH = ROOT / "2_data" / "lotto.csv"
APP_DIR = ROOT / "1_app_flutter" / "lotto_app"
APP_CSV_PATH = APP_DIR / "assets" / "lotto.csv"
DB_PATH = APP_DIR / "assets" / "db" / "lotto.db"

HEADER = ["회차", "추첨일", "번호1", "번호2", "번호3", "번호4", "번호5", "번호6", "보너스"]

# 1회 추첨일. 이후 매주 토요일 추첨 (1000회=2022-01-29, 1100회=2023-12-30 로 검증)
FIRST_DRAW_DATE = datetime.date(2002, 12, 7)


def draw_date_of(round_no):
    return (FIRST_DRAW_DATE + datetime.timedelta(weeks=round_no - 1)).isoformat()


def read_csv_text(path):
    raw = path.read_bytes()
    for enc in ("utf-8-sig", "cp949"):
        try:
            text = raw.decode(enc)
            print(f"CSV 인코딩 확인 완료: {enc}")
            return text
        except UnicodeDecodeError:
            pass
    raise RuntimeError("CSV 인코딩을 판별할 수 없습니다 (UTF-8 또는 CP949 필요).")


def to_int(value):
    value = str(value).strip()
    return int(value) if value else None


def validate_draw(round_no, nums, bonus):
    if round_no is None or round_no < 1:
        raise ValueError(f"회차 오류: {round_no}")
    if any(n is None or n < 1 or n > 45 for n in nums):
        raise ValueError(f"{round_no}회 번호 범위 오류: {nums}")
    if len(set(nums)) != 6:
        raise ValueError(f"{round_no}회 번호 중복 오류: {nums}")
    if bonus is not None:
        if bonus < 1 or bonus > 45:
            raise ValueError(f"{round_no}회 보너스 번호 범위 오류: {bonus}")
        if bonus in nums:
            raise ValueError(f"{round_no}회 보너스 번호가 1등 번호와 중복됨: {bonus}")


def parse_rows(text):
    rows = list(csv.reader(io.StringIO(text)))
    header = [h.strip().replace(" ", "") for h in rows[0]]
    col = {name: i for i, name in enumerate(header) if name}

    def get(row, name):
        i = col.get(name)
        return row[i].strip() if i is not None and i < len(row) else ""

    draws = {}
    for row in rows[1:]:
        if not row or all(not str(x).strip() for x in row):
            continue
        round_no = to_int(get(row, "회차"))
        nums = [to_int(get(row, f"번호{i}")) for i in range(1, 7)]
        bonus = to_int(get(row, "보너스"))
        validate_draw(round_no, nums, bonus)

        date = get(row, "추첨일") or draw_date_of(round_no)
        draws[round_no] = (round_no, date, *sorted(nums), bonus)

    missing = set(range(1, max(draws) + 1)) - set(draws)
    if missing:
        print(f"⚠ 빠진 회차가 있습니다: {sorted(missing)}")
    return [draws[k] for k in sorted(draws, reverse=True)]


def write_csv(draws, path):
    path.parent.mkdir(parents=True, exist_ok=True)
    with path.open("w", encoding="utf-8", newline="") as f:
        w = csv.writer(f, lineterminator="\n")
        w.writerow(HEADER)
        w.writerows(["" if v is None else v for v in d] for d in draws)


def same_db(draws, path):
    """기존 DB 의 내용이 같으면 True (SQLite 파일은 다시 만들 때마다 바이트가 달라져 불필요한 커밋이 생김)"""
    if not path.exists():
        return False
    try:
        conn = sqlite3.connect(path)
        rows = conn.execute("SELECT * FROM past_winners ORDER BY 회차 DESC").fetchall()
        conn.close()
    except sqlite3.Error:
        return False
    return rows == [tuple(d) for d in sorted(draws, key=lambda d: -d[0])]


def write_db(draws, path):
    path.parent.mkdir(parents=True, exist_ok=True)
    if same_db(draws, path):
        return
    if path.exists():
        path.unlink()
    conn = sqlite3.connect(path)
    conn.execute("""
        CREATE TABLE past_winners (
            회차 INTEGER PRIMARY KEY,
            추첨일 TEXT,
            번호1 INTEGER NOT NULL,
            번호2 INTEGER NOT NULL,
            번호3 INTEGER NOT NULL,
            번호4 INTEGER NOT NULL,
            번호5 INTEGER NOT NULL,
            번호6 INTEGER NOT NULL,
            보너스 INTEGER
        )
    """)
    conn.executemany("INSERT INTO past_winners VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)", draws)
    conn.commit()
    conn.execute("VACUUM")
    conn.close()


def main():
    if not CSV_PATH.exists():
        raise FileNotFoundError(f"lotto.csv 파일을 찾을 수 없습니다: {CSV_PATH}")

    draws = parse_rows(read_csv_text(CSV_PATH))

    write_csv(draws, CSV_PATH)
    write_csv(draws, APP_CSV_PATH)
    write_db(draws, DB_PATH)

    print("")
    print("완료")
    print(f"회차 수: {len(draws)} (최신 {draws[0][0]}회, {draws[0][1]})")
    print(f"최신 번호: {list(draws[0][2:8])} + 보너스 {draws[0][8]}")
    print(f"DB: {DB_PATH} ({DB_PATH.stat().st_size / 1024:.0f} KB)")
    print(f"CSV(UTF-8): {CSV_PATH}")
    print(f"CSV(UTF-8): {APP_CSV_PATH}")


if __name__ == "__main__":
    main()
