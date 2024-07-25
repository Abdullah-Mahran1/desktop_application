# desktop_application

A new Flutter project.

## Getting Started
<!-- TODO: Add steps of deploying the application in a different device -->
This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## Project elements

1. read data from device using modbus protocol (✔)
2. store data in csv format (✔)
3. load data from csv format (✔)
4. display data in graph, steps:
    - readFromCsv returns List of DataEntry (✔)
    - loadGraphData converts it into [1] DataEntries - (✔) & [2] creates understandable labels for it (✔)
    - chartWidget takes data and draws chart (✔)
5. UI and navigation (✔)
6. manage alerts using hive (✔)
7. correct init code, to have (Singlton settings and data container) (✔)
8. Store settings (✔)
9. Add live graph
10. Check connection
11. Throw alerts when:
    - threshold is exceeded
    - device is disconnected, show statues of ping & modbus connections

## File Structure

1. csv_communication

## suggestions

- while data_loadig, check if data is more or less than needed, if more: split it (✔), if less: read more (TODO)
- button to trigger datalogging on/off
- button to refresh data graphed, get the updated file and redraw the graph
