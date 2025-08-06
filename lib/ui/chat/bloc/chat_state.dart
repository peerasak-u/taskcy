import 'package:equatable/equatable.dart';

import '../../../domain/models/chat.dart';

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
  final List<Chat> chats;

  const ChatLoaded({required this.chats});

  @override
  List<Object?> get props => [chats];
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
  final List<Chat> searchResults;
  final String query;

  const ChatSearchLoaded({
    required this.searchResults,
    required this.query,
  });

  @override
  List<Object?> get props => [searchResults, query];
}