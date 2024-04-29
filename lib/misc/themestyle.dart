import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Color maincolor = const Color(0xff141E46);

class MainFont extends StatelessWidget {
  final String title;
  final double? fsize;
  final FontWeight? fweight;
  final Color? color;
  const MainFont(
      {super.key, required this.title, this.fsize, this.fweight, this.color});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: GoogleFonts.roboto(
        textStyle:
            TextStyle(color: color, fontWeight: fweight, fontSize: fsize),
      ),
    );
  }
}

class GlobalButton extends StatelessWidget {
  final bool? isbool;
  final Function callback;
  final String title;
  const GlobalButton(
      {super.key, this.isbool, required this.callback, required this.title});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 50,
        width: double.infinity,
        child: ElevatedButton(
            style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
                backgroundColor: maincolor),
            onPressed: () {
              callback();
            },
            child: Text(
              title,
              style: const TextStyle(color: Colors.white),
            )));
  }
}

class Globalbutton extends StatelessWidget {
  final String title;
  final double? wsize;
  final double? hsize;
  final Function fcallback;
  final Color? bgcolor;
  final Color? fcolor;
  const Globalbutton(
      {super.key,
      required this.title,
      this.wsize,
      this.hsize,
      required this.fcallback,
      this.bgcolor,
      this.fcolor});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: hsize ?? MediaQuery.of(context).size.height,
      width: wsize ?? MediaQuery.of(context).size.width,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            backgroundColor: bgcolor ?? maincolor),
        onPressed: () {
          fcallback();
        },
        child: Text(
          title,
          style: TextStyle(color: fcolor ?? Colors.white),
        ),
      ),
    );
  }
}
