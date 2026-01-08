// GoalPeriodScreen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../theme/app_theme.dart';
import 'create_habit_controller.dart';

class GoalPeriodScreen extends StatefulWidget {
  final CreateHabitController? controller;
  const GoalPeriodScreen({super.key, this.controller});

  @override
  State<GoalPeriodScreen> createState() => _GoalPeriodScreenState();
}

class _GoalPeriodScreenState extends State<GoalPeriodScreen> {
  int? _openIndex = 0;
  String _selectedTaskValue = 'Every Day';

  Set<String> selectedDays = {'MON'};
  Set<int> selectedMonthDays = {1};
  int daysPerWeek = 3;
  int daysPerMonth = 3;

  @override
  void initState() {
    super.initState();
    if (widget.controller != null) {
      _selectedTaskValue = widget.controller!.selectedTaskValue.value;

      // Reset all to defaults first
      selectedDays = {'MON'};
      selectedMonthDays = {1};
      daysPerWeek = 3;
      daysPerMonth = 3;

      // Only load saved data for the selected task value
      switch (_selectedTaskValue) {
        case 'Specific days of the week':
          if (widget.controller!.selectedDays.isNotEmpty) {
            selectedDays = widget.controller!.selectedDays.toSet();
          }
          break;
        case 'Number of days per week':
          if (widget.controller!.daysPerWeek.value > 0) {
            daysPerWeek = widget.controller!.daysPerWeek.value;
          }
          break;
        case 'Specific days of the month':
          if (widget.controller!.selectedMonthDays.isNotEmpty) {
            selectedMonthDays = widget.controller!.selectedMonthDays.toSet();
          }
          break;
        case 'Number of days per month':
          if (widget.controller!.daysPerMonth.value > 0) {
            daysPerMonth = widget.controller!.daysPerMonth.value;
          }
          break;
      }

      // Set the correct open index based on selected task value
      switch (_selectedTaskValue) {
        case 'Every Day':
          _openIndex = 0;
          break;
        case 'Specific days of the week':
          _openIndex = 1;
          break;
        case 'Number of days per week':
          _openIndex = 2;
          break;
        case 'Specific days of the month':
          _openIndex = 3;
          break;
        case 'Number of days per month':
          _openIndex = 4;
          break;
      }
    }
  }

  void _toggle(int index) {
    setState(() {
      _openIndex = _openIndex == index ? null : index;
      // Update selected task value based on index
      switch (index) {
        case 0:
          _selectedTaskValue = 'Every Day';
          break;
        case 1:
          _selectedTaskValue = 'Specific days of the week';
          break;
        case 2:
          _selectedTaskValue = 'Number of days per week';
          break;
        case 3:
          _selectedTaskValue = 'Specific days of the month';
          break;
        case 4:
          _selectedTaskValue = 'Number of days per month';
          break;
      }
    });
  }

  void _toggleDay(String day) {
    setState(() {
      if (selectedDays.contains(day)) {
        selectedDays.remove(day);
      } else {
        selectedDays.add(day);
      }
    });
  }

  void _selectAllDays() {
    setState(() {
      selectedDays = {'MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT', 'SUN'};
    });
  }

  void _selectAllMonthDays() {
    setState(() {
      selectedMonthDays = Set.from(List.generate(31, (i) => i + 1));
    });
  }

  void _toggleMonthDay(int day) {
    setState(() {
      if (selectedMonthDays.contains(day)) {
        selectedMonthDays.remove(day);
      } else {
        selectedMonthDays.add(day);
      }
    });
  }

  void _updateDaysPerWeek(int delta) {
    setState(() {
      daysPerWeek = (daysPerWeek + delta).clamp(1, 7);
    });
  }

  void _updateDaysPerMonth(int delta) {
    setState(() {
      daysPerMonth = (daysPerMonth + delta).clamp(1, 31);
    });
  }

