import 'package:catcher/core/catcher.dart';
import 'package:catcher/handlers/console_handler.dart';
import 'package:catcher/mode/dialog_report_mode.dart';
import 'package:catcher/model/catcher_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firechat/common/configuration/injection.dart';
import 'package:flutter/material.dart';

import 'app.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  await initDI();

  final _navigatorKey = GlobalKey<NavigatorState>();

  CatcherOptions debugOptions = CatcherOptions(DialogReportMode(), [ConsoleHandler()]);

  Catcher(App(_navigatorKey), debugConfig: debugOptions, navigatorKey: _navigatorKey);
}