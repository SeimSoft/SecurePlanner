import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:private_planner/data/database.dart';
import 'package:private_planner/core/theme/app_theme.dart';
import 'package:intl/intl.dart';

class TodoListTile extends HookWidget {
  final Todo todo;
  final Category? category;

  const TodoListTile({super.key, required this.todo, this.category});

  Color getPriorityColor() {
    switch (todo.priority) {
      case 2:
        return AppTheme.priorityHigh;
      case 1:
        return AppTheme.priorityMedium;
      default:
        return AppTheme.priorityLow;
    }
  }

  bool _isDueToday() {
    if (todo.dueDate == null) return false;
    final now = DateTime.now();
    return todo.dueDate!.year == now.year && todo.dueDate!.month == now.month && todo.dueDate!.day == now.day;
  }

  @override
  Widget build(BuildContext context) {
    final isToday = _isDueToday();

    final controller = useAnimationController(duration: const Duration(seconds: 2), lowerBound: 0.1, upperBound: 1.0);
    useEffect(() {
      if (isToday) controller.repeat(reverse: true); else controller.stop();
      return null;
    }, [isToday]);
    final pulseOpacity = useAnimation(controller);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Container(
        decoration: isToday
            ? BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.red.withOpacity(pulseOpacity), width: 2),
              )
            : null,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Container(width: 4, height: 40, decoration: BoxDecoration(color: getPriorityColor(), borderRadius: BorderRadius.circular(2))),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(todo.title ?? 'No Title', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 4),
                    Row(children: [
                      if (category != null) ...[
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(color: _parseColor(category!.color).withOpacity(0.1), borderRadius: BorderRadius.circular(4)),
                          child: Text(category!.name ?? '', style: TextStyle(fontSize: 10, color: _parseColor(category!.color), fontWeight: FontWeight.bold)),
                        ),
                        const SizedBox(width: 8),
                      ],
                      Icon(Icons.calendar_today, size: 14, color: isToday ? Colors.red : Colors.grey.shade600),
                      const SizedBox(width: 4),
                      Text(todo.dueDate != null ? DateFormat('dd.MM.yyyy').format(todo.dueDate!) : '', style: TextStyle(fontSize: 12, color: isToday ? Colors.red : Colors.grey.shade600, fontWeight: isToday ? FontWeight.bold : null)),
                    ]),
                  ],
                ),
              ),
              Text(todo.status, style: TextStyle(fontSize: 12, color: Colors.grey.shade500)),
            ],
          ),
        ),
      ),
    );
  }

  Color _parseColor(String? colorStr) {
    if (colorStr == null) return Colors.grey;
    try {
      return Color(int.parse(colorStr.replaceAll('#', '0xFF')));
    } catch (e) {
      return Colors.grey;
    }
  }
}
