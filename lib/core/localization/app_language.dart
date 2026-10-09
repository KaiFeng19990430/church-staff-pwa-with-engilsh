import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Stores the user's language preference and provides translations for UI text.
class AppLanguage extends ChangeNotifier {
  static const _preferenceKey = 'app_language';

  Locale _locale = const Locale('zh', 'TW');
  Locale get locale => _locale;
  bool get isEnglish => _locale.languageCode == 'en';
  late final Future<void> ready;

  AppLanguage() {
    ready = _restorePreference();
  }

  Future<void> _restorePreference() async {
    final preferences = await SharedPreferences.getInstance();
    final languageCode = preferences.getString(_preferenceKey);
    if (languageCode == null || languageCode == _locale.languageCode) return;
    _locale = languageCode == 'en'
        ? const Locale('en')
        : const Locale('zh', 'TW');
    notifyListeners();
  }

  Future<void> setLanguage(String languageCode) async {
    final nextLocale = languageCode == 'en'
        ? const Locale('en')
        : const Locale('zh', 'TW');
    if (_locale == nextLocale) return;
    _locale = nextLocale;
    notifyListeners();
    final preferences = await SharedPreferences.getInstance();
    await preferences.setString(_preferenceKey, nextLocale.languageCode);
  }

  static String text(BuildContext context, String traditionalChinese) {
    if (Localizations.localeOf(context).languageCode != 'en') {
      return traditionalChinese;
    }
    final exact = _english[traditionalChinese];
    if (exact != null) return exact;

    var translated = traditionalChinese;
    for (final entry in _englishEntriesByLength) {
      translated = translated.replaceAll(entry.key, entry.value);
    }
    return translated;
  }

  static final _englishEntriesByLength = _english.entries.toList()
    ..sort((a, b) => b.key.length.compareTo(a.key.length));

