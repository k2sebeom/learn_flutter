import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webtoon/models/webtoon_model.dart';
import 'package:webtoon/services/api_service.dart';

class DetailScreen extends StatefulWidget {
  final WebtoonModel webtoon;

  const DetailScreen({
    super.key,
    required this.webtoon,
  });

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  late Future<WebtoonDetailModel> webtoon;
  late Future<List<WebtoonEpisodeModel>> episodes;

  // late SharedPreferences prefs;

  bool isLiked = false;

  // Future initPrefs() async {
  //   prefs = await SharedPreferences.getInstance();
  //   final likedToons = prefs.getStringList('likedToons');
  //   if (likedToons != null) {
  //     setState(() {
  //       isLiked = likedToons.contains(widget.webtoon.id);
  //     });
  //   } else {
  //     await prefs.setStringList('likedToons', []);
  //   }
  // }

  void openToonUrl(String link) async {
    final uri = Uri.parse(link);
    await launchUrl(uri);
  }

  @override
  void initState() {
    super.initState();
    webtoon = ApiService.getToonById(widget.webtoon.id);
    episodes = ApiService.getLatestEpisodesById(widget.webtoon.id);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(widget.webtoon.title),
        backgroundColor: const Color(0xFF2DB400),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.favorite_border_outlined),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            children: [
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Hero(
                    tag: widget.webtoon.id,
                    child: Container(
                      clipBehavior: Clip.hardEdge,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 3,
                            offset: const Offset(2, 2),
                            color: Colors.black.withOpacity(0.5),
                          ),
                        ],
                      ),
                      width: 250,
                      child: Image.network(
                        widget.webtoon.thumb,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              FutureBuilder(
                  future: webtoon,
                  builder: (ctx, snapshot) {
                    if (snapshot.hasData) {
                      final detail = snapshot.data;
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            detail!.about,
                            style: const TextStyle(
                              fontSize: 15,
                            ),
                          ),
                          const SizedBox(height: 15),
                          Text('${detail.genre} / ${detail.age}'),
                        ],
                      );
                    } else {
                      return const Text('...');
                    }
                  }),
              const SizedBox(height: 30),
              FutureBuilder(
                future: episodes,
                builder: (ctx, snapshot) {
                  if (snapshot.hasData) {
                    final episodes = snapshot.data!;
                    return Column(
                      children: [
                        for (var ep in episodes)
                          Container(
                            margin: const EdgeInsets.only(bottom: 10),
                            decoration: BoxDecoration(
                              // color: Colors.red,
                              border: Border.symmetric(
                                horizontal: BorderSide(
                                  color: Colors.black.withOpacity(0.5),
                                  width: 0.2,
                                ),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                  height: 60,
                                  child: Image.network(ep.thumb),
                                ),
                                Text(
                                  ep.title,
                                ),
                                IconButton(
                                  onPressed: () {
                                    openToonUrl(
                                        'https://comic.naver.com/webtoon/detail?titleId=${widget.webtoon.id}&no=${ep.id}');
                                  },
                                  icon: const Icon(
                                    Icons.arrow_forward_ios,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    );
                  } else {
                    return Container();
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
