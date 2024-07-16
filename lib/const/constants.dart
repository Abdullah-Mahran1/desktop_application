const int backgroundColor = 0xffffffff;
const int secondBackgroundColor = 0xffF1F2F7;

const int secondaryColor = 0xFFA6ABC8;
const int highlightColor = 0xff707FDD;
const int alertColor = 0xFFFFCC00;
const int blackColor = 0xFF111111;

const int ch0Color = 0xFF5A6ACF;
const int ch1Color = 0xFF77C9A1;
const int ch2Color = 0xFFC31A1A;
const int ch3Color = 0xFFF0E600;

const double defaultPadding = 20.0;

const String serverIpAdrs = '192.168.1.20';
const int serverPortNo = 502;
const int deviceId = 1;
List<int> chAddresses = [30001, 30101, 30201, 30301]; //addresses of ch0 to ch3
int readingBuffer =
    500; // number of elements to accumulate before storing to excel file, production version can have value of 50

const int serverReadingDelay = 3000; // one millisecound per reading
//  Global Variables:
// int selectedSideMenuItem = 0;

List<bool> selectedChannels = [true, true, false, false];
Map<int, Map<String, double>> channelThresholds = {
  0: {'>=': 3.7},
  1: {'<': 3.7},
  2: {'>=': 3.7},
  3: {'>=': 3.7},
};
List<double> powerRange = [0, 80];

// enum GraphXView {
//   MINUTE,
//   HOUR,
//   SIX_HOURS,
//   DAY,
//   SIX_DAYS
//   // minutes([1, 2, 3]),
//   // hours([1, 2, 3]),
//   // days([1, 2, 3]);

//   // final List<int> data;
//   // const GraphXView(this.data);
// }

// GraphXView currentXView = GraphXView.MINUTE;

