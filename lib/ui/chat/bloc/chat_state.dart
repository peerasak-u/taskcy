import 'package:equatable/equatable.dart';

import '../view_model/chats_view_model.dart';

abstract class ChatState extends Equatable {
  const ChatState();

  @override
  List<Object?> get props => [];
}

class ChatInitial extends ChatState {
  const ChatInitial();
}

class ChatLoading extends ChatState {
  const ChatLoading();
}

class ChatLoaded extends ChatState {
  final ChatsViewModel chatsData;

  const ChatLoaded({required this.chatsData});

  @override
  List<Object?> get props => [chatsData];
}

class ChatEmpty extends ChatState {
  const ChatEmpty();
}

class ChatError extends ChatState {
  final String message;

  const ChatError({required this.message});

  @override
  List<Object?> get props => [message];
}

class ChatSearchLoading extends ChatState {
  const ChatSearchLoading();
}

class ChatSearchLoaded extends ChatState {
  final ChatsViewModel searchResults;
  final String query;

  const ChatSearchLoaded({
    required this.searchResults,
    required this.query,
  });

  @override
  List<Object?> get props => [searchResults, query];
}