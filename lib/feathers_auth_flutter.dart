library feathers_auth_flutter;

import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
part 'src/feathers_app.dart';
part 'src/feathers_service.dart';
part 'src/feathers_error.dart';

class FeathersAuthFlutter {}

/*abstract*/
/*
forceAthenticate, never, onExpired
FeathersApp(base url, AuthConfig({path, shared pref access token key, mode}))
..configure()
app.init()
  .on().emit().off() => socket

FeatherService = app.service('path')
FeathersResponse = service.get, find, create, update(put), patch, delete

app.initialize()//auth
app.authnticate()//body//params
app.reauthenticate(mode)

// app.custom().get()
*/
