import '../../domain/models/team.dart';

class TeamServiceLocal {
  static List<Team>? _teams;
  static int _teamCounter = 3;

  Future<List<Team>> getTeams() async {
    _teams ??= _seedInitialTeams();
    return List<Team>.from(_teams!);
  }

  Future<Team?> getTeamById(String id) async {
    final teams = await getTeams();
    try {
      return teams.firstWhere((team) => team.id == id);
    } catch (e) {
      return null;
    }
  }

  Future<List<Team>> getTeamsByOwner(String ownerId) async {
    final teams = await getTeams();
    return teams.where((team) => team.ownerId == ownerId).toList();
  }

  Future<List<Team>> getTeamsByMember(String memberId) async {
    final teams = await getTeams();
    return teams.where((team) => 
      team.ownerId == memberId || team.memberIds.contains(memberId)
    ).toList();
  }

  Future<List<Team>> searchTeams(String query) async {
    final teams = await getTeams();
    final lowerQuery = query.toLowerCase();
    
    return teams.where((team) {
      return team.name.toLowerCase().contains(lowerQuery) ||
             team.description.toLowerCase().contains(lowerQuery);
    }).toList();
  }

  Future<List<Team>> getTeamsByPrivacy(TeamPrivacy privacy) async {
    final teams = await getTeams();
    return teams.where((team) => team.privacy == privacy).toList();
  }

  Future<Team> saveTeam(Team team) async {
    _teams ??= _seedInitialTeams();
    final existingIndex = _teams!.indexWhere((t) => t.id == team.id);
    
    if (existingIndex != -1) {
      _teams![existingIndex] = team.copyWith(updatedAt: DateTime.now());
    } else {
      _teams!.add(team);
    }
    
    return _teams!.firstWhere((t) => t.id == team.id);
  }

  Future<Team> createTeam({
    required String name,
    required String description,
    required TeamPrivacy privacy,
    required String ownerId,
  }) async {
    final id = _generateId();
    final now = DateTime.now();
    
    final team = Team(
      id: id,
      name: name,
      description: description,
      privacy: privacy,
      ownerId: ownerId,
      memberIds: const [],
      createdAt: now,
      updatedAt: now,
    );
    
    return await saveTeam(team);
  }

  Future<Team> updateTeam(String id, {
    String? name,
    String? description,
    TeamPrivacy? privacy,
  }) async {
    _teams ??= _seedInitialTeams();
    final teamIndex = _teams!.indexWhere((team) => team.id == id);
    
    if (teamIndex == -1) {
      throw Exception('Team not found');
    }
    
    final updatedTeam = _teams![teamIndex].copyWith(
      name: name,
      description: description,
      privacy: privacy,
      updatedAt: DateTime.now(),
    );
    
    _teams![teamIndex] = updatedTeam;
    
    return updatedTeam;
  }

  Future<Team> addMemberToTeam(String teamId, String memberId) async {
    _teams ??= _seedInitialTeams();
    final teamIndex = _teams!.indexWhere((team) => team.id == teamId);
    
    if (teamIndex == -1) {
      throw Exception('Team not found');
    }
    
    final team = _teams![teamIndex];
    if (!team.memberIds.contains(memberId)) {
      final updatedMemberIds = List<String>.from(team.memberIds)..add(memberId);
      final updatedTeam = team.copyWith(
        memberIds: updatedMemberIds,
        updatedAt: DateTime.now(),
      );
      
      _teams![teamIndex] = updatedTeam;
      
      return updatedTeam;
    }
    
    return team;
  }

  Future<Team> removeMemberFromTeam(String teamId, String memberId) async {
    _teams ??= _seedInitialTeams();
    final teamIndex = _teams!.indexWhere((team) => team.id == teamId);
    
    if (teamIndex == -1) {
      throw Exception('Team not found');
    }
    
    final team = _teams![teamIndex];
    final updatedMemberIds = List<String>.from(team.memberIds)..remove(memberId);
    final updatedTeam = team.copyWith(
      memberIds: updatedMemberIds,
      updatedAt: DateTime.now(),
    );
    
    _teams![teamIndex] = updatedTeam;
    
    return updatedTeam;
  }

  Future<void> deleteTeam(String id) async {
    _teams ??= _seedInitialTeams();
    _teams!.removeWhere((team) => team.id == id);
  }

  String _generateId() {
    _teamCounter++;
    return 'team_$_teamCounter';
  }

  List<Team> _seedInitialTeams() {
    final now = DateTime.now();
    
    return [
      Team(
        id: 'team_axentech',
        name: 'AxenTech',
        description: 'Flutter development team for AxenTech assignment project',
        privacy: TeamPrivacy.private,
        ownerId: 'user_peerasak',
        memberIds: const ['user_claude'],
        createdAt: now.subtract(const Duration(days: 25)),
        updatedAt: now.subtract(const Duration(hours: 3)),
      ),
      Team(
        id: 'team_pygmy',
        name: 'Pygmy Migration',
        description: 'Dedicated team for migrating Pygmy app from iOS to Flutter',
        privacy: TeamPrivacy.private,
        ownerId: 'user_peerasak',
        memberIds: const ['user_claude'],
        createdAt: now.subtract(const Duration(days: 20)),
        updatedAt: now.subtract(const Duration(hours: 1)),
      ),
      Team(
        id: 'team_creativeworks',
        name: 'CreativeWorks Studio',
        description: 'Multi-disciplinary team for creative and marketing projects',
        privacy: TeamPrivacy.public,
        ownerId: 'user_sarah',
        memberIds: const ['user_peerasak', 'user_claude', 'user_alex'],
        createdAt: now.subtract(const Duration(days: 40)),
        updatedAt: now.subtract(const Duration(minutes: 30)),
      ),
    ];
  }
}