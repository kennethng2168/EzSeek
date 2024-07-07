import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class TikTokEmbedPage extends StatelessWidget {
  final String videoUrl =
      "https://www.tiktok.com/player/v1/7208486952377634053?music_info=1&description=1&controls=1&progress_bar=1&loop=1&autoplay=1&native_context_menu=1";

  @override
  Widget build(BuildContext context) {
    var controller = WebViewController()
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
        ),
      )
      ..loadRequest(Uri.parse(videoUrl));

    return Scaffold(
      backgroundColor: Colors.black,
      // appBar: AppBar(
      //   title: Text('TikTok Video'),
      // ),
      body: SafeArea(
          child: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 50),
            Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: WebViewWidget(controller: controller),
            ),
          ],
        ),
      )),
    );
  }
}
