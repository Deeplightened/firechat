


import 'package:firechat/views/common/theme/colors.dart';
import 'package:flutter/material.dart';

class LandingPage extends StatelessWidget {

  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => LandingPage());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: themeBackgroundColor,
      body: Center(
        child: CircularProgressIndicator(
          strokeWidth: 3,
          valueColor: AlwaysStoppedAnimation(themeTextColor),
        )
      ),
    );
  }


}