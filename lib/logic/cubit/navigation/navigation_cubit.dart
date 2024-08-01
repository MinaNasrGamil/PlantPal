import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../constants/enums.dart';

part 'navigation_state.dart';

class NavigationCubit extends Cubit<NavigationState> {
  NavigationCubit() : super(NavigationState.inital());

  void changeBottomNavBar(int index) {
    // Emit the new selected item
    emit(state.copyWith(
        navbarItem: NavbarItem.values[index], navbarIndex: index));
  }

  void clickMore(bool isClicked) {
    emit(state.copyWith(isMoreClicked: isClicked));
  }

  void clickToolBatItem(ToolBarItem toolBarItem) {
    emit(state.copyWith(toolBarItem: toolBarItem));
  }
}
