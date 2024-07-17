import 'package:advan_lab1/pages/allmusic.dart';
import 'package:advan_lab1/widget/musicitem.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Music'),
      ),
      body: Container(
        padding: EdgeInsetsDirectional.all(5),
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/music3.jpg"), fit: BoxFit.fill)),
        child: Column(
          children: [
            SizedBox(height: 20),
            Expanded(
              flex: 2,
              child: Container(
                  child: GridView.count(
                crossAxisCount: 3,
                mainAxisSpacing: 5,
                crossAxisSpacing: 5,
                children: [
                  MusicCard(
                    color: Color.fromARGB(255, 25, 1, 90).withOpacity(.8),
                    icon: Icons.music_note_outlined,
                    label: 'All Music',
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (ctx) => AllMusicPage()));
                    },
                  ),
                  MusicCard(
                    color: Color.fromARGB(255, 104, 2, 49).withOpacity(.8),
                    icon: Icons.playlist_play,
                    label: 'Playlist',
                    onPressed: () {},
                  ),
                  MusicCard(
                    color: Color.fromARGB(255, 168, 13, 2).withOpacity(.8),
                    icon: Icons.favorite,
                    label: 'Favorites',
                    onPressed: () {},
                  ),
                  MusicCard(
                    color: Color.fromARGB(255, 158, 95, 2).withOpacity(.8),
                    icon: Icons.folder,
                    label: 'Folders',
                    onPressed: () {},
                  ),
                ],
              )),
            ),
            SizedBox(height: 5),
            Expanded(
              child: Container(
                color: Color.fromARGB(0, 14, 1, 71).withOpacity(.6),
                child: Column(
                  //crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.all(5),
                      child: Row(
                        children: [
                          Icon(
                            Icons.queue_music,
                            color: Colors.white,
                            size: 30,
                          ),
                          SizedBox(width: 5),
                          Text(
                            'Recent Play',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
