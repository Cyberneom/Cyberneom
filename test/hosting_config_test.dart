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
}
