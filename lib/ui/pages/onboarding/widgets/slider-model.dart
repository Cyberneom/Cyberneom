import 'package:cyberneom/utils/constants/neom-assets.dart';
import 'package:cyberneom/utils/constants/neom-translation-constants.dart';
import 'package:get/get.dart';

class SliderModel{
  String imagePath;
  String title;
  String msg1;
  String msg2;

  SliderModel(this.imagePath, this.title, this.msg1, {this.msg2 = ""});


  static List<SliderModel> getRequiredPermissionsSlides(){
    List<SliderModel> slides = [];
    SliderModel s1 = new SliderModel(NeomAssets.logo,
        NeomTranslationConstants.locationRequiredTitle.tr, NeomTranslationConstants.locationRequiredMsg1.tr,
        msg2: NeomTranslationConstants.locationRequiredMsg2.tr);
    slides.add(s1);

    return slides;
  }

}