// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Vietnamese (`vi`).
class AppLocalizationsVi extends AppLocalizations {
  AppLocalizationsVi([String locale = 'vi']) : super(locale);

  @override
  String get appTitle => 'Lotto Leader';

  @override
  String get close => 'Đóng';

  @override
  String get apply => 'Áp dụng';

  @override
  String get lookup => 'Xem';

  @override
  String get calculating => 'Đang tính…';

  @override
  String get extracting => 'Đang tạo…';

  @override
  String get extractButton => 'Tạo số';

  @override
  String get countHint => 'SL';

  @override
  String get remainingCombos => 'Số tổ hợp còn lại';

  @override
  String get menuResults => 'Kết quả';

  @override
  String get menuReset => 'Đặt lại';

  @override
  String get menuAlarm => 'Nhắc nhở';

  @override
  String get menuSettings => 'Cài đặt';

  @override
  String get privacyPolicy => 'Chính sách quyền riêng tư';

  @override
  String get disclaimer => 'Miễn trừ trách nhiệm';

  @override
  String get contact => 'Liên hệ';

  @override
  String get versionLabel => 'Phiên bản';

  @override
  String currentVersion(String version) {
    return 'Phiên bản ứng dụng hiện tại $version';
  }

  @override
  String get language => 'Ngôn ngữ';

  @override
  String get languageSystem => 'Dùng ngôn ngữ của thiết bị';

  @override
  String drawAlarm(String game) {
    return 'Nhắc ngày quay số $game';
  }

  @override
  String get resetDone => 'Đã đặt lại về cài đặt mặc định.';

  @override
  String get privacyText =>
      'Ứng dụng này miễn phí. Lần đầu mở ứng dụng, bạn tạo một hồ sơ đơn giản chỉ với biệt danh. Biệt danh và lịch sử tạo số chỉ được lưu trên thiết bị này, không bao giờ gửi cho đơn vị vận hành và có thể xóa bất cứ lúc nào tại Cài đặt → Xóa tài khoản.\n\nBản thân ứng dụng không thu thập thông tin nhận dạng cá nhân như tên, số điện thoại hay email.\n\nỨng dụng dùng Google AdMob để hiển thị quảng cáo. Trong quá trình đó, Google có thể thu thập ID quảng cáo, thông tin thiết bị và thông tin sử dụng ứng dụng. Ở những nơi cần sự đồng ý (ví dụ EEA và Vương quốc Anh), bạn sẽ được hỏi khi mở ứng dụng lần đầu và có thể thay đổi bất cứ lúc nào tại Cài đặt → Quyền riêng tư quảng cáo.\n\nCác thông tin này có thể được dùng để phân phối quảng cáo, cải thiện chất lượng ứng dụng và ngăn chặn gian lận.';

  @override
  String get disclaimerText =>
      'Ứng dụng này là công cụ cung cấp thống kê các số trúng thưởng trước đây và giúp bạn tạo tổ hợp số.\n\nỞ mọi loại xổ số, mỗi tổ hợp đều có cơ hội trúng giải độc đắc hoàn toàn như nhau (ví dụ 1/8.145.060 với Lotto 6/45 của Hàn Quốc và 1/292.201.338 với Powerball). Bộ lọc và thống kê trong ứng dụng không làm tăng cơ hội trúng thưởng. Vui lòng chỉ dùng để giải trí và tham khảo.\n\nĐây là ứng dụng độc lập và không liên kết với bất kỳ đơn vị vận hành xổ số nào (bao gồm Dong-hang Lottery, Powerball, Mega Millions, Lotto 6/49, EuroMillions, Eurojackpot, Loto 6, Irish Lotto hay Vietlott).\n\nỨng dụng không đảm bảo trúng thưởng. Bạn tự chịu trách nhiệm khi mua và chơi xổ số.\n\nỨng dụng không bán vé và không cung cấp dịch vụ cá cược, thưởng tiền mặt hay cờ bạc.';

