import 'package:flutter/material.dart';
import 'package:panorama/panorama.dart';
import 'package:split_view/split_view.dart';


class PanoramaView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
      child:
      SplitView(
        viewMode: SplitViewMode.Vertical,
        activeIndicator: SplitIndicator(
          viewMode: SplitViewMode.Vertical,
          isActive: true,
        ),
        children: [
          Panorama(
            child: Image.network('https://image.shutterstock.com/z/stock-photo-connection-lines-around-earth-globe-futuristic-technology-theme-background-with-light-effect-d-549340267.jpg'),
          ),
          Panorama(
            child: Image.network('https://image.shutterstock.com/z/stock-photo-connection-lines-around-earth-globe-futuristic-technology-theme-background-with-light-effect-d-549340267.jpg'),
          ),
        ],
        onWeightChanged: (w) => print("Horizon: $w"),
        controller: SplitViewController(limits: [null, WeightLimit(max: 0.5)]),
      ),
      ),
    );
  }
}
