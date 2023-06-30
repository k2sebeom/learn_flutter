import 'package:flutter/material.dart';
import 'package:webtoon/models/webtoon_model.dart';
import 'package:webtoon/services/api_service.dart';
import 'package:webtoon/widgets/webtoon_widget.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final Future<List<WebtoonModel>> webtoons = ApiService.getTodaysToons();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Today\'s Toons'),
        backgroundColor: const Color(0xFF2DB400),
        actions: const [],
      ),
      body: FutureBuilder(
        future: webtoons,
        builder: (ctx, snapshot) {
          if (snapshot.hasData) {
            return Column(
              children: [
                const SizedBox(height: 30),
                Expanded(
                  child: makeList(snapshot),
                ),
              ],
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }

  ListView makeList(AsyncSnapshot<List<WebtoonModel>> snapshot) {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      scrollDirection: Axis.horizontal,
      itemCount: snapshot.data!.length,
      itemBuilder: (ctx, idx) {
        final webtoon = snapshot.data![idx];
        return WebtoonWidget(webtoon: webtoon);
      },
      separatorBuilder: (context, index) => const SizedBox(width: 20),
    );
  }
}
