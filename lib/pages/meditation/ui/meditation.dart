import 'dart:async';
import 'dart:convert';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'package:zenova/constants/colors.dart';
import 'package:zenova/constants/image_strings.dart';
import 'package:zenova/constants/sizes.dart';
import 'package:zenova/helper/helper_functions.dart';
import 'package:zenova/utils/appbar.dart';

class Meditation extends StatefulWidget {
  const Meditation({super.key});

  @override
  State<Meditation> createState() => _MeditationState();
}

class _MeditationState extends State<Meditation> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  List<dynamic> mp3List = [];
  List<dynamic> filteredList = [];
  List<String> categories = [];
  String? selectedCategory;

  final AudioPlayer _audioPlayer = AudioPlayer();
  int? _currentlyPlayingIndex;
  PlayerState _playerState = PlayerState.stopped;
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;
  StreamSubscription? _durationSubscription;
  StreamSubscription? _positionSubscription;
  StreamSubscription? _playerCompleteSubscription;
  StreamSubscription? _playerStateChangeSubscription;

  @override
  void initState() {
    super.initState();
    fetchMP3List();
    _setupAudioPlayer();
  }

  void _setupAudioPlayer() {
    _durationSubscription = _audioPlayer.onDurationChanged.listen((duration) {
      setState(() => _duration = duration);
    });

    _positionSubscription = _audioPlayer.onPositionChanged.listen((position) {
      setState(() => _position = position);
    });

    _playerCompleteSubscription = _audioPlayer.onPlayerComplete.listen((event) {
      setState(() {
        _playerState = PlayerState.stopped;
        _position = Duration.zero;
      });
    });

    _playerStateChangeSubscription =
        _audioPlayer.onPlayerStateChanged.listen((state) {
      setState(() {
        _playerState = state;
      });
    });
  }

  @override
  void dispose() {
    _durationSubscription?.cancel();
    _positionSubscription?.cancel();
    _playerCompleteSubscription?.cancel();
    _playerStateChangeSubscription?.cancel();
    _audioPlayer.dispose();
    super.dispose();
  }

  Future<void> fetchMP3List() async {
    final url = dotenv.env['MPMP3_JSON_URL'] ?? "";
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          mp3List = data;
          filteredList = mp3List;
          categories = data
              .expand((item) => item["categories"] as List<dynamic>)
              .toSet()
              .cast<String>()
              .toList();
          categories.sort();
        });
      } else {
        throw Exception("Failed to load mp3 list");
      }
    } catch (e) {
      debugPrint("Error fetching MP3 list: $e");
    }
  }

  void filterByCategory(String? category) {
    setState(() {
      selectedCategory = category;
      if (category == null) {
        filteredList = mp3List;
      } else {
        filteredList = mp3List
            .where((mp3) =>
                (mp3["categories"] as List<dynamic>).contains(category))
            .toList();
      }
    });
  }

  Future<void> _togglePlayPause(int index, String url) async {
    if (_currentlyPlayingIndex == index &&
        _playerState == PlayerState.playing) {
      await _audioPlayer.pause();
    } else {
      // Stop current playback if another track is playing
      if (_currentlyPlayingIndex != null &&
          _playerState == PlayerState.playing) {
        await _audioPlayer.stop();
      }

      // Start new playback
      _currentlyPlayingIndex = index;
      await _audioPlayer.play(UrlSource(url));
    }
  }

  Future<void> _restartAudio() async {
    if (_currentlyPlayingIndex != null) {
      final url = filteredList[_currentlyPlayingIndex!]["url"];
      await _audioPlayer.seek(Duration.zero);
      await _audioPlayer.play(UrlSource(url));
    }
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));

    return [
      if (duration.inHours > 0) hours,
      minutes,
      seconds,
    ].join(':');
  }

  @override
  Widget build(BuildContext context) {
    final dark = EHelperFunctions.isDarkMode(context);

    return Scaffold(
      key: _scaffoldKey,
      appBar: EAppBar(
        title: Text(
          'Meditation',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        leadingIcon: Icons.menu_rounded,
        leadingOnPressed: () {
          _scaffoldKey.currentState?.openDrawer();
        },
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Category filter section
          Padding(
            padding: const EdgeInsets.all(ESizes.md),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text(
                      "Category:",
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      selectedCategory ?? "All",
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ],
                ),
                IconButton(
                  icon: Icon(
                    Icons.filter_list_rounded,
                    color: dark ? EColors.white : Colors.black,
                  ),
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      builder: (context) {
                        return ListView(
                          padding: const EdgeInsets.all(ESizes.md),
                          children: [
                            ListTile(
                              title: Text(
                                "All",
                                style: TextStyle(
                                  color: dark ? EColors.white : Colors.black,
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              selected: selectedCategory == null,
                              onTap: () {
                                filterByCategory(null);
                                Navigator.pop(context);
                              },
                            ),
                            ...categories.map((cat) => ListTile(
                                  title: Text(
                                    cat,
                                    style: TextStyle(
                                      color:
                                          dark ? EColors.white : Colors.black,
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  selected: selectedCategory == cat,
                                  onTap: () {
                                    filterByCategory(cat);
                                    Navigator.pop(context);
                                  },
                                )),
                          ],
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          ),

          // List of MP3s
          Expanded(
            child: mp3List.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    itemCount: filteredList.length,
                    itemBuilder: (context, index) {
                      final mp3 = filteredList[index];
                      final isPlaying = _currentlyPlayingIndex == index &&
                          _playerState == PlayerState.playing;
                      final isPaused = _currentlyPlayingIndex == index &&
                          _playerState == PlayerState.paused;
                      final isStopped = _currentlyPlayingIndex == index &&
                          _playerState == PlayerState.stopped;

                      return Container(
                        margin:  EdgeInsets.symmetric(
                            horizontal: 12.w, vertical: 6.h),
                        decoration: BoxDecoration(
                          color: dark
                              ? EColors.primaryColor.withValues(alpha:0.1)
                              : Colors.white,
                          borderRadius: BorderRadius.circular(8.r),
                          border: Border.all(
                            color: dark
                                ? EColors.primaryColor.withValues(alpha:0.3)
                                : EColors.darkGrey,
                          ),
                        ),
                        child: Column(
                          children: [
                            ListTile(
                              contentPadding: const EdgeInsets.all(8),
                              leading: Image.asset(
                                dark ? EImages.darkMusic : EImages.lightMusic,
                                height: 48.h,
                                width: 48.w,
                              ),
                              title: Text(
                                mp3["title"],
                                style:  TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: Text(
                                mp3["duration"],
                                style: TextStyle(
                                  color:
                                      dark ? EColors.darkGrey : Colors.black54,
                                  fontSize: 12.sp,
                                ),
                              ),
                              trailing: isStopped
                                  ? IconButton(
                                      icon: Icon(
                                        Icons.replay_circle_filled_outlined,
                                        size: 36.r,
                                        color: EColors.primaryColor,
                                      ),
                                      onPressed: () => _restartAudio(),
                                    )
                                  : IconButton(
                                      icon: Icon(
                                        isPlaying
                                            ? Icons.pause_circle_filled
                                            : Icons.play_circle_fill,
                                        size: 36.r,
                                        color: EColors.primaryColor,
                                      ),
                                      onPressed: () => _togglePlayPause(
                                        index,
                                        mp3["url"],
                                      ),
                                    ),
                            ),
                            // Progress indicator
                            if (_currentlyPlayingIndex == index)
                              Padding(
                                padding:  EdgeInsets.symmetric(
                                    horizontal: 16.0.w, vertical: 8.0.h),
                                child: Column(
                                  children: [
                                    LinearProgressIndicator(
                                      value: _duration.inSeconds == 0
                                          ? 0
                                          : _position.inSeconds /
                                              _duration.inSeconds,
                                      backgroundColor: dark
                                          ? EColors.darkGrey
                                          : Colors.grey[300],
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        EColors.primaryColor,
                                      ),
                                      minHeight: 4.w,
                                    ),
                                     SizedBox(height: 4.h),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          _formatDuration(_position),
                                          style: TextStyle(
                                            fontSize: 12.sp,
                                            color: dark
                                                ? EColors.lightGrey
                                                : Colors.black54,
                                          ),
                                        ),
                                        Text(
                                          _formatDuration(_duration),
                                          style: TextStyle(
                                            fontSize: 12.sp,
                                            color: dark
                                                ? EColors.lightGrey
                                                : Colors.black54,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
