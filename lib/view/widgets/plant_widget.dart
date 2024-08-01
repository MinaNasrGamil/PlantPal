import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../constants/enums.dart';
import '../../data/models/plant_model.dart';
import '../../logic/cubit/plant/plant_cubit.dart';

class PlantWidget extends StatelessWidget {
  const PlantWidget({
    super.key,
    required this.topHight,
    required this.bottomHight,
    required this.toolBarHight,
    required this.inPlantLibarry,
  });

  final double topHight;
  final double bottomHight;
  final double toolBarHight;
  final bool inPlantLibarry;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: SizedBox(
          height: MediaQuery.of(context).size.height -
              topHight -
              bottomHight -
              toolBarHight -
              50,
          width: MediaQuery.of(context).size.width,
          child: BlocBuilder<PlantCubit, PlantState>(
            builder: (context, state) {
              List<Plant> plants = inPlantLibarry
                  ? state.plants
                  : state.plants
                      .where(
                        (plant) => plant.isFavorite == true,
                      )
                      .toList();
              return GridView.builder(
                itemCount: plants.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3, // Number of columns
                  crossAxisSpacing: 8.0, // Spacing between columns
                  mainAxisSpacing: 8.0, // Spacing between rows
                ),
                itemBuilder: (context, index) {
                  return GridTile(
                    footer: GridTileBar(
                      backgroundColor: Colors.black45,
                      title: Text(plants[index].commonName),
                    ),
                    header: Align(
                        alignment: Alignment.topRight,
                        child: IconButton(
                            style: ButtonStyle(
                              padding: WidgetStateProperty.all(
                                  EdgeInsets.zero), // Remove padding
                            ),
                            onPressed: () {
                              context.read<PlantCubit>().clickOnFavorite(
                                  plants[index].plantId,
                                  !plants[index].isFavorite,
                                  index);
                            },
                            icon: state.plantStatus == Status.looding &&
                                    state.index == index
                                ? const CircularProgressIndicator()
                                : Icon(
                                    Icons.favorite,
                                    size: 18,
                                    color: plants[index].isFavorite
                                        ? Colors.redAccent
                                        : Colors.blueGrey,
                                  ))),
                    child: Image.network(plants[index].imageUrl,
                        fit: BoxFit.cover),
                  );
                },
              );
            },
          )),
    );
  }
}
