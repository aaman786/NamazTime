import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_application_1/methods/namaztiming_method.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';

import 'methods/location_method.dart';

String checkForJummah(String sName) {
  if (DateFormat('EEE').format(DateTime.now()) == "Fri") {
    if (sName == "Dhuhr") {
      return "Jummah";
    } else {
      return sName;
    }
  } else {
    return sName;
  }
}

class AdhanTimeSreen extends StatefulWidget {
  const AdhanTimeSreen({Key? key}) : super(key: key);

  @override
  State<AdhanTimeSreen> createState() => _AdhanTimeSreenState();
}

class _AdhanTimeSreenState extends State<AdhanTimeSreen> {
  NamazTime namazTime = NamazTime();
  @override
  void initState() {
    super.initState();
    getCoordinates();
  }

  double? latitude;
  double? longitude;

  void getCoordinates() async {
    LocationMethod locationMethod = LocationMethod();
    LocationData locationData = await locationMethod.getLocation();

    setState(() {
      latitude = locationData.latitude;
      longitude = locationData.longitude;
    });
    print("The lat is : $latitude");

    namazTime.getNamazTime(latitude!, longitude!);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: latitude == null
          ? const Center(child: CircularProgressIndicator())
          : Scaffold(
              backgroundColor: const Color(0xFF285450).withOpacity(0.9),
              appBar: AppBar(
                title: const Text("Adhan Time"),
              ),
              body: Column(children: [
                CurrentSalahCard(
                  namazTime: namazTime,
                ),
                const SizedBox(height: 10),
                const Text(
                  "Timing Of Salah",
                  style: TextStyle(
                      color: Colors.amber,
                      fontSize: 18,
                      letterSpacing: 1,
                      fontFamily: 'PlayfairDisplay',
                      fontWeight: FontWeight.w600),
                ),
                NamazTiming(
                  namazTime: namazTime,
                ),
              ]),
            ),
    );
  }
}

class CurrentSalahCard extends StatefulWidget {
  final NamazTime namazTime;
  const CurrentSalahCard({Key? key, required this.namazTime}) : super(key: key);

  @override
  State<CurrentSalahCard> createState() => _CurrentSalahCardState();
}

class _CurrentSalahCardState extends State<CurrentSalahCard> {
  static var countDownDuration;
  Duration duration = const Duration();
  Timer? timer;

  late int index = widget.namazTime.checkCurrentSalah();

  @override
  void initState() {
    super.initState();
    startTimer();
    counter();
    reset();
  }

  void reset() {
    setState(() {
      duration = countDownDuration;
    });
  }

