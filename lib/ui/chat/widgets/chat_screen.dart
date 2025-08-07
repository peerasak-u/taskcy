import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/theme/app_colors.dart';
import '../../shared/widgets/header_widget.dart';
import '../../shared/widgets/loading_state_widget.dart';
import '../../shared/widgets/error_state_widget.dart';
import '../../shared/widgets/empty_state_widget.dart';
import '../bloc/chat_bloc.dart';
import '../bloc/chat_event.dart';
import '../bloc/chat_state.dart';
import 'chat_item_widget.dart';
import 'chat_search_field.dart';

class ChatScreen extends StatelessWidget {
  final TextEditingController searchController;
  
  const ChatScreen({super.key, required this.searchController});

  void _onSearchChanged(BuildContext context) {
    final query = searchController.text.trim();
    context.read<ChatBloc>().add(SearchChats(query: query));
  }

  void _onSearchClear(BuildContext context) {
    searchController.clear();
    context.read<ChatBloc>().add(const LoadChats());
  }

  @override
  Widget build(BuildContext context) {
    // Load chats after build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ChatBloc>().add(const LoadChats());
    });
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
              controller: searchController,
              onChanged: (value) => _onSearchChanged(context),
              onClear: () => _onSearchClear(context),
            ),
            Expanded(
              child: BlocBuilder<ChatBloc, ChatState>(
                builder: (context, state) {
                  if (state is ChatLoading || state is ChatInitial) {
                    return const LoadingStateWidget();
                  } else if (state is ChatLoaded) {
                    return _buildLoadedState(context, state.chatsData.chats);
                  } else if (state is ChatSearchLoading) {
                    return const LoadingStateWidget(
                      message: 'Searching...',
                      showMessage: true,
                    );
                  } else if (state is ChatSearchLoaded) {
                    return _buildSearchResultsState(context, state.searchResults.chats, state.query);
                  } else if (state is ChatEmpty) {
                    return const EmptyStateWidget(
                      icon: Icons.chat_bubble_outline,
                      title: 'No chats yet',
                      message: 'Start a conversation with your team members',
                    );
                  } else if (state is ChatError) {
                    return ErrorStateWidget(
                      message: state.message,
                      onRetry: () => context.read<ChatBloc>().add(const LoadChats()),
                    );
                  }
                  return const LoadingStateWidget();
                },
              ),
            ),
          ],
        ),
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
      return const EmptyStateWidget(
        icon: Icons.search_off,
        title: 'No results found',
        message: 'Try searching with different keywords',
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

}