import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_colors.dart';
import '../../../domain/models/user.dart';
import '../../../routing/route_utils.dart';
import '../cubit/add_task_cubit.dart';
import '../cubit/add_task_state.dart';
import 'team_member_selector.dart';
import 'date_picker_field.dart';
import 'time_picker_fields.dart';
import 'board_status_selector.dart';

class AddTaskScreen extends StatelessWidget {
  const AddTaskScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AddTaskCubit, AddTaskState>(
      listener: (context, state) {
        if (state is AddTaskSuccess) {
          context.go(RouteUtils.homePath);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Task created successfully'),
              backgroundColor: AppColors.green,
            ),
          );
        } else if (state is AddTaskError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: AppColors.orange,
            ),
          );
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: _buildAppBar(context),
        body: const SafeArea(
          child: _AddTaskForm(),
        ),
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.background,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(
          Icons.arrow_back_ios,
          color: AppColors.textPrimary,
          size: 20,
        ),
        onPressed: () => context.go(RouteUtils.homePath),
      ),
      title: const Text(
        'Add Task',
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
      ),
      centerTitle: true,
    );
  }
}

class _AddTaskForm extends StatefulWidget {
  const _AddTaskForm();

  @override
  State<_AddTaskForm> createState() => _AddTaskFormState();
}

class _AddTaskFormState extends State<_AddTaskForm> {
  final _taskNameController = TextEditingController();
  final _mockUsers = [
    User(
      id: '1',
      email: 'jeny@example.com',
      fullName: 'Jeny',
      avatarUrl: 'https://example.com/jeny.jpg',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ),
    User(
      id: '2',
      email: 'mehrin@example.com',
      fullName: 'mehrin',
      avatarUrl: 'https://example.com/mehrin.jpg',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ),
    User(
      id: '3',
      email: 'avishek@example.com',
      fullName: 'Avishek',
      avatarUrl: 'https://example.com/avishek.jpg',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ),
    User(
      id: '4',
      email: 'jafor@example.com',
      fullName: 'Jafor',
      avatarUrl: 'https://example.com/jafor.jpg',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ),
  ];

  @override
  void dispose() {
    _taskNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddTaskCubit, AddTaskState>(
      builder: (context, state) {
        final cubit = context.read<AddTaskCubit>();
        final formModel = cubit.formModel;
        final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
        
        return SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          padding: EdgeInsets.only(
            left: 24,
            right: 24,
            top: 24,
            bottom: 24 + keyboardHeight,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTaskNameField(cubit),
              const SizedBox(height: 32),
              TeamMemberSelector(
                availableMembers: _mockUsers,
                selectedMembers: formModel.selectedMembers,
                onMemberToggle: cubit.toggleTeamMember,
                onAddMember: _handleAddMember,
              ),
              const SizedBox(height: 32),
              DatePickerField(
                label: 'Date',
                selectedDate: formModel.selectedDate,
                onDateSelected: cubit.updateSelectedDate,
              ),
              const SizedBox(height: 32),
              TimePickerFields(
                startTime: formModel.startTime,
                endTime: formModel.endTime,
                onStartTimeChanged: cubit.updateStartTime,
                onEndTimeChanged: cubit.updateEndTime,
              ),
              const SizedBox(height: 32),
              BoardStatusSelector(
                selectedStatus: formModel.boardStatus,
                onStatusChanged: cubit.updateBoardStatus,
              ),
              const SizedBox(height: 48),
              _buildSaveButton(context, state, cubit),
              const SizedBox(height: 24),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTaskNameField(AddTaskCubit cubit) {
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
          onChanged: cubit.updateTaskName,
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

  Widget _buildSaveButton(BuildContext context, AddTaskState state, AddTaskCubit cubit) {
    final isLoading = state is AddTaskLoading;
    
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: isLoading ? null : () => cubit.createTask(),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.background,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: isLoading
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