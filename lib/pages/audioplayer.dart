import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';

class AudioPlayerPage extends StatefulWidget {
  final Audio audio;
  const AudioPlayerPage({super.key, required this.audio});

  @override
  State<AudioPlayerPage> createState() => _AudioPlayerPageState();
}

class _AudioPlayerPageState extends State<AudioPlayerPage> {
  final assetsAudioPlayer = AssetsAudioPlayer();
  int changeValue = 0;
  double changeVolume = 0.0;
  double changeSpeed = 0.0;
  IconData? icon = Icons.volume_up;
  Color? color = Colors.white;

  @override
  void initState() {
    initplyer();
    super.initState();
  }

  void initplyer() async {
    await assetsAudioPlayer.open(widget.audio, autoStart: false);
    assetsAudioPlayer.currentPosition.listen((event) {
      changeValue = event.inSeconds;
    });

    assetsAudioPlayer.volume.listen((event) {
      changeVolume = event;
    });

    assetsAudioPlayer.playSpeed.listen((event) {
      changeSpeed = event;
    });

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.audio.metas.title ?? 'no title'),
      ),
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/music5.jpg'), fit: BoxFit.fill)),
        child: Column(
          children: [
            SizedBox(height: 30),
            Row(
              children: [
                SizedBox(width: 100),
                CircleAvatar(
                  backgroundImage: AssetImage('assets/music6.jpg'),
                  radius: 120,
                ),
                SizedBox(width: 40),
                Column(
                  children: [
                    IconButton(
                      onPressed: () {
                        selectSpeed();
                        setState(() {});
                      },
                      icon: Icon(
                        Icons.speed,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      'speed:$changeSpeed',
                      style: TextStyle(fontSize: 12, color: Colors.white),
                    ),
                    IconButton(
                      onPressed: () {
                        selectVolume();
                        setState(() {});
                      },
                      icon: Icon(
                        icon,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      'volum:$changeVolume',
                      style: TextStyle(fontSize: 12, color: Colors.white),
                    ),
                    IconButton(
                      onPressed: () {
                        if (color == Colors.white) {
                          color = Colors.red;
                        } else {
                          color = Colors.white;
                        }
                        setState(() {});
                      },
                      icon: Icon(
                        Icons.favorite,
                        color: color,
                      ),
                    ),
                    Text(
                      'Add to Favorite',
                      style: TextStyle(fontSize: 12, color: Colors.white),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 50),
            Container(
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
                                fontSize: 16,
                                fontWeight: FontWeight.w500),
                          ),
                          SizedBox(height: 10),
                          Slider(
                            value: changeValue.toDouble(),
                            min: 0,
                            max:
                                snapShots.data?.duration.inSeconds.toDouble() ??
                                    0.0,
                            onChanged: (value) {
                              setState(() {
                                changeValue = value.toInt();
                              });
                            },
                            onChangeEnd: (value) async {
                              await assetsAudioPlayer
                                  .seek(Duration(seconds: value.toInt()));
                            },
                          ),
                          SizedBox(height: 5),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(width: 50),
                              IconButton(
                                onPressed: snapShots.data?.current?.index == 0
                                    ? null
                                    : () {
                                        assetsAudioPlayer.previous();
                                      },
                                icon: Icon(
                                  Icons.skip_previous,
                                  color: Color.fromARGB(240, 104, 2, 145),
                                  size: 30,
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  changeValue = changeValue + 10;
                                  setState(() {});
                                },
                                icon: Icon(
                                  Icons.forward_10,
                                  color: Colors.white,
                                ),
                              ),
                              getBtnWidget,
                              IconButton(
                                onPressed: () {
                                  changeValue = changeValue - 10;
                                  setState(() {});
                                },
                                icon: Icon(
                                  Icons.replay_10,
                                  color: Colors.white,
                                ),
                              ),
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
                                icon: Icon(
                                  Icons.skip_next,
                                  color: Color.fromARGB(240, 104, 2, 145),
                                  size: 30,
                                ),
                              ),
                              SizedBox(width: 50),
                            ],
                          ),
                          SizedBox(height: 5),
                          Text(
                            " ${convertSecond(changeValue)} / ${convertSecond(snapShots.data?.duration.inSeconds ?? 0)}",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w500),
                          )
                        ],
                      ),
                    );
                  }),
            ),
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
        return FloatingActionButton(
          child: Icon(
            color: Colors.white,
            size: 30,
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

  void selectSpeed() async {
    await showDialog(
        context: context,
        builder: (
          context,
        ) {
          return Dialog(
              backgroundColor: Colors.black,
              child: Container(
                height: 200,
                width: 200,
                child: Column(
                  children: [
                    Text(
                      'Speed',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                      ),
                    ),
                    TextButton(
                        onPressed: () {
                          changeSpeed = 1;
                          //setStateEx(() {});
                        },
                        child: Text('1x')),
                    TextButton(
                        onPressed: () {
                          changeSpeed = 2;

                          //setStateEx(() {});
                        },
                        child: Text('2x')),
                    TextButton(
                        onPressed: () {
                          changeSpeed = 3;
                          //setStateEx(() {});
                        },
                        child: Text('3x')),
                    SizedBox(height: 30),
                    TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                          assetsAudioPlayer.setPlaySpeed(changeSpeed);
                        },
                        child: Text(
                          'back',
                          style: TextStyle(color: Colors.white, fontSize: 17),
                        ))
                  ],
                ),
              ));
        });
  }

  void selectVolume() async {
    await showDialog(
        context: context,
        builder: (
          context,
        ) {
          return StatefulBuilder(builder: (context, setStateEx) {
            return Dialog(
                backgroundColor: Colors.black,
                child: Container(
                  height: 200,
                  width: 200,
                  child: Column(
                    children: [
                      Text(
                        'Volum',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                        ),
                      ),
                      TextButton(
                          onPressed: () {
                            changeVolume = 0;
                            icon = Icons.volume_off;
                            setStateEx(() {});
                          },
                          child: Text('0x')),
                      TextButton(
                          onPressed: () {
                            changeVolume = .5;
                            icon = Icons.volume_up;
                            setStateEx(() {});
                          },
                          child: Text('.5x')),
                      TextButton(
                          onPressed: () {
                            changeVolume = 1;
                            icon = Icons.volume_up;
                            setStateEx(() {});
                          },
                          child: Text('1x')),
                      SizedBox(height: 30),
                      TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                            assetsAudioPlayer.setVolume(changeVolume);
                          },
                          child: Text(
                            'back',
                            style: TextStyle(color: Colors.white, fontSize: 17),
                          ))
                    ],
                  ),
                ));
          });
        });
  }
}