  @override
  Widget build(BuildContext context) {
    final sections = <_Section>[
      _Section(
        title: 'Every Day',
        child: const SizedBox.shrink(),
      ),
      _Section(
        title: 'Specific days of the week',
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: ['MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT', 'SUN']
                  .map((day) => GestureDetector(
                onTap: () => _toggleDay(day),
                child: _DayPill(label: day, selected: selectedDays.contains(day)),
              ))
                  .toList(),
            ),
            const SizedBox(height: 10),
            _Hint(text: '*Task needs to be done every ${selectedDays.join(", ")}'),
          ],
        ),
      ),
      _Section(
        title: 'Number of days per week',
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 6),
            _StepperBar(
              valueText: '$daysPerWeek',
              onDecrement: () => _updateDaysPerWeek(-1),
              onIncrement: () => _updateDaysPerWeek(1),
            ),
            const SizedBox(height: 8),
            _Hint(text: '*Complete on any $daysPerWeek days of the week'),
          ],
        ),
      ),
      _Section(
        title: 'Specific days of the month',
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 6),
            _MonthGrid(
              selectedDays: selectedMonthDays,
              onDaySelected: _toggleMonthDay,
            ),
            const SizedBox(height: 10),
            Align(
              alignment: Alignment.center,
              child: OutlinedButton(
                onPressed: _selectAllMonthDays,
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: context.borderColor),
                  foregroundColor: context.textColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                ),
                child: const Text('Select All'),
              ),
            ),
            const SizedBox(height: 8),
            _Hint(text: '*Task needs to be done on ${selectedMonthDays.toList()..sort()}'),
          ],
        ),
      ),
      _Section(
        title: 'Number of days per month',
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 6),
            _StepperBar(
              valueText: '$daysPerMonth',
              onDecrement: () => _updateDaysPerMonth(-1),
              onIncrement: () => _updateDaysPerMonth(1),
            ),
            const SizedBox(height: 8),
            _Hint(text: '*Complete on any $daysPerMonth days of the month'),
          ],
        ),
      ),
    ];

    return Scaffold(
      backgroundColor: context.backgroundColor,
      appBar: AppBar(
        backgroundColor: context.backgroundColor,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            // Save selected task value to controller before closing
            if (widget.controller != null) {
              widget.controller!.selectTaskValue(_selectedTaskValue);
              widget.controller!.updateSelectedDays(selectedDays);
              widget.controller!.updateSelectedMonthDays(selectedMonthDays);
              widget.controller!.updateDaysPerWeek(daysPerWeek);
              widget.controller!.updateDaysPerMonth(daysPerMonth);
            }
            Navigator.pop(context);
          },
          icon: Icon(Icons.close_rounded, color: context.textColor),
        ),
        centerTitle: true,
        title: Text('Goal Period', style: Theme.of(context).textTheme.titleLarge),
      ),
      body: SafeArea(
        child: ListView.separated(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          itemBuilder: (ctx, i) {
            final open = _openIndex == i;
            final s = sections[i];
            return _OptionCard(
              title: s.title,
              isActive: open,
              onTap: () => _toggle(i),
              child: s.child,
            );
          },
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemCount: sections.length,
        ),
      ),
    );
  }
}

class _Section {
  final String title;
  final Widget child;
  _Section({required this.title, required this.child});
}

class _OptionCard extends StatelessWidget {
  final String title;
  final bool isActive;
  final VoidCallback onTap;
  final Widget child;

  const _OptionCard({
    required this.title,
    required this.isActive,
    required this.onTap,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final borderColor = isActive ? context.primaryColor : context.borderColor;
    // final bg =isActive ? context.primaryColor.withOpacity(0.07) : context.cardColor;
    final bg =context.cardColor;

    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        curve: Curves.easeOut,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: borderColor, width: 2),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    title,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: context.textColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            AnimatedCrossFade(
              firstChild: const SizedBox.shrink(),
              secondChild: Padding(
                padding: const EdgeInsets.only(top: 10),
                child: child,
              ),
              crossFadeState: isActive
                  ? CrossFadeState.showSecond
                  : CrossFadeState.showFirst,
              duration: const Duration(milliseconds: 160),
              sizeCurve: Curves.easeOut,
            ),
          ],
        ),
      ),
    );
  }
}

class _DayPill extends StatelessWidget {
  final String label;
  final bool selected;
  const _DayPill({required this.label, this.selected = false});

  @override
  Widget build(BuildContext context) {
    final color = selected ? Colors.white : context.textColor;
    final bg = selected ? context.primaryColor : context.surfaceColor;
    final border = selected ? context.primaryColor : context.borderColor;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: border, width: 1),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _StepperBar extends StatelessWidget {
  final String valueText;
  final VoidCallback onDecrement;
  final VoidCallback onIncrement;

  const _StepperBar({
    required this.valueText,
    required this.onDecrement,
    required this.onIncrement,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _RoundIconBtn(icon: Icons.remove_rounded, onPressed: onDecrement),
        const SizedBox(width: 10),
        Expanded(
          child: Container(
            height: 36,
            decoration: BoxDecoration(
              color: context.surfaceColor,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: context.borderColor),
            ),
            alignment: Alignment.center,
            child: Text(
              valueText,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: context.textColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        _RoundIconBtn(icon: Icons.add_rounded, onPressed: onIncrement),
      ],
    );
  }
}

class _RoundIconBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;
  const _RoundIconBtn({required this.icon, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: context.surfaceColor,
      shape: const CircleBorder(),
      child: InkWell(
        onTap: onPressed, // no-op
        customBorder: const CircleBorder(),
        child: Container(
          width: 36,
          height: 36,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            border: Border.all(color: context.borderColor),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: context.textColor, size: 20),
        ),
      ),
    );
  }
}

class _MonthGrid extends StatelessWidget {
  final Set<int> selectedDays;
  final Function(int) onDaySelected;

  const _MonthGrid({
    required this.selectedDays,
    required this.onDaySelected,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(vertical: 6),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        childAspectRatio: 1,
      ),
      itemCount: 31,
      itemBuilder: (context, index) {
        final day = index + 1;
        final selected = selectedDays.contains(day);
        final bg = selected ? context.primaryColor : context.surfaceColor;
        final textColor = selected ? Colors.white : context.textColor;
        final border = selected ? context.primaryColor : context.borderColor;

        return GestureDetector(
          onTap: () => onDaySelected(day),
          child: Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: bg,
              shape: BoxShape.circle,
              border: Border.all(color: border, width: 1),
            ),
            child: Text(
              '$day',
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(color: textColor),
            ),
          ),
        );
      },
    );
  }
}

class _Hint extends StatelessWidget {
  final String text;
  const _Hint({required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style:
      Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.orangeAccent),
    );
  }
}