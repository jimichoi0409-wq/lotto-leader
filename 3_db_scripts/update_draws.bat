@echo off
rem 당첨번호 수집 (이 PC 에서 실행하는 예비 방법)
rem  - 동행복권 사이트는 해외 서버(GitHub Actions)의 접속을 막을 수 있어, 한국 로또가 실패하면 이 파일을 쓰세요.
rem  - 윈도우 작업 스케줄러에 "매주 토요일 22:00" 으로 등록하면 자동으로 실행됩니다.
rem  - 저장소를 GitHub 에 올린 뒤라면 아래 git 명령으로 결과를 올려 앱이 받아 가게 합니다.
chcp 65001 > nul
cd /d "%~dp0.."
python -X utf8 3_db_scripts\collect_draws.py
if exist .git (
  git add 2_data docs\draws 1_app_flutter\lotto_app\assets
  git diff --cached --quiet || git commit -m "Update lottery draws (local)" && git push
)
