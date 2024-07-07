import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod/riverpod.dart';
import 'package:hashlib/hashlib.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:reward_popup/reward_popup.dart';
import '../providers.dart';
import 'package:http/http.dart' as http;

class AlbumScreen extends ConsumerStatefulWidget {
  AlbumScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<AlbumScreen> createState() => _AlbumScreenState();
}

class _AlbumScreenState extends ConsumerState<AlbumScreen> {
  String? base64Image;
  // Define the prompts for each topic
  final Map<String, List<String>> prompts = {
    'biodiversity': [
      "Create an impactful scene illustrating the direct harm of deforestation and environmental degradation. Render the image in 16K resolution, focusing on the cutting forest and its impact on diverse species."
    ],
    'air_water_pollution': [
      'Create an impactful scene illustrating the direct harm of plastic product and chemical disposal on marine life and ocean pollution.Redering the image to 16k, marine life'
    ],
    'climate_change_carbon_emission': [
      "Create an impactful scene illustrating the devastating effects of flooding on communities and natural landscapes. Render the image in 16K resolution, capturing the powerful force of rising waters, submerged homes, and displaced wildlife. Highlight the urgent need for flood management and climate resilience.",
      "Create an impactful scene illustrating the direct harm of carbon emissions on the environment. Render the image in 16K resolution, depicting the effects of air pollution and greenhouse gases on ecosystems."
      // "Create a visually striking scene depicting the destructive impact of a landslide on a serene landscape. Rendered in detailed 16K resolution, show the aftermath with debris-strewn slopes, uprooted trees, and displaced wildlife. Emphasize the sudden and powerful force of nature, highlighting the need for disaster preparedness and environmental awareness."
    ],
    'renewable_energy': [
      "Create an impactful scnene illustrating renewable energy, 16k resolution"
    ],
  };

// Method to get a random prompt from a given topic
  String getRandomPrompt() {
    final topic = prompts.keys.elementAt(random.nextInt(prompts.keys.length));
    final promptList = prompts[topic]!;
    final prompt = promptList[random.nextInt(promptList.length)];
    return prompt;
  }

