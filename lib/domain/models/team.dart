import 'package:equatable/equatable.dart';

enum TeamPrivacy { private, public, secret }

class Team extends Equatable {
  final String id;
  final String name;
  final String description;
  final TeamPrivacy privacy;
  final String ownerId;
  final List<String> memberIds;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Team({
    required this.id,
    required this.name,
    required this.description,
    required this.privacy,
    required this.ownerId,
    required this.memberIds,
    required this.createdAt,
    required this.updatedAt,
  });

  Team copyWith({
    String? id,
    String? name,
    String? description,
    TeamPrivacy? privacy,
    String? ownerId,
    List<String>? memberIds,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Team(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      privacy: privacy ?? this.privacy,
      ownerId: ownerId ?? this.ownerId,
      memberIds: memberIds ?? this.memberIds,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        description,
        privacy,
        ownerId,
        memberIds,
        createdAt,
        updatedAt,
      ];
}