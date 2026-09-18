import 'package:cyberneom/app_routes.dart';
import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter_test/flutter_test.dart';
import 'package:neom_books/books_routes.dart';
import 'package:neom_commons/app_flavour.dart';
import 'package:neom_core/app_config.dart';
import 'package:neom_core/utils/constants/app_route_constants.dart';
import 'package:neom_core/utils/enums/app_in_use.dart';
import 'package:neom_core/utils/enums/media_item_type.dart';

void main() {
  late AppInUse previousApp;

  setUp(() {
    previousApp = AppConfig.instance.appInUse;
    AppConfig.instance.appInUse = AppInUse.c;
  });

  tearDown(() {
    AppConfig.instance.appInUse = previousApp;
  });

  test('only EMXI exposes the books library', () {
    for (final app in AppInUse.values) {
      AppConfig.instance.appInUse = app;
      expect(
        AppFlavour.showBooksLibrary(),
        app == AppInUse.e,
        reason: 'Books must be exclusive to EMXI, not ${app.name}',
      );
    }
  });

  test('levitation requires Cyberneom and debug mode', () {
    for (final app in AppInUse.values) {
      AppConfig.instance.appInUse = app;
      expect(AppFlavour.showLevitation(), kDebugMode && app == AppInUse.c);
    }
  });

  test('Cyberneom has no book catalogue routes and retains PDF preview', () {
    final names = AppRoutes.getAppRoutes().map((route) => route.name).toSet();
    expect(names, isNot(contains(AppRouteConstants.libraryHome)));
    expect(names, isNot(contains(AppRouteConstants.topBooks)));
    expect(names, isNot(contains(AppRouteConstants.bookDetails)));
    expect(names, contains(AppRouteConstants.reading));
    expect(
      names.where((name) => name.startsWith('/levitation')).isNotEmpty,
      kDebugMode,
    );
    expect(names, contains(AppRouteConstants.audioPlayer));
  });

  test('generic reader routes do not expose the EMXI catalogue', () {
    expect(BooksRoutes.readerRoutes.map((route) => route.name), [
      AppRouteConstants.reading,
    ]);
  });

  test('EMXI retains its existing catalogue and PDF reader', () {
    final names = BooksRoutes.routes.map((route) => route.name);
    expect(
      names,
      containsAll([
        AppRouteConstants.libraryHome,
        AppRouteConstants.topBooks,
        AppRouteConstants.bookDetails,
        AppRouteConstants.reading,
      ]),
    );
    AppConfig.instance.appInUse = AppInUse.e;
    expect(
      AppFlavour.getMainItemDetailsRoute('work', type: MediaItemType.pdf),
      AppRouteConstants.bookPath('work'),
    );
  });

  test('Cyberneom audio keeps using the player, not book details', () {
    for (final type in MediaItemType.values.where((type) => type.isAudio)) {
      expect(
        AppFlavour.getMainItemDetailsRoute('audio', type: type),
        AppRouteConstants.audioPlayerMedia,
      );
    }
    expect(
      AppFlavour.getMainItemDetailsRoute('legacy-audio'),
      AppRouteConstants.audioPlayerMedia,
    );
  });

  test('Cyberneom PDF preview does not navigate to a removed catalogue', () {
    for (final type in [MediaItemType.pdf, MediaItemType.book]) {
      expect(
        AppFlavour.getMainItemDetailsRoute('preview', type: type),
        AppRouteConstants.readingPath('preview'),
      );
    }
  });
}
