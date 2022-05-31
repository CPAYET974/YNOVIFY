import 'package:flutter/material.dart';
import 'package:ynovify/music.dart';
import 'package:just_audio/just_audio.dart';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mou4',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'MOU4'),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _indexList = 0;
  bool _pause = true;
  bool _isInit = false;
  final _player = AudioPlayer();

  List<Music> musicList = [
    Music('Alone', 'Marshmello', 'assets/alone_marshmello.jpg',
        'assets/music_alone_marshmello.mp3'),
    Music('T-Kt', 'Hiroyuki Sawano', 'assets/t-kt_hiroyuki_sawano.jpg',
        'assets/music_t-kt_hiroyuki_sawano.mp3'),
  ];

  @override
  void initState() {
    super.initState();
    _initPlayer();
  }

  Future<void> _initPlayer() async {
    await _player.setAsset(musicList[_indexList].urlSong);
  }

  void _changeIndexList(int newIndex) {
    setState(() {
      _indexList += newIndex;
      if (_indexList < 0) {
        _indexList = 0;
      } else if (_indexList > musicList.length - 1) {
        _indexList = musicList.length - 1;
      } else {
        _initPlayer();
      }
    });
  }

  void _playOrPause() {
    setState(() {
      if (_pause) {
        _pause = false;
        _player.play();
      } else {
        _pause = true;
        _player.pause();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Center(
          child: Text(
            widget.title,
            style: const TextStyle(color: Colors.pinkAccent, fontSize: 41),
          ),
        ),
        backgroundColor: Colors.black,
      ),
      backgroundColor: Colors.black87,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            const SizedBox(
              height: 50,
            ),
            Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(musicList[_indexList].imagePath),
                  fit: BoxFit.fill,
                ),
                color: Colors.black87,
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Text(
              musicList[_indexList].title,
              style: const TextStyle(fontSize: 41, color: Colors.pinkAccent),
            ),
            // const SizedBox(
            //   height: 5,
            // ),
            Text(
              musicList[_indexList].singer,
              style: const TextStyle(fontSize: 21, color: Colors.pinkAccent),
            ),
            StreamBuilder(
                stream: _player.durationStream,
                builder: (context, asyncSnapshot) {
                  final Object? duration = asyncSnapshot.data;
                  return Text(
                    duration.toString(),
                    style:
                        const TextStyle(fontSize: 21, color: Colors.pinkAccent),
                  );
                }),
            const SizedBox(height: 25),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                    onPressed: () => _changeIndexList(-1),
                    child: const Icon(
                      Icons.skip_previous,
                      color: Colors.pinkAccent,
                      size: 70,
                    )),
                TextButton(
                  onPressed: () => _playOrPause(),
                  child: _pause
                      ? const Icon(
                          Icons.play_arrow,
                          color: Colors.pinkAccent,
                          size: 70,
                        )
                      : const Icon(
                          Icons.pause,
                          color: Colors.pinkAccent,
                          size: 70,
                        ),
                ),
                TextButton(
                    onPressed: () => _changeIndexList(1),
                    child: const Icon(
                      Icons.skip_next,
                      color: Colors.pinkAccent,
                      size: 70,
                    )),
              ],
            )
          ],
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
