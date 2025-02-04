import 'package:cell_calendar/src/components/days_row/days_row.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../calendar_event.dart';

/// Numbers to return accurate events in the cell.
const dayLabelContentHeight = 12;
const dayLabelVerticalMargin = 3;
const _dayLabelHeight = dayLabelContentHeight + (dayLabelVerticalMargin * 2);

const _eventLabelContentHeight = 13;
const _eventLabelBottomMargin = 3;
const _eventLabelHeight = _eventLabelContentHeight + _eventLabelBottomMargin;

/// Get events to be shown from [CalendarStateController]
///
/// Shows accurate number of [_EventLabel] by the height of the parent cell
class EventLabels extends HookConsumerWidget {
  EventLabels({
    required this.date,
    required this.events,
  });

  final DateTime date;
  final List<CalendarEvent> events;

  List<CalendarEvent> _eventsOnTheDay(
      DateTime date, List<CalendarEvent> events) {
    final res = events
        .where((event) =>
            event.eventDate.year == date.year &&
            event.eventDate.month == date.month &&
            event.eventDate.day == date.day)
        .toList();
    return res;
  }

  bool _hasEnoughSpace(double cellHeight, int eventsLength) {
    final eventsTotalHeight = _eventLabelHeight * eventsLength;
    final spaceForEvents = cellHeight - _dayLabelHeight;
    return spaceForEvents > eventsTotalHeight;
  }

  int _maxIndex(double cellHeight, int eventsLength) {
    final spaceForEvents = cellHeight - _dayLabelHeight;
    const indexing = 1;
    const indexForPlot = 1;
    return spaceForEvents ~/ _eventLabelHeight - (indexing + indexForPlot);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cellHeight = ref.watch(cellHeightProvider);
    if (cellHeight == null) {
      return const SizedBox.shrink();
    }
    final eventsOnTheDay = _eventsOnTheDay(date, events);
    final hasEnoughSpace = _hasEnoughSpace(cellHeight, eventsOnTheDay.length);
    final maxIndex = _maxIndex(cellHeight, eventsOnTheDay.length);
    int len = 0;
    if (eventsOnTheDay.length > 0) {
      return _EventLabel(
        eventsOnTheDay[0],
        cellHeight,
      );
    } else {
      return SizedBox.shrink();
    }
  }
}

/// label to show [CalendarEvent]
class _EventLabel extends StatelessWidget {
  _EventLabel(this.event, this.cellHeight);

  final CalendarEvent event;
  final double cellHeight;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: event.eventBackgroundColor,
        borderRadius: BorderRadius.all(
          Radius.circular(5),
        ),
      ),
      margin: EdgeInsets.only(right: 2, left: 2),
      height: (cellHeight / 1.7) > 36 ? 36 : (cellHeight / 1.7),
      width: double.infinity,
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Padding(
          padding: EdgeInsets.all(3),
          child: Text(
            event.totalHours,
            style: event.eventTextStyle,
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
