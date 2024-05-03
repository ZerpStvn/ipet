// ignore_for_file: file_names
// import 'package:flutter/material.dart';

// class BottomNavBarRaisedInsetFb1 extends StatefulWidget {
//   const BottomNavBarRaisedInsetFb1({super.key});

//   @override
//   _BottomNavBarRaisedInsetFb1State createState() =>
//       _BottomNavBarRaisedInsetFb1State();
// }

// class _BottomNavBarRaisedInsetFb1State
//     extends State<BottomNavBarRaisedInsetFb1> {
//   //- - - - - - - - - instructions - - - - - - - - - - - - - - - - - -
//   // WARNING! MUST ADD extendBody: true; TO CONTAINING SCAFFOLD
//   //
//   // Instructions:
//   //
//   // add this widget to the bottomNavigationBar property of a Scaffold, along with
//   // setting the extendBody parameter to true i.e:
//   //
//   // Scaffold(
//   //  extendBody: true,
//   //  bottomNavigationBar: BottomNavBarRaisedInsetFb1()
//   // )
//   //
//   // Properties such as color and height can be set by changing the properties at the top of the build method
//   //
//   // For help implementing this in a real app, watch https://www.youtube.com/watch?v=C0_3w0kd0nc. The style is different, but connecting it to navigation is the same.
//   //
//   //- - - - - - - - - - - - - - -  - - - - - - - - - - - - - - - - - -

//   @override
//   Widget build(BuildContext context) {
//     Size size = MediaQuery.of(context).size;
//     double height = 56;

//     const primaryColor = Colors.blue;
//     const secondaryColor = Colors.black54;
//     const accentColor = Color(0xffffffff);
//     const backgroundColor = Colors.white;

//     const shadowColor = Colors.grey; //color of Navbar shadow
//     double elevation = 100; //Elevation of the bottom Navbar

//     return BottomAppBar(
//       color: Colors.transparent,
//       elevation: 0,
//       child: Stack(
//         children: [
//           CustomPaint(
//             size: Size(size.width, height),
//             painter: BottomNavCurvePainter(
//                 backgroundColor: backgroundColor,
//                 shadowColor: shadowColor,
//                 elevation: elevation),
//           ),
//           Center(
//             heightFactor: 0.6,
//             child: FloatingActionButton(
//                 backgroundColor: primaryColor,
//                 elevation: 0.1,
//                 onPressed: () {},
//                 child: const Icon(Icons.shopping_basket)),
//           ),
//           SizedBox(
//             height: height,
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceAround,
//               children: [
//                 NavBarIcon(
//                   text: "Home",
//                   icon: Icons.home_outlined,
//                   selected: true,
//                   onPressed: () {},
//                   defaultColor: secondaryColor,
//                   selectedColor: primaryColor,
//                 ),
//                 NavBarIcon(
//                   text: "Search",
//                   icon: Icons.search_outlined,
//                   selected: false,
//                   onPressed: () {},
//                   defaultColor: secondaryColor,
//                   selectedColor: primaryColor,
//                 ),
//                 const SizedBox(width: 56),
//                 NavBarIcon(
//                     text: "Cart",
//                     icon: Icons.local_grocery_store_outlined,
//                     selected: false,
//                     onPressed: () {},
//                     defaultColor: secondaryColor,
//                     selectedColor: primaryColor),
//                 NavBarIcon(
//                   text: "Calendar",
//                   icon: Icons.date_range_outlined,
//                   selected: false,
//                   onPressed: () {},
//                   selectedColor: primaryColor,
//                   defaultColor: secondaryColor,
//                 )
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class BottomNavCurvePainter extends CustomPainter {
//   BottomNavCurvePainter(
//       {this.backgroundColor = Colors.white,
//       this.insetRadius = 38,
//       this.shadowColor = Colors.grey,
//       this.elevation = 100});

//   Color backgroundColor;
//   Color shadowColor;
//   double elevation;
//   double insetRadius;
//   @override
//   void paint(Canvas canvas, Size size) {
//     Paint paint = Paint()
//       ..color = backgroundColor
//       ..style = PaintingStyle.fill;
//     Path path = Path();

//     double insetCurveBeginnningX = size.width / 2 - insetRadius;
//     double insetCurveEndX = size.width / 2 + insetRadius;

//     path.lineTo(insetCurveBeginnningX, 0);
//     path.arcToPoint(Offset(insetCurveEndX, 0),
//         radius: const Radius.circular(41), clockwise: true);

//     path.lineTo(size.width, 0);

//     path.lineTo(size.width, size.height + 56);
//     path.lineTo(
//         0,
//         size.height +
//             56); //+56 here extends the navbar below app bar to include extra space on some screens (iphone 11)
//     canvas.drawShadow(path, shadowColor, elevation, true);
//     canvas.drawPath(path, paint);
//   }

//   @override
//   bool shouldRepaint(CustomPainter oldDelegate) {
//     return false;
//   }
// }

// class NavBarIcon extends StatelessWidget {
//   const NavBarIcon(
//       {super.key,
//       required this.text,
//       required this.icon,
//       required this.selected,
//       required this.onPressed,
//       this.selectedColor = const Color(0xffFF8527),
//       this.defaultColor = Colors.black54});
//   final String text;
//   final IconData icon;
//   final bool selected;
//   final Function() onPressed;
//   final Color defaultColor;
//   final Color selectedColor;

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         IconButton(
//           onPressed: onPressed,
//           splashColor: Colors.transparent,
//           highlightColor: Colors.transparent,
//           icon: Icon(
//             icon,
//             size: 25,
//             color: selected ? selectedColor : defaultColor,
//           ),
//         ),
//       ],
//     );
//   }
// }
