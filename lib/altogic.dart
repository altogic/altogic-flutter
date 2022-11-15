library altogic;

import 'dart:async';

import 'package:altogic_dart/altogic_dart.dart';
import 'package:altogic_dart/altogic_dart.dart' as dart;
import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

export 'package:altogic_dart/altogic_dart.dart'
    hide createClient, AltogicClient, ClientOptions;

part 'src/altogic_client.dart';
part 'src/auth.dart';
part 'src/local_storage.dart';
part 'src/observer.dart';
part 'src/flutter_auth_manager.dart';
part 'src/client_options.dart';
