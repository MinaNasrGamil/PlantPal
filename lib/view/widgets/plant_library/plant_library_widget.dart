import 'package:flutter/widgets.dart';

import '../plant_widget.dart';

class PlantLibraryWidget extends StatelessWidget {
  final double topHight;
  final double bottomHight;
  final double toolBarHight;
  const PlantLibraryWidget(
      {super.key,
      required this.topHight,
      required this.bottomHight,
      required this.toolBarHight});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: PlantWidget(
        topHight: topHight,
        bottomHight: bottomHight,
        toolBarHight: toolBarHight,
        inPlantLibarry: true,
      ),
    );
  }
}
