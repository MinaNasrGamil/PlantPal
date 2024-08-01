// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'plant_cubit.dart';

class PlantState extends Equatable {
  final Status plantStatus;
  final List<Plant> plants;
  final Map<String, bool> userplants;
  final int index;
  final List<Plant> orignalPlants;
  const PlantState(
      {required this.plantStatus,
      required this.plants,
      required this.userplants,
      required this.index,
      required this.orignalPlants});

  factory PlantState.inital() {
    return const PlantState(
        plantStatus: Status.inital,
        plants: [],
        userplants: {},
        index: -1,
        orignalPlants: []);
  }
  @override
  List<Object?> get props =>
      [plantStatus, plants, userplants, index, orignalPlants];

  PlantState copyWith({
    Status? plantStatus,
    List<Plant>? plants,
    Map<String, bool>? userplants,
    int? index,
    List<Plant>? orignalPlants,
  }) {
    return PlantState(
      plantStatus: plantStatus ?? this.plantStatus,
      plants: plants ?? this.plants,
      userplants: userplants ?? this.userplants,
      index: index ?? this.index,
      orignalPlants: orignalPlants ?? this.orignalPlants,
    );
  }
}
