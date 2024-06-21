import 'package:appinio_video_player/appinio_video_player.dart';
import 'package:emploiflutter/ui/utils/extension/context_extension.dart';
import 'package:emploiflutter/ui/utils/theme/app_color.dart';
import 'package:emploiflutter/ui/utils/theme/theme.dart';
import 'package:flutter/services.dart';

import '../theme/text_styles.dart';

class PlayVideoScreen extends StatefulWidget {
  final String path;

  const PlayVideoScreen({super.key, required this.path});

  @override
  State<PlayVideoScreen> createState() => _PlayVideoScreenState();
}

class _PlayVideoScreenState extends State<PlayVideoScreen> {
  late VideoPlayerController videoPlayerController;
  late CustomVideoPlayerController _customVideoPlayerController;

  // late VideoPlayerController _controller;
  bool isPlay = false;

  @override
  void initState() {
    super.initState();
    print("Path of file is =====================================> ${widget.path}");
    videoPlayerController = VideoPlayerController.network("https://api.emploihunt.com${widget.path}")
      ..initialize().then((value) => setState(() {}));
    _customVideoPlayerController = CustomVideoPlayerController(
      customVideoPlayerSettings: CustomVideoPlayerSettings(
        showFullscreenButton: false,
          systemUIModeAfterFullscreen: SystemUiMode.immersiveSticky),
      context: context,
      videoPlayerController: videoPlayerController,
    );
  }

  @override
  void dispose() {
    _customVideoPlayerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          leading: GestureDetector(
              onTap: (){
                context.pop();
              },
              child: Icon(Icons.arrow_back,color: Colors.white,)),
          backgroundColor: Colors.black,
          title: Text("Video Resume",style: TextStyles.w400.copyWith(fontSize: 16.sp,color: AppColors.colors.whiteColors),),
          centerTitle: true,
        ),
        body: SafeArea(
          child: Stack(
            children: [
              _customVideoPlayerController.videoPlayerController.value.isInitialized
                  ? Align(
                    alignment: Alignment.center,
                    child: CustomVideoPlayer(
                        customVideoPlayerController: _customVideoPlayerController),
                  )
                  : Container(),
              !_customVideoPlayerController.videoPlayerController.value.isInitialized
                  ? Align(
                    alignment: Alignment.center,
                    child: CircularProgressIndicator())
                  : Container(),
            ],
          ),
        ),
      ),
    );
  }

}
/*   @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
            _controller.value.isInitialized
                ? AspectRatio(
              aspectRatio: _controller.value.aspectRatio,
              child: VideoPlayer(_controller),
            )
                : Container(),
            !_controller.value.isInitialized
                ? CircularProgressIndicator()
                : Container(),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          isPlay ? _controller.pause() : _controller.play();
        },
        child: Icon(
          isPlay && !_controller.value.isBuffering ? Icons.pause : Icons.play_arrow,
        ),
      ),
    );
  }

 */