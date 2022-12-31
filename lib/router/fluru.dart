import 'package:fifa2022/screens/Auth/auth_screen.dart';
import 'package:fifa2022/screens/admin_panel/admin_login.dart';
import 'package:fifa2022/screens/admin_panel/admin_panel.dart';
import 'package:fifa2022/screens/home/home_screen.dart';
import 'package:fifa2022/screens/home/temp_screen.dart';
import 'package:fifa2022/screens/matches/add_new_match.dart';
import 'package:fifa2022/screens/matches/all_matches.dart';
import 'package:fifa2022/screens/matches/match_page.dart';
import 'package:fifa2022/screens/profile/profile.dart';
import 'package:fifa2022/screens/shared_widgets/notfound.dart';
import 'package:fluro/fluro.dart';

import 'package:fluro/fluro.dart' as fluro;
import 'package:flutter/material.dart' hide Router;
class FluroRouterMain {
  static FluroRouter router = fluro.FluroRouter();

  static final Handler _loginHandler = Handler(
      handlerFunc: (BuildContext? context, Map<String, dynamic> params) =>
          const AuthPage(isLogin: true));

  static final Handler _registerHandler = Handler(
      handlerFunc: (BuildContext? context, Map<String, dynamic> params) =>
      const AuthPage(isLogin: false));
  static final Handler _homeHandler = Handler(
      handlerFunc: (BuildContext? context, Map<String, dynamic> params) =>
      const HomePage());

  static final Handler _allMatchesHandler = Handler(
      handlerFunc: (BuildContext? context, Map<String, dynamic> params) =>
      const AllMatches());

  static final Handler _profileHandler = Handler(
      handlerFunc: (BuildContext? context, Map<String, dynamic> params) =>
      const ProfilePage());

  static final Handler _addMatchHandler = Handler(
      handlerFunc: (BuildContext? context, Map<String, dynamic> params) =>
       CreateEditMatchDetails());

  static final Handler _matchHandler = Handler(
      handlerFunc: (BuildContext? context, Map<String, dynamic> params) =>
          MatchPage(id: params["id"][0].toString(),));

  static final Handler _adminLoginHandler = Handler(
      handlerFunc: (BuildContext? context, Map<String, dynamic> params) =>
          const AdminLogin());
  static final Handler _adminPanelHandler = Handler(
      handlerFunc: (BuildContext? context, Map<String, dynamic> params) =>
      const AdminPanel());


  static void setupRouter() {

    router.notFoundHandler = Handler(
        handlerFunc: (BuildContext? context, Map<String, List<String>> params) {
          return const NotFound();
        });
    router.define("login", handler: _loginHandler, transitionType: TransitionType.fadeIn);
    router.define("admin/login", handler: _adminLoginHandler, transitionType: TransitionType.fadeIn);
    router.define("admin/dashboard", handler: _adminPanelHandler, transitionType: TransitionType.fadeIn);
    router.define("register", handler: _registerHandler, transitionType: TransitionType.fadeIn);
    router.define("home", handler: _homeHandler, transitionType: TransitionType.fadeIn);
    router.define("matches", handler: _allMatchesHandler, transitionType: TransitionType.fadeIn);
    router.define("profile", handler: _profileHandler, transitionType: TransitionType.fadeIn);
    router.define("addMatch", handler: _addMatchHandler, transitionType: TransitionType.fadeIn);
    router.define("match/:id", handler: _matchHandler, transitionType: TransitionType.fadeIn);
  }
}
