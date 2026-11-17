import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Flutter assets cannot sweep private root files into the bundle', () {
    final pubspec = File('pubspec.yaml').readAsStringSync();
    expect(
      pubspec,
      isNot(matches(RegExp(r'^\s*-\s*assets/\s*(?:#.*)?$', multiLine: true))),
    );
    expect(File('assets/service_account.json').existsSync(), isFalse);
  });

  test(
    'direct chamber links load the same Flutter app as in-app navigation',
    () {
      final config =
          jsonDecode(File('firebase.json').readAsStringSync())
              as Map<String, dynamic>;
      final hosting = config['hosting'] as Map<String, dynamic>;
      final rewrites = (hosting['rewrites'] as List)
          .cast<Map<String, dynamic>>();
      final chamber = rewrites.firstWhere(
        (rule) => rule['source'] == '/generator',
      );

      expect(hosting['public'], 'build/web');
      expect(chamber['destination'], '/index.html');
      // Preserve the explicit legacy HTML entry point without shadowing Flutter.
      expect(File('web/generator.html').existsSync(), isTrue);
    },
  );

  test('Hosting retains credential and source-map exclusions', () {
    final config =
        jsonDecode(File('firebase.json').readAsStringSync())
            as Map<String, dynamic>;
    final ignored = config['hosting']['ignore'] as List;

    expect(
      ignored,
      containsAll(<String>[
        '**/*service_account*',
        '**/*service-account*',
        '**/*.pem',
        '**/*.key',
        '**/.env*',
        '**/*.map',
      ]),
    );
  });

  test('Hosting configures COOP/COEP cross-origin isolation and Wasm headers', () {
    final config =
        jsonDecode(File('firebase.json').readAsStringSync())
            as Map<String, dynamic>;
    final headersRules = (config['hosting']['headers'] as List)
        .cast<Map<String, dynamic>>();

    final globalRule = headersRules.firstWhere(
      (rule) => rule['source'] == '**',
    );
    final globalHeaders = <String, String>{
      for (final h in (globalRule['headers'] as List).cast<Map<String, dynamic>>())
        h['key'] as String: h['value'] as String,
    };
    expect(globalHeaders['Cross-Origin-Opener-Policy'], 'same-origin');
    expect(globalHeaders['Cross-Origin-Embedder-Policy'], 'credentialless');
    expect(globalHeaders['X-Content-Type-Options'], 'nosniff');

    final wasmRule = headersRules.firstWhere(
      (rule) => rule['source'] == '**/*.wasm',
    );
    final wasmHeaders = <String, String>{
      for (final h in (wasmRule['headers'] as List).cast<Map<String, dynamic>>())
        h['key'] as String: h['value'] as String,
    };
    expect(wasmHeaders['Content-Type'], 'application/wasm');
    expect(wasmHeaders['Cache-Control'], contains('no-cache'));
  });
}
