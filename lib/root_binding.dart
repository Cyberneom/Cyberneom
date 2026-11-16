import 'dart:async';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart' show Icons;
import 'package:neom_cloud/neom_cloud.dart';
import 'package:neom_core/domain/use_cases/cloud_drive_service.dart';
import 'package:neom_core/domain/use_cases/cloud_email_service.dart';
import 'package:neom_core/domain/use_cases/google_auth_service.dart';
import 'package:neom_core/domain/use_cases/google_calendar_sync_service.dart';
import 'package:neom_core/domain/use_cases/release_upload_service.dart';
import 'package:neom_generator/data/implementations/harmonic/harmonic_footprint_controller.dart';
import 'package:neom_generator/domain/use_cases/neom_generator_service.dart';
import 'package:neom_releases/ui/release_upload_controller.dart';
import 'package:sint/sint.dart';

import 'package:neom_eeg/data/hub/eeg_hub.dart';
import 'package:neom_eeg/data/implementations/eeg_calibration_controller.dart';
import 'package:neom_eeg/data/implementations/eeg_connection_controller.dart';
import 'package:neom_eeg/data/implementations/eeg_neurofeedback_controller.dart';
import 'package:neom_eeg/data/implementations/eeg_session_capture_controller.dart';
import 'package:neom_eeg/data/implementations/eeg_watch_controller.dart';
import 'package:neom_core/domain/use_cases/neuro_state_service.dart';
import 'package:neom_eeg/data/implementations/eeg_neuro_state_adapter.dart';
import 'package:neom_eeg/domain/models/emotiv_cortex_config.dart';
import 'package:neom_eeg/ui/widgets/eeg_live_dashboard.dart';
import 'package:neom_generator/domain/use_cases/chamber_neuro_panel.dart';
import 'eeg/cyberneom_eeg_practice_bridge.dart';
import 'package:neom_analytics/data/firestore/analytics_firestore.dart';
import 'package:neom_audio_player/audio_player_invoker.dart';
import 'package:neom_creator_analytics/data/implementations/creator_analytics_controller.dart';
import 'package:neom_creator_analytics/domain/use_cases/creator_analytics_service.dart';
import 'package:neom_rooms/data/implementations/live_host_controller.dart';
import 'package:neom_rooms/data/implementations/live_listener_controller.dart';
import 'package:neom_sound/data/implementations/equalizer_controller.dart';
import 'package:neom_sound/domain/use_cases/equalizer_service.dart';
import 'package:neom_audio_player/data/implementations/audio_lite_player_controller.dart';
import 'package:neom_audio_player/data/providers/neom_audio_provider.dart';
import 'package:neom_audio_player/neom_audio_handler.dart';
import 'package:neom_audio_player/data/implementations/enhanced_playback_controller.dart';
import 'package:neom_audio_player/domain/use_cases/enhanced_playback_service.dart';
import 'package:neom_audio_platform/neom_audio_platform.dart';
import 'package:neom_audio_player/ui/player/miniplayer_controller.dart';
import 'package:neom_auth/ui/login/login_controller.dart';
import 'package:neom_auth/ui/login/google_auth_controller.dart';

