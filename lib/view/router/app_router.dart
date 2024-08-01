import 'package:flutter/material.dart';

import '../../constants/enums.dart';
import '../screens/home_screen.dart';
import '../screens/login_screen.dart';

List<Page> onGenerateMyAppPages(
  AppStatus status,
  List<Page<dynamic>> pages,
) {
  switch (status) {
    case AppStatus.authenticated:
      return [MaterialPage(child: HomeScreen())];
    case AppStatus.unAuthenticated:
      return [MaterialPage(child: LoginScreen())];
  }
}
