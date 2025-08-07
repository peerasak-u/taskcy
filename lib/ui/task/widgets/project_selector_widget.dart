import 'package:flutter/material.dart';

import '../../../domain/models/project.dart';
import '../../core/theme/app_colors.dart';

class ProjectSelectorWidget extends StatelessWidget {
  final List<Project> availableProjects;
  final Project? selectedProject;
  final Function(Project) onProjectSelected;

  const ProjectSelectorWidget({
    super.key,
    required this.availableProjects,
    required this.selectedProject,
    required this.onProjectSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Project',
          style: TextStyle(
            fontSize: 14,
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w400,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.transparent, width: 2),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<Project>(
              value: selectedProject,
              hint: const Text(
                'Select a project',
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w400,
                ),
              ),
              style: const TextStyle(
                fontSize: 16,
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w500,
              ),
              icon: const Icon(
                Icons.keyboard_arrow_down,
                color: AppColors.textSecondary,
              ),
              dropdownColor: AppColors.surface,
              isExpanded: true,
              menuMaxHeight: 200,
              selectedItemBuilder: (BuildContext context) {
                return availableProjects.map<Widget>((Project project) {
                  return Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      project.name,
                      style: const TextStyle(
                        fontSize: 16,
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w500,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  );
                }).toList();
              },
              items: availableProjects.map<DropdownMenuItem<Project>>((
                Project project,
              ) {
                return DropdownMenuItem<Project>(
                  value: project,
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Text(
                      project.name,
                      style: const TextStyle(
                        fontSize: 16,
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w500,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                );
              }).toList(),
              onChanged: (Project? project) {
                if (project != null) {
                  onProjectSelected(project);
                }
              },
            ),
          ),
        ),
      ],
    );
  }
}
