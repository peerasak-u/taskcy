import 'package:equatable/equatable.dart';

import '../view_model/home_view_model.dart';

abstract class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object?> get props => [];
}

class HomeInitial extends HomeState {
  const HomeInitial();
}

class HomeLoading extends HomeState {
  const HomeLoading();
}

class HomeLoaded extends HomeState {
  final HomeViewModel homeData;

  const HomeLoaded({required this.homeData});

  @override
  List<Object?> get props => [homeData];
}

class HomeEmpty extends HomeState {
  const HomeEmpty();
}

class HomeError extends HomeState {
  final String message;

  const HomeError({required this.message});

  @override
  List<Object?> get props => [message];
}