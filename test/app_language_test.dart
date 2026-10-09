import 'package:church_staff_pwa/core/localization/app_language.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('persists the selected language', () async {
    SharedPreferences.setMockInitialValues({});
    await SharedPreferences.getInstance();

    final language = AppLanguage();
    await language.ready;
    await language.setLanguage('en');

    final restoredLanguage = AppLanguage();
    await restoredLanguage.ready;

    expect(restoredLanguage.locale, const Locale('en'));
    expect(restoredLanguage.isEnglish, isTrue);
  });

  testWidgets('translates interface text using the active locale', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        locale: Locale('en'),
        supportedLocales: [Locale('zh', 'TW'), Locale('en')],
        home: _LocalizedTextProbe(),
      ),
    );

    expect(find.text('Home'), findsOneWidget);
  });
}

class _LocalizedTextProbe extends StatelessWidget {
  const _LocalizedTextProbe();

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Text(AppLanguage.text(context, '首頁')));
  }
}
