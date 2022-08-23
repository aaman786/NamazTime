import 'package:adhan/adhan.dart';
import 'package:flutter_application_1/methods/location_method.dart';
import 'package:flutter_application_1/methods/namaztiming_method.dart';
import 'package:flutter_application_1/model/adhantime_model.dart';
import 'package:intl/intl.dart';

void main(List<String> args) {
  double latitude = 22.636383;
  double longitude = 75.810692;

  final Coordinates coordinates = Coordinates(latitude, longitude);

  final params = CalculationMethod.dubai.getParameters();

  final prayerTimes = PrayerTimes.today(coordinates, params);

  // AdhanTime adhanTimeFajr = AdhanTime(
  //     salahEndTime: DateFormat.jm().format(prayerTimes.sunrise),
  //     salahName: "Fajr",
  //     salahStartTime: DateFormat.jm().format(prayerTimes.fajr));
  // adhanTimeFajr.addAdhanDetails();
  String s = "34:00";
  print(prayerTimes.fajr);

  print(
      "---Today's Prayer Times in Your Local Timezone(${prayerTimes.fajr.timeZoneName})---");
  // print(prayerTimes);
  // print(DateFormat.jm().format(prayerTimes.fajr));
  // print(DateFormat.jm().format(prayerTimes.sunrise));
  // print(DateFormat.jm().format(prayerTimes.dhuhr));
  // print(DateFormat.jm().format(prayerTimes.asr));
  // print(DateFormat.jm().format(prayerTimes.maghrib));
  // print(DateFormat.jm().format(prayerTimes.isha));

  // double degree = Qibla(coordinates).direction;
  // print(degree);
}
