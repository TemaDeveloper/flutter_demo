import 'package:flutter/foundation.dart';
import 'package:pocketbase/pocketbase.dart';

class BackendProxyForLosharikArtemie {
  static final _instance = BackendProxyForLosharikArtemie()._internalConstructor();
  // https://stackoverflow.com/questions/53886304/understanding-factory-constructor-code-example-dart
  factory BackendProxyForLosharikArtemie() {
    return _instance;
  }

  BackendProxyForLosharikArtemie _internalConstructor() {
    const url = kDebugMode ? 'http://127.0.0.1:8090' : 'TODO';
      
    final pocketBase = PocketBase(url);

    var instance = BackendProxyForLosharikArtemie();
    instance._pocketBase = pocketBase;
    return instance;
  }

  /* instance */
  late PocketBase _pocketBase;
  PocketBase get pb => _pocketBase;

  late bool _isVerified;
  bool get isVerified => _isVerified;

  late bool _isLogged;
  bool get isLogged => _isLogged;

  /// true <-> success
  Future<bool> authenticate(String email, String password) async {
    final authData = await pb.collection('users').authWithPassword(
      email,
      password
    );

    _isLogged = pb.authStore.isValid;

    if (_isLogged) {
      print(authData.meta['emailVerified']);
    }

    return _isLogged;
  }
}
