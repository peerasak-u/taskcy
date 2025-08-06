import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/repositories/chat_repository.dart';
import 'chat_event.dart';
import 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final ChatRepository _chatRepository;

  ChatBloc({
    required ChatRepository chatRepository,
  })  : _chatRepository = chatRepository,
        super(const ChatInitial()) {
    on<LoadChats>(_onLoadChats);
    on<SearchChats>(_onSearchChats);
    on<RefreshChats>(_onRefreshChats);
  }

  Future<void> _onLoadChats(
    LoadChats event,
    Emitter<ChatState> emit,
  ) async {
    try {
      emit(const ChatLoading());

      final chats = await _chatRepository.getChats(perPage: 50);

      if (chats.isEmpty) {
        emit(const ChatEmpty());
      } else {
        emit(ChatLoaded(chats: chats));
      }
    } catch (error) {
      emit(ChatError(message: error.toString()));
    }
  }

  Future<void> _onSearchChats(
    SearchChats event,
    Emitter<ChatState> emit,
  ) async {
    try {
      if (event.query.isEmpty) {
        // If search query is empty, load all chats
        add(const LoadChats());
        return;
      }

      emit(const ChatSearchLoading());

      final searchResults = await _chatRepository.getChats(
        search: event.query,
        perPage: 50,
      );

      emit(ChatSearchLoaded(
        searchResults: searchResults,
        query: event.query,
      ));
    } catch (error) {
      emit(ChatError(message: error.toString()));
    }
  }

  Future<void> _onRefreshChats(
    RefreshChats event,
    Emitter<ChatState> emit,
  ) async {
    try {
      // Don't emit loading state for refresh to avoid UI flicker
      final chats = await _chatRepository.getChats(perPage: 50);

      if (chats.isEmpty) {
        emit(const ChatEmpty());
      } else {
        emit(ChatLoaded(chats: chats));
      }
    } catch (error) {
      emit(ChatError(message: error.toString()));
    }
  }
}