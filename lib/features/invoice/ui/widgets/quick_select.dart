import 'package:flutter/material.dart';

class QuickSelect extends StatelessWidget {
  final Function(DateTimeRange) onRangeSelected;
  final VoidCallback onCustomRangeTap;

  const QuickSelect({
    super.key,
    required this.onRangeSelected,
    required this.onCustomRangeTap,
  });

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();

    final todayRange = DateTimeRange(start: now, end: now);
    final yesterdayRange = DateTimeRange(
      start: now.subtract(const Duration(days: 1)),
      end: now.subtract(const Duration(days: 1)),
    );
    final last7Days = DateTimeRange(
      start: now.subtract(const Duration(days: 6)),
      end: now,
    );
    final last30Days = DateTimeRange(
      start: now.subtract(const Duration(days: 29)),
      end: now,
    );

    final thisMonth = DateTimeRange(
      start: DateTime(now.year, now.month, 1),
      // end: DateTime(now.year, now.month + 1, 0),
      end: now,
    );

    final lastMonth = DateTimeRange(
      start: DateTime(now.year, now.month - 1, 1),
      end: DateTime(now.year, now.month, 0),
    );

    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "Date Range",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Divider(height: 40),
          ListTile(
            title: Text("Today"),
            onTap: () => onRangeSelected(todayRange),
          ),
          ListTile(
            title: const Text("Yesterday"),
            onTap: () => onRangeSelected(yesterdayRange),
          ),
          ListTile(
            title: const Text("Last 7 Days"),
            onTap: () => onRangeSelected(last7Days),
          ),
          ListTile(
            title: const Text("Last 30 Days"),
            onTap: () => onRangeSelected(last30Days),
          ),
          ListTile(
            title: const Text("This Month"),
            onTap: () => onRangeSelected(thisMonth),
          ),
          ListTile(
            title: const Text("Last Month"),
            onTap: () => onRangeSelected(lastMonth),
          ),
          Divider(),
          ListTile(title: const Text("Custom Range"), onTap: onCustomRangeTap),
        ],
      ),
    );
  }
}
