import 'package:flutter/material.dart';

class Textformtype extends StatelessWidget {
  final TextEditingController textEditingController;
  final String uppertitle;
  final String fieldname;
  final String textvalidator;
  final Widget? icons;
  final bool? isbscure;
  final Function(String)? onchange;
  const Textformtype(
      {super.key,
      required this.textEditingController,
      required this.uppertitle,
      required this.fieldname,
      this.icons,
      required this.textvalidator,
      this.onchange,
      this.isbscure});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(uppertitle),
        const SizedBox(
          height: 5,
        ),
        SizedBox(
          height: 65,
          child: TextFormField(
            controller: textEditingController,
            validator: (val) {
              if (val!.isEmpty) {
                return textvalidator;
              } else {
                return null;
              }
            },
            obscureText: isbscure ?? false,
            keyboardType: TextInputType.name,
            decoration: InputDecoration(
                hintText: fieldname,
                suffix: icons,
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10))),
          ),
        ),
      ],
    );
  }
}
