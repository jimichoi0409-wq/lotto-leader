# Lotto Leader — winning numbers data sources

These files are published for the Lotto Leader app. Results are provided for reference only and are not official.
Always check the official lottery operator for the final results.

| File | Lottery | Source | Notes |
|---|---|---|---|
| `kr645.csv` | Lotto 6/45 (Korea) | Dong-hang Lottery results pages (dhlottery.co.kr) | |
| `powerball.csv` | Powerball (US) | New York State Open Data, dataset d6yy-54nr (data.ny.gov) | |
| `megamillions.csv` | Mega Millions (US) | New York State Open Data, dataset 5xaw-6ayf (data.ny.gov) | Current rules since 2025-04-08 |
| `euromillions.csv` | EuroMillions | FDJ results archives (fdj.fr) | Since 2016-09-27 (Lucky Stars 1–12) |
| `eurojackpot.csv` | Eurojackpot | Eesti Loto (eestiloto.ee), an official Eurojackpot operator | History from 2025-09-02, accumulated from then on |
| `jp_loto6.csv` | Loto 6 (Japan) | くじしるべ (kujishirube.info), loto6-all.csv | The site grants free reuse and redistribution, commercial or not (CSVの利用条件, 2026-10-13). Every collection is checked against 47 draws confirmed on the official Mizuho Bank results pages (draws 1–20, 981–1000, 2142–2148) |
| `vn_mega645.csv` | Mega 6/45 (Vietnam) | Vietlott results as archived by NhanAZ-Data/vietlott-research, cross-checked against vietvudanh/vietlott-data | Any draw where the two archives disagree is rejected. The data remains subject to the original source's (Vietlott) conditions |
| `ca649.csv` | Lotto 6/49 (Canada) | "Lotto 6/49 Historical Dataset (1982-2026)" by Mark Kruger on Kaggle (CC0 1.0; the bundled LICENSE file is MIT, Copyright (c) 2025 Lotto 6/49 Historical Dataset), draws up to 2026-07-15. Later draws entered by the operator from official announcements | 74 overlapping draws (2025-11 to 2026-07) match the official WCLC results pages exactly, and every row's position equals the official draw number |
| (manual) | Irish Lotto | Entered by the operator from official announcements | |

Corrections are tracked with the `revision` field in `manifest.json`.
Contact: jnhteamsoft@gmail.com
