class DataEntry {
  DateTime dateTime;
  late double timeValue; // X-axis value not label
  final double min, max, average, peak2Peak;

  DataEntry(
      {required this.dateTime,
      required this.min,
      required this.max,
      required this.average,
      required this.peak2Peak}) {
    String timeValue = dateTime.toString().replaceAll(RegExp(r'[^\d]'), '');
  }
  List<String> toCSVRow() {
    return [
      dateTime.toString(),
      min.toString(),
      max.toString(),
      average.toString(),
      peak2Peak.toString()
    ];
  }

  @override
  String toString() {
    return 'DateTime: $dateTime, $min < $average < $max, Peak2Peak: $peak2Peak';
  }
}
