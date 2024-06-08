// ignore_for_file: library_private_types_in_public_api

import 'dart:math';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:audioplayers/audioplayers.dart';

class GradientBackgroundWithAnimation extends StatefulWidget {
  const GradientBackgroundWithAnimation({super.key});

  @override
  _GradientBackgroundState createState() => _GradientBackgroundState();
}

class _GradientBackgroundState extends State<GradientBackgroundWithAnimation> {
  final List<Color> _colors1 = [Colors.deepPurpleAccent, Colors.teal];
  final List<Color> _colors2 = [Colors.pink, Colors.indigo];
  bool _toggle = true;

  final List<List<String>> _relaxationTexts = [
    [
      "Breathe in, breathe out.",
      "Relax your mind.",
      "Feel the calm.",
      "Embrace tranquility.",
      "Let go of stress.",
      "Peaceful thoughts.",
      "Serenity now.",
      "Find your peace.",
      "Calm and collected.",
      "Breathe deeply.",
    ],
    [
      "Quiet your mind.",
      "Relax your body.",
      "Feel the stillness.",
      "Embrace the quiet.",
      "Release tension.",
      "Think peaceful thoughts.",
      "Feel the serenity.",
      "Calm and composed.",
      "Peaceful and relaxed.",
      "Find your center.",
    ],
    [
      "Find your balance.",
      "Stay calm.",
      "Clear your mind.",
      "Tranquility now.",
      "Relax and breathe.",
      "Inner peace.",
      "Calmness and serenity.",
      "Relax and let go.",
      "Feel the calmness.",
      "Relax and unwind.",
    ],
    [
      "Quiet your mind.",
      "Relax your body.",
      "Feel the stillness.",
      "Embrace the quiet.",
      "Release tension.",
      "Think peaceful thoughts.",
      "Feel the serenity.",
      "Calm and composed.",
      "Peaceful and relaxed.",
      "Find your center.",
    ],
    [
      "Quiet your mind.",
      "Relax your body.",
      "Feel the stillness.",
      "Embrace the quiet.",
      "Release tension.",
      "Think peaceful thoughts.",
      "Feel the serenity.",
      "Calm and composed.",
      "Peaceful and relaxed.",
      "Find your center.",
    ],
    [
      "Find your balance.",
      "Stay calm.",
      "Clear your mind.",
      "Tranquility now.",
      "Relax and breathe.",
      "Inner peace.",
      "Calmness and serenity.",
      "Relax and let go.",
      "Feel the calmness.",
      "Relax and unwind.",
    ],
    [
      "Breathe in, breathe out.",
      "Relax your mind.",
      "Feel the calm.",
      "Embrace tranquility.",
      "Let go of stress.",
      "Peaceful thoughts.",
      "Serenity now.",
      "Find your peace.",
      "Calm and collected.",
      "Breathe deeply.",
    ],
  ];

  final List<String> _audioFiles = [
    'audios/CallOfSilence.mp3',
    'audios/MoonlightSonata3rdMvt.mp3',
    'audios/Everytime-We-Touch.mp3',
    'audios/Fantaisie-Impromptu.mp3',
    'audios/Revolutionary-Etude.mp3',
    'audios/Miss-you.mp3',
    'audios/Wonderful-tonight.mp3'
  ];

  final List<String> _songs = [
    'Call of Silence',
    'Moonlight Sonata 3rd Mvt',
    'Everytime We Touch',
    'Fantaisie Impromptu.. Chopin',
    'Revolutionary Etude.. Chopin',
    'Miss you',
    'Wonderful tonight'
  ];

  int _currentAudioIndex = 0;
  String _currentText = "";
  late AudioPlayer _audioPlayer;
  bool _isPlaying = false;
  double _currentSliderValue = 0.0;
  Duration _totalDuration = Duration.zero;
  Duration _currentPosition = Duration.zero;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    _audioPlayer.onDurationChanged.listen((Duration d) {
      setState(() {
        _totalDuration = d;
      });
    });
    _audioPlayer.onPositionChanged.listen((Duration p) {
      setState(() {
        _currentSliderValue = p.inMilliseconds.toDouble();
         _currentPosition = p;
      });
    });

    Timer.periodic(const Duration(seconds: 3), (timer) {
      setState(() {
        _toggle = !_toggle;
        _currentText = _relaxationTexts[_currentAudioIndex][Random().nextInt(10)];
      });
    });

    setState(() {
      _currentText = _relaxationTexts[_currentAudioIndex][Random().nextInt(10)];
    });

