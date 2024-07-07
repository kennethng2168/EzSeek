import 'package:ezseek/screens/shop.dart';
import 'package:ezseek/screens/tiktok_embed_sreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'screens/feed_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(ProviderScope(
      child: MaterialApp(
    debugShowCheckedModeBanner: false,
    home: FeedScreen(),
  )));
}
