
import 'dart:io';

import 'package:cyberneom/utils/neom-app-theme.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

class FullScreenMedia extends StatelessWidget {
  final String? mediaUrl;
  FullScreenMedia({this.mediaUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        child: Center(
          child: Hero(
            tag: 'imageHero_$mediaUrl',
            child: CachedNetworkImage(imageUrl: mediaUrl!,)
            ),
        ),
        onTap: () {
          Get.back();
        },
      ),
    );
  }
}

cachedNetworkImage(mediaUrl) {
  return GestureDetector(
    child: Hero(
      tag: 'imageHero_$mediaUrl',
      child: CachedNetworkImage(
        imageUrl: mediaUrl,
        fit: BoxFit.fitHeight,
        //placeholder: (context,url)=>  CircularProgressIndicator(),
        errorWidget: (context,url,error)=>Icon(
          Icons.error,
        ),
      ),
    ),
    onTap: () => Get.to(FullScreenMedia(mediaUrl: mediaUrl,)),
  );
}


fileImage(mediaUrl) {
  return GestureDetector(
    child: Hero(
      tag: 'imageHero_$mediaUrl',
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: FileImage(File(mediaUrl)),
            fit: BoxFit.cover,
          ),
        ),
      ),
    ),
    onTap: () => Get.to(FullScreenStoragedMedia(mediaUrl: mediaUrl,)),
  );
}

cachedNetworkThumbnail(thumbnailUrl, mediaUrl) {
  return GestureDetector(
    child: Hero(
      tag: 'thumbnail_$thumbnailUrl',
      child:CachedNetworkImage(
        imageUrl: thumbnailUrl,
        fit: BoxFit.cover,
        errorWidget: (context,url,error)=>Icon(
          Icons.error,
        ),
      ),
    ),
    onTap: () => Get.to(FullScreenVideo(thumbnailUrl: thumbnailUrl, mediaUrl: mediaUrl,)),
  );
}

class FullScreenStoragedMedia extends StatelessWidget {
  final String mediaUrl;
  FullScreenStoragedMedia({required this.mediaUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        child: Center(
          child: Hero(
              tag: 'imageHero_$mediaUrl',
              child: Image.file(File(mediaUrl)),
          ),
        ),
        onTap: () {
          Get.back();
        },
      ),
    );
  }
}

class FullScreenVideo extends StatefulWidget {
  final String? thumbnailUrl;
  final String? mediaUrl;
  FullScreenVideo({this.thumbnailUrl, this.mediaUrl});

  @override
  _FullScreenVideo createState() => _FullScreenVideo();
}

class _FullScreenVideo extends State<FullScreenVideo> {

  late VideoPlayerController _controller;
  late Future<void> _initializeVideoPlayerFuture;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(decoration: NeomAppTheme.neomBoxDecoration,
        child: GestureDetector(
        child: Center(
          child: Hero(
              tag: 'thumbnail_${widget.thumbnailUrl}',
              child: FutureBuilder(
                future: _initializeVideoPlayerFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    // If the VideoPlayerController has finished initialization, use
                    // the data it provides to limit the aspect ratio of the VideoPlayer.
                    return AspectRatio(
                      aspectRatio: _controller.value.aspectRatio,
                      // Use the VideoPlayer widget to display the video.
                      child: VideoPlayer(_controller),
                    );
                  } else {
                    // If the VideoPlayerController is still initializing, show a
                    // loading spinner.
                    return Container(child: Stack(
                        children: [
                          Center(child: CachedNetworkImage(
                              imageUrl: widget.thumbnailUrl!
                          ),),
                          Center(child: CircularProgressIndicator(),),
                        ]
                    ),);
                  }
                },
              )
          ),
        ),
        onTap: () {
          Get.back();
        },
      ),),
    );
  }

  @override
  void initState() {
    _controller = VideoPlayerController.network(widget.mediaUrl!);
    _initializeVideoPlayerFuture = _controller.initialize();
    _controller.play();
    super.initState();
  }

  @override
  void dispose() {
    // Ensure disposing of the VideoPlayerController to free up resources.
    _controller.dispose();
    super.dispose();
  }

}


