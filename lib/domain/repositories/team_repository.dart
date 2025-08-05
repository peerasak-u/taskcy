import '../models/team.dart';

abstract class TeamRepository {
  Future<List<Team>> getTeams({
    int page = 1,
    int perPage = 20,
    String? search,
    TeamPrivacy? privacy,
  });

  Future<Team> getTeamById(String id);

  Future<Team> createTeam({
    required String name,
    required String description,
    required TeamPrivacy privacy,
    required String ownerId,
  });

  Future<Team> updateTeam(
    String id, {
    String? name,
    String? description,
    TeamPrivacy? privacy,
  });

  Future<void> deleteTeam(String id);

  Future<List<Team>> getTeamsByOwner(String ownerId);

  Future<List<Team>> getTeamsByMember(String memberId);

  Future<Team> addMemberToTeam(String teamId, String memberId);

  Future<Team> removeMemberFromTeam(String teamId, String memberId);
}