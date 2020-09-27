import 'package:flutter/material.dart';
import 'package:smoke_counter/model/smoke_model.dart';
import 'package:smoke_counter/repository/smoke_repository.dart';
import '../locator.dart';

class SmokeProvider with ChangeNotifier {
  /* State Properties */
  SmokeRepository _smokeRepository = locator<SmokeRepository>();
  bool isCountsAvaible = false;
  String lastSmokeTimeLong = "";
  String todaySmokeCount = "";
  String totalSmokeCount = "";
  List<double> listSmokeDataHourly;
  List<List<double>> listStressDataHourly;

  /* State Methods */
  void addSmoke(int selectedStressIndex) async {
    // stress değeri 3 seçenekten biri değilse bitir
    if (selectedStressIndex < 0 || selectedStressIndex > 2) {
      return;
    }
    // last,today,total bilgileri sıfırlanır
    isCountsAvaible = false; // bayrağı indir (veriler yok de)
    notifyListeners();
    // içilen sigara oluşturulur
    DateTime dateTimeNow = DateTime.now();
    SmokeModel smokeModel = new SmokeModel(dateTimeNow, selectedStressIndex);
    // içilen sigara db ve static listeye kayıt edilir
    await _smokeRepository.addSmoke(smokeModel);
    // last,today,total bilgileri yeniden alınır
    _getCounts();
    isCountsAvaible = true; // bayrağı kaldır (veriler var de)
    notifyListeners();
  }

  void getCountRefresh() {
    // last,today,total bilgileri sıfırlanır
    isCountsAvaible = false; // bayrağı indir (veriler yok de)
    notifyListeners();
    // last,today,total bilgileri yeniden alınır
    _getCounts();
    isCountsAvaible = true; // bayrağı kaldır (veriler var de)
    notifyListeners();
  }

  void getChartsData(DateTime startDate, DateTime endDate) async {
    // girilen başlangıç ve bitiş tarihi arasındaki gün sayısı alınır
    int dayRange = endDate.difference(startDate).inDays + 1;
    // veriler sıfırlanır ön yüze bildirilir
    if (listSmokeDataHourly != null) {
      listSmokeDataHourly.clear();
    }
    if (listStressDataHourly != null) {
      listStressDataHourly.clear();
    }
    notifyListeners();

    // smoke verileri çekilir
    List<SmokeModel> smokes = await _smokeRepository.getAllSmoke();
    List<SmokeModel> tempSmokes = List<SmokeModel>();
    // saatlere göre sigara sayısı tutulacak liste oluşturulur
    listSmokeDataHourly = new List<double>.generate(25, (i) => 0);
    listStressDataHourly = new List<List<double>>.generate(
        25, (i) => new List<double>.generate(3, (index) => 0));

    // Seçilen Tarih aralığındaki tüm günler için dolaşılır smoke verileri alınır
    List<SmokeModel> tempSmokes2 = new List<SmokeModel>();
    int dayCount = dayRange;
    for (int i = 0; i < dayCount; i++) {
      // her bir gün kontrol edilir, içinde veri olmayan gün varsa, toplam gün sayısından çıkarılır.
      DateTime nextDay = startDate.add(Duration(days: i));
      tempSmokes2 = smokes
          .where((x) =>
              x.dateTime.year == nextDay.year &&
              x.dateTime.month == nextDay.month &&
              x.dateTime.day == nextDay.day)
          .toList();
      if (tempSmokes2.length <= 0) {
        dayRange -= 1;
      } else {
        // içinde smoke verisi olan gün varsa, o veriler eklenir.
        tempSmokes.addAll(tempSmokes2);
      }
    }

    // Hangi saatte sigara içildi bilgileri listeye eklenir
    for (SmokeModel smokeModel in tempSmokes) {
      // içilen smoke sayısı
      listSmokeDataHourly[smokeModel.dateTime.hour] += 1;
      // stress değeri eklenir
      listStressDataHourly[smokeModel.dateTime.hour][smokeModel.stress] += 1;
    }

    // Tarih aralığı seçilmişse, içilen sigara ortalaması alınır, ve stress ort.
    if (dayRange > 1) {
      for (int i = 0; i < listSmokeDataHourly.length; i++) {
        // o saat içinde içilen sigaralar toplamı, kaç gün ise o kadara bölünür
        listSmokeDataHourly[i] /= dayRange;
        // o saat içindeki stress toplamları, kaç gün ise o kadara bölünür
        listStressDataHourly[i][0] /= dayRange;
        listStressDataHourly[i][1] /= dayRange;
        listStressDataHourly[i][2] /= dayRange;
        // virgülden sonra ilk basamağa kadar yuvarlanır.
        listSmokeDataHourly[i] =
            double.parse(listSmokeDataHourly[i].toStringAsFixed(1));
        listStressDataHourly[i][0] =
            double.parse(listStressDataHourly[i][0].toStringAsFixed(1));
        listStressDataHourly[i][1] =
            double.parse(listStressDataHourly[i][1].toStringAsFixed(1));
        listStressDataHourly[i][2] =
            double.parse(listStressDataHourly[i][2].toStringAsFixed(1));
      }
    }

    // veriler eklendi diye ön yüze haber verilir
    notifyListeners();
  }