import 'package:neom_collectives/ui/collective_controller.dart';
import 'package:neom_collectives/ui/details/collective_details_controller.dart';
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
import 'package:neom_core/domain/use_cases/collective_details_service.dart';
import 'package:neom_core/domain/use_cases/collective_service.dart';
import 'package:neom_core/domain/use_cases/bank_service.dart';
import 'package:neom_core/domain/use_cases/camera_service.dart';
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
import 'package:neom_core/domain/use_cases/qr_scanner_service.dart';
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
// neom_downloads uses dart:io directly — excluded from web compilation
// import 'package:neom_downloads/data/implementations/download_controller.dart';
import 'package:neom_events/ui/event_details_controller.dart';
import 'package:neom_generator/data/firestore/chamber_firestore.dart';
import 'package:neom_generator/ui/neom_generator_controller.dart';
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
import 'package:neom_scanner/neom_scanner.dart' show MobileQrScannerService;
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
    // Registers all neom_audio_platform controllers (Jam, Radio, SmartQueue,
    // ListeningStats, PlaylistGenerator) as eager singletons.
    AudioPlatformBinding.dependencies();

    return <Bind>[
      Bind.putContract<UserService, UserController>(UserController(), permanent: true),
      Bind.putContract<LoginService, LoginController>(LoginController(), permanent: true),
      Bind.putContract<NeomGeneratorService, NeomGeneratorController>(NeomGeneratorController(), permanent: true),

      Bind.contract<HomeService, HomeController>(() => HomeController(), fenix: true),
      Bind.contract<TimelineService, TimelineController>(() => TimelineController(), fenix: true),

      Bind.contract<AudioPlayerInvokerService, AudioPlayerInvoker>(() => AudioPlayerInvoker(), fenix: true),
      Bind.contract<AudioHandlerService, NeomAudioHandler>(() => NeomAudioProvider.audioHandler!, fenix: true),
      Bind.contract<EnhancedPlaybackService, EnhancedPlaybackController>(() => EnhancedPlaybackController(), fenix: true),
      Bind.contract<MiniPlayerService, MiniPlayerController>(() => MiniPlayerController(), fenix: true),
      Bind.lazyPut(() => AudioPlayerHomeController()),
      Bind.contract<AudioLitePlayerService, AudioLitePlayerController>(() => AudioLitePlayerController(), fenix: true),

      Bind.lazyPut<EventDetailsService?>(() => Sint.isRegistered<EventDetailsController>()
          ? Sint.find<EventDetailsController>() : null, fenix: true),
      Bind.lazyPut<QrScannerService>(() => const MobileQrScannerService(), fenix: true),

      Bind.contract<ItemlistService, ItemlistController>(() => ItemlistController(), fenix: true),
      Bind.contract<SearchService, AppSearchController>(() => AppSearchController(), fenix: true),
      Bind.contract<PostDetailsService, PostDetailsController>(() => PostDetailsController(), fenix: true),

      Bind.contract<PostUploadService, PostUploadController>(() => PostUploadController(), fenix: true),
      if (!kIsWeb) ...[
        Bind.contract<AppCameraService, AppCameraController>(() => AppCameraController(), fenix: true),
        Bind.contract<ImageEditorService, ImageEditorController>(() => ImageEditorController(), fenix: true),
        Bind.contract<MediaUploadService, MediaUploadController>(() => MediaUploadController(), fenix: true),
        Bind.contract<MediaPlayerService, MediaPlayerController>(() => MediaPlayerController(), fenix: true),
      ],
      if (kIsWeb) ...[
        Bind.contract<MediaUploadService, MediaUploadWebController>(() => MediaUploadWebController(), fenix: true),
      ],

      Bind.lazyPut<AnalyticsRepository>(() => AnalyticsFirestore(), fenix: true),
      Bind.lazyPut<JobRepository>(() => JobFirestore()),

      Bind.contract<AppDrawerService, AppDrawerController>(() => AppDrawerController(), fenix: true),
      Bind.contract<SettingsService, SettingsController>(() => SettingsController(), fenix: true),
      Bind.contract<ProfileService, ProfileController>(() => ProfileController(), fenix: true),
      Bind.contract<MateService, MateController>(() => MateController(), fenix: true),

      if (!kIsWeb) ...[
        Bind.contract<NotificationService, PushNotificationInvoker>(() => PushNotificationInvoker(), fenix: true),
      ],

      Bind.contract<CollectiveService, CollectiveController>(() => CollectiveController(), fenix: true),
      Bind.contract<CollectiveDetailsService, CollectiveDetailsController>(() => CollectiveDetailsController(), fenix: true),

      Bind.contract<BankService, BankController>(() => BankController(), fenix: true),
      Bind.contract<WalletRepository, WalletFirestore>(() => WalletFirestore(), fenix: true),
      Bind.contract<WooMediaService, WooMediaAPI>(() => WooMediaAPI(), fenix: true),
      Bind.contract<WooGatewayService, WooGatewayController>(() => WooGatewayController(), fenix: true),
      Bind.contract<StripeGatewayService, StripeGatewayController>(() => StripeGatewayController(), fenix: true),
      Bind.contract<StripeApiService, StripeApiController>(() => StripeApiController(), fenix: true),

      // Google Cloud — Calendar, Drive, Gmail
      Bind.contract<GoogleAuthService, GoogleAuthController>(() => GoogleAuthController(), fenix: true),
      Bind.contract<GoogleCalendarSyncService, GoogleCalendarController>(
        () => GoogleCalendarController(Sint.find<GoogleAuthService>()),
        fenix: true,
      ),
      Bind.contract<CloudDriveService, GoogleDriveController>(
        () => GoogleDriveController(Sint.find<GoogleAuthService>()),
        fenix: true,
      ),
      Bind.contract<CloudEmailService, GoogleGmailController>(
        () => GoogleGmailController(Sint.find<GoogleAuthService>()),
        fenix: true,
      ),

      Bind.contract<InstrumentService, InstrumentController>(() => InstrumentController(), fenix: true),
      Bind.contract<GenreService, GenreController>(() => GenreController(), fenix: true),
      Bind.contract<ProfileInstrumentsRepository, ProfileInstrumentsFirestore>(() => ProfileInstrumentsFirestore(), fenix: true),

      Bind.contract<InboxService, InboxController>(() => InboxController(), fenix: true),
      Bind.contract<InboxRoomService, InboxRoomController>(() => InboxRoomController(), fenix: true),

      Bind.contract<ChamberRepository, ChamberFirestore>(() => ChamberFirestore(), fenix: true),

      if (!kIsWeb) ...[
        Bind.contract<GeoLocatorService, GeoLocatorController>(() => GeoLocatorController(), fenix: true),
        Bind.contract<MapsService, MapsController>(() => MapsController(), fenix: true),
      ],

      Bind.contract<AppHiveService, AppHiveController>(() => AppHiveController(), fenix: true),

      Bind.contract<ReportService, ReportController>(() => ReportController(), fenix: true),

      Bind.contract<InvoiceRepository, InvoiceFirestore>(() => InvoiceFirestore(), fenix: true),

      Bind.contract<SubscriptionService, SubscriptionController>(() => SubscriptionController(), fenix: true),

      Bind.contract<EqualizerService, EqualizerController>(() => EqualizerController(), fenix: true),

      Bind.contract<CreatorAnalyticsService, CreatorAnalyticsController>(() => CreatorAnalyticsController(), fenix: true),

      Bind.lazyPut(() => LiveHostController(), fenix: true),
      Bind.lazyPut(() => LiveListenerController(), fenix: true),

      Bind.contract<ReleaseUploadService, ReleaseUploadController>(() => ReleaseUploadController(), fenix: true),

      // Huella Armónica — voice-based personal frequency identity
      Bind.lazyPut(() => HarmonicFootprintController(), fenix: true),

      // EEG — one hub for every headset. The hub routes connect() by the
      // device model: Emotiv (EPOC X / Insight / MN8 / Flex) through Cortex
      // when `emotivClientId`/`emotivClientSecret` are set in properties.json,
      // Muse over BLE, and the simulator in debug builds. Adding a vendor is
      // a driver registration here, not a code path in the app.
      Bind.lazyPut(() {
        late final EegConnectionController controller;
        final hub = EegHub.standard(
          emotiv: EmotivCortexConfig.fromAppProperties(),
          onEmotivAccessPending: (msg) => controller.reportPending(msg),
        );
        controller = EegConnectionController(provider: hub);
        return controller;
      }, fenix: true),
      Bind.lazyPut(() => EegNeurofeedbackController(
        deviceService: Sint.find<EegConnectionController>().provider,
      ), fenix: true),
      // Personal baseline (eyes open / eyes closed) per profile and headset
      // model, and the watcher that turns it into alerts and automatic
      // markers (sustained T7/T8 asymmetry, beta over rest, hypofrontality,
      // lost contact). Both are opt-in for the EEG dashboard: registering
      // them here is what makes their panels appear.
      Bind.lazyPut(() => EegCalibrationController(
        hub: Sint.find<EegConnectionController>().hub!,
        subjectId: () {
          final id = Sint.find<UserController>().profile.id;
          return id.isEmpty ? null : id;
        },
      ), fenix: true),
      Bind.lazyPut(() => EegWatchController(
        hub: Sint.find<EegConnectionController>().hub!,
        calibration: () => Sint.find<EegCalibrationController>().current.value,
        capture: () => Sint.isRegistered<EegSessionCaptureController>()
            ? Sint.find<EegSessionCaptureController>()
            : null,
      ), fenix: true),
      // Publishes the headset as the ecosystem's NeuroStateService (neom_core
      // contract, no neom_eeg import on the consumer side). Its consumer is
      // the experiences HUD, which shows the measured state while a headset
      // streams. Started on creation: the adapter only reads the hub once
      // started. The Cámara Neom does not read it — it stays untouched, and
      // its hemispheric meter keeps measuring the audio.
      Bind.lazyPut<NeuroStateService>(() {
        final adapter = EegNeuroStateAdapter(
          deviceService: Sint.find<EegConnectionController>().provider,
        );
        unawaited(adapter.start());
        return adapter;
      }, fenix: true),
      // Cámara Neom "Modo EEG": the chamber gets a neuro layout with the EEG
      // dashboard in the centre. The chamber only knows ChamberNeuroPanel;
      // which headset feeds it is the hub's business, so any model works.
      Bind.put<ChamberNeuroPanel>(ChamberNeuroPanel(
        id: 'eeg',
        icon: Icons.psychology,
        builder: (_) => const EegLiveDashboard(compact: true),
        statusLine: () {
          if (!Sint.isRegistered<EegConnectionController>()) return null;
          final eeg = Sint.find<EegConnectionController>();
          final device = eeg.connectedDevice.value;
          if (device == null) return 'Sin headset';
          final poor = eeg.status.value?.poorContacts().length ?? 0;
          return '${device.type.displayName} · '
              '${device.channels.length - poor}/${device.channels.length} sensores';
        },
      ), permanent: true),
      // Cuts the EEG live buffer into per-practice captures (frequencies,
      // voice, markers, bands, coherence) by observing the chamber's public
      // reactive state. Must come after both controllers above.
      Bind.put(CyberneomEegPracticeBridge(), permanent: true),
    ];
  }

}