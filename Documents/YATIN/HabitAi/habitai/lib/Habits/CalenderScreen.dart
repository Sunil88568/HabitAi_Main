import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import '../theme/app_theme.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Calendar"),
      ),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: TableCalendar(
          firstDay: DateTime.utc(2020, 1, 1),
          lastDay: DateTime.utc(2030, 12, 31),
          focusedDay: _focusedDay,
          selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
          onDaySelected: (selectedDay, focusedDay) {
            setState(() {
              _selectedDay = selectedDay;
              _focusedDay = focusedDay; // update focused day
            });
          },
          calendarStyle: CalendarStyle(
            todayDecoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              shape: BoxShape.circle,
            ),
            selectedDecoration: BoxDecoration(
              color: Theme.of(context).brightness == Brightness.dark ? AppColors.darkError : AppColors.lightError,
              shape: BoxShape.circle,
            ),
            defaultTextStyle: TextStyle(color: Theme.of(context).colorScheme.onBackground),
            weekendTextStyle: TextStyle(color: Theme.of(context).brightness == Brightness.dark ? AppColors.darkSecondaryText : AppColors.lightSecondaryText),
          ),
          headerStyle: HeaderStyle(
            titleCentered: true,
            formatButtonVisible: false,
            titleTextStyle: TextStyle(color: Theme.of(context).colorScheme.onBackground, fontSize: 18),
            leftChevronIcon: Icon(Icons.chevron_left, color: Theme.of(context).colorScheme.onBackground),
            rightChevronIcon: Icon(Icons.chevron_right, color: Theme.of(context).colorScheme.onBackground),
          ),
        ),
      ),
    );
  }
}
