import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/theme/app_colors.dart';
import '../../shared/widgets/header_widget.dart';
import '../bloc/chat_bloc.dart';
import '../bloc/chat_event.dart';
import '../bloc/chat_state.dart';
import 'chat_item_widget.dart';
import 'chat_search_field.dart';

class ChatScreen extends StatefulWidget {
  final TextEditingController searchController;
  
  const ChatScreen({super.key, required this.searchController});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  void initState() {
    super.initState();
    // Load chats when screen is built
    context.read<ChatBloc>().add(const LoadChats());
  }

  void _onSearchChanged(BuildContext context) {
    final query = widget.searchController.text.trim();
    context.read<ChatBloc>().add(SearchChats(query: query));
  }

  void _onSearchClear(BuildContext context) {
    widget.searchController.clear();
    context.read<ChatBloc>().add(const LoadChats());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            HeaderWidget(
              centerText: 'Chat',
              rightIcon: Icons.add,
              onRightTap: () {
                // TODO: Implement add new chat functionality
              },
            ),
            ChatSearchField(
              controller: widget.searchController,
              onChanged: (value) => _onSearchChanged(context),
              onClear: () => _onSearchClear(context),
            ),
            Expanded(
              child: BlocBuilder<ChatBloc, ChatState>(
                builder: (context, state) {
                  if (state is ChatLoading || state is ChatInitial) {
                    return _buildLoadingState();
                  } else if (state is ChatLoaded) {
                    return _buildLoadedState(context, state.chatsData.chats);
                  } else if (state is ChatSearchLoading) {
                    return _buildSearchLoadingState();
                  } else if (state is ChatSearchLoaded) {
                    return _buildSearchResultsState(context, state.searchResults.chats, state.query);
                  } else if (state is ChatEmpty) {
                    return _buildEmptyState(context);
                  } else if (state is ChatError) {
                    return _buildErrorState(context, state.message);
                  }
                  return _buildLoadingState();
                },
              ),
            ),
          ],
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

  Widget _buildSearchLoadingState() {
    return const Padding(
      padding: EdgeInsets.all(20.0),
      child: Row(
        children: [
          SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: AppColors.primary,
            ),
          ),
          SizedBox(width: 12),
          Text(
            'Searching...',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadedState(BuildContext context, List chats) {
    return RefreshIndicator(
      onRefresh: () async {
        context.read<ChatBloc>().add(const RefreshChats());
      },
      color: AppColors.primary,
      child: ListView.builder(
        itemCount: chats.length,
        itemBuilder: (context, index) {
          final chat = chats[index];
          return ChatItemWidget(
            chat: chat,
            onTap: () {
              // TODO: Navigate to chat conversation
            },
            onCameraTap: () {
              // TODO: Implement camera functionality
            },
          );
        },
      ),
    );
  }

  Widget _buildSearchResultsState(BuildContext context, List searchResults, String query) {
    if (searchResults.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off,
              size: 80,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'No results found',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Try searching with different keywords',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.grey[500],
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: searchResults.length,
      itemBuilder: (context, index) {
        final chat = searchResults[index];
        return ChatItemWidget(
          chat: chat,
          onTap: () {
            // TODO: Navigate to chat conversation
          },
          onCameraTap: () {
            // TODO: Implement camera functionality
          },
        );
      },
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.chat_bubble_outline,
            size: 80,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'No chats yet',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Start a conversation with your team members',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 80,
            color: Colors.red[400],
          ),
          const SizedBox(height: 16),
          Text(
            'Something went wrong',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: Colors.red[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            message,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              context.read<ChatBloc>().add(const LoadChats());
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
            ),
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }
}