  @override
  String get contactText =>
      'Nếu bạn có câu hỏi, gặp lỗi hoặc có góp ý, vui lòng gửi email cho chúng tôi.\n\nĐơn vị vận hành: 한지성\nEmail: jnhteamsoft@gmail.com\n\nChúng tôi thường trả lời trong vòng 3 ngày làm việc.';

  @override
  String get chooseLottery => 'Chọn xổ số';

  @override
  String gameRule(String count, String max) {
    return '$count số (1–$max)';
  }

  @override
  String gameRuleBonus(String label, String count, String max) {
    return ' + $count $label (1–$max)';
  }

  @override
  String jackpotOdds(String odds) {
    return 'Xác suất độc đắc 1/$odds';
  }

  @override
  String drawCount(String count) {
    return '$count kỳ quay';
  }

  @override
  String get drawsPending => 'Sắp có kết quả';

  @override
  String get drawRoundPrefix => 'Kỳ #';

  @override
  String get drawRoundSuffix => '';

  @override
  String get drawResultPrefix => 'Kết quả ';

  @override
  String get drawResultSuffix => '';

  @override
  String drawDate(String date) {
    return 'Quay ngày $date';
  }

  @override
  String get noDrawDate => 'Không rõ ngày quay';

  @override
  String get noResultsStored =>
      'Chưa có kết quả trước đây.\n(Kết quả của xổ số này sẽ sớm có.)';

  @override
  String get dbLoading => 'Đang tải kết quả. Vui lòng thử lại sau giây lát.';

  @override
  String get dbLoadingShort => 'Đang tải kết quả…';

  @override
  String get dbLoadFailed => 'Không tải được kết quả.';

  @override
  String get freqPrefix => '[';

  @override
  String get freqSuffix => '] kỳ gần nhất: ra nhiều | ít nhất';

  @override
  String get freqHint => 'tất cả';

  @override
  String get mostDrawn => 'Ra nhiều nhất';

  @override
  String get leastDrawn => 'Ra ít nhất';

  @override
  String get noDrawData => 'Xổ số này chưa có dữ liệu kết quả.';

  @override
  String get recentTooLarge =>
      'Số kỳ nhập lớn hơn số kỳ đã lưu nên dùng tất cả các kỳ.';

  @override
  String get freqError => 'Không tính được tần suất.';

  @override
  String includeExcludeHeader(String maxInc) {
    return 'Chọn (tối đa $maxInc) | Loại (tối đa 18)';
  }

  @override
  String get includeRow => 'Số chọn';

  @override
  String get excludeRow => 'Số loại';

  @override
  String get includeBonusRow => 'Số chọn';

  @override
  String get excludeBonusRow => 'Số loại';

  @override
  String bonusHeader(String label, String max, String inc, String exc) {
    return '$label (1–$max, chọn tối đa $inc · loại tối đa $exc)';
  }

  @override
  String get numbersWord => 'số';

  @override
  String pickerInclude(String kind) {
    return 'Chọn $kind';
  }

  @override
  String pickerExclude(String kind) {
    return 'Loại $kind';
  }

  @override
  String pickerConflict(String number) {
    return '$number đã có trong danh sách còn lại.';
  }

  @override
  String pickerMax(String max) {
    return 'Bạn có thể chọn tối đa $max.';
  }

  @override
  String get includeLabel => 'Số chọn';

  @override
  String get excludeLabel => 'Số loại';

  @override
  String includeBonusLabel(String label) {
    return '$label chọn';
  }

  @override
  String excludeBonusLabel(String label) {
    return '$label loại';
  }

  @override
  String notNumber(String label, String raw) {
    return '$label: \"$raw\" không phải là số.';
  }

  @override
  String outOfRange(String label, String max) {
    return '$label phải từ 1 đến $max.';
  }

  @override
  String get dupInclude => 'Số chọn bị trùng.';

  @override
  String get dupExclude => 'Số loại bị trùng.';

  @override
  String conflict(String numbers) {
    return 'Các số vừa được chọn vừa bị loại: $numbers';
  }

