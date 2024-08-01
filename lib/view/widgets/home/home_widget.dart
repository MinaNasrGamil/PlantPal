import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../constants/enums.dart';
import '../../../logic/cubit/navigation/navigation_cubit.dart';
import '../plant_widget.dart';
import 'home_reminders_widget.dart';
import 'tool_bar_widget.dart';

class HomeWidget extends StatelessWidget {
  final double bottomHight;
  final double topHight;
  HomeWidget({super.key, required this.bottomHight, required this.topHight});
  final _scrollController = ScrollController();
  final _columnKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final double toolBarHight = MediaQuery.of(context).size.height * 0.11225;
    return Stack(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ToolBarWidget(
                toolBarHight: toolBarHight,
                scrollController: _scrollController,
                columnKey: _columnKey),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: BlocBuilder<NavigationCubit, NavigationState>(
                buildWhen: (previous, current) =>
                    previous.toolBarItem != current.toolBarItem,
                builder: (context, state) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        state.toolBarItem == ToolBarItem.favorits
                            ? 'Favorits'
                            : 'Plant Care Reminders',
                        style: const TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      Text(state.toolBarItem == ToolBarItem.favorits
                          ? 'Growing happiness\none leaf at a time. 🌿💚'
                          : 'Quenching their thirst\none drop at a time. 🌱💧')
                    ],
                  );
                },
              ),
            )
          ],
        ),
        Positioned(
          bottom: 0,
          child: SizedBox(
            height: MediaQuery.of(context).size.height -
                topHight -
                bottomHight -
                toolBarHight -
                50,
            width: MediaQuery.of(context).size.width,
            child: SingleChildScrollView(
                controller: _scrollController,
                physics: const NeverScrollableScrollPhysics(),
                child: Column(
                  key: _columnKey,
                  children: [
                    HomeRemindersWidget(
                        topHight: topHight,
                        bottomHight: bottomHight,
                        toolBarHight: toolBarHight),
                    PlantWidget(
                      topHight: topHight,
                      bottomHight: bottomHight,
                      toolBarHight: toolBarHight,
                      inPlantLibarry: false,
                    ),
                  ],
                )),
          ),
        ),
      ],
    );
  }
}
