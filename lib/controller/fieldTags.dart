import 'package:flutter/material.dart';
import 'package:ipet/misc/themestyle.dart';
import 'package:textfield_tags/textfield_tags.dart';

class ClinicFieldTags extends StatelessWidget {
  const ClinicFieldTags({
    super.key,
    required this.stringController,
    required double distanceToField,
    required this.servicetags,
    this.hintext,
  }) : _distanceToField = distanceToField;

  final StringTagController<String> stringController;
  final double _distanceToField;
  final List<String> servicetags;
  final String? hintext;

  @override
  Widget build(BuildContext context) {
    return TextFieldTags<String>(
      textfieldTagsController: stringController,
      textSeparators: const [' ', ','],
      letterCase: LetterCase.normal,
      validator: (String tag) {
        if (stringController.getTags!.contains(tag)) {
          return 'You\'ve already entered that';
        }
        return null;
      },
      inputFieldBuilder: (context, inputFieldValues) {
        return TextField(
          onTap: () {
            stringController.getFocusNode?.requestFocus();
          },
          controller: inputFieldValues.textEditingController,
          focusNode: inputFieldValues.focusNode,
          decoration: InputDecoration(
            hintText: inputFieldValues.tags.isNotEmpty ? "" : hintext,
            isDense: true,
            border: const OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.black,
                width: 3.0,
              ),
            ),
            focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(
                color: Color.fromARGB(255, 74, 137, 92),
                width: 3.0,
              ),
            ),
            errorText: inputFieldValues.error,
            prefixIconConstraints:
                BoxConstraints(maxWidth: _distanceToField * 0.8),
            prefixIcon: inputFieldValues.tags.isNotEmpty
                ? SingleChildScrollView(
                    controller: inputFieldValues.tagScrollController,
                    scrollDirection: Axis.vertical,
                    child: Padding(
                      padding: const EdgeInsets.only(
                        top: 8,
                        bottom: 8,
                        left: 8,
                      ),
                      child: Wrap(
                          runSpacing: 4.0,
                          spacing: 4.0,
                          children: inputFieldValues.tags.map((String tag) {
                            if (!servicetags.contains(tag)) {
                              servicetags.add(tag);
                            }
                            return Container(
                              decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(20.0),
                                  ),
                                  color: maincolor),
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 5.0),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10.0, vertical: 5.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  InkWell(
                                    child: Text(
                                      tag,
                                      style:
                                          const TextStyle(color: Colors.white),
                                    ),
                                    onTap: () {},
                                  ),
                                  const SizedBox(width: 4.0),
                                  InkWell(
                                    child: const Icon(
                                      Icons.cancel,
                                      size: 14.0,
                                      color: Color.fromARGB(255, 233, 233, 233),
                                    ),
                                    onTap: () {
                                      inputFieldValues.onTagRemoved(tag);

                                      servicetags.remove(tag);
                                    },
                                  )
                                ],
                              ),
                            );
                          }).toList()),
                    ),
                  )
                : null,
          ),
          onChanged: inputFieldValues.onTagChanged,
          onSubmitted: inputFieldValues.onTagSubmitted,
        );
      },
    );
  }
}
