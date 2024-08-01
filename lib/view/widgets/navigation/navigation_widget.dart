import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../constants/enums.dart';
import '../../../logic/cubit/navigation/navigation_cubit.dart';
import '../forume/community_widget.dart';
import '../home/home_widget.dart';
import '../pkantIdentification/plant_identification_widget.dart';
import '../plant_library/plant_library_widget.dart';
import '../reminders/reminders_widget.dart';

class NavigationWidget extends StatelessWidget {
  final double bottomHight;
  final double topHight;
  const NavigationWidget(
      {super.key, required this.bottomHight, required this.topHight});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NavigationCubit, NavigationState>(
      builder: (context, state) {
        switch (state.navbarItem) {
          case NavbarItem.home:
            return HomeWidget(
              bottomHight: bottomHight,
              topHight: topHight,
            );
          case NavbarItem.library:
            return PlantLibraryWidget(
              topHight: topHight,
              bottomHight: bottomHight,
              toolBarHight: 0,
            );
          case NavbarItem.reminders:
            return const RemindersWidget();
          case NavbarItem.identification:
            return const PlantIdentificationWidget();
          case NavbarItem.community:
            return const CommunityWidget();
        }
      },
    );
  }
}
