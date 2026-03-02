import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:sint/sint.dart';

import 'package:neom_analytics/data/firestore/analytics_firestore.dart';
import 'package:neom_audio_player/audio_player_invoker.dart';
import 'package:neom_audio_player/data/implementations/audio_lite_player_controller.dart';
import 'package:neom_audio_player/neom_audio_handler.dart';
import 'package:neom_audio_player/ui/home/audio_player_home_controller.dart';
import 'package:neom_audio_player/ui/player/miniplayer_controller.dart';
import 'package:neom_auth/ui/login/login_controller.dart';

import 'package:neom_bands/ui/band_controller.dart';
import 'package:neom_bands/ui/details/band_details_controller.dart';
import 'package:neom_bank/data/firestore/wallet_firestore.dart';
import 'package:neom_bank/data/implementations/bank_controller.dart';
import 'package:neom_camera/ui/app_camera_controller.dart';
import 'package:neom_commerce/data/firestore/invoice_firestore.dart';
import 'package:neom_commons/ui/app_drawer_controller.dart';
import 'package:neom_core/data/implementations/app_hive_controller.dart';
import 'package:neom_core/data/implementations/geolocator_controller.dart';
import 'package:neom_core/data/implementations/maps_controller.dart';
import 'package:neom_core/data/implementations/mate_controller.dart';
import 'package:neom_core/data/implementations/report_controller.dart';
import 'package:neom_core/data/implementations/subscription_controller.dart';
import 'package:neom_core/data/implementations/user_controller.dart';
import 'package:neom_core/domain/repository/chamber_repository.dart';
import 'package:neom_core/domain/repository/invoice_repository.dart';
import 'package:neom_core/domain/repository/job_repository.dart';
import 'package:neom_core/domain/repository/profile_instruments_repository.dart';
import 'package:neom_core/domain/repository/wallet_repository.dart';
import 'package:neom_core/domain/use_cases/app_drawer_service.dart';
import 'package:neom_core/domain/use_cases/app_hive_service.dart';
import 'package:neom_core/domain/use_cases/audio_handler_service.dart';
import 'package:neom_core/domain/use_cases/audio_lite_player_service.dart';
import 'package:neom_core/domain/use_cases/audio_player_invoker_service.dart';
import 'package:neom_core/domain/use_cases/band_details_service.dart';
import 'package:neom_core/domain/use_cases/band_service.dart';
import 'package:neom_core/domain/use_cases/bank_service.dart';
import 'package:neom_core/domain/use_cases/camera_service.dart';
import 'package:neom_core/domain/use_cases/download_service.dart';
import 'package:neom_core/domain/use_cases/event_details_service.dart';
import 'package:neom_core/domain/use_cases/genre_service.dart';
import 'package:neom_core/domain/use_cases/geolocator_service.dart';
import 'package:neom_core/domain/use_cases/home_service.dart';
import 'package:neom_core/domain/use_cases/inbox_service.dart';
import 'package:neom_core/domain/use_cases/instrument_service.dart';
import 'package:neom_core/domain/use_cases/itemlist_service.dart';
import 'package:neom_core/domain/use_cases/login_service.dart';
import 'package:neom_core/domain/use_cases/maps_service.dart';
import 'package:neom_core/domain/use_cases/mate_service.dart';
import 'package:neom_core/domain/use_cases/miniplayer_service.dart';
import 'package:neom_core/domain/use_cases/notification_service.dart';
import 'package:neom_core/domain/use_cases/post_upload_service.dart';
import 'package:neom_core/domain/repository/analytics_repository.dart';
import 'package:neom_core/domain/use_cases/image_editor_service.dart';
import 'package:neom_core/domain/use_cases/media_player_service.dart';
import 'package:neom_core/domain/use_cases/media_upload_service.dart';
import 'package:neom_core/domain/use_cases/profile_service.dart';
import 'package:neom_core/domain/use_cases/report_service.dart';
import 'package:neom_core/domain/use_cases/search_service.dart';
import 'package:neom_core/domain/use_cases/settings_service.dart';
import 'package:neom_core/domain/use_cases/stripe_api_service.dart';
import 'package:neom_core/domain/use_cases/stripe_gateway_service.dart';
import 'package:neom_core/domain/use_cases/subscription_service.dart';
import 'package:neom_core/domain/use_cases/timeline_service.dart';
import 'package:neom_core/domain/use_cases/user_service.dart';
import 'package:neom_core/domain/use_cases/woo_gateway_service.dart';
import 'package:neom_core/domain/use_cases/woo_media_service.dart';
import 'package:neom_downloads/data/implementations/download_controller.dart';
import 'package:neom_events/ui/event_details_controller.dart';
import 'package:neom_generator/data/firestore/chamber_firestore.dart';
import 'package:neom_genres/data/implementations/genre_controller.dart';
import 'package:neom_home/ui/home_controller.dart';
import 'package:neom_image_editor/data/implementations/image_editor_controller.dart';
import 'package:neom_inbox/domain/use_cases/inbox_room_service.dart';
import 'package:neom_inbox/ui/inbox_controller.dart';
import 'package:neom_inbox/ui/inbox_room_controller.dart';
import 'package:neom_instruments/data/firestore/profile_instruments_firestore.dart';
import 'package:neom_instruments/ui/instrument_controller.dart';
import 'package:neom_itemlists/ui/itemlist_controller.dart';
import 'package:neom_jobs/data/firestore/job_firestore.dart';
import 'package:neom_media_player/ui/media_player_controller.dart';
import 'package:neom_media_upload/ui/media_upload_controller.dart';
import 'package:neom_media_upload/ui/media_upload_web_controller.dart';
import 'package:neom_notifications/data/implementations/push_notification_invoker.dart';
import 'package:neom_core/domain/use_cases/post_details_service.dart';
import 'package:neom_posts/ui/details/post_details_controller.dart';
import 'package:neom_posts/ui/upload/post_upload_controller.dart';
import 'package:neom_profile/ui/profile_controller.dart';
import 'package:neom_search/ui/app_search_controller.dart';
import 'package:neom_settings/ui/settings_controller.dart';
import 'package:neom_stripe/data/implementations/stripe_api_controller.dart';
import 'package:neom_stripe/data/implementations/stripe_gateway_controller.dart';
import 'package:neom_timeline/ui/timeline_controller.dart';
import 'package:neom_woo/data/api_services/woo_media_api.dart';
import 'package:neom_woo/data/implementations/woo_gateway_controller.dart';