  void addTime() {
    const int subSec = -1;
    setState(() {
      final seconds = duration.inSeconds + subSec;
      if (seconds <= 0) {
        timer?.cancel();
        setState(() {});
      }
      duration = Duration(seconds: seconds);
    });
  }

  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (_) => addTime());
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  void counter() {
    DateTime sEnd = widget.namazTime.adhanDetails[index]['salahEndTime'];
    DateTime nowTime = DateTime.now();
    countDownDuration = Duration(minutes: sEnd.difference(nowTime).inMinutes);
  }

  @override
  Widget build(BuildContext context) {
    String twoDigit(int n) => n.toString().padLeft(2, '0');
    final hr = twoDigit(duration.inHours);
    final min = twoDigit(duration.inMinutes.remainder(60));
    final sec = twoDigit(duration.inSeconds.remainder(60));

    return Container(
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 62, 135, 129).withOpacity(0.7),
        borderRadius: const BorderRadius.all(Radius.circular(15)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 40),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.black54, width: 2)),
              child: Column(children: [
                Text(
                  DateFormat('EEE, MMM d, ' 'yy').format(DateTime.now()),
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600),
                ),
                const Text(
                  "hijri date",
                  // DateFormat('EEE, MMM d, ' 'yy').format(DateTime.now()),
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600),
                ),
              ]),
            ),
            SizedBox(height: 5),
            Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
              currentSalahDetails(
                  "Begins from",
                  18,
                  Colors.blueGrey.shade900,
                  DateFormat.jm().format(
                      widget.namazTime.adhanDetails[index]['salahStartTime']),
                  16,
                  Colors.black87,
                  null),
              currentSalahDetails(
                  checkForJummah(
                      widget.namazTime.adhanDetails[index]["salahName"]),
                  40,
                  Colors.amber,
                  "$hr:$min:$sec",
                  20,
                  Colors.black87.withOpacity(0.8),
                  const Color(0xFFFFFFFF).withOpacity(0.3)),
              currentSalahDetails(
                  "  Overs On  ",
                  18,
                  Colors.blueGrey.shade900,
                  DateFormat.jm().format(
                      widget.namazTime.adhanDetails[index]['salahEndTime']),
                  16,
                  Colors.black87,
                  null),
            ]),
            const SizedBox(
              height: 10,
            ),
            RichText(
              text: TextSpan(children: [
                TextSpan(
                    style: TextStyle(
                        color: Colors.blueGrey.shade900,
                        fontSize: 18,
                        fontWeight: FontWeight.w500),
                    text: "Timezone: "),
                TextSpan(
                    style: TextStyle(
                        fontSize: 20,
                        color: Colors.black87.withOpacity(0.8),
                        fontWeight: FontWeight.w600),
                    text: widget.namazTime.getTimezone)
              ]),
            ),
          ],
        ),
      ),
    );
  }

  Column currentSalahDetails(String aText, double aSize, Color aColor,
      String bText, double bSize, Color bColor, Color? bgColor) {
    return Column(
      children: [
        Text(
          aText,
          style: TextStyle(
            fontSize: aSize,
            fontWeight: FontWeight.w600,
            color: aColor,
          ),
        ),
        Text(
          bText,
          style: TextStyle(
              fontSize: bSize,
              fontWeight: FontWeight.w600,
              color: bColor,
              backgroundColor: bgColor),
        )
      ],
    );
  }
}

IconData checkForsvg(String? sName) {
  switch (sName) {
    case "Chast":
      return CupertinoIcons.sun_dust;
    case "Jawal":
      return Icons.cancel;
    case "Isha":
      return CupertinoIcons.moon;
    case "Tahjjud":
      return CupertinoIcons.star;
    default:
      return Icons.fork_right;
  }
}

class NamazTiming extends StatelessWidget {
  final NamazTime namazTime;
  const NamazTiming({Key? key, required this.namazTime}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(08),
      padding: const EdgeInsets.only(left: 50, right: 50, top: 3, bottom: 7),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.blueAccent, width: 2),
        borderRadius: const BorderRadius.all(Radius.circular(10.0)),
      ),
      child: Column(
        children: [
          ListView.builder(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemCount: namazTime.adhanDetails.length,
            itemBuilder: (context, index) => Column(
              children: [
                NamazTimeRow(
                    svg: namazTime.adhanDetails[index]["icon"], // null then
                    salahName: checkForJummah(
                        namazTime.adhanDetails[index]["salahName"]),
                    salahTime: DateFormat.jm().format(
                        namazTime.adhanDetails[index]["salahStartTime"])),
                dividerBtwNamzTime(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Divider dividerBtwNamzTime() {
    return Divider(
      height: 6,
      thickness: 2,
      color: Colors.red,
    );
  }

  Padding NamazTimeRow(
      {String? svg, required String salahName, required String salahTime}) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          svg != null
              ? SvgPicture.asset(
                  svg,
                  height: 16,
                  color: Colors.white,
                )
              : Icon(
                  checkForsvg(salahName),
                  size: 16,
                  color: Colors.white,
                ),
          Text(
            salahName,
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
          Text(
            salahTime,
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
        ],
      ),
    );
  }
}

Color kElementTextStyleColour = Colors.brown[900]!;

// Color kBackgroundClr =
// Color color = ;
