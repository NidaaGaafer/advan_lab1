import 'package:advan_lab1/pages/audioplayer.dart';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';

class AllMusicPage extends StatefulWidget {
  const AllMusicPage({super.key});

  @override
  State<AllMusicPage> createState() => _AllMusicPageState();
}

class _AllMusicPageState extends State<AllMusicPage> {
  final playList = Playlist(audios: [
    Audio('assets/song1.mp3', metas: Metas(title: "Song 1")),
    Audio('assets/song2.mp3', metas: Metas(title: "Song 2")),
    Audio('assets/song3.mp3', metas: Metas(title: "Song 3")),
  ]);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('All Music'),
      ),
      body: Container(
        color: Color.fromARGB(255, 25, 1, 90),
        child: ListView(
          children: [
            for (var music in playList.audios)
              ListTile(
                trailing: IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.more_horiz, color: Colors.white)),
                title: TextButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (ctx) => AudioPlayerPage(
                                    audio: music,
                                  )));
                    },
                    child: Text(
                      music.metas.title ?? 'No Title',
                      style: TextStyle(color: Colors.white),
                    )),
              ),
          ],
        ),
      ),
    );
  }
}
