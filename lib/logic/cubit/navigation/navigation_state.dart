// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'navigation_cubit.dart';

class NavigationState extends Equatable {
  final NavbarItem navbarItem;
  final int navbarIndex;
  final bool isMoreClicked;
  final ToolBarItem toolBarItem;

  const NavigationState(
      {required this.navbarItem,
      required this.navbarIndex,
      required this.isMoreClicked,
      required this.toolBarItem});

  factory NavigationState.inital() {
    return const NavigationState(
        navbarItem: NavbarItem.home,
        navbarIndex: 0,
        isMoreClicked: false,
        toolBarItem: ToolBarItem.reminders);
  }

  @override
  // TODO: implement props
  List<Object?> get props =>
      [navbarItem, navbarIndex, isMoreClicked, toolBarItem];

  NavigationState copyWith({
    NavbarItem? navbarItem,
    int? navbarIndex,
    bool? isMoreClicked,
    ToolBarItem? toolBarItem,
  }) {
    return NavigationState(
      navbarItem: navbarItem ?? this.navbarItem,
      navbarIndex: navbarIndex ?? this.navbarIndex,
      isMoreClicked: isMoreClicked ?? this.isMoreClicked,
      toolBarItem: toolBarItem ?? this.toolBarItem,
    );
  }
}