  @override
  String get calcError => 'Tính toán thất bại. Vui lòng kiểm tra bộ lọc.';

  @override
  String get busy => 'Đang tính. Vui lòng đợi!';

  @override
  String get noResults => 'Không còn tổ hợp nào. Vui lòng đổi cài đặt.';

  @override
  String tooMany(String count) {
    return 'Chỉ còn $count tổ hợp nên sẽ tạo $count tổ hợp.';
  }

  @override
  String get noExtract => 'Không có tổ hợp nào. Vui lòng đổi cài đặt.';

  @override
  String get extractError => 'Không tạo được số. Vui lòng kiểm tra cài đặt.';

  @override
  String get resultsTitle => 'Tổ hợp của bạn';

  @override
  String get copied => 'Đã sao chép số.';

  @override
  String get copyButton => 'Sao chép';

  @override
  String get shareButton => 'Chia sẻ';

  @override
  String shareHeader(String game) {
    return '🍀Số $game của tôi🍀';
  }

  @override
  String get shareSubject => 'Số xổ số của tôi';

  @override
  String get noHelp => 'Không có mô tả.';

  @override
  String get obWelcome => 'Chào mừng đến với Lotto Leader';

  @override
  String get obChooseLanguage =>
      'Hãy chọn ngôn ngữ. Bạn có thể đổi lại trong Cài đặt.';

  @override
  String get obNext => 'Tiếp';

  @override
  String get obBack => 'Quay lại';

  @override
  String get obProfileTitle => 'Đăng ký nhanh';

  @override
  String get obProfileBody =>
      'Chỉ cần chọn biệt danh để bắt đầu.\nHồ sơ và lịch sử chỉ được lưu trên thiết bị này.';

  @override
  String get obNickname => 'Biệt danh';

  @override
  String get obNicknameHint => '2–12 ký tự';

  @override
  String get obNicknameError => 'Vui lòng nhập biệt danh từ 2–12 ký tự.';

  @override
  String get obAge => 'Tôi đủ tuổi chơi xổ số theo quy định ở nước tôi';

  @override
  String get obAgree =>
      'Tôi đồng ý với Chính sách quyền riêng tư và Miễn trừ trách nhiệm';

  @override
  String get obView => 'Xem';

  @override
  String get obStart => 'Bắt đầu';

  @override
  String get obNeedChecks => 'Vui lòng xác nhận tất cả mục bắt buộc.';

  @override
  String get menuHistory => 'Lịch sử';

  @override
  String historyJoined(String date) {
    return 'Tham gia $date';
  }

  @override
  String historyStats(int count) {
    return '$count lần tạo số';
  }

  @override
  String get historyEmpty => 'Chưa có lịch sử.\nTổ hợp bạn tạo sẽ hiện ở đây.';

  @override
  String historyTickets(int count) {
    return '$count tổ hợp';
  }

  @override
  String historyFilters(int count) {
    return '$count bộ lọc';
  }

  @override
  String get historyClearAll => 'Xóa toàn bộ lịch sử';

  @override
  String get historyClearConfirm => 'Xóa toàn bộ lịch sử tạo số?';

  @override
  String get historyDeleted => 'Đã xóa mục này.';

  @override
  String get delete => 'Xóa';

  @override
  String get cancel => 'Hủy';

  @override
  String get confirm => 'OK';

  @override
  String profileNickname(String name) {
    return 'Biệt danh: $name';
  }

  @override
  String get withdraw => 'Xóa tài khoản (hồ sơ và lịch sử)';

  @override
  String get withdrawConfirm =>
      'Hồ sơ và lịch sử sẽ bị xóa khỏi thiết bị này và bạn sẽ quay về màn hình đầu. Tiếp tục?';

  @override
  String get manualEntry => 'Nhập kết quả thủ công';

  @override
  String get manualHelp =>
      'Dùng khi cập nhật tự động không hoạt động, dựa theo kết quả chính thức. Dữ liệu chính thức cùng ngày sẽ thay thế mục bạn nhập.';

