import '../../domain/models/team.dart';
import '../../domain/models/user.dart';
import 'user_service_local.dart';

class TeamServiceLocal {
  static List<Team>? _teams;
  static int _teamCounter = 3;
  final UserServiceLocal _userService = UserServiceLocal();

  Future<List<Team>> getTeams() async {
    _teams ??= await _seedInitialTeams();
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
      team.ownerId == memberId || team.members.any((member) => member.id == memberId)
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
    _teams ??= await _seedInitialTeams();
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
      members: const [],
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
    _teams ??= await _seedInitialTeams();
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
    _teams ??= await _seedInitialTeams();
    final teamIndex = _teams!.indexWhere((team) => team.id == teamId);
    
    if (teamIndex == -1) {
      throw Exception('Team not found');
    }
    
    final team = _teams![teamIndex];
    if (!team.members.any((member) => member.id == memberId)) {
      final userToAdd = await _userService.getUserById(memberId);
      if (userToAdd != null) {
        final updatedMembers = List<User>.from(team.members)..add(userToAdd);
        final updatedTeam = team.copyWith(
          members: updatedMembers,
          updatedAt: DateTime.now(),
        );
        
        _teams![teamIndex] = updatedTeam;
        
        return updatedTeam;
      } else {
        throw Exception('User not found');
      }
    }
    
    return team;
  }

  Future<Team> removeMemberFromTeam(String teamId, String memberId) async {
    _teams ??= await _seedInitialTeams();
    final teamIndex = _teams!.indexWhere((team) => team.id == teamId);
    
    if (teamIndex == -1) {
      throw Exception('Team not found');
    }
    
    final team = _teams![teamIndex];
    final updatedMembers = team.members.where((member) => member.id != memberId).toList();
    final updatedTeam = team.copyWith(
      members: updatedMembers,
      updatedAt: DateTime.now(),
    );
    
    _teams![teamIndex] = updatedTeam;
    
    return updatedTeam;
  }

  Future<void> deleteTeam(String id) async {
    _teams ??= await _seedInitialTeams();
    _teams!.removeWhere((team) => team.id == id);
  }

  String _generateId() {
    _teamCounter++;
    return 'team_$_teamCounter';
  }

  Future<List<Team>> _seedInitialTeams() async {
    final allUsers = await _userService.getUsers();
    
    // Helper function to get users by IDs
    List<User> getUsersByIds(List<String> userIds) {
      return userIds.map((id) => allUsers.firstWhere((user) => user.id == id)).toList();
    }
    
    final now = DateTime.now();
    
    return [
      Team(
        id: 'team_axentech',
        name: 'AxenTech',
        description: 'Flutter development team for AxenTech assignment project',
        privacy: TeamPrivacy.private,
        ownerId: 'user_peerasak',
        members: getUsersByIds(['user_claude']),
        createdAt: now.subtract(const Duration(days: 25)),
        updatedAt: now.subtract(const Duration(hours: 3)),
      ),
      Team(
        id: 'team_pygmy',
        name: 'Pygmy Migration',
        description: 'Dedicated team for migrating Pygmy app from iOS to Flutter',
        privacy: TeamPrivacy.private,
        ownerId: 'user_peerasak',
        members: getUsersByIds(['user_claude']),
        createdAt: now.subtract(const Duration(days: 20)),
        updatedAt: now.subtract(const Duration(hours: 1)),
      ),
      Team(
        id: 'team_creativeworks',
        name: 'CreativeWorks Studio',
        description: 'Multi-disciplinary team for creative and marketing projects',
        privacy: TeamPrivacy.public,
        ownerId: 'user_sarah',
        members: getUsersByIds(['user_peerasak', 'user_claude', 'user_alex']),
        createdAt: now.subtract(const Duration(days: 40)),
        updatedAt: now.subtract(const Duration(minutes: 30)),
      ),
    ];
  }
}