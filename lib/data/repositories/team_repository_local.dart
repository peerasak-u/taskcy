import '../../domain/models/team.dart';
import '../../domain/repositories/team_repository.dart';
import '../services/team_service_local.dart';

class TeamRepositoryLocal implements TeamRepository {
  final TeamServiceLocal _teamService = TeamServiceLocal();

  @override
  Future<List<Team>> getTeams({
    int page = 1,
    int perPage = 20,
    String? search,
    TeamPrivacy? privacy,
  }) async {
    // Simulate API call
    await Future.delayed(const Duration(milliseconds: 300));
    
    List<Team> teams;
    
    if (search != null && search.isNotEmpty) {
      teams = await _teamService.searchTeams(search);
    } else {
      teams = await _teamService.getTeams();
    }
    
    // Apply privacy filter
    if (privacy != null) {
      teams = teams.where((team) => team.privacy == privacy).toList();
    }
    
    // Apply pagination
    final startIndex = (page - 1) * perPage;
    final endIndex = startIndex + perPage;
    
    if (startIndex >= teams.length) {
      return [];
    }
    
    return teams.sublist(
      startIndex,
      endIndex > teams.length ? teams.length : endIndex,
    );
  }

  @override
  Future<Team> getTeamById(String id) async {
    // Simulate API call
    await Future.delayed(const Duration(milliseconds: 500));
    
    final team = await _teamService.getTeamById(id);
    if (team == null) {
      throw Exception('Team not found');
    }
    return team;
  }

  @override
  Future<Team> createTeam({
    required String name,
    required String description,
    required TeamPrivacy privacy,
    required String ownerId,
  }) async {
    // Simulate API call
    await Future.delayed(const Duration(milliseconds: 800));
    
    return await _teamService.createTeam(
      name: name,
      description: description,
      privacy: privacy,
      ownerId: ownerId,
    );
  }

  @override
  Future<Team> updateTeam(
    String id, {
    String? name,
    String? description,
    TeamPrivacy? privacy,
  }) async {
    // Simulate API call
    await Future.delayed(const Duration(milliseconds: 500));
    
    return await _teamService.updateTeam(
      id,
      name: name,
      description: description,
      privacy: privacy,
    );
  }

  @override
  Future<void> deleteTeam(String id) async {
    // Simulate API call
    await Future.delayed(const Duration(milliseconds: 500));
    
    await _teamService.deleteTeam(id);
  }

  @override
  Future<List<Team>> getTeamsByOwner(String ownerId) async {
    // Simulate API call
    await Future.delayed(const Duration(milliseconds: 300));
    
    return await _teamService.getTeamsByOwner(ownerId);
  }

  @override
  Future<List<Team>> getTeamsByMember(String memberId) async {
    // Simulate API call
    await Future.delayed(const Duration(milliseconds: 300));
    
    return await _teamService.getTeamsByMember(memberId);
  }

  @override
  Future<Team> addMemberToTeam(String teamId, String memberId) async {
    // Simulate API call
    await Future.delayed(const Duration(milliseconds: 500));
    
    return await _teamService.addMemberToTeam(teamId, memberId);
  }

  @override
  Future<Team> removeMemberFromTeam(String teamId, String memberId) async {
    // Simulate API call
    await Future.delayed(const Duration(milliseconds: 500));
    
    return await _teamService.removeMemberFromTeam(teamId, memberId);
  }
}