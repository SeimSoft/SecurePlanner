import 'package:uuid/uuid.dart';

enum TodoPriority { low, medium, high }

class TodoModel {
  final String id;
  final String title;
  final TodoPriority priority;
  final String timeEstimate;
  final DateTime dueDate;
  final String? encryptedBlob;
  final int version;
  final bool deleted;
  final DateTime updatedAt;

  TodoModel({
    String? id,
    required this.title,
    required this.priority,
    required this.timeEstimate,
    required this.dueDate,
    this.encryptedBlob,
    this.version = 1,
    this.deleted = false,
    DateTime? updatedAt,
  })  : id = id ?? const Uuid().v4(),
        updatedAt = updatedAt ?? DateTime.now();

  TodoModel copyWith({
    String? title,
    TodoPriority? priority,
    String? timeEstimate,
    DateTime? dueDate,
    String? encryptedBlob,
    int? version,
    bool? deleted,
    DateTime? updatedAt,
  }) {
    return TodoModel(
      id: id,
      title: title ?? this.title,
      priority: priority ?? this.priority,
      timeEstimate: timeEstimate ?? this.timeEstimate,
      dueDate: dueDate ?? this.dueDate,
      encryptedBlob: encryptedBlob ?? this.encryptedBlob,
      version: version ?? this.version,
      deleted: deleted ?? this.deleted,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'priority': priority.index,
      'time_estimate': timeEstimate,
      'due_date': dueDate.toIso8601String(),
      'encrypted_blob': encryptedBlob,
      'version': version,
      'deleted': deleted,
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  factory TodoModel.fromJson(Map<String, dynamic> json) {
    return TodoModel(
      id: json['id'],
      title: json['title'],
      priority: TodoPriority.values[json['priority'] ?? 0],
      timeEstimate: json['time_estimate'],
      dueDate: DateTime.parse(json['due_date']),
      encryptedBlob: json['encrypted_blob'],
      version: json['version'] ?? 1,
      deleted: json['deleted'] ?? false,
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }
}
