import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../constants/enums.dart';
import '../../logic/bloc/app_bloc.dart';
import '../../logic/cubit/navigation/navigation_cubit.dart';
import '../widgets/app_bar_widget.dart';
import '../widgets/authentcation/verification_widget.dart';
import '../widgets/navigation/app_drawer_widget.dart';
import '../widgets/navigation/bottom_navigation_bar_widget.dart';
import '../widgets/navigation/navigation_widget.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final bottomHight = MediaQuery.of(context).size.height * 0.08;
    final topHight = MediaQuery.of(context).size.height * 0.0715;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size(double.infinity, topHight),
        child: const AppBarWidget(),
      ),
      body: BlocBuilder<AppBloc, AppState>(
        buildWhen: (previous, current) =>
            previous.verificationStatus != current.verificationStatus,
        builder: (context, state) {
          return state.verificationStatus == VerificationcStatus.notVerified
              ? const Center(
                  child: VerificattionWidget(),
                )
              : Stack(
                  children: [
                    NavigationWidget(
                      bottomHight: bottomHight,
                      topHight: topHight,
                    ),
                    BlocBuilder<NavigationCubit, NavigationState>(
                      buildWhen: (previous, current) =>
                          previous.isMoreClicked != current.isMoreClicked,
                      builder: (context, state) {
                        if (state.isMoreClicked == true) {
                          return const AppDrawerWidget();
                        }
                        return const SizedBox();
                      },
                    ),
                  ],
                );
        },
      ),
      bottomNavigationBar: BottomNavigationBarWidget(
        bottomHight: bottomHight,
      ),
    );
  }
}