  /* Private Shared Methods */
  void _getCounts() async {
    // 2 : durumda bu fonk kullanılıyor : sigara ekleyince, 2.sayfadan 1.ye gelince

    List<SmokeModel> smokes = await _smokeRepository.getAllSmoke();
    // total count
    totalSmokeCount = smokes.length.toString();
    // today count
    List<SmokeModel> tempSmokes = List.from(smokes);
    DateTime today = DateTime.now();
    tempSmokes = tempSmokes
        .where((x) =>
            x.dateTime.year == today.year &&
            x.dateTime.month == today.month &&
            x.dateTime.day == today.day)
        .toList(); // bugünkiler alınır
    todaySmokeCount = tempSmokes.length.toString();
    // last smoke time long
    tempSmokes = List.from(smokes);
    tempSmokes.sort((a, b) => (a.dateTime.toUtc().microsecondsSinceEpoch >
            b.dateTime.toUtc().microsecondsSinceEpoch)
        ? 1
        : 0);
    //a.dateTime.isBefore(b.dateTime) ? 1 : 0);
    SmokeModel tempSmoke;
    String timeLongText = "";
    if (tempSmokes.length > 0) {
      tempSmoke = tempSmokes[tempSmokes.length - 1];
    }
    if (tempSmoke != null) {
      Duration timeDiff = today.difference(tempSmoke.dateTime);
      int inDays = timeDiff.inDays;
      int inHours = timeDiff.inHours;
      int inMinutes = timeDiff.inMinutes;
      int inSeconds = timeDiff.inSeconds;
      int tempResult = 0;
      if (inDays > 30) {
        tempResult = (inDays / 30).floor();
        timeLongText += "$tempResult Month ";
        tempResult *= 30; // day
        inDays -= tempResult;
        tempResult *= 24; // hour
        inHours -= tempResult;
        tempResult *= 60; // minutes
        inMinutes -= tempResult;
        tempResult *= 60; // seconds
        inSeconds -= tempResult;
      }
      if (inDays > 0) {
        tempResult = inDays;
        timeLongText += "$tempResult Day ";
        inDays -= tempResult;
        tempResult *= 24; // hour
        inHours -= tempResult;
        tempResult *= 60; // minutes
        inMinutes -= tempResult;
        tempResult *= 60; // seconds
        inSeconds -= tempResult;
      } else {
        if (inHours > 0) {
          tempResult = inHours;
          timeLongText += "${tempResult}H ";
          inHours -= tempResult;
          tempResult *= 60; // minutes
          inMinutes -= tempResult;
          tempResult *= 60; // seconds
          inSeconds -= tempResult;
        }
        if (inMinutes > 0) {
          tempResult = inMinutes;
          timeLongText += "${tempResult}m ";
          inMinutes -= tempResult;
          tempResult *= 60; // seconds
          inSeconds -= tempResult;
        }
        if (inSeconds >= 0) {
          // >= sebebi, yeni eklenen ile şu anki zamanın farkı 0 sn 10milisaniye falan olduğu için
          tempResult = inSeconds;
          if (timeLongText.isEmpty && tempResult < 10) {
            timeLongText = "Now";
          } else {
            timeLongText += "${tempResult}s ";
          }
        }
      }
    }
    lastSmokeTimeLong = timeLongText;
  }
}