class RootBinding extends Binding {

  @override
  List<Bind> dependencies() {
    return [
      Bind.put(UserController(), permanent: true),
      Bind.lazyPut<UserService>(() => Get.find<UserController>(), fenix: true),
      Bind.put(LoginController(), permanent: true),
      Bind.lazyPut<LoginService>(() => Get.find<LoginController>(), fenix: true),

      Bind.lazyPut(() => HomeController(), fenix: true),
      Bind.lazyPut<HomeService>(() => Get.find<HomeController>(), fenix: true),
      Bind.lazyPut(() => TimelineController(), fenix: true),
      Bind.lazyPut<TimelineService>(() => Get.find<TimelineController>(), fenix: true),

      Bind.lazyPut(() => AudioPlayerInvoker(), fenix: true),
      Bind.lazyPut<AudioPlayerInvokerService>(() => Get.find<AudioPlayerInvoker>(), fenix: true),
      Bind.lazyPut(() => NeomAudioHandler(), fenix: true),
      Bind.lazyPut<AudioHandlerService>(() => Get.find<NeomAudioHandler>(), fenix: true),
      Bind.lazyPut(() => MiniPlayerController(), fenix: true),
      Bind.lazyPut<MiniPlayerService>(() => Get.find<MiniPlayerController>(), fenix: true),
      Bind.lazyPut(() => AudioPlayerHomeController()),
      Bind.lazyPut(() => AudioLitePlayerController(), fenix: true),
      Bind.lazyPut<AudioLitePlayerService>(() => Get.find<AudioLitePlayerController>(), fenix: true),

      Bind.lazyPut<EventDetailsService?>(() => Get.isRegistered<EventDetailsController>()
          ? Get.find<EventDetailsController>() : null, fenix: true),

      Bind.lazyPut(() => ItemlistController(), fenix: true),
      Bind.lazyPut<ItemlistService>(() => Get.find<ItemlistController>(), fenix: true),
      Bind.lazyPut(() => AppSearchController(), fenix: true),
      Bind.lazyPut<SearchService>(() => Get.find<AppSearchController>(), fenix: true),
      Bind.lazyPut(() => PostDetailsController(), fenix: true),
      Bind.lazyPut<PostDetailsService>(() => Get.find<PostDetailsController>(), fenix: true),

      Bind.lazyPut(() => PostUploadController(), fenix: true),
      Bind.lazyPut<PostUploadService>(() => Get.find<PostUploadController>(), fenix: true),
      if (!kIsWeb) ...[
        Bind.lazyPut(() => AppCameraController(), fenix: true),
        Bind.lazyPut<AppCameraService>(() => Get.find<AppCameraController>(), fenix: true),
        Bind.lazyPut(() => ImageEditorController(), fenix: true),
        Bind.lazyPut<ImageEditorService>(() => Get.find<ImageEditorController>(), fenix: true),
        Bind.lazyPut(() => MediaUploadController(), fenix: true),
        Bind.lazyPut<MediaUploadService>(() => Get.find<MediaUploadController>(), fenix: true),
        Bind.lazyPut(() => MediaPlayerController(), fenix: true),
        Bind.lazyPut<MediaPlayerService>(() => Get.find<MediaPlayerController>(), fenix: true),
      ],
      if (kIsWeb) ...[
        Bind.lazyPut(() => MediaUploadWebController(), fenix: true),
        Bind.lazyPut<MediaUploadService>(() => Get.find<MediaUploadWebController>(), fenix: true),
      ],

      Bind.lazyPut<AnalyticsRepository>(() => AnalyticsFirestore(), fenix: true),
      Bind.lazyPut<JobRepository>(() => JobFirestore()),

      Bind.lazyPut(() => AppDrawerController(), fenix: true),
      Bind.lazyPut<AppDrawerService>(() => Get.find<AppDrawerController>(), fenix: true),
      Bind.lazyPut(() => SettingsController(), fenix: true),
      Bind.lazyPut<SettingsService>(() => Get.find<SettingsController>(), fenix: true),
      Bind.lazyPut(() => ProfileController(), fenix: true),
      Bind.lazyPut<ProfileService>(() => Get.find<ProfileController>(), fenix: true),
      Bind.lazyPut(() => MateController(), fenix: true),
      Bind.lazyPut<MateService>(() => Get.find<MateController>(), fenix: true),

      if (!kIsWeb) ...[
        Bind.lazyPut(() => PushNotificationInvoker(), fenix: true),
        Bind.lazyPut<NotificationService>(() => Get.find<PushNotificationInvoker>(), fenix: true),
      ],

      Bind.lazyPut(() => BandController(), fenix: true),
      Bind.lazyPut<BandService>(() => Get.find<BandController>(), fenix: true),
      Bind.lazyPut(() => BandDetailsController(), fenix: true),
      Bind.lazyPut<BandDetailsService>(() => Get.find<BandDetailsController>(), fenix: true),

      Bind.lazyPut(() => BankController(), fenix: true),
      Bind.lazyPut<BankService>(() => Get.find<BankController>(), fenix: true),
      Bind.lazyPut(() => WalletFirestore(), fenix: true),
      Bind.lazyPut<WalletRepository>(() => Get.find<WalletFirestore>(), fenix: true),
      Bind.lazyPut(() => WooMediaAPI(), fenix: true),
      Bind.lazyPut<WooMediaService>(() => Get.find<WooMediaAPI>(), fenix: true),
      Bind.lazyPut(() => WooGatewayController(), fenix: true),
      Bind.lazyPut<WooGatewayService>(() => Get.find<WooGatewayController>(), fenix: true),
      Bind.lazyPut(() => StripeGatewayController(), fenix: true),
      Bind.lazyPut<StripeGatewayService>(() => Get.find<StripeGatewayController>(), fenix: true),
      Bind.lazyPut(() => StripeApiController(), fenix: true),
      Bind.lazyPut<StripeApiService>(() => Get.find<StripeApiController>(), fenix: true),

      Bind.lazyPut(() => InstrumentController(), fenix: true),
      Bind.lazyPut<InstrumentService>(() => Get.find<InstrumentController>(), fenix: true),
      Bind.lazyPut(() => GenreController(), fenix: true),
      Bind.lazyPut<GenreService>(() => Get.find<GenreController>(), fenix: true),
      Bind.lazyPut(() => ProfileInstrumentsFirestore(), fenix: true),
      Bind.lazyPut<ProfileInstrumentsRepository>(() => Get.find<ProfileInstrumentsFirestore>(), fenix: true),

      Bind.lazyPut(() => InboxController(), fenix: true),
      Bind.lazyPut<InboxService>(() => Get.find<InboxController>(), fenix: true),
      Bind.lazyPut(() => InboxRoomController(), fenix: true),
      Bind.lazyPut<InboxRoomService>(() => Get.find<InboxRoomController>(), fenix: true),

      Bind.lazyPut(() => ChamberFirestore(), fenix: true),
      Bind.lazyPut<ChamberRepository>(() => Get.find<ChamberFirestore>(), fenix: true),

      if (!kIsWeb) ...[
        Bind.lazyPut(() => GeoLocatorController(), fenix: true),
        Bind.lazyPut<GeoLocatorService>(() => Get.find<GeoLocatorController>(), fenix: true),
        Bind.lazyPut(() => MapsController(), fenix: true),
        Bind.lazyPut<MapsService>(() => Get.find<MapsController>(), fenix: true),
      ],

      Bind.lazyPut(() => AppHiveController(), fenix: true),
      Bind.lazyPut<AppHiveService>(() => Get.find<AppHiveController>(), fenix: true),

      Bind.lazyPut(() => ReportController(), fenix: true),
      Bind.lazyPut<ReportService>(() => Get.find<ReportController>(), fenix: true),

      Bind.lazyPut(() => InvoiceFirestore(), fenix: true),
      Bind.lazyPut<InvoiceRepository>(() => Get.find<InvoiceFirestore>(), fenix: true),

      Bind.lazyPut(() => SubscriptionController(), fenix: true),
      Bind.lazyPut<SubscriptionService>(() => Get.find<SubscriptionController>(), fenix: true),

      if (!kIsWeb) ...[
        Bind.lazyPut(() => DownloadController(''), fenix: true),
        Bind.lazyPut<DownloadService>(() => Get.find<DownloadController>(), fenix: true),
      ],
    ];
  }

}