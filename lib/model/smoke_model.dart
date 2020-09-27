class SmokeModel {
  DateTime
      dateTime; // yıl/ay/gün ve saat/dakika/saniye (son sigara bilgisini göstermek için)
  int stress; // 2-stressli 1-normal 0-iyi
  SmokeModel(this.dateTime, this.stress);
  SmokeModel.fromMap(Map<String, dynamic> map) {
    this.dateTime = DateTime.fromMicrosecondsSinceEpoch(map['datetime'] as int);
    this.stress = map['stress'] as int;
  }

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map["datetime"] = this.dateTime.toUtc().microsecondsSinceEpoch;
    map["stress"] = this.stress;
    return map;
  }
}
