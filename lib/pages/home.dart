import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final assetsAudioPlayer = AssetsAudioPlayer();

  @override
  void initState() {
    initplyer();
    super.initState();
  }

  void initplyer() async {
    await assetsAudioPlayer.open(
        Playlist(audios: [
          Audio('assets/song1.mp3', metas: Metas(title: "Song 1")),
          Audio('assets/song2.mp3', metas: Metas(title: "Song 2")),
          Audio('assets/song3.mp3', metas: Metas(title: "Song 3")),
        ]),
        autoStart: false);

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 16, 3, 139),
                borderRadius: BorderRadius.circular(20),
              ),
              height: 400,
              width: 400,
              child: StreamBuilder(
                  stream: assetsAudioPlayer.realtimePlayingInfos,
                  builder: (context, snapShots) {
                    if (snapShots.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            assetsAudioPlayer.getCurrentAudioTitle == " "
                                ? 'Please play your song'
                                : assetsAudioPlayer.getCurrentAudioTitle,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 25),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              IconButton(
                                onPressed: snapShots.data?.current?.index == 0
                                    ? null
                                    : () {
                                        assetsAudioPlayer.previous();
                                      },
                                icon: Icon(Icons.skip_previous),
                              ),
                              getBtnWidget,
                              IconButton(
                                onPressed: snapShots.data?.current?.index ==
                                        (assetsAudioPlayer
                                                    .playlist?.audios.length ??
                                                0) -
                                            1
                                    ? null
                                    : () {
                                        assetsAudioPlayer.next();
                                      },
                                icon: Icon(Icons.skip_next),
                              ),
                            ],
                          ),
                          Slider(
                              value: snapShots.data?.currentPosition.inSeconds
                                      .toDouble() ??
                                  0,
                              min: 0,
                              max: snapShots.data?.duration.inSeconds
                                      .toDouble() ??
                                  0,
                              onChanged: (value) {}),
                          SizedBox(height: 20),
                          Text(
                            " ${convertSecond(snapShots.data?.currentPosition.inSeconds ?? 0)} / ${convertSecond(snapShots.data?.duration.inSeconds ?? 0)}",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 17,
                                fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                    );
                  }),
            )
          ],
        ),
      ),
    );
  }

  String convertSecond(int second) {
    String minutes = (second ~/ 60).toString();
    String secondsStr = (second % 60).toString();
    return '${minutes.padLeft(2, '0')} : ${secondsStr.padLeft(2, '0')}';
  }

  Widget get getBtnWidget =>
      assetsAudioPlayer.builderIsPlaying(builder: (ctx, isPlaying) {
        return FloatingActionButton.large(
          child: Icon(
            color: Colors.white,
            size: 70,
            isPlaying ? Icons.pause : Icons.play_arrow,
          ),
          onPressed: () {
            if (isPlaying) {
              assetsAudioPlayer.pause();
            } else {
              assetsAudioPlayer.play();
            }

            setState(() {});
          },
          shape: CircleBorder(),
        );
      });
}
