import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/models/team.dart';

class TeamServiceLocal {
  static const String _teamsKey = 'teams';
  static const String _teamCounterKey = 'team_counter';

  Future<List<Team>> getTeams() async {
    final prefs = await SharedPreferences.getInstance();
    final teamsJson = prefs.getStringList(_teamsKey) ?? [];
    
    return teamsJson.map((json) {
      final Map<String, dynamic> teamMap = jsonDecode(json);
      return Team(
        id: teamMap['id'],
        name: teamMap['name'],
        description: teamMap['description'],
        privacy: TeamPrivacy.values.firstWhere((p) => p.name == teamMap['privacy']),
        ownerId: teamMap['ownerId'],
        memberIds: List<String>.from(teamMap['memberIds'] ?? []),
        createdAt: DateTime.parse(teamMap['createdAt']),
        updatedAt: DateTime.parse(teamMap['updatedAt']),
      );
    }).toList();
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
    final teams = await getTeams();
    final existingIndex = teams.indexWhere((t) => t.id == team.id);
    
    if (existingIndex != -1) {
      teams[existingIndex] = team.copyWith(updatedAt: DateTime.now());
    } else {
      teams.add(team);
    }
    
    await _saveTeams(teams);
    return teams.firstWhere((t) => t.id == team.id);
  }

  Future<Team> createTeam({
    required String name,
    required String description,
    required TeamPrivacy privacy,
    required String ownerId,
  }) async {
    final id = await _generateId();
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
    final teams = await getTeams();
    final teamIndex = teams.indexWhere((team) => team.id == id);
    
    if (teamIndex == -1) {
      throw Exception('Team not found');
    }
    
    final updatedTeam = teams[teamIndex].copyWith(
      name: name,
      description: description,
      privacy: privacy,
      updatedAt: DateTime.now(),
    );
    
    teams[teamIndex] = updatedTeam;
    await _saveTeams(teams);
    
    return updatedTeam;
  }

  Future<Team> addMemberToTeam(String teamId, String memberId) async {
    final teams = await getTeams();
    final teamIndex = teams.indexWhere((team) => team.id == teamId);
    
    if (teamIndex == -1) {
      throw Exception('Team not found');
    }
    
    final team = teams[teamIndex];
    if (!team.memberIds.contains(memberId)) {
      final updatedMemberIds = List<String>.from(team.memberIds)..add(memberId);
      final updatedTeam = team.copyWith(
        memberIds: updatedMemberIds,
        updatedAt: DateTime.now(),
      );
      
      teams[teamIndex] = updatedTeam;
      await _saveTeams(teams);
      
      return updatedTeam;
    }
    
    return team;
  }

  Future<Team> removeMemberFromTeam(String teamId, String memberId) async {
    final teams = await getTeams();
    final teamIndex = teams.indexWhere((team) => team.id == teamId);
    
    if (teamIndex == -1) {
      throw Exception('Team not found');
    }
    
    final team = teams[teamIndex];
    final updatedMemberIds = List<String>.from(team.memberIds)..remove(memberId);
    final updatedTeam = team.copyWith(
      memberIds: updatedMemberIds,
      updatedAt: DateTime.now(),
    );
    
    teams[teamIndex] = updatedTeam;
    await _saveTeams(teams);
    
    return updatedTeam;
  }

  Future<void> deleteTeam(String id) async {
    final teams = await getTeams();
    teams.removeWhere((team) => team.id == id);
    await _saveTeams(teams);
  }

  Future<String> _generateId() async {
    final prefs = await SharedPreferences.getInstance();
    final counter = prefs.getInt(_teamCounterKey) ?? 0;
    final newCounter = counter + 1;
    await prefs.setInt(_teamCounterKey, newCounter);
    return 'team_$newCounter';
  }

  Future<void> _saveTeams(List<Team> teams) async {
    final prefs = await SharedPreferences.getInstance();
    final teamsJson = teams.map((team) {
      return jsonEncode({
        'id': team.id,
        'name': team.name,
        'description': team.description,
        'privacy': team.privacy.name,
        'ownerId': team.ownerId,
        'memberIds': team.memberIds,
        'createdAt': team.createdAt.toIso8601String(),
        'updatedAt': team.updatedAt.toIso8601String(),
      });
    }).toList();
    
    await prefs.setStringList(_teamsKey, teamsJson);
  }
}