  @override
  String get manualRound => 'Kỳ số';

  @override
  String get manualDate => 'Ngày quay';

  @override
  String manualMain(String count) {
    return '$count số trúng thưởng';
  }

  @override
  String manualBonus(String label, String count) {
    return '$label: $count';
  }

  @override
  String get manualSave => 'Lưu';

  @override
  String get manualSaved => 'Đã lưu kết quả.';

  @override
  String get manualList => 'Mục bạn đã nhập';

  @override
  String get manualNone => 'Chưa có mục nhập thủ công.';

  @override
  String get manualTag => 'Thủ công';

  @override
  String get mErrRound => 'Vui lòng kiểm tra kỳ số.';

  @override
  String mErrMain(String count) {
    return 'Vui lòng chọn $count số trúng thưởng.';
  }

  @override
  String mErrBonus(String label, String count) {
    return '$label: vui lòng chọn $count.';
  }

  @override
  String get mErrBonusOverlap => 'Số phụ không được trùng với số trúng thưởng.';

  @override
  String get mErrDate =>
      'Vui lòng kiểm tra ngày. Không cho phép ngày trong tương lai, ngày không quay hoặc ngày trước khi áp dụng luật hiện tại.';

  @override
  String get mErrExists => 'Đã có kết quả cho ngày (kỳ) này.';

  @override
  String get adPrivacyOptions => 'Quyền riêng tư quảng cáo';

  @override
  String rewardTitle(String count) {
    return 'Tạo $count tổ hợp';
  }

  @override
  String rewardBody(String free, String count) {
    return 'Tối đa $free tổ hợp miễn phí.\nXem một quảng cáo ngắn để tạo đủ $count.';
  }

  @override
  String rewardWatch(String count) {
    return 'Xem quảng cáo để tạo $count';
  }

  @override
  String rewardFreeOnly(String free) {
    return 'Chỉ $free';
  }

  @override
  String rewardNotEarned(String free) {
    return 'Quảng cáo chưa xem hết nên sẽ tạo $free tổ hợp.';
  }

  @override
  String get patternFilters => 'Bộ lọc loại mẫu';

  @override
  String get pastPending => ' (sắp có kết quả)';

  @override
  String get fKr1st => 'Loại các bộ số từng trúng độc đắc';

  @override
  String get hKr1st =>
      'Loại các tổ hợp trùng với bất kỳ kết quả độc đắc nào trước đây.';

  @override
  String get fKr23 => 'Loại tổ hợp trùng 5 số với kỳ trước';

  @override
  String get hKr23 =>
      'Loại các tổ hợp trùng 5 trong 6 số của bất kỳ kỳ quay nào trước đây.';

  @override
  String get fKr4th => 'Loại tổ hợp trùng 4 số (100 kỳ gần nhất)';

  @override
  String get hKr4th =>
      'Loại các tổ hợp trùng 4 số với bất kỳ kỳ nào trong 100 kỳ gần nhất.';

  @override
  String get fKr5th => 'Loại bộ 3 số liên tiếp từng xuất hiện';

  @override
  String get hKr5th =>
      'Loại các tổ hợp chứa 3 số liên tiếp từng xuất hiện trong một kỳ quay trước.';

  @override
  String get fKrRange => 'Loại khoảng hẹp (lớn nhất − nhỏ nhất ≤ 9)';

  @override
  String get hKrRange =>
      'Loại các tổ hợp có số lớn nhất và nhỏ nhất cách nhau 9 trở xuống.';

  @override
  String fPastFull(String k) {
    return 'Loại bộ số từng trúng ($k số trùng)';
  }

  @override
  String hPastFull(String k) {
    return 'Loại các tổ hợp trùng với $k số chính của bất kỳ kỳ nào theo luật hiện tại.';
  }

  @override
  String fPastMinus1(String m) {
    return 'Loại tổ hợp trùng $m số với kỳ trước';
  }

  @override
  String hPastMinus1(String k, String m) {
    return 'Loại các tổ hợp trùng $m trong $k số chính của bất kỳ kỳ quay nào trước đây.';
  }

