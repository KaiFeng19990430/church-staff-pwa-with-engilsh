import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/localization/app_language.dart';
import '../../../../core/services/install_hint_service.dart';

/// Reminds people using the site in a browser to add it to their home screen.
class AddToHomeCard extends StatefulWidget {
  const AddToHomeCard({super.key, this.service = const InstallHintService()});

  final InstallHintService service;

  static const dismissedKey = 'add_to_home_dismissed';

  @override
  State<AddToHomeCard> createState() => _AddToHomeCardState();
}

class _AddToHomeCardState extends State<AddToHomeCard> {
  bool _dismissed = true;
  bool _installing = false;

  @override
  void initState() {
    super.initState();
    _loadDismissed();
  }

  Future<void> _loadDismissed() async {
    final prefs = await SharedPreferences.getInstance();
    if (!mounted) return;
    setState(
      () => _dismissed = prefs.getBool(AddToHomeCard.dismissedKey) ?? false,
    );
  }

  Future<void> _dismiss() async {
    setState(() => _dismissed = true);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(AddToHomeCard.dismissedKey, true);
  }

  Future<void> _install() async {
    setState(() => _installing = true);
    final accepted = await widget.service.prompt();
    if (!mounted) return;
    setState(() {
      _installing = false;
      if (accepted) _dismissed = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final hint = widget.service.read();
    if (_dismissed || !hint.shouldSuggest) return const SizedBox.shrink();

    final theme = Theme.of(context);
    final canInstall =
        hint.platform == InstallPlatform.android && hint.canPrompt;

    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.add_to_home_screen,
                    size: 20,
                    color: theme.colorScheme.primary,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    AppLanguage.text(context, '把這個網站加到手機桌面'),
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                AppLanguage.text(context, '桌面會多一個圖示，之後點一下就能打開，不用再去 LINE 找連結。'),
              ),
              const SizedBox(height: 12),
              if (canInstall)
                Text(AppLanguage.text(context, '按下面的「安裝到手機」，再按「安裝」就好了。'))
              else
                ..._steps(context, hint, theme),
              const SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: _dismiss,
                    child: Text(AppLanguage.text(context, '不用了')),
                  ),
                  if (canInstall) ...[
                    const SizedBox(width: 8),
                    FilledButton(
                      onPressed: _installing ? null : _install,
                      child: Text(AppLanguage.text(context, '安裝到手機')),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _steps(BuildContext context, InstallHint hint, ThemeData theme) {
    WidgetSpan icon(IconData data) => WidgetSpan(
      alignment: PlaceholderAlignment.middle,
      child: Icon(data, size: 20, color: theme.colorScheme.primary),
    );
    final share = icon(Icons.ios_share);
    final List<List<InlineSpan>> steps = switch (hint.platform) {
      InstallPlatform.ios => [
        switch (hint.browser) {
          InstallBrowser.chrome => [
            TextSpan(text: AppLanguage.text(context, '點網址列右邊的分享圖示 ')),
            share,
          ],
          InstallBrowser.safari => [
            TextSpan(text: AppLanguage.text(context, '點下方工具列的分享圖示 ')),
            share,
            TextSpan(
              text: AppLanguage.text(context, '。下方只有網址列的話，先點網址列右邊的「⋯」，再點「分享」'),
            ),
          ],
          InstallBrowser.other => [
            TextSpan(text: AppLanguage.text(context, '點瀏覽器的分享圖示 ')),
            share,
          ],
        },
        [TextSpan(text: AppLanguage.text(context, '往下滑，點「加入主畫面」'))],
        [TextSpan(text: AppLanguage.text(context, '點右上角的「加入」，之後從桌面的圖示打開'))],
      ],
      _ => [
        [
          TextSpan(text: AppLanguage.text(context, '點瀏覽器右上角的選單 ')),
          icon(Icons.more_vert),
        ],
        [TextSpan(text: AppLanguage.text(context, '點「安裝應用程式」或「加到主畫面」'))],
        [TextSpan(text: AppLanguage.text(context, '點「安裝」，之後從桌面的圖示打開'))],
      ],
    };
    return [
      for (final (index, spans) in steps.indexed)
        Padding(
          padding: const EdgeInsets.only(bottom: 6),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 24,
                child: Text(
                  '${index + 1}.',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              Expanded(child: Text.rich(TextSpan(children: spans))),
            ],
          ),
        ),
    ];
  }
}
