import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:launch_at_startup/launch_at_startup.dart';

import 'constant.dart';
import 'system.dart';

class AutoLaunch {
  static AutoLaunch? _instance;

  AutoLaunch._internal() {
    launcher.setup(appName: appName, appPath: Platform.resolvedExecutable);
  }

  factory AutoLaunch() {
    _instance ??= AutoLaunch._internal();
    return _instance!;
  }

  @visibleForTesting
  static LaunchAtStartup launcher = launchAtStartup;

  Future<bool> get isEnable async {
    return launcher.isEnabled();
  }

  Future<bool> enable() async {
    return launcher.enable();
  }

  Future<bool> disable() async {
    return launcher.disable();
  }

  Future<void> _update = Future.value();

  /// An update runs after the write of the one before it, so a status read
  /// never sees the entry half written by a call that started earlier.
  Future<void> updateStatus(bool isAutoLaunch) {
    if (kDebugMode) {
      return Future.value();
    }
    final update = _update.then((_) => _apply(isAutoLaunch));
    _update = update.then<void>((_) {}, onError: (Object _) {});
    return update;
  }

  Future<void> _apply(bool isAutoLaunch) async {
    if (await isEnable == isAutoLaunch) return;
    if (isAutoLaunch == true) {
      await enable();
    } else {
      await disable();
    }
  }
}

final autoLaunch = system.isDesktop && !safeModeBuild ? AutoLaunch() : null;