  static const Map<String, String> _english = {
    '首頁': 'Home',
    '服事表': 'Roster',
    '我的': 'Profile',
    '個人中心': 'Profile',
    '帳號管理': 'Account management',
    '新增、刪除或修改同工權限': 'Add, remove, or edit staff accounts and permissions',
    '聚會設定': 'Service settings',
    '新增或修改每週的聚會': 'Add or edit weekly services',
    '小組管理': 'Group management',
    '設定各牧區小組清單': 'Manage ministry groups',
    '服事提醒': 'Roster reminders',
    '每週一晚間發送提醒': 'Send a reminder every Monday evening',
    '語言 / Language': 'Language / 語言',
    '繁體中文': '繁體中文',
    'English': 'English',
    '登出': 'Sign out',
    '登出確認': 'Confirm sign out',
    '確定要登出嗎？': 'Are you sure you want to sign out?',
    '取消': 'Cancel',
    '載入中…': 'Loading…',
    '登入': 'Sign in',
    '密碼': 'Password',
    '顯示密碼': 'Show password',
    '隱藏密碼': 'Hide password',
    '請輸入 Email': 'Enter your email',
    '請輸入密碼': 'Enter your password',
    '忘記密碼？': 'Forgot password?',
    '忘記密碼': 'Forgot password',
    '請到信箱收信': 'Check your inbox',
    '好': 'OK',
    '輸入登入用的 Email，我們會寄一封重設密碼的信給你。':
        'Enter your sign-in email and we’ll send you a password reset link.',
    '行事曆': 'Calendar',
    '上個月': 'Previous month',
    '下個月': 'Next month',
    '行事曆未啟用或設定不完整': 'Calendar is disabled or not fully configured',
    '教會年度活動一覽': 'Church events throughout the year',
    '新增活動': 'Add event',
    '當天沒有活動': 'No events for this day',
    '近期暫無活動': 'No upcoming activities',
    '近期活動': 'Recent activities',
    '尚未登入同工資料': 'No staff account is signed in',
    '尚未設定可檢視的牧區': 'No ministries are available to view',
    '請聯絡管理員為您加入服事牧區': 'Ask an administrator to assign you to a ministry',
    '載入服事資訊中…': 'Loading roster…',
    '切換至編輯模式': 'Switch to edit mode',
    '無法開啟每日靈糧頁面': 'Could not open the devotional page',
    '載入今日經文範圍中...': 'Loading today’s reading…',
    '查看今日經文範圍': 'View today’s reading',
    '更新於': 'Updated',
    '載入失敗': 'Could not load',
    '同工': 'Staff member',
    '我的服事': 'My upcoming duties',
    '最近還沒有排到你的服事': 'No upcoming duties are scheduled for you',
    '載入近期活動中…': 'Loading upcoming activities…',
    '把這個網站加到手機桌面': 'Add this app to your home screen',
    '桌面會多一個圖示，之後點一下就能打開，不用再去 LINE 找連結。':
        'Add an icon to your home screen so you can open the app without finding the link in LINE.',
    '按下面的「安裝到手機」，再按「安裝」就好了。':
        'Tap “Install on this device” below, then tap “Install”.',
    '點網址列右邊的分享圖示 ': 'Tap the share icon beside the address bar ',
    '點下方工具列的分享圖示 ': 'Tap the share icon in the bottom toolbar ',
    '。下方只有網址列的話，先點網址列右邊的「⋯」，再點「分享」':
        '. If only the address bar is shown, tap “…” beside it, then tap “Share”.',
    '點瀏覽器的分享圖示 ': 'Tap the browser’s share icon ',
    '往下滑，點「加入主畫面」': 'Scroll down and tap “Add to Home Screen”.',
    '點右上角的「加入」，之後從桌面的圖示打開':
        'Tap “Add” in the top-right corner, then open the app from your home screen.',
    '點瀏覽器右上角的選單 ': 'Tap the menu in the top-right corner of the browser ',
    '點「安裝應用程式」或「加到主畫面」': 'Tap “Install app” or “Add to Home screen”.',
    '點「安裝」，之後從桌面的圖示打開':
        'Tap “Install”, then open the app from your home screen.',
    '安裝到手機': 'Install on this device',
    '沒有權限進入編輯模式': 'You do not have permission to enter edit mode',
    '切換至檢視模式': 'Switch to view mode',
    '請先到使用者管理為您指派服事牧區':
        'Ask an administrator to assign you to a roster ministry first.',
    '此類別目前沒有服事資訊': 'No roster information is available for this service.',
    '可以用服事表照片快速建立': 'Create rosters quickly from a roster photo.',
    '懂技術的同工可以貼上 JSON 快速建立': 'Advanced users can paste JSON to create rosters.',
    '管理員建立後會在這裡顯示':
        'Rosters will appear here after an administrator creates them.',
    '匯入服事表': 'Import roster',
    '進階：匯入整季服事表': 'Advanced: import a full season',
    '用服事表照片辨識，依日期批次填入': 'Scan a roster photo and fill assignments by date.',
    '給懂技術的同工用（貼上 JSON 資料）。一般直接在下面各日期按「新增服事項目」排班即可。':
        'For advanced users: paste JSON data. Otherwise, assign duties using “Add duty item” below each date.',
    '匯入': 'Import',
    '管理員': 'Administrator',
    '小組長': 'Group leader',
    '組員': 'Group member',
    '服事表編輯': 'Roster editor',
    '行事曆編輯': 'Calendar editor',
    '活動名稱': 'Event name',
    '整天': 'All day',
    '全天': 'All day',
    '說明': 'Description',
    '刪除活動': 'Delete event',
    '複製': 'Duplicate',
    '編輯': 'Edit',
    '時間': 'Time',
    '地點': 'Location',
    '開始': 'Start',
    '結束': 'End',
    '儲存': 'Save',
    '儲存失敗，請稍後再試': 'Could not save. Please try again later.',
    '刪除': 'Delete',
    '確認刪除': 'Confirm deletion',
    '確定要刪除此小組嗎？': 'Are you sure you want to delete this group?',
    '確定要刪除此事件嗎？': 'Are you sure you want to delete this event?',
    '確定要刪除': 'Are you sure you want to delete',
    '新增小組': 'Add group',
    '編輯小組': 'Edit group',
    '新增事件': 'Add event',
    '事件選項設定': 'Event options',
    '服事項目設定': 'Duty item settings',
    '標籤顏色': 'Label color',
    '事件名稱': 'Event name',
    '服事項目名稱': 'Duty item name',
    '例：敬拜主領': 'e.g. Worship leader',
    '例：聖餐主日': 'e.g. Communion Sunday',
    '今天以後每一週的服事表都會拿掉這一項，已經排的人也會一起刪掉。已經過去的服事表不會動。':
        'This item and its assignments will be removed from all future rosters. Past rosters will not change.',
    '剛才的變更還沒儲存。要儲存的話，請按右上角 ✓。':
        'Your changes are not saved yet. Tap the checkmark in the top-right corner to save.',
    '這個聚會還沒有服事項目。\n按左下角「新增項目」加入，例如「招待」「司琴」，全部加好後按右上角 ✓ 儲存。':
        'There are no duty items for this service yet. Tap “Add item” below, then tap the checkmark above to save.',
    '編輯事件': 'Edit event',
    '新增項目': 'Add item',
    '新增服事項目': 'Add duty item',
    '新增': 'Add',
    '編輯項目': 'Edit item',
    '編輯服事表': 'Edit roster',
    '完成': 'Done',
    '重試': 'Retry',
    '檢查更新': 'Check for updates',
    '檢查中…': 'Checking…',
    '找到新版本，正在更新…': 'Update found. Installing…',
    '已經是最新版本': 'You’re up to date',
    '檢查更新失敗': 'Could not check for updates',
    '有新版本可以更新': 'A new version is available',
    '怎麼更新': 'How to update',
    '新增帳號': 'Add account',
    '編輯帳號': 'Edit account',
    '基本資料': 'Basic information',
    '姓名': 'Name',
    '請輸入姓名': 'Enter a name',
    '搜尋姓名': 'Search by name',
    '沒有符合的帳號': 'No matching accounts',
    '管理員擁有全部編輯權限，不需要另外指定。':
        'Administrators have all editing permissions; no additional selection is needed.',
    '儲存成功': 'Saved successfully',
    '已新增所有牧區': 'All ministries added',
    '請至少設定一個牧區': 'Select at least one ministry',
    '尚未儲存': 'Unsaved changes',
    '這裡改的人員還沒儲存，去交換會丟掉這些改動。':
        'Your changes are not saved. Switching will discard them.',
    '留在這裡': 'Stay here',
    '丟掉並交換': 'Discard and swap',
    '確認': 'Confirm',
    '繼續編輯': 'Continue editing',
    '不儲存，離開': 'Discard and leave',
    '還沒儲存': 'Unsaved changes',
    '歡迎回來': 'Welcome back',
    '每日靈糧': 'Daily devotional',
    '不用了': 'Not now',
    '小組設定': 'Group settings',
    '新增聚會': 'Add service',
    '修改聚會': 'Edit service',
    '最多 20 種聚會': 'A maximum of 20 services is allowed',
    '已儲存聚會設定': 'Service settings saved',
    '至少要有一個聚會是開啟的。': 'At least one service must be enabled.',
    '請填寫': 'This field is required',
    '不能有特殊字元': 'Special characters are not allowed',
    '已經有同樣簡稱的聚會': 'A service with this short name already exists',
    '簡稱': 'Short name',
    '完整名稱': 'Full name',
    '每週': 'Weekly',
    '確定': 'Confirm',
    '顯示在服事表分頁上，例如「主日」「禱告會」':
        'Shown on roster tabs, for example “Sunday” or “Prayer meeting”.',
    '例如「主日崇拜」「週三禱告會」':
        'For example, “Sunday worship” or “Wednesday prayer meeting”.',
    '請輸入名稱': 'Enter a name',
    '名稱已存在': 'This name already exists',
    '小組名稱': 'Group name',
    '編輯權限': 'Edit permissions',
    '新增牧區': 'Add ministry',
    '牧區': 'Ministry',
    '牧區資料（必填）': 'Ministry assignments (required)',
    '所屬小組': 'Groups',
    '尚未設定小組清單': 'No groups have been configured',
    '參與服事': 'Participates in duties',
    '角色': 'Role',
    'Email (選填)': 'Email (optional)',
    '帳號代稱（選填）': 'Display username (optional)',
    '補上後會建立登入帳號並需要設定密碼':
        'Adding an email creates a sign-in account and requires a password.',
    '請輸入有效的 Email': 'Enter a valid email address',
    '顯示在個人頁，不是登入用；不填就用姓名':
        'Shown on the profile, not used to sign in. Defaults to the name.',
    '補上 Email 後會建立登入帳號，請設定可登入的密碼':
        'An account will be created for this email. Set a sign-in password.',
    '建立登入帳號用': 'Used to create the sign-in account',
    '不能變更自己的角色，請另一位管理員幫你改':
        'You cannot change your own role. Ask another administrator to change it.',
    '尚未設定牧區。請按「新增牧區」，至少設定一個才能儲存。':
        'No ministries assigned. Add at least one ministry before saving.',
    '在牧區裡勾選「參與服事」，這位同工才會出現在該服事的排班名單。':
        'Select “Participates in duties” for this staff member to appear in that roster.',
    '確定要刪除此牧區嗎？': 'Are you sure you want to delete this ministry?',
    '尚未設定服事項目：請先到「服事表」按鉛筆，再按右上角清單圖示「服事項目設定」新增':
        'No duty items are configured. Open the roster, select Edit, then use Duty settings to add items.',
    '您尚未設定可檢視的牧區': 'No ministries are available to view',
    '主日崇拜': 'Sunday worship',
    '青年崇拜': 'Youth worship',
    '兒童主日學': 'Children’s Sunday school',
    '主日': 'Sunday service',
    '青崇': 'Youth service',
    '兒主': 'Children’s ministry',
    '星期一': 'Monday',
    '星期二': 'Tuesday',
    '星期三': 'Wednesday',
    '星期四': 'Thursday',
    '星期五': 'Friday',
    '星期六': 'Saturday',
    '星期日': 'Sunday',
    '帳號或密碼錯誤': 'Incorrect email or password',
    '帳號已被停用，請聯絡管理員': 'This account is disabled. Contact an administrator.',
    '此電子郵件已被註冊': 'This email address is already registered',
    '密碼強度不足，至少 6 個字元': 'Password must be at least 6 characters',
    '電子郵件格式錯誤': 'Invalid email address',
    '網路連線失敗，請檢查網路': 'Network connection failed. Check your connection.',
    '登入嘗試次數過多，請稍後再試': 'Too many sign-in attempts. Try again later.',
    '登入失敗，請稍後再試': 'Sign-in failed. Please try again later.',
    '沒有權限執行此操作，請聯絡管理員': 'You do not have permission. Contact an administrator.',
    '網路不穩，請稍後再試': 'Network connection is unstable. Try again later.',
    '資料不存在': 'The requested data does not exist',
    '資料已存在': 'The data already exists',
    '操作條件不符，請重新整理頁面':
        'The operation could not be completed. Refresh the page and try again.',
    '資料處理失敗，請稍後再試': 'Could not process the data. Please try again later.',
    '操作逾時，請稍後再試': 'The operation timed out. Please try again later.',
    '操作失敗，請稍後再試': 'The operation failed. Please try again later.',
    '寄送次數過多，請稍後再試': 'Too many emails sent. Try again later.',
    '無法寄出重設信，請稍後再試': 'Could not send the reset email. Please try again later.',
    '系統設定缺少推播金鑰，請聯絡管理員。':
        'Push notification configuration is missing a key. Contact an administrator.',
    '通知權限未開啟，請到 iPhone 設定允許此 App 通知。':
        'Notifications are not allowed. Enable them for this app in iPhone Settings.',
    '目前裝置無法取得推播識別碼，請重新開啟 App 後再試。':
        'This device could not get a notification token. Reopen the app and try again.',
    '已取得識別碼，但儲存失敗，請稍後再試。':
        'A notification token was received but could not be saved. Try again later.',
    '通知偏好儲存失敗，請稍後再試。':
        'Could not save notification preferences. Try again later.',
    '推播服務尚未初始化完成，請重整後再試。':
        'Notifications are still initializing. Refresh and try again.',
    '推播通知未啟用。': 'Push notifications are disabled.',
    '目前環境不支援網頁推播。': 'Web push notifications are not supported here.',
    '通知未啟用，請確認瀏覽器通知權限設定。':
        'Notifications are disabled. Check your browser notification permissions.',
    '更新通知設定失敗': 'Could not update notification settings',
    '離線或連線逾時，且沒有快取資料':
        'You are offline or the request timed out, and there is no cached data.',
  };
}
