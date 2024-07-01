// // ... (rest of the code)
// class WarpTransition extends StatefulWidget {
//   const WarpTransition({required this.months, Key? key}) : super(key: key);

//   final List<DateTime> months;

//   @override
//   State<WarpTransition> createState() => _WarpTransitionState();
// }

// class _WarpTransitionState extends State<WarpTransition>
//     with SingleTickerProviderStateMixin {
//   late AnimationController _animationController;
//   late Animation<double> _animation;
//   late Axis _currentAxis;
//   final double _maxWidth = 300; // Adjust this value as needed

//   @override
//   void initState() {
//     super.initState();
//     _animationController = AnimationController(
//       duration: const Duration(milliseconds: 500),
//       vsync: this,
//     );
//     _animation = Tween<double>(begin: 0, end: 1).animate(_animationController);
//     _currentAxis = Axis.horizontal;
//     //
//   }

//   @override
//   void dispose() {
//     _animationController.dispose();
//     super.dispose();
//   }

//   void _switchAxis() {
//     setState(() {
//       _currentAxis =
//           _currentAxis == Axis.horizontal ? Axis.vertical : Axis.horizontal;
//       _animationController.forward();
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       _animationController.forward();
//     });
//     return SingleChildScrollView(
//       child: Column(
//         children: [
//           ElevatedButton(
//             onPressed: _switchAxis,
//             child: const Text('Switch Axis'),
//           ),
//           SizedBox(
//             width: MediaQuery.of(context).size.width,
//             height: MediaQuery.of(context).size.height,
//             child: AnimatedBuilder(
//               animation: _animation,
//               builder: (context, child) {
//                 return LayoutBuilder(
//                   builder: (context, constraints) {
//                     return Stack(
//                       children: [
//                         for (int i = 0; i < widget.months.length; i++)
//                           AnimatedPositioned(
//                             duration: const Duration(milliseconds: 500),
//                             curve: Curves.easeInOut,
//                             left: _currentAxis == Axis.horizontal
//                                 ? _animation.value *
//                                     (i * 280 + i * 20) %
//                                     constraints.maxWidth
//                                 : 0,
//                             top: _currentAxis == Axis.vertical
//                                 ? _animation.value *
//                                     ((i ~/ (constraints.maxWidth / 280)) * 300 +
//                                         (i % (constraints.maxWidth / 280)) *
//                                             300 +
//                                         i * 10) %
//                                     constraints.maxHeight
//                                 : 0,
//                             child: SizedBox(
//                               width: 150,
//                               height: 200,
//                               child: buildCalendar(widget.months[i]),
//                             ),
//                           ),
//                       ],
//                     );
//                   },
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget buildCalendar(DateTime month) {
//     // Your existing calendar building logic
//     return Container(
//       color: Colors.blue,
//       child: Center(child: Text(month.toString())),
//     );
//   }
// }
