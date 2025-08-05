import 'package:flutter_bloc/flutter_bloc.dart';

enum NavigationTab { home, project, chat, profile }

class NavigationCubit extends Cubit<NavigationTab> {
  NavigationCubit() : super(NavigationTab.home);

  void selectTab(NavigationTab tab) {
    emit(tab);
  }

  void goToHome() {
    emit(NavigationTab.home);
  }

  void goToProject() {
    emit(NavigationTab.project);
  }

  void goToChat() {
    emit(NavigationTab.chat);
  }

  void goToProfile() {
    emit(NavigationTab.profile);
  }
}