import 'package:flutter/material.dart';

import '../theme/colors.dart';
import '../theme/constants.dart';
import '../theme/styles.dart';

class PrimaryButton extends StatelessWidget {
  final String label;
  final Widget child;
  final double height;
  final Color color;
  final Function(BuildContext) onClick;

  const PrimaryButton(
      {Key key,
      @required this.onClick,
      this.label,
      this.child,
      this.color,
      this.height = 50})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onClick(context);
      },
      child: Container(
        height: height,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(themeDefaultRadius)),
            color: color ?? themeAccentColor),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Expanded(
                child: Center(
                    child:
                        child ?? Text(label, style: themeFieldLabelTextStyle)))
          ],
        ),
      ),
    );
  }
}
