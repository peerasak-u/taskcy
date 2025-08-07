import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/models/project.dart';
import '../../../domain/models/user.dart';
import '../../core/theme/app_colors.dart';
import '../../shared/widgets/header_widget.dart';
import '../../task_list/bloc/task_list_bloc.dart';
import '../../task_list/bloc/task_list_event.dart';
import '../bloc/add_task_bloc.dart';
import '../bloc/add_task_event.dart';
import '../bloc/add_task_state.dart';
import '../view_model/add_task_form_model.dart';
import 'project_selector_widget.dart';
import 'description_field_widget.dart';
import 'team_member_selector.dart';
import 'date_picker_field.dart';
import 'time_picker_fields.dart';
import 'board_status_selector.dart';

class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({super.key});

  static Future<void> show(BuildContext context) {
    return showGeneralDialog<void>(
      context: context,
      barrierDismissible: true,
      barrierLabel: '',
      pageBuilder: (context, animation, secondaryAnimation) {
        return const AddTaskScreen();
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0.0, 1.0);
        const end = Offset.zero;
        const curve = Curves.easeInOut;

        var tween = Tween(begin: begin, end: end).chain(
          CurveTween(curve: curve),
        );
        var offsetAnimation = animation.drive(tween);

        return SlideTransition(
          position: offsetAnimation,
          child: child,
        );
      },
    );
  }

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final TextEditingController _taskNameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Load initial data when the screen is created
    context.read<AddTaskBloc>().add(const LoadInitialData());
  }

  @override
  void dispose() {
    _taskNameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _syncControllersWithState(AddTaskFormModel formModel) {
    // Update controllers only if the text differs to avoid cursor position issues
    if (_taskNameController.text != formModel.taskName) {
      _taskNameController.text = formModel.taskName;
    }
    if (_descriptionController.text != formModel.description) {
      _descriptionController.text = formModel.description;
    }
  }

  @override
  Widget build(BuildContext context) {

    return BlocListener<AddTaskBloc, AddTaskState>(
      listener: (context, state) {
        if (state is AddTaskSuccess) {
          // Refresh task list if available
          try {
            context.read<TaskListBloc>().add(const RefreshTaskList());
            debugPrint('🔄 AddTaskScreen: Triggered task list refresh after task creation');
          } catch (e) {
            debugPrint('⚠️ AddTaskScreen: TaskListBloc not found, refresh not triggered');
          }
          
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Task created successfully'),
              backgroundColor: AppColors.green,
            ),
          );
        } else if (state is AddTaskFailed) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: AppColors.orange,
            ),
          );
        } else if (state is AddTaskInvalidate) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage),
              backgroundColor: AppColors.orange,
            ),
          );
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight),
          child: SafeArea(
            child: HeaderWidget(
              centerText: 'Add Task',
              leftIcon: Icons.close,
              onLeftTap: () => Navigator.of(context).pop(),
            ),
          ),
        ),
        body: SafeArea(
          top: false,
          child: BlocBuilder<AddTaskBloc, AddTaskState>(
            builder: (context, state) {
              if (state is AddTaskInitial || state is AddTaskLoading) {
                return _buildLoadingState();
              } else if (state is AddTaskReady || state is AddTaskInvalidate || state is AddTaskSubmitting || state is AddTaskFailed) {
                // Sync controllers with current state
                late final AddTaskFormModel formModel;
                if (state is AddTaskReady) {
                  formModel = state.formModel;
                } else if (state is AddTaskInvalidate) {
                  formModel = state.formModel;
                } else if (state is AddTaskSubmitting) {
                  formModel = state.formModel;
                } else if (state is AddTaskFailed) {
                  formModel = state.formModel;
                }
                _syncControllersWithState(formModel);
                
                return _buildFormState(context, state);
              }
              return _buildLoadingState();
            },
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return const Center(
      child: CircularProgressIndicator(
        color: AppColors.primary,
      ),
    );
  }

  Widget _buildFormState(BuildContext context, AddTaskState state) {
    late final AddTaskFormModel formModel;
    late final List<Project> availableProjects;
    late final List<User> availableUsers;
    bool isSubmitting = false;

    if (state is AddTaskReady) {
      formModel = state.formModel;
      availableProjects = state.availableProjects;
      availableUsers = state.availableUsers;
    } else if (state is AddTaskInvalidate) {
      formModel = state.formModel;
      availableProjects = state.availableProjects;
      availableUsers = state.availableUsers;
    } else if (state is AddTaskSubmitting) {
      formModel = state.formModel;
      availableProjects = state.availableProjects;
      availableUsers = state.availableUsers;
      isSubmitting = true;
    } else if (state is AddTaskFailed) {
      formModel = state.formModel;
      availableProjects = state.availableProjects;
      availableUsers = state.availableUsers;
    }

    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
    
    return SingleChildScrollView(
      physics: const ClampingScrollPhysics(),
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 24,
        bottom: MediaQuery.of(context).padding.bottom + 24 + keyboardHeight,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTaskNameField(context),
          const SizedBox(height: 32),
          ProjectSelectorWidget(
            availableProjects: availableProjects,
            selectedProject: formModel.selectedProject,
            onProjectSelected: (project) {
              context.read<AddTaskBloc>().add(SelectProject(project));
            },
          ),
          const SizedBox(height: 32),
          DescriptionFieldWidget(
            controller: _descriptionController,
            description: formModel.description,
            onDescriptionChanged: (description) {
              context.read<AddTaskBloc>().add(UpdateDescription(description));
            },
          ),
          const SizedBox(height: 32),
          TeamMemberSelector(
            availableMembers: availableUsers,
            selectedMembers: formModel.selectedMembers,
            onMemberToggle: (user) {
              context.read<AddTaskBloc>().add(ToggleTeamMember(user));
            },
            onAddMember: _handleAddMember,
          ),
          const SizedBox(height: 32),
          DatePickerField(
            label: 'Date',
            selectedDate: formModel.selectedDate,
            onDateSelected: (date) {
              context.read<AddTaskBloc>().add(UpdateSelectedDate(date));
            },
          ),
          const SizedBox(height: 32),
          TimePickerFields(
            startTime: formModel.startTime,
            endTime: formModel.endTime,
            onStartTimeChanged: (time) {
              context.read<AddTaskBloc>().add(UpdateStartTime(time));
            },
            onEndTimeChanged: (time) {
              context.read<AddTaskBloc>().add(UpdateEndTime(time));
            },
          ),
          const SizedBox(height: 32),
          BoardStatusSelector(
            selectedStatus: formModel.boardStatus,
            onStatusChanged: (status) {
              context.read<AddTaskBloc>().add(UpdateBoardStatus(status));
            },
          ),
          const SizedBox(height: 48),
          _buildSaveButton(context, isSubmitting),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildTaskNameField(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Task Name',
          style: TextStyle(
            fontSize: 14,
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w400,
          ),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _taskNameController,
          onChanged: (value) {
            context.read<AddTaskBloc>().add(UpdateTaskName(value));
          },
          maxLines: 1,
          textInputAction: TextInputAction.next,
          style: const TextStyle(
            fontSize: 16,
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w500,
          ),
          decoration: InputDecoration(
            hintText: 'Enter task name',
            hintStyle: const TextStyle(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w400,
            ),
            filled: true,
            fillColor: AppColors.surface,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: AppColors.primary,
                width: 2,
              ),
            ),
            contentPadding: const EdgeInsets.all(16),
          ),
        ),
      ],
    );
  }

  Widget _buildSaveButton(BuildContext context, bool isSubmitting) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: isSubmitting 
          ? null 
          : () => context.read<AddTaskBloc>().add(const SubmitTask()),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.background,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: isSubmitting
          ? const SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.background),
              ),
            )
          : const Text(
              'Save',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
      ),
    );
  }

  void _handleAddMember() {
    // TODO: Implement add member functionality
    // This could open a user selection dialog or navigate to a user selection screen
  }
}