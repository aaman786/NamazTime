class AdhanTime {
  final String salahName;
  final DateTime salahStartTime;
  final DateTime salahEndTime;
  final String? icon;

  AdhanTime(
      {required this.salahName,
      required this.salahStartTime,
      required this.salahEndTime,
      this.icon});

  Map<String, dynamic> toMap() {
    return {
      "salahName": salahName,
      "salahStartTime": salahStartTime,
      "salahEndTime": salahEndTime,
      "icon": icon,
    };
  }
}
