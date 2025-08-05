import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../app_colors.dart';
import '../custom_colors_extension.dart';

part 'theme_state.dart';

class ThemeCubit extends Cubit<ThemeState> {
  ThemeCubit() : super(const ThemeState());

  void toggleTheme() {
    emit(state.copyWith(
      isDarkMode: !state.isDarkMode,
    ));
  }

  void setLightTheme() {
    emit(state.copyWith(isDarkMode: false));
  }

  void setDarkTheme() {
    emit(state.copyWith(isDarkMode: true));
  }
}