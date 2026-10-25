"""5_store_assets/스토어_등록_문구.md 의 항목별 글자 수 제한 확인.

  python -X utf8 tool/check_store_text.py
제한을 넘는 항목이 있으면 종료 코드 1.
"""
import re
import sys
from pathlib import Path

DOC = Path(__file__).resolve().parents[3] / "5_store_assets" / "스토어_등록_문구.md"

# 항목 이름(언어마다 다름) → (종류, 제한, 단위)
FIELDS = [
    (r"앱 이름|App name|Nombre|Nom|Name|アプリ名|Tên ứng dụng", "앱 이름", 30, "chars"),
    (r"부제|Subtitle|Subtítulo|Sous-titre|Untertitel|サブタイトル|Phụ đề", "iOS 부제", 30, "chars"),
    (r"짧은 설명|Short description|Descripción breve|Description courte|Kurzbeschreibung|簡単な説明|Mô tả ngắn", "Play 짧은 설명", 80, "chars"),
    (r"프로모션 문구|Promotional text|Texto promocional|Texte promotionnel|Werbetext|プロモーションテキスト|Văn bản quảng cáo", "iOS 프로모션", 170, "chars"),
    (r"키워드|Keywords|Palabras clave|Mots-clés|Schlüsselwörter|キーワード|Từ khóa", "iOS 키워드", 100, "bytes"),
]


def main():
    text = DOC.read_text(encoding="utf-8")
    sections = re.split(r"^## ", text, flags=re.M)[1:]
    bad = 0
    for sec in sections:
        lang = sec.splitlines()[0].strip()
        print(f"[{lang}]")
        for pattern, label, limit, unit in FIELDS:
            m = re.search(r"^\*\*(?:" + pattern + r")[^*]*\*\*\s*(.+)$", sec, flags=re.M)
            if not m:
                print(f"  ! {label}: 없음")
                bad += 1
                continue
            value = m.group(1).strip()
            size = len(value.encode("utf-8")) if unit == "bytes" else len(value)
            ok = size <= limit
            bad += 0 if ok else 1
            print(f"  {'OK ' if ok else 'NG '} {label}: {size}/{limit} {unit}")
        body = re.search(r"```\n(.*?)```", sec, flags=re.S)
        n = len(body.group(1)) if body else 0
        ok = 0 < n <= 4000
        bad += 0 if ok else 1
        print(f"  {'OK ' if ok else 'NG '} 자세한 설명: {n}/4000 chars")
    sys.exit(1 if bad else 0)


if __name__ == "__main__":
    main()
