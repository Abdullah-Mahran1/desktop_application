import 'package:desktop_application/const/constants.dart';
import 'package:flutter/material.dart';

class DateTimePickerWidget extends StatefulWidget {
  final Function(DateTime) onDateTimeSelected;
  final DateTime? initialDateTime;

  const DateTimePickerWidget({
    Key? key,
    required this.onDateTimeSelected,
    this.initialDateTime,
  }) : super(key: key);

  @override
  _DateTimePickerWidgetState createState() => _DateTimePickerWidgetState();
}

class _DateTimePickerWidgetState extends State<DateTimePickerWidget> {
  late DateTime selectedDate;
  late TimeOfDay selectedTime;

  @override
  void initState() {
    super.initState();
    selectedDate = widget.initialDateTime ?? DateTime.now();
    selectedTime = TimeOfDay.fromDateTime(selectedDate);
  }

  void _updateDateTime() {
    final dateTime = DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
      selectedTime.hour,
      selectedTime.minute,
    );
    widget.onDateTimeSelected(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    return Column(mainAxisAlignment: MainAxisAlignment.start, children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          DatePickerWidget(
            initialDate: selectedDate,
            onDateSelected: (date) {
              setState(() {
                selectedDate = date;
                _updateDateTime();
              });
            },
          ),
          const SizedBox(width: defaultPadding),
          TimePickerWidget(
            initialTime: selectedTime,
            onTimeSelected: (time) {
              setState(() {
                selectedTime = TimeOfDay(hour: time.hour, minute: time.minute);
                _updateDateTime();
              });
            },
          ),
          const SizedBox(height: defaultPadding),
        ],
      ),
      const SizedBox(
        height: defaultPadding,
      ),
      Text(
        "Selected DateTime: ${selectedDate.year}-${selectedDate.month.toString().padLeft(2, '0')}-${selectedDate.day.toString().padLeft(2, '0')} ${selectedTime.format(context)}",
      ),
    ]);
  }
}

class DatePickerWidget extends StatefulWidget {
  final Function(DateTime) onDateSelected;
  final DateTime initialDate;

  DatePickerWidget(
      {Key? key, required this.onDateSelected, required this.initialDate})
      : super(key: key);

  @override
  _DatePickerWidgetState createState() => _DatePickerWidgetState();
}

class _DatePickerWidgetState extends State<DatePickerWidget> {
  late DateTime selectedDate;

  @override
  void initState() {
    super.initState();
    selectedDate = widget.initialDate;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: () async {
            final DateTime? pickedDate = await showDatePicker(
              context: context,
              initialDate: selectedDate,
              firstDate: DateTime(2000),
              lastDate: DateTime(2101),
            );
            if (pickedDate != null && pickedDate != selectedDate) {
              setState(() {
                selectedDate = pickedDate;
              });
              widget.onDateSelected(selectedDate);
            }
          },
          child: const Text("Select Date",
              style: TextStyle(color: Color(highlightColor))),
        ),
      ],
    );
  }
}

class TimePickerWidget extends StatefulWidget {
  final Function(DateTime) onTimeSelected;
  final TimeOfDay initialTime;

  TimePickerWidget(
      {Key? key, required this.onTimeSelected, required this.initialTime})
      : super(key: key);

  @override
  _TimePickerWidgetState createState() => _TimePickerWidgetState();
}

class _TimePickerWidgetState extends State<TimePickerWidget> {
  late TimeOfDay selectedTime;

  @override
  void initState() {
    super.initState();
    selectedTime = widget.initialTime;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: () async {
            final TimeOfDay? pickedTime = await showTimePicker(
              context: context,
              initialTime: selectedTime,
            );
            if (pickedTime != null && pickedTime != selectedTime) {
              setState(() {
                selectedTime = pickedTime;
              });
              final now = DateTime.now();
              final selectedDateTime = DateTime(now.year, now.month, now.day,
                  selectedTime.hour, selectedTime.minute);
              widget.onTimeSelected(selectedDateTime);
            }
          },
          child: const Text("Select Time",
              style: TextStyle(color: Color(highlightColor))),
        ),
      ],
    );
  }
}
