import 'package:fitflut/gymPages/BodyRegions.dart';

class Exercise {
  int id;
  String name;
  int weight;
  BodyRegions bodyRegion;
  int rep1, rep2, rep3;

  Exercise(
      {required this.id, required this.name, required this.weight, required this.bodyRegion, required this.rep1, required this.rep2, required this.rep3});

  Map<String, Object?> toMap() {
    return {
      "name": name,
      "weight": weight,
      "bodyregion": bodyRegion.toString()
    };
  }
}
