import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class TextFormFieldWidget extends StatelessWidget {
  final String name;
  final bool multiLines;
  final TextEditingController controller;
  const TextFormFieldWidget(
      {Key? key,
      required this.name,
      required this.multiLines,
      required this.controller})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: 10,
        horizontal: 20,
      ),
      child: TextFormField(
        controller: controller,
        validator: (val) => val!.isEmpty ? "$name Can't be empty" : null,
        decoration: InputDecoration(hintText: name),
        minLines: multiLines ? 6 : 1,
        maxLines: multiLines ? 6 : 1,
      ),
    );
  }
}
