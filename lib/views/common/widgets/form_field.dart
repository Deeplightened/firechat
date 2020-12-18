
import 'package:firechat/views/common/theme/styles.dart';
import 'package:flutter/material.dart';


class CustomFormField extends StatefulWidget {
  final String label;
  final Widget child;

  const CustomFormField({Key key, this.label, @required this.child}) : super(key: key);

  @override
  _CustomFormFieldState createState() => _CustomFormFieldState();
}

class _CustomFormFieldState extends State<CustomFormField> {

  bool passwordDisplayed = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label
        (widget.label == null)
            ? Container()
            : Text(
                widget.label,
                style: themeFieldLabelTextStyle,
              ),

        // Field
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12.0),
          child: Stack(
            children: [
              widget.child,
            ],
          )
        ),
      ],
    );
  }
}
