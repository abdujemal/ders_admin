// ignore_for_file: public_member_api_docs
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:ders_admin/constants.dart';
import 'package:ders_admin/main.dart';

class AudioItem extends ConsumerStatefulWidget {
  final String id;
  final String title;
  final bool isThisAudioPlaying;
  final VoidCallback onPlayTab;
  final void Function(String url) onLoaded;
  const AudioItem({
    super.key,
    required this.id,
    required this.title,
    required this.isThisAudioPlaying,
    required this.onPlayTab,
    required this.onLoaded,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AudioItemState();
}

class _AudioItemState extends ConsumerState<AudioItem> {
  AudioState audioState = AudioState.idle;
  bool isLoading = false;
  late String url;
  late String name;

  @override
  void initState() {
    super.initState();

    url = widget.id.split(":-").last;
    name = widget.id.split(":-").first;
    print(url);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(),
        ),
      ),
      child: ListTile(
        leading: IconButton(
          icon: audioState == AudioState.playing && widget.isThisAudioPlaying
              ? const Icon(Icons.pause)
              : const Icon(Icons.play_arrow),
          onPressed: () async {
            // if (audioState == AudioState.playing && widget.isThisAudioPlaying) {
            //   audioState = AudioState.paused;
            //   setState(() {});
            //   player.pause();
            //   return;
            // }
            // if (audioState == AudioState.paused && widget.isThisAudioPlaying) {
            //   audioState = AudioState.playing;
            //   setState(() {});
            //   player.resume();
            //   return;
            // }
            // setState(() {
            //   isLoading = true;
            // });
            // // String? url = await ;
            // if (url != null) {
            //   await player.play(UrlSource(url!)).catchError((e) {
            //     audioState == AudioState.idle;
            //     isLoading = false;
            //     setState(() {});
            //     Fluttertoast.showToast(msg: e.toString());
            //   });
            //   widget.onPlayTab();
            //   setState(() {
            //     isLoading = false;
            //     audioState = AudioState.playing;
            //   });
            // } else {
            //   setState(() {
            //     isLoading = false;
            //     audioState = AudioState.idle;
            //   });
            // }
          },
        ),
        trailing: const Icon(Icons.stop),
        title: Text(name),
      ),
    );
  }
}
