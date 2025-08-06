import 'package:equatable/equatable.dart';
import 'package:intl/intl.dart';

import '../../../../domain/models/user.dart';

class UserViewModel extends Equatable {
  final String id;
  final String email;
  final String fullName;
  final String? avatarUrl;
  final String displayName;
  final String initials;
  final String formattedJoinDate;
  final bool hasAvatar;

  const UserViewModel({
    required this.id,
    required this.email,
    required this.fullName,
    this.avatarUrl,
    required this.displayName,
    required this.initials,
    required this.formattedJoinDate,
    required this.hasAvatar,
  });

  factory UserViewModel.fromUser(User user) {
    final displayName = _getDisplayName(user.fullName);
    final initials = _getInitials(user.fullName);
    final formattedJoinDate = _getFormattedJoinDate(user.createdAt);
    final hasAvatar = user.avatarUrl != null && user.avatarUrl!.isNotEmpty;

    return UserViewModel(
      id: user.id,
      email: user.email,
      fullName: user.fullName,
      avatarUrl: user.avatarUrl,
      displayName: displayName,
      initials: initials,
      formattedJoinDate: formattedJoinDate,
      hasAvatar: hasAvatar,
    );
  }

  static String _getDisplayName(String fullName) {
    if (fullName.trim().isEmpty) return 'User';
    
    final parts = fullName.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts[0]} ${parts[1]}';
    }
    
    return parts[0];
  }

  static String _getInitials(String fullName) {
    if (fullName.trim().isEmpty) return 'U';
    
    final parts = fullName.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0].toUpperCase()}${parts[1][0].toUpperCase()}';
    }
    
    return parts[0][0].toUpperCase();
  }

  static String _getFormattedJoinDate(DateTime createdAt) {
    return DateFormat('MMM yyyy').format(createdAt);
  }

  String get firstName {
    final parts = fullName.trim().split(' ');
    return parts.isNotEmpty ? parts[0] : '';
  }

  String get lastName {
    final parts = fullName.trim().split(' ');
    return parts.length >= 2 ? parts[1] : '';
  }

  String get emailDomain {
    final atIndex = email.indexOf('@');
    return atIndex != -1 ? email.substring(atIndex + 1) : '';
  }

  bool get isBusinessEmail {
    final businessDomains = ['gmail.com', 'yahoo.com', 'hotmail.com', 'outlook.com'];
    return !businessDomains.contains(emailDomain.toLowerCase());
  }

  @override
  List<Object?> get props => [
    id,
    email,
    fullName,
    avatarUrl,
    displayName,
    initials,
    formattedJoinDate,
    hasAvatar,
  ];
}