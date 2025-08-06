import 'package:flutter/material.dart';

import '../../../domain/models/user.dart';
import '../../shared/widgets/user_avatar_widget.dart';
import '../../core/theme/app_colors.dart';

class TeamMemberSelector extends StatelessWidget {
  final List<User> availableMembers;
  final List<User> selectedMembers;
  final ValueChanged<User> onMemberToggle;
  final VoidCallback? onAddMember;

  const TeamMemberSelector({
    super.key,
    required this.availableMembers,
    required this.selectedMembers,
    required this.onMemberToggle,
    this.onAddMember,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Team Member',
          style: TextStyle(
            fontSize: 14,
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w400,
          ),
        ),
        const SizedBox(height: 12),
        ConstrainedBox(
          constraints: const BoxConstraints(
            minHeight: 60,
            maxHeight: 80,
          ),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            physics: const ClampingScrollPhysics(),
            child: Row(
              children: [
                ...availableMembers.asMap().entries.map((entry) {
                  final index = entry.key;
                  final member = entry.value;
                  final isSelected = selectedMembers.contains(member);
                  
                  return Padding(
                    padding: EdgeInsets.only(
                      right: index < availableMembers.length - 1 ? 12 : 12,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        UserAvatarWidget(
                          user: member,
                          isSelected: isSelected,
                          onTap: () => onMemberToggle(member),
                          size: 48,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _getDisplayName(member.fullName),
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  );
                }),
                _buildAddButton(),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAddButton() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        UserAvatarWidget(
          showAddIcon: true,
          onTap: onAddMember,
          size: 48,
        ),
        const SizedBox(height: 4),
        const SizedBox(
          height: 16, // Match height of text in other columns
        ),
      ],
    );
  }

  String _getDisplayName(String fullName) {
    final firstName = fullName.split(' ').first;
    return firstName.length > 8 
      ? '${firstName.substring(0, 8)}...'
      : firstName;
  }
}