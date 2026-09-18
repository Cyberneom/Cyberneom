import 'package:cyberneom/app_routes.dart';
import 'package:cyberneom/localization/app_translations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:neom_blog/utils/constants/blog_translation_constants.dart';
import 'package:neom_core/utils/constants/app_route_constants.dart';

void main() {
  test(
    'Cyberneom registers reflection editor, drafts and public reader exactly once',
    () {
      final names = AppRoutes.getAppRoutes()
          .map((route) => route.name)
          .toList();
      for (final route in [
        AppRouteConstants.blog,
        AppRouteConstants.blogEditor,
        AppRouteConstants.blogEntry,
      ]) {
        expect(names.where((name) => name == route), hasLength(1));
      }
      expect(names, isNot(contains(AppRouteConstants.blogAdmin)));
      expect(names, isNot(contains(AppRouteConstants.blogAnalytics)));
    },
  );

  test('Cyberneom includes reflection localization in all four languages', () {
    final translations = AppTranslations().keys;
    for (final locale in ['es', 'en', 'fr', 'de']) {
      for (final key in [
        BlogTranslationConstants.practiceReflection,
        BlogTranslationConstants.practiceBefore,
        BlogTranslationConstants.practiceAfter,
        BlogTranslationConstants.practiceLocalDraft,
        BlogTranslationConstants.practiceReference,
        BlogTranslationConstants.blogSaveFailed,
      ]) {
        expect(translations[locale]![key], isNotNull, reason: '$locale / $key');
        expect(translations[locale]![key], isNotEmpty);
      }
    }
  });
}
