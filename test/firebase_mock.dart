import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

Future<void> setupFirebaseMocks() async {
  TestWidgetsFlutterBinding.ensureInitialized();

  const MethodChannel channel = MethodChannel('plugins.flutter.io/firebase_core');

  channel.setMockMethodCallHandler((MethodCall methodCall) async {
    if (methodCall.method == 'Firebase#initializeCore') {
      return [
        {
          'name': '[DEFAULT]',
          'options': {
            'apiKey': 'fakeApiKey',
            'appId': 'fakeAppId',
            'messagingSenderId': 'fakeSenderId',
            'projectId': 'fakeProjectId',
          },
          'pluginConstants': {},
        }
      ];
    }
    if (methodCall.method == 'Firebase#initializeApp') {
      return {
        'name': '[DEFAULT]',
        'options': {
          'apiKey': 'fakeApiKey',
          'appId': 'fakeAppId',
          'messagingSenderId': 'fakeSenderId',
          'projectId': 'fakeProjectId',
        },
        'pluginConstants': {},
      };
    }
    return null;
  });
}
