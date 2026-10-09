import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/localization/app_language.dart';
import '../../domain/entities/calendar_event.dart';

/// Bottom sheet that lists all events on a given [day].
///
/// Tapping an event row closes this sheet and hands the event back through
/// [onOpenEvent]. It deliberately does not open the detail sheet itself: the
/// caller decides what that sheet can do, and an admin's edit/delete buttons
/// went missing when this widget short-circuited that.
///
/// [onAddEvent] is supplied for admins only; when it is null the sheet is the
/// read-only list every member sees.
Future<void> showDayEventsSheet(
  BuildContext context, {
  required DateTime day,
  required List<CalendarEvent> events,
  required Future<void> Function(CalendarEvent event) onOpenEvent,
  Future<void> Function(DateTime day)? onAddEvent,
}) async {
  final locale = Localizations.localeOf(context).toString();
  final title = DateFormat.yMMMMd(locale).add_EEEE().format(day);
  final colorScheme = Theme.of(context).colorScheme;

  await showModalBottomSheet<void>(
    context: context,
    showDragHandle: true,
    isScrollControlled: true,
    builder: (sheetContext) {
      return SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            20,
            8,
            20,
            20 + MediaQuery.viewInsetsOf(sheetContext).bottom,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                Localizations.localeOf(sheetContext).languageCode == 'en'
                    ? '${events.length} event(s) today'
                    : '當天活動 ${events.length} 筆',
                style: TextStyle(fontSize: 13, color: colorScheme.primary),
              ),
              const SizedBox(height: 12),
              if (events.isEmpty)
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Text(AppLanguage.text(sheetContext, '當天沒有活動')),
                )
              else
                Flexible(
                  child: ListView.separated(
                    shrinkWrap: true,
                    itemCount: events.length,
                    separatorBuilder: (_, index) => const SizedBox(height: 8),
                    itemBuilder: (context, index) {
                      final event = events[index];
                      return Material(
                        color: colorScheme.surfaceContainerHighest.withValues(
                          alpha: 0.32,
                        ),
                        borderRadius: BorderRadius.circular(12),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(12),
                          onTap: () async {
                            Navigator.of(sheetContext).pop();
                            await onOpenEvent(event);
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  event.title,
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  _formatEventTimeSummary(
                                    event,
                                    Localizations.localeOf(context).toString(),
                                  ),
                                  style: const TextStyle(fontSize: 13),
                                ),
                                if (event.location != null &&
                                    event.location!.isNotEmpty) ...[
                                  const SizedBox(height: 4),
                                  Text(
                                    event.location!,
                                    style: const TextStyle(
                                      fontSize: 13,
                                      color: Colors.black54,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              if (onAddEvent != null) ...[
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    onPressed: () async {
                      // Close first: the form is itself a modal sheet, and
                      // stacking two leaves the list visible behind it.
                      Navigator.of(sheetContext).pop();
                      await onAddEvent(day);
                    },
                    icon: const Icon(Icons.add),
                    label: Text(AppLanguage.text(sheetContext, '新增活動')),
                  ),
                ),
              ],
            ],
          ),
        ),
      );
    },
  );
}

String _formatEventTimeSummary(CalendarEvent event, String locale) {
  if (event.isAllDay) {
    if (locale.startsWith('en')) {
      return event.spansMultipleDays ? 'All day, multiple days' : 'All day';
    }
    return event.spansMultipleDays ? '全天，多日活動' : '全天';
  }

  final sameDay = DateUtils.isSameDay(event.startTime, event.endTime);
  if (sameDay) {
    final startText = DateFormat.Hm(locale).format(event.startTime);
    final endText = DateFormat.Hm(locale).format(event.endTime);
    return '$startText - $endText';
  }

  final startText = DateFormat.Md(locale).add_Hm().format(event.startTime);
  final endText = DateFormat.Md(locale).add_Hm().format(event.endTime);
  return '$startText - $endText';
}