  @override
  String fPastMinus2(String r, String m) {
    return 'Loại tổ hợp trùng $m số ($r kỳ gần nhất)';
  }

  @override
  String hPastMinus2(String r, String m) {
    return 'Loại các tổ hợp trùng $m số chính với bất kỳ kỳ nào trong $r kỳ gần nhất.';
  }

  @override
  String get fPastConsec => 'Loại bộ 3 số liên tiếp từng xuất hiện';

  @override
  String get hPastConsec =>
      'Loại các tổ hợp chứa 3 số liên tiếp (ví dụ 7, 8, 9) từng xuất hiện trong một kỳ quay trước.';

  @override
  String fNarrow(String n) {
    return 'Loại khoảng hẹp (lớn nhất − nhỏ nhất ≤ $n)';
  }

  @override
  String hNarrow(String n) {
    return 'Loại các tổ hợp có số lớn nhất và nhỏ nhất cách nhau $n trở xuống.';
  }

  @override
  String get f3Consec => 'Loại 3 số liên tiếp';

  @override
  String get h3Consec =>
      'Loại các tổ hợp có 3 số liên tiếp như 1, 2, 3 hoặc 33, 34, 35.';

  @override
  String get fDouble3Consec => 'Loại 2 nhóm 3 số liên tiếp';

  @override
  String get hDouble3Consec =>
      'Loại các tổ hợp gồm 2 nhóm 3 số liên tiếp như 1, 2, 3, 20, 21, 22.';

  @override
  String get fSkip1 => 'Loại 3 số cách đều 2';

  @override
  String get hSkip1 =>
      'Loại các tổ hợp có 3 số cách nhau 2 như 1, 3, 5 hoặc 15, 17, 19.';

  @override
  String get fSkip2 => 'Loại 3 số cách đều 3';

  @override
  String get hSkip2 =>
      'Loại các tổ hợp có 3 số cách nhau 3 như 1, 4, 7 hoặc 15, 18, 21.';

  @override
  String get fSkip3 => 'Loại 3 số cách đều 4';

  @override
  String get hSkip3 =>
      'Loại các tổ hợp có 3 số cách nhau 4 như 1, 5, 9 hoặc 15, 19, 23.';

  @override
  String get f2Pairs => 'Loại từ 2 cặp số liên tiếp';

  @override
  String get h2Pairs =>
      'Loại các tổ hợp có từ hai cặp số liên tiếp trở lên, như 1, 2 và 15, 16.';

  @override
  String fAllOdd(String k) {
    return 'Loại toàn số lẻ ($k số lẻ)';
  }

  @override
  String hAllOdd(String k) {
    return 'Loại các tổ hợp mà cả $k số đều là số lẻ.';
  }

  @override
  String fAllEven(String k) {
    return 'Loại toàn số chẵn ($k số chẵn)';
  }

  @override
  String hAllEven(String k) {
    return 'Loại các tổ hợp mà cả $k số đều là số chẵn.';
  }

  @override
  String get fOE1 => 'Loại L-C-L-C-L-C / C-L-C-L-C-L';

  @override
  String get fOE2 => 'Loại C-C-L-L-C-C / L-L-C-C-L-L';

  @override
  String get fOE3 => 'Loại C-C-C-C-C-L / L-L-L-L-L-C';

  @override
  String get fOE4 => 'Loại C-C-C-C-L-L / L-L-L-L-C-C';

  @override
  String get fOE5 => 'Loại C-C-C-L-L-L / L-L-L-C-C-C';

  @override
  String hOE(String pattern) {
    return 'Loại các tổ hợp mà 6 số sắp xếp tăng dần có thứ tự lẻ (L)/chẵn (C) là $pattern.';
  }

  @override
  String get fSameDigit => 'Loại từ 3 số cùng chữ số cuối';

  @override
  String get hSameDigit =>
      'Loại các tổ hợp có từ 3 số trở lên cùng chữ số cuối, như 1, 11, 21, 31.';

