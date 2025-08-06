import 'package:equatable/equatable.dart';

import 'team.dart';

class Project extends Equatable {
  final String id;
  final String name;
  final String description;
  final Team team;
  final String ownerId;
  final DateTime? dueDate;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Project({
    required this.id,
    required this.name,
    required this.description,
    required this.team,
    required this.ownerId,
    this.dueDate,
    required this.createdAt,
    required this.updatedAt,
  });

  Project copyWith({
    String? id,
    String? name,
    String? description,
    Team? team,
    String? ownerId,
    DateTime? dueDate,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Project(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      team: team ?? this.team,
      ownerId: ownerId ?? this.ownerId,
      dueDate: dueDate ?? this.dueDate,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  bool get isOverdue {
    if (dueDate == null) return false;
    return DateTime.now().isAfter(dueDate!);
  }

  @override
  List<Object?> get props => [
        id,
        name,
        description,
        team,
        ownerId,
        dueDate,
        createdAt,
        updatedAt,
      ];
}