class Plant {
  final String plantId;
  final String commonName;
  final String scientificName;
  final String careInstructions;
  final String sunlightRequirements;
  final String wateringSchedule;
  final String imageUrl;
  bool isFavorite;

  Plant({
    required this.plantId,
    required this.commonName,
    required this.scientificName,
    required this.careInstructions,
    required this.sunlightRequirements,
    required this.wateringSchedule,
    required this.imageUrl,
    this.isFavorite = false,
  });
}