    // _playAudio(); // Start playing the first audio file at initialization
  }

  void _playPause() async {
    if (_isPlaying) {
      await _audioPlayer.pause();
    } else {
      await _audioPlayer.play(AssetSource(_audioFiles[_currentAudioIndex]));
    }
    setState(() {
      _isPlaying = !_isPlaying;
    });
  }

  void _next() {
    _currentAudioIndex = (_currentAudioIndex + 1) % _audioFiles.length;
    _playAudio();
  }

  void _previous() {
    _currentAudioIndex = (_currentAudioIndex - 1 + _audioFiles.length) % _audioFiles.length;
    _playAudio();
  }

  void _playAudio() async {
    await _audioPlayer.stop();
    await _audioPlayer.play(AssetSource(_audioFiles[_currentAudioIndex]));
    setState(() {
      _isPlaying = true;
      _currentText = _relaxationTexts[_currentAudioIndex][Random().nextInt(10)];
    });
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  }


  bool _isMenuOpen = false;

  void _toggleMenu() {
    setState(() {
      _isMenuOpen = !_isMenuOpen;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerTop,
      // floatingActionButton: Container(
      //   width: 30,
      //   height: 30,
      //   decoration: BoxDecoration(
      //     color: Colors.black.withOpacity(0.6),
      //     shape: BoxShape.circle
      //   ),
      //   child: Center(
      //     child: Container(
      //       width: 6,
      //       height: 6,
      //       decoration: const BoxDecoration(
      //       color: Colors.white,
      //       shape: BoxShape.circle
      //     ),
      //     ),
      //   ),
      // ),
      body: Stack(
        children: [
          AnimatedContainer(
        duration: const Duration(seconds: 3),
        onEnd: () {
          setState(() {
            _toggle = !_toggle;
            _currentText = _relaxationTexts[_currentAudioIndex][Random().nextInt(10)];
          });
        },
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: _toggle ? _colors1 : _colors2,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                _currentText,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 50),
              Container(
                width: MediaQuery.of(context).size.width - 40,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.6),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    Text(
                      _songs[_currentAudioIndex],
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Slider(
                      value: _currentSliderValue.clamp(0.0, _totalDuration.inMilliseconds.toDouble()),
                      min: 0,
                      max: _totalDuration.inMilliseconds.toDouble(),
                      onChanged: (double value) {
                        setState(() {
                          _currentSliderValue = value;
                          _audioPlayer.seek(Duration(milliseconds: value.toInt()));
                        });
                      },
                      activeColor: Colors.pink,
                    ),
                    Transform.translate(
                      offset: const Offset(0, -15),
                      child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text(
                          _formatDuration(_currentPosition),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12
                          ),
                        ),
                        const SizedBox(width: 52,),
                        Text(
                          _formatDuration(_totalDuration - _currentPosition),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12
                          ),
                        ),
                      ],
                    ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.skip_previous, color: Colors.white),
                          onPressed: _previous,
                          iconSize: 36,
                        ),
                        IconButton(
                          icon: Icon(
                            _isPlaying ? Icons.pause : Icons.play_arrow,
                            color: Colors.white,
                          ),
                          onPressed: _playPause,
                          iconSize: 36,
                        ),
                        IconButton(
                          icon: const Icon(Icons.skip_next, color: Colors.white),
                          onPressed: _next,
                          iconSize: 36,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),

      AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            left: _isMenuOpen ? 0 : -200,
            child: Container(
              width: 200, // Width of the menu
              decoration: const BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(22)
                )
                // boxShadow: [
                //   BoxShadow(color: Colors.white.withOpacity(0.4), offset: Offset(3, 5))
                // ]
              ),
              child: Container(
                margin: const EdgeInsets.only(top: 12),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListTile(
                      leading: const Icon(Icons.home, color: Colors.white,),
                      title: const Text(
                        'Home',
                        style: TextStyle(
                          color: Colors.white
                        ),
                      ),
                      onTap: () {
                        // Handle menu item tap
                        _toggleMenu();
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.settings, color: Colors.white,),
                      title: const Text(
                        'Settings',
                        style: TextStyle(
                          color: Colors.white
                        ),
                      ),
                      onTap: () {
                        // Handle menu item tap
                        _toggleMenu();
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          mainAxisAlignment: _isMenuOpen ? MainAxisAlignment.end : MainAxisAlignment.spaceBetween,
          children: [
            if(!_isMenuOpen)
            IconButton(
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all(Colors.white),
                shape: WidgetStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)
                  )
                )
              ),
              onPressed: (){
        
              }, 
              icon: const Icon(Icons.cast_connected, color: Colors.black,)
            ),
            if(!_isMenuOpen)
            Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.6),
            shape: BoxShape.circle
          ),
          child: Center(
            child: Container(
              width: 6,
              height: 6,
              decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle
            ),
            ),
          ),
        ),
            IconButton(
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all(Colors.white),
                shape: WidgetStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)
                  )
                )
              ),
              onPressed: _toggleMenu,
              tooltip: 'Toggle Menu',
              icon: Icon(_isMenuOpen ? Icons.close : Icons.menu),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerTop,
    );
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }
}