  @override
  Future<void> fetchImages() async {
    try {
      final uri = Uri.https('345a-14-192-242-19.ngrok-free.app',
          '/generate-image/', {'prompt': getRandomPrompt()});

      final response =
          await http.post(uri, headers: {'Content-Type': 'application/json'});

      print('Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        // Assuming the response body is the image data in bytes
        final bytes = response.bodyBytes;
        final base64String = base64Encode(bytes);
        setState(() {
          base64Image = base64String;
        });
      } else {
        print(
            'Failed to load image. Status Code: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Widget _topBanner() {
    return Container(
      // padding: EdgeInsets.all(15.0),
      height: 300,
      decoration: BoxDecoration(
        color: Colors.black,
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {
      // _readRewards();
    });
  }

  dynamic imagesList = [
    "assets/images/carbon.png",
    "assets/images/airpollution.jpeg",
    "assets/images/renewable.jpeg",
    "assets/images/biodiversity.png"
  ];
  final random = new Random();

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          children: [
            Stack(
              children: <Widget>[
                _topBanner(),
                Padding(
                  padding: EdgeInsets.only(
                    left: 15,
                    top: 55,
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            height: 60,
                            child: Image.asset(
                                "assets/images/horizontal_white_tiktok_logo.png"),
                          ),
                        ],
                      ),
                      Container(
                        child: Text(
                          ref.watch(numberAlbumProvider).toString() + "/4",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 30,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            child: Container(
                              alignment: Alignment.centerLeft,
                              width: 180,
                              padding: EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                color: ref.watch(chanceProvider) <= 0
                                    ? Colors.grey.shade500
                                    : Colors.white,
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.redeem,
                                    color: Colors.black,
                                    size: 30,
                                  ),
                                  const SizedBox(width: 5),
                                  Text(
                                    "Redeem Now",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            onTap: ref.watch(chanceProvider) <= 0
                                ? null
                                : () async {
                                    await fetchImages();

                                    var randomImage = imagesList[
                                        random.nextInt(imagesList.length)];
                                    ref.watch(chanceProvider.notifier).state -=
                                        1;
                                    for (var i = 0;
                                        i < imagesList.length;
                                        i++) {
                                      if (randomImage == imagesList[i]) {
                                        if (i == 0) {
                                          if (ref.watch(reward1Provider) >=
                                              1.00) {
                                            print("Try Again Next Time");
                                          } else {
                                            ref
                                                .watch(reward1Provider.notifier)
                                                .state += 0.25;
                                            if (ref.watch(reward1Provider) >=
                                                1.00) {
                                              ref
                                                  .watch(numberAlbumProvider
                                                      .notifier)
                                                  .state += 1;
                                            }
                                          }
                                        } else if (i == 1) {
                                          if (ref.watch(reward2Provider) >=
                                              1.00) {
                                            print("Try Again Next Time");
                                          } else {
                                            ref
                                                .watch(reward2Provider.notifier)
                                                .state += 0.25;

                                            if (ref.watch(reward2Provider) >=
                                                1.00) {
                                              ref
                                                  .watch(numberAlbumProvider
                                                      .notifier)
                                                  .state += 1;
                                            }
                                          }
                                        } else if (i == 2) {
                                          if (ref.watch(reward3Provider) >=
                                              1.00) {
                                            print("Try Again Next Time");
                                          } else {
                                            ref
                                                .watch(reward3Provider.notifier)
                                                .state += 0.25;
                                            if (ref.watch(reward3Provider) >=
                                                1.00) {
                                              ref
                                                  .watch(numberAlbumProvider
                                                      .notifier)
                                                  .state += 1;
                                            }
                                          }
                                        } else if (i == 3) {
                                          if (ref.watch(reward4Provider) >=
                                              1.00) {
                                            print("Try Again Next Time");
                                          } else {
                                            ref
                                                .watch(reward4Provider.notifier)
                                                .state += 0.25;
                                            if (ref.watch(reward4Provider) >=
                                                1.00) {
                                              ref
                                                  .watch(numberAlbumProvider
                                                      .notifier)
                                                  .state += 1;
                                            }
                                          }
                                        }
                                      }
                                      if (ref
                                              .watch(
                                                  numberAlbumProvider.notifier)
                                              .state >=
                                          4) {
                                        ref
                                            .watch(numberAlbumProvider.notifier)
                                            .state = 0;

                                        ref
                                            .watch(reward1Provider.notifier)
                                            .state = 0.0;
                                        ref
                                            .watch(reward2Provider.notifier)
                                            .state = 0.0;
                                        ref
                                            .watch(reward3Provider.notifier)
                                            .state = 0.0;
                                        ref
                                            .watch(reward4Provider.notifier)
                                            .state = 0.0;
                                      }
                                    }

                                    final answer =
                                        await showRewardPopup<String>(
                                      context,
                                      backgroundColor: Colors.black,
                                      child: Positioned.fill(
                                        child: InkWell(
                                          onTap: () {
                                            Navigator.of(context).pop(true);
                                          },
                                          child: Image.memory(
                                            base64Decode(base64Image!),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Container(
                        child: Text(
                          "Remaining Chance: ${ref.watch(chanceProvider)}",
                          style: TextStyle(
                            decorationThickness: 1,
                            color: Colors.white70,
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  alignment: Alignment.topCenter,
                  padding: EdgeInsets.only(
                    top: 230,
                    right: 10,
                    left: 10,
                  ),
                  child: Container(
                    padding: EdgeInsets.all(10),
                    height: MediaQuery.of(context).size.height / 1.5,
                    width: MediaQuery.of(context).size.width,
                    child: Card(
                      color: Colors.white,
                      elevation: 8,
                      child: Column(
                        children: [
                          Container(
                              alignment: Alignment.centerLeft,
                              padding: EdgeInsets.all(15),
                              child: Row(children: [
                                Column(
                                  children: [
                                    Container(
                                      alignment: Alignment.centerLeft,
                                      child: CircleAvatar(
                                        backgroundImage: AssetImage(
                                            "assets/images/carbon.png"),
                                        radius: 70,
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    Container(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        "Climate Change \n& Carbon Emission ",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    LinearPercentIndicator(
                                      barRadius: Radius.circular(15),
                                      animation: true,
                                      width: 150,
                                      lineHeight: 25,
                                      percent: ref.watch(reward1Provider),
                                      center: Text(
                                        ref.watch(reward1Provider) == 0.0
                                            ? "0/4"
                                            : ref.watch(reward1Provider) == 0.25
                                                ? "1/4"
                                                : ref.watch(reward1Provider) ==
                                                        0.5
                                                    ? "2/4"
                                                    : ref.watch(reward1Provider) ==
                                                            0.75
                                                        ? "3/4"
                                                        : ref.watch(reward1Provider) ==
                                                                1.00
                                                            ? "4/4"
                                                            : "",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                      backgroundColor: Colors.grey,
                                      progressColor: Colors.greenAccent,
                                    )
                                  ],
                                ),
                                const Spacer(),
                                Column(
                                  children: [
                                    Container(
                                      alignment: Alignment.centerLeft,
                                      child: CircleAvatar(
                                        backgroundImage: AssetImage(
                                            "assets/images/airpollution.jpeg"),
                                        radius: 70,
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    Container(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        "Air & Water\n Pollution ",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    LinearPercentIndicator(
                                      barRadius: Radius.circular(15),
                                      animation: true,
                                      width: 150,
                                      lineHeight: 25,
                                      percent: ref.watch(reward2Provider),
                                      center: Text(
                                        ref.watch(reward2Provider) == 0.0
                                            ? "0/4"
                                            : ref.watch(reward2Provider) == 0.25
                                                ? "1/4"
                                                : ref.watch(reward2Provider) ==
                                                        0.5
                                                    ? "2/4"
                                                    : ref.watch(reward2Provider) ==
                                                            0.75
                                                        ? "3/4"
                                                        : ref.watch(reward2Provider) ==
                                                                1.00
                                                            ? "4/4"
                                                            : "",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                      backgroundColor: Colors.grey,
                                      progressColor: Colors.greenAccent,
                                    )
                                  ],
                                ),
                              ])),
                          Container(
                              alignment: Alignment.centerLeft,
                              padding: EdgeInsets.all(20),
                              child: Row(children: [
                                Column(
                                  children: [
                                    Container(
                                      alignment: Alignment.centerLeft,
                                      child: CircleAvatar(
                                        backgroundImage: AssetImage(
                                            "assets/images/renewable.jpeg"),
                                        radius: 70,
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    Container(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        "Renewable Energy \n(Solar)",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    LinearPercentIndicator(
                                      barRadius: Radius.circular(15),
                                      animation: true,
                                      width: 150,
                                      lineHeight: 25,
                                      percent: ref.watch(reward3Provider),
                                      center: Text(
                                        ref.watch(reward3Provider) == 0.0
                                            ? "0/4"
                                            : ref.watch(reward3Provider) == 0.25
                                                ? "1/4"
                                                : ref.watch(reward3Provider) ==
                                                        0.5
                                                    ? "2/4"
                                                    : ref.watch(reward3Provider) ==
                                                            0.75
                                                        ? "3/4"
                                                        : ref.watch(reward3Provider) ==
                                                                1.00
                                                            ? "4/4"
                                                            : "",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                      backgroundColor: Colors.grey,
                                      progressColor: Colors.greenAccent,
                                    )
                                  ],
                                ),
                                const Spacer(),
                                Column(
                                  children: [
                                    Container(
                                      alignment: Alignment.centerLeft,
                                      child: CircleAvatar(
                                        backgroundImage: AssetImage(
                                            "assets/images/biodiversity.png"),
                                        radius: 70,
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    Container(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        "Biodiversity\n Ecosystem",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    LinearPercentIndicator(
                                      barRadius: Radius.circular(15),
                                      animation: true,
                                      width: 150,
                                      lineHeight: 25,
                                      percent: ref.watch(reward4Provider),
                                      center: Text(
                                        ref.watch(reward4Provider) == 0.0
                                            ? "0/4"
                                            : ref.watch(reward4Provider) == 0.25
                                                ? "1/4"
                                                : ref.watch(reward4Provider) ==
                                                        0.5
                                                    ? "2/4"
                                                    : ref.watch(reward4Provider) ==
                                                            0.75
                                                        ? "3/4"
                                                        : ref.watch(reward4Provider) ==
                                                                1.00
                                                            ? "4/4"
                                                            : "",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                      backgroundColor: Colors.grey,
                                      progressColor: Colors.greenAccent,
                                    )
                                  ],
                                ),
                              ])),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Container(
              alignment: Alignment.topCenter,
              padding: EdgeInsets.only(
                top: 2,
                right: 15,
                left: 15,
              ),
              child: Container(
                alignment: Alignment.bottomCenter,
                child: GestureDetector(
                  child: Icon(
                    Icons.close,
                    color: Colors.black,
                    size: 30,
                  ),
                  onTap: () => Navigator.pop(context),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
