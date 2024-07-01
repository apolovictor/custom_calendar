import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const CalenderScreenUI(),
    );
  }
}

extension DateOnlyCompare on DateTime {
  bool isSameDate(DateTime other) {
    return this.year == other.year &&
        this.month == other.month &&
        this.day == other.day;
  }
}

class CalenderScreenUI extends StatefulWidget {
  const CalenderScreenUI({super.key});

  @override
  State<CalenderScreenUI> createState() => _CalenderScreenUIState();
}

class _CalenderScreenUIState extends State<CalenderScreenUI>
    with SingleTickerProviderStateMixin {
  // ignore: prefer_final_fields
  DateTime _currentMonth = DateTime.now();
  bool selectedcurrentyear = false;
  bool isSwitch = false;

  @override
  Widget build(BuildContext context) {
    // ... (rest of the build method)
    List<DateTime> months = [];

    for (var i = 0; i < 12; i++) {
      months.add(DateTime(_currentMonth.year, (i % 12) + 1, 1));
    }

    Widget layoutTransition = isSwitch
        ? Stack(
            key: ValueKey(1),
            children: [
              Positioned(
                top: 0,
                bottom: 0,
                left: 0,
                right: MediaQuery.of(context).size.width * 0.7,
                child: SizedBox.expand(
                  child: SingleChildScrollView(
                    physics: BouncingScrollPhysics(),
                    child: WarpTransition(
                      months: months,
                    ),
                  ),
                ),
              ),
            ],
          )
        : Stack(
            key: ValueKey(2),
            children: [
              Positioned(
                top: 0,
                bottom: 0,
                left: 0,
                right: 0,
                child: SizedBox.expand(
                  child: SingleChildScrollView(
                    physics: BouncingScrollPhysics(),
                    child: Hero(
                      tag: 'calendar',
                      child: WarpTransition(
                        months: months,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );

    var tween =
        Tween(begin: 0.0, end: 1.0).chain(CurveTween(curve: Curves.easeInOut));
    return Scaffold(
      // ... (rest of the Scaffold)
      appBar: AppBar(
        title: Text("Custom Calendar"),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                // isSwitch = !isSwitch;
              });
            },
            icon: Icon(Icons.refresh),
          )
        ],
      ),
      body: AnimatedSwitcher(
          duration: const Duration(milliseconds: 900),
          transitionBuilder: (child, animation) {
            return ScaleTransition(
              scale: animation.drive(tween),
              // position: tween.animate(animation),
              child: child,
            );
          },
          child: layoutTransition),
      // Stack(
      //   children: [
      //     Positioned(
      //       left: 0,
      //       right: 0,
      //       // right: MediaQuery.of(context).size.width * 0.7,
      //       child: WarpTransition(
      //         months: months,
      //       ),
      //     ),
      //   ],
      // ),
    );
  }
}

class WarpTransition extends StatelessWidget {
  const WarpTransition({axis, required this.months, super.key});

  final List<DateTime> months;

  @override
  Widget build(BuildContext context) {
    Widget buildWeekDay(String day) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5.0),
        child: Text(
          day,
          style: TextStyle(fontWeight: FontWeight.w500),
        ),
      );
    }

    Widget _buildWeeks() {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Wrap(
          alignment: WrapAlignment.spaceBetween,
          children: [
            buildWeekDay('Seg'),
            buildWeekDay('Ter'),
            buildWeekDay('Qua'),
            buildWeekDay('Qui'),
            buildWeekDay('Sex'),
            buildWeekDay('Sab'),
            buildWeekDay('Dom'),
          ],
        ),
      );
    }

    // This widget builds the detailed calendar grid for the chosen month.
    Widget buildCalendar(DateTime month) {
      // Calculating various details for the month's display
      int daysInMonth = DateTime(month.year, month.month + 1, 0).day;
      DateTime firstDayOfMonth = DateTime(month.year, month.month, 1);
      int weekdayOfFirstDay = firstDayOfMonth.weekday;

      DateTime lastDayOfPreviousMonth =
          firstDayOfMonth.subtract(Duration(days: 1));
      int daysInPreviousMonth = lastDayOfPreviousMonth.day;

      return Column(
        children: [
          SizedBox(
            width: 280,
            child: Wrap(
              direction: Axis.horizontal,
              alignment: WrapAlignment.spaceBetween,
              runAlignment: WrapAlignment.spaceBetween,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                SizedBox(),
                Text(
                  DateFormat('MMMM').format(month),
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                IconButton(onPressed: () {}, icon: Icon(Icons.open_in_full))
              ],
            ),
          ),
          SizedBox(width: 280, child: _buildWeeks()),
          Container(
            height: 200,
            width: 280,
            child: GridView.builder(
              padding: EdgeInsets.zero,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 7,
                // childAspectRatio: 0.4,
              ),
              // Calculating the total number of cells required in the grid
              itemCount: daysInMonth + weekdayOfFirstDay - 1,
              itemBuilder: (context, index) {
                // if (DateFormat('MMMM').format(month) == "September") {
                //   // print("weekdayOfFirstDay == $weekdayOfFirstDay");
                //   print("month.weekday == ${month.weekday}");
                // }
                DateTime date2 = DateTime(
                    month.year, month.month, index - weekdayOfFirstDay + 2);

                if (index < weekdayOfFirstDay - 1) {
                  // Displaying dates from the previous month in grey
                  int previousMonthDay =
                      daysInPreviousMonth - (weekdayOfFirstDay - index) + 2;
                  return Container(
                    decoration: const BoxDecoration(
                      border: Border(
                        top: BorderSide.none,
                        left: BorderSide(width: 1.0, color: Colors.grey),
                        right: BorderSide(width: 1.0, color: Colors.grey),
                        bottom: BorderSide(width: 1.0, color: Colors.grey),
                      ),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      previousMonthDay.toString(),
                      style: TextStyle(color: Colors.grey),
                    ),
                  );
                } else {
                  // Displaying the current month's days
                  DateTime date = DateTime(
                      month.year, month.month, index - weekdayOfFirstDay + 2);
                  String text = date.day.toString();
                  bool isWeekend = date.weekday == DateTime.saturday ||
                      date.weekday == DateTime.sunday;

                  return InkWell(
                    onTap: isWeekend
                        ? null
                        : () {
                            print(
                                "${date.day} -- ${date.month} -- ${date.year} -- ${date.weekday}");
                            // Handle tap on a date cell
                            // This is where you can add functionality when a date is tapped
                          },
                    child: Container(
                      decoration: BoxDecoration(
                        border: const Border(
                          top: BorderSide.none,
                          left: BorderSide(width: 1.0, color: Colors.grey),
                          right: BorderSide(width: 1.0, color: Colors.grey),
                          bottom: BorderSide(width: 1.0, color: Colors.grey),
                        ),
                        color: DateFormat('yyyy-MM-dd')
                                    .format(DateTime.now()) ==
                                DateFormat('yyyy-MM-dd').format(date2)
                            ? Colors.blueAccent
                            : isWeekend
                                ? Colors.grey[300]
                                : null, // Apply grey background for weekends
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(
                            flex: 2,
                            child: Center(
                              child: Text(
                                text,
                                style: DateFormat('yyyy-MM-dd')
                                            .format(DateTime.now()) ==
                                        DateFormat('yyyy-MM-dd').format(date2)
                                    ? TextStyle(color: Colors.white)
                                    : isWeekend
                                        ? TextStyle(color: Colors.black38)
                                        : TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                              ),
                            ),
                          ),
                          // Expanded(
                          //   flex: 0,
                          //   child: SizedBox(
                          //     child: Image.network(
                          //       'https://via.placeholder.com/150', // Sample image URL
                          //       width: 40,
                          //       height: 40,
                          //       fit: BoxFit.cover,
                          //     ),
                          //   ),
                          // ),
                          // Expanded(
                          //   flex: 2,
                          //   child: Padding(
                          //     padding:
                          //         const EdgeInsets.only(left: 3.0, right: 3.0),
                          //     child: Text(
                          //       'Sample Text', // Sample text
                          //       textAlign: TextAlign.center,
                          //       style: const TextStyle(
                          //         fontSize: 10.0,
                          //         fontWeight: FontWeight.w400,
                          //         color: Color.fromARGB(255, 127, 126, 126),
                          //       ),
                          //     ),
                          //   ),
                          // ),
                        ],
                      ),
                    ),
                  );
                }
              },
            ),
          ),
        ],
      );
    }

    // getCalendar(DateTime month) {
    //   return buildCalendar(month);
    // }

    // generateMonths() {
    //   return months.map((month) => getCalendar(month)).toList();
    // }

    return SizedBox(
      child: Wrap(
        direction: Axis.horizontal,
        spacing: 20,
        runSpacing: 10,
        children: [
          for (var month in months) buildCalendar(month),
        ],
      ),
    );
  }
}

Route createRouteSlide(
    String? heroTag,
    Widget targetPage,
    Duration? transitionDuration,
    Duration? reverseTransitionDuration,
    Offset? beginValue,
    Offset? endValue,
    Cubic? curveValue) {
  return PageRouteBuilder(
    transitionDuration: transitionDuration ?? const Duration(milliseconds: 300),
    reverseTransitionDuration:
        reverseTransitionDuration ?? const Duration(milliseconds: 300),
    pageBuilder: (context, animation, secondaryAnimation) =>
        Builder(builder: (context) {
      return targetPage;
    }),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final begin = beginValue ?? const Offset(0.0, 1.0);
      final end = endValue ?? const Offset(0.0, 0.0);
      final curve = curveValue ?? Curves.easeInOut;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return Material(
        child: SlideTransition(
          position: animation.drive(tween),
          child: child,
        ),
      );
    },
  );
}
