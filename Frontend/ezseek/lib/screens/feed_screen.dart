import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:ezseek/screens/album_screen.dart';
import 'package:ezseek/screens/tiktok_embed_sreen.dart';
import 'package:ezseek/screens/virtual_try_on_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:video_player/video_player.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../data/video.dart';
import '../models/tiktok_video.dart';
import '../providers.dart';
import '../utils/tik_tok_icons_icons.dart';
import '../widgets/bottom_bar.dart';
import 'messages_screen.dart';
import 'profile_screen.dart';
import 'search_screen.dart';
import 'package:http/http.dart' as http;

class FeedScreen extends ConsumerStatefulWidget {
  FeedScreen({Key? key}) : super(key: key);

  @override
  _FeedScreenState createState() => _FeedScreenState();
}

class _FeedScreenState extends ConsumerState<FeedScreen> {
  String? authorUrl;
  var controller;

  @override
  void initState() {
    super.initState();
    fetchOEmbedData();
  }

  Future<void> fetchOEmbedData() async {
    final response = await http.get(Uri.parse(
        'https://www.tiktok.com/oembed?url=https://www.tiktok.com/@phbxc/video/7208486952377634053'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        authorUrl = data['author_url'];
      });
      controller = WebViewController()
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..setBackgroundColor(const Color(0x00000000))
        ..setNavigationDelegate(
          NavigationDelegate(
            onProgress: (int progress) {
              // Update loading bar.
            },
            onPageStarted: (String url) {},
            onPageFinished: (String url) {},
            onHttpError: (HttpResponseError error) {},
            onWebResourceError: (WebResourceError error) {},
            onNavigationRequest: (NavigationRequest request) {
              if (request.url.startsWith('https://www.youtube.com/')) {
                return NavigationDecision.prevent;
              }
              return NavigationDecision.navigate;
            },
          ),
        )
        ..loadRequest(Uri.parse(authorUrl ?? ""));
    } else {
      // Handle error
      print('Failed to load oEmbed data');
    }
  }

  @override
  Widget build(BuildContext context) {
    final actualScreen = ref.watch(screenIndexProvider);

    return Scaffold(
      backgroundColor: actualScreen == 0 ? Colors.black : Colors.white,
      body: Stack(
        children: [
          PageView.builder(
            itemCount: 2,
            onPageChanged: (value) {
              print(value);
              ref.watch(currentScreenProvider.notifier).state = 4;
              if (value == 1)
                SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
              else
                SystemChrome.setSystemUIOverlayStyle(
                    SystemUiOverlayStyle.light);
            },
            itemBuilder: (context, index) {
              if (index == 0) return scrollFeed();
              return SafeArea(
                // child: Column(children: [
                child: authorUrl!.isNotEmpty
                    ? Container(child: WebViewWidget(controller: controller))
                    //   authorUrl.toString(),
                    //   style: TextStyle(
                    //     color: Colors.white,
                    //   ),
                    // )
                    : Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircularProgressIndicator(),
                            const SizedBox(height: 10),
                            Text(
                              "Loading...",
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
              );
            },
          )
        ],
      ),
    );
  }

  Widget scrollFeed() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Expanded(child: currentScreen()),
        BottomBar(),
      ],
    );
  }

  Widget feedVideos() {
    return Stack(
      children: [
        TikTokEmbedPage(),
        TikTokEmbedPage(),
        SafeArea(
          child: Container(
            padding: EdgeInsets.only(left: 100, top: 20),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Column(
                    children: [
                      Text('Following',
                          style: TextStyle(
                              fontSize: 17.0,
                              fontWeight: FontWeight.w500,
                              color: Colors.white70)),
                      Container(
                        color: Colors.transparent,
                        height: 2,
                        width: 30,
                      )
                    ],
                  ),
                  const SizedBox(width: 15),
                  Column(
                    children: [
                      Text('Shop',
                          style: TextStyle(
                              fontSize: 17.0,
                              fontWeight: FontWeight.w500,
                              color: Colors.white70)),
                      Container(
                        color: Colors.transparent,
                        height: 2,
                        width: 30,
                      )
                    ],
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  Column(
                    children: [
                      Text('For You',
                          style: TextStyle(
                              fontSize: 17.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.white)),
                      Container(
                        color: Colors.white,
                        height: 2,
                        width: 30,
                      )
                    ],
                  ),
                  const Spacer(),
                  Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(right: 20),
                        child: GestureDetector(
                          child: Container(
                            child: Icon(
                              TikTokIcons.search,
                              color: Colors.white,
                            ),
                          ),
                          onTap: () => Navigator.push(
                            context,
                            createFadeRoute(SearchScreen()),
                          ),
                        ),
                      ),
                    ],
                  )
                ]),
          ),
        ),
      ],
    );
  }

  Route createFadeRoute(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = 0.0;
        const end = 1.0;
        const curve = Curves.easeInOut;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        var fadeAnimation = animation.drive(tween);

        return FadeTransition(
          opacity: fadeAnimation,
          child: child,
        );
      },
    );
  }

  Widget currentScreen() {
    final actualScreen = ref.watch(screenIndexProvider);
    print(actualScreen);
    switch (actualScreen) {
      case 0:
        return feedVideos();
      case 1:
        return TryOnScreen();
      case 2:
        return AlbumScreen();
      case 3:
        return ProfileScreen();
      case 4:
        return WebViewWidget(
          controller: controller,
        );
      default:
        return feedVideos();
    }
  }

  Widget videoCard(Video video) {
    return Stack(
      children: [
        video.controller != null
            ? GestureDetector(
                onTap: () {
                  if (video.controller!.value.isPlaying) {
                    video.controller?.pause();
                  } else {
                    video.controller?.play();
                  }
                },
                child: SizedBox.expand(
                    child: FittedBox(
                  fit: BoxFit.cover,
                  child: SizedBox(
                    width: video.controller?.value.size.width ?? 0,
                    height: video.controller?.value.size.height ?? 0,
                    child: VideoPlayer(video.controller!),
                  ),
                )),
              )
            : Container(
                color: Colors.black,
                child: Center(
                  child: Text("Loading"),
                ),
              ),
        Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[SizedBox(height: 20)],
        ),
      ],
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