  @override
  String get fTripleMult => 'Loại 3 bội số liên tiếp';

  @override
  String get hTripleMult =>
      'Loại các tổ hợp chứa 3 bội số liên tiếp của cùng một số, như 2, 4, 6 hoặc 4, 8, 12.';

  @override
  String get alarmIntro =>
      'Bạn sẽ nhận thông báo 3 giờ trước mỗi kỳ quay của các xổ số đã bật.';

  @override
  String alarmDrawAt(String days, String time) {
    return 'Quay $days $time (giờ địa phương)';
  }

  @override
  String get alarmUnsupported =>
      'Thiết bị này không hỗ trợ thông báo. Vui lòng dùng ứng dụng trên điện thoại.';

  @override
  String get alarmDenied =>
      'Thông báo đang tắt. Vui lòng cho phép thông báo của ứng dụng này trong cài đặt điện thoại.';

  @override
  String alarmOn(String game) {
    return 'Chúng tôi sẽ nhắc bạn 3 giờ trước mỗi kỳ quay $game.';
  }

  @override
  String alarmOff(String game) {
    return 'Đã tắt nhắc nhở $game.';
  }

  @override
  String notifyTitle(String game) {
    return 'Hôm nay quay $game!';
  }

  @override
  String get notifyBody =>
      'Còn 3 giờ nữa là quay số. Hãy tạo số trong Lotto Leader.';

  @override
  String get notifyChannel => 'Nhắc ngày quay số';

  @override
  String get winPending => 'Chờ quay';

  @override
  String winDrawOf(String date) {
    return 'So với kỳ quay ngày $date';
  }

  @override
  String winRank(String rank) {
    return 'Giải $rank';
  }

  @override
  String winBest(String rank) {
    return 'Cao nhất: $rank';
  }

  @override
  String get winNone => 'Không trúng';

  @override
  String winMatch(String main) {
    return 'Trùng $main số';
  }

  @override
  String winMatchPlus(String main, String bonus) {
    return 'Trùng $main+$bonus';
  }

  @override
  String winMatchBonus(String main) {
    return 'Trùng $main số + số phụ';
  }

  @override
  String get winPendingHint =>
      'Kết quả sẽ được so sánh tự động khi có. Nếu chậm, hãy dùng Cài đặt → Nhập kết quả thủ công.';

  @override
  String get statsTitle => 'Thống kê số';

  @override
  String statsRecent(String n) {
    return '$n kỳ gần nhất';
  }

  @override
  String get statsAll => 'Tất cả';

  @override
  String get statsMain => 'Số chính';

  @override
  String get statsSortNumber => 'Theo số';

  @override
  String get statsSortMost => 'Ra nhiều nhất';

  @override
  String get statsSortLeast => 'Ra ít nhất';

  @override
  String get statsSortGap => 'Lâu chưa ra nhất';

  @override
  String statsAnalyzed(int n) {
    return 'Dựa trên $n kỳ quay gần nhất';
  }

  @override
  String get statsHot => 'Số nóng';

  @override
  String get statsCold => 'Số lạnh';

  @override
  String statsCount(String n) {
    return '$n lần';
  }

  @override
  String statsGap(int n) {
    return '$n kỳ trước';
  }

  @override
  String get statsGapLatest => 'Kỳ trước';

  @override
  String get statsGapNever => 'Chưa ra';

  @override
  String get statsOddEven => 'Tỷ lệ lẻ / chẵn';

  @override
  String statsOddLabel(String odd, String even) {
    return '$odd lẻ : $even chẵn';
  }

  @override
  String get statsDisclaimer =>
      'Đây chỉ là kết quả trước đây và không dự đoán các kỳ quay sau.';

  @override
  String get backupExport => 'Sao lưu lịch sử';

  @override
  String get backupImport => 'Khôi phục từ bản sao lưu';

  @override
  String get backupShareText =>
      'Tệp sao lưu Lotto Leader. Trên điện thoại mới, mở Cài đặt → Khôi phục từ bản sao lưu và chọn tệp này.';

