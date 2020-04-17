class WaterData {
  int id;
  String jsonWater;

  WaterData({
    this.id,
    this.jsonWater,
  });
  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map['id'] = id;
    map['jsonWater'] = jsonWater;
    return map;
  }

  // Extract a Note object from a Map object
  WaterData.fromMapObject(Map<String, dynamic> map) {
    this.id = map['id'];
    this.jsonWater = map['jsonWater'];
  }
}
