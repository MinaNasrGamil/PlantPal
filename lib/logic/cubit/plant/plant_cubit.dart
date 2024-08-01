import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../constants/enums.dart';
import '../../../data/models/plant_model.dart';
import '../../../data/repositories/plant_repository.dart';

part 'plant_state.dart';

class PlantCubit extends Cubit<PlantState> {
  final PlantRepository plantRepository;
  PlantCubit(this.plantRepository) : super(PlantState.inital()) {
    fechPlanntData();
  }

  Future<void> fechPlanntData() async {
    emit(state.copyWith(plantStatus: Status.looding));
    try {
      List<Plant> plants = await plantRepository.fetchPlantsData();
      emit(state.copyWith(
        plantStatus: Status.success,
        plants: plants,
        orignalPlants: plants,
      ));
    } catch (e) {
      print(e);
      emit(state.copyWith(plantStatus: Status.error));
    }
  }

  Future<void> clickOnFavorite(
      String plantId, bool isFavorite, int index) async {
    emit(state.copyWith(plantStatus: Status.looding, index: index));
    try {
      await plantRepository.clicOnFavorit(plantId, isFavorite).then(
        (_) {
          List<Plant> plants = state.plants;
          plants[index].isFavorite = isFavorite;
          emit(state.copyWith(
              plantStatus: Status.success, plants: plants, index: -1));
        },
      );
    } catch (e) {
      emit(state.copyWith(plantStatus: Status.error, index: -1));
      print(e);
    }
  }

  void search(String textSearch) {
    List<Plant> plantData = state.orignalPlants;
    emit(state.copyWith(plants: []));
    List<Plant> searchedPlant = [];
    for (var p in plantData) {
      if (p.commonName.toLowerCase().contains(textSearch.toLowerCase()) ||
          p.scientificName.toLowerCase().contains(textSearch.toLowerCase()) ||
          p.careInstructions.toLowerCase().contains(textSearch.toLowerCase())) {
        if (p.commonName.toLowerCase().contains(textSearch.toLowerCase())) {
          searchedPlant.insert(0, p);
        } else {
          searchedPlant.add(p);
        }
        emit(state.copyWith(plants: searchedPlant));
      }
    }
  }
}