  @override
  String get backupEmpty => 'Chưa có gì để sao lưu.';

  @override
  String get backupFailed =>
      'Không tạo được tệp sao lưu. Vui lòng thử lại sau.';

  @override
  String get backupImportConfirm =>
      'Bản sao lưu sẽ được gộp với lịch sử trên thiết bị này. Biệt danh và ngày đăng ký sẽ lấy theo bản sao lưu. Tiếp tục?';

  @override
  String backupImportDone(String history, String manual) {
    return 'Khôi phục xong. Đã thêm: lịch sử $history · kết quả thủ công $manual';
  }

  @override
  String get backupInvalid =>
      'Đây không phải tệp sao lưu Lotto Leader hoặc tệp đã bị hỏng.';

  @override
  String get backupTooLarge =>
      'Tệp quá lớn. Vui lòng chọn tệp sao lưu Lotto Leader.';

  @override
  String get continueButton => 'Tiếp tục';

  @override
  String get colon => ': ';

  @override
  String fSum(String lo, String hi) {
    return 'Loại tổng ngoài $lo–$hi';
  }

  @override
  String hSum(String lo, String hi) {
    return 'Loại các tổ hợp có tổng số chính nhỏ hơn $lo hoặc lớn hơn $hi. Khoảng 95% tổ hợp nằm trong khoảng này.';
  }

  @override
  String get fBirthday => 'Loại bộ số toàn từ 31 trở xuống (ngày sinh)';

  @override
  String get hBirthday =>
      'Loại các tổ hợp chỉ gồm số 1–31 (số dùng cho ngày). Nhiều người chọn theo ngày sinh nên nếu trúng độc đắc với các số này thì khả năng phải chia giải cao hơn. Cơ hội trúng thưởng vẫn như mọi tổ hợp khác.';

  @override
  String get fLowHigh => 'Loại toàn số nhỏ hoặc toàn số lớn';

  @override
  String hLowHigh(String half, String next, String max) {
    return 'Loại các tổ hợp mà mọi số đều trong 1–$half, hoặc đều trong $next–$max.';
  }

  @override
  String get fDecade4 => 'Loại từ 4 số cùng một chục';

  @override
  String get hDecade4 =>
      'Loại các tổ hợp có từ 4 số cùng một nhóm mười (1–9, 10–19, 20–29 …), như 41, 43, 45, 48.';

  @override
  String get fRepeatLast => 'Loại tổ hợp chứa từ 2 số của kỳ trước';

  @override
  String get hRepeatLast =>
      'Loại các tổ hợp lặp lại từ 2 số chính của kỳ quay gần nhất.';

  @override
  String fBonusRecent(String n, String label) {
    return 'Loại $label của $n kỳ gần nhất';
  }

  @override
  String hBonusRecent(String n, String label) {
    return 'Số $label đã ra trong $n kỳ gần nhất sẽ không được chọn.';
  }

  @override
  String fBonusPairRecent(String n, String label) {
    return 'Loại cặp $label của $n kỳ gần nhất';
  }

  @override
  String hBonusPairRecent(String n, String label) {
    return 'Cặp $label giống một trong $n kỳ gần nhất sẽ không được chọn.';
  }

  @override
  String fBonusConsec(String label) {
    return 'Loại $label liên tiếp (ví dụ 3·4)';
  }

  @override
  String hBonusConsec(String label) {
    return 'Cặp $label là hai số liên tiếp, như 3·4, sẽ không được chọn.';
  }

  @override
  String fBonusParity(String label) {
    return 'Loại $label cùng lẻ hoặc cùng chẵn';
  }

  @override
  String hBonusParity(String label) {
    return 'Cặp $label cùng là số lẻ hoặc cùng là số chẵn sẽ không được chọn.';
  }

  @override
  String get filtersOverseas => 'Bộ lọc thêm cho xổ số này';

  @override
  String filtersBonus(String label) {
    return 'Bộ lọc $label';
  }
}
