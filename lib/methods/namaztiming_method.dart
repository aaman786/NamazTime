import 'package:adhan/adhan.dart';
import '../model/adhantime_model.dart';

class NamazTime {
  // final double latitude = 22.636383;
  // final double longitude = 75.810692;

  String? timeZone;
  String get getTimezone {
    return timeZone!;
  }

  List<Map<String, dynamic>> adhanDetails = [];

  int checkCurrentSalah() {
    DateTime d = DateTime.now();

    int index = 0;
    while (index < adhanDetails.length) {
      if (d.isAfter(adhanDetails[index]['salahStartTime']) &&
          d.isBefore(adhanDetails[index]['salahEndTime'])) {
        break;
      }
      index++;
    }

    return index;
  }

  void getNamazTime(double latitude, double longitude) {
    print("lat $latitude");

    final Coordinates coordinates = Coordinates(latitude, longitude);
    final params = CalculationMethod.dubai.getParameters();
    final prayerTimes = PrayerTimes.today(coordinates, params);
    timeZone = prayerTimes.fajr.timeZoneName;

    final DateTime endOfSunrise =
            prayerTimes.sunrise.add(const Duration(minutes: 120)),
        jawalTime = prayerTimes.dhuhr.subtract(const Duration(minutes: 25)),
        endOfIsha = prayerTimes.isha.add(const Duration(hours: 5)),
        endOfTahajjud = prayerTimes.fajr
            .add(const Duration(days: 1))
            .subtract(const Duration(minutes: 40));

    addingNamazTimeToList(
        "Fajr", prayerTimes.fajr, prayerTimes.sunrise, "assets/svg/imsak.svg");
    addingNamazTimeToList(
        "Sunrise", prayerTimes.sunrise, endOfSunrise, "assets/svg/sunrise.svg");
    addingNamazTimeToList("Chast", endOfSunrise, jawalTime, null);
    addingNamazTimeToList("Jawal", jawalTime, prayerTimes.dhuhr, null);
    addingNamazTimeToList(
        "Dhuhr", prayerTimes.dhuhr, prayerTimes.asr, "assets/svg/sunFill.svg");
    addingNamazTimeToList(
        "Asr", prayerTimes.asr, prayerTimes.maghrib, "assets/svg/sun.svg");
    addingNamazTimeToList("Maghrib", prayerTimes.maghrib, prayerTimes.isha,
        "assets/svg/sunset.svg");
    addingNamazTimeToList("Isha", prayerTimes.isha, endOfIsha, null);
    addingNamazTimeToList("Tahajjud", endOfIsha, endOfTahajjud, null);
  }

  void addingNamazTimeToList(
      String sName, DateTime stTime, DateTime edTime, String? icon) {
    AdhanTime adhanTime = AdhanTime(
        salahEndTime: edTime,
        salahName: sName,
        salahStartTime: stTime,
        icon: icon);
    Map<String, dynamic> map = adhanTime.toMap();
    adhanDetails.add(map);
  }
}
