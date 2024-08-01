import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import '../../../logic/cubit/navigation/navigation_cubit.dart';

class BottomNavigationBarWidget extends StatelessWidget {
  final double bottomHight;
  const BottomNavigationBarWidget({
    super.key,
    required this.bottomHight,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NavigationCubit, NavigationState>(
      buildWhen: (previous, current) =>
          previous.navbarIndex != current.navbarIndex,
      builder: (context, state) {
        return SizedBox(
          height: bottomHight,
          child: BottomNavigationBar(
            backgroundColor: Colors.red,
            selectedItemColor: Colors.black,
            unselectedItemColor: Colors.black,
            selectedIconTheme: const IconThemeData(color: Colors.lightGreen),
            currentIndex: state.navbarIndex,
            items: <BottomNavigationBarItem>[
              const BottomNavigationBarItem(
                icon: Icon(Icons.grid_view_rounded),
                label: 'Overview',
              ),
              BottomNavigationBarItem(
                icon: SvgPicture.asset(
                  'assets/images/search.svg',
                  width: 30,
                  height: 30,
                ),
                label: 'Plants',
              ),
              BottomNavigationBarItem(
                icon: SvgPicture.asset(
                  'assets/images/plantAlarm.svg',
                  width: 30,
                  height: 30,
                ),
                label: 'Reminders',
              ),
              BottomNavigationBarItem(
                icon: Image.asset(
                  'assets/images/plantCamira.png',
                  width: 30,
                  height: 30,
                ),
                label: 'plant identifier',
              ),
              BottomNavigationBarItem(
                icon: SvgPicture.asset(
                  'assets/images/plantCommunity.svg',
                  width: 30,
                  height: 30,
                ),
                label: 'Community',
              ),
            ],
            onTap: (index) {
              context.read<NavigationCubit>().changeBottomNavBar(index);
            },
          ),
        );
      },
    );
  }
}
