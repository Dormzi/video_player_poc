import 'package:flutter/material.dart';
import 'package:vimeo_video_player_poc/vimeo/vimeo_player.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Vimeo Video Player')),
      body: Center(
        child: VimeoPlayer(url: 'https://vimeo.com/345498908'),
      ),
    );
  }
}
