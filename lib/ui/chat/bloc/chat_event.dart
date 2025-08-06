import 'package:equatable/equatable.dart';

abstract class ChatEvent extends Equatable {
  const ChatEvent();

  @override
  List<Object?> get props => [];
}

class LoadChats extends ChatEvent {
  const LoadChats();
}

class SearchChats extends ChatEvent {
  final String query;

  const SearchChats({required this.query});

  @override
  List<Object?> get props => [query];
}

class RefreshChats extends ChatEvent {
  const RefreshChats();
}