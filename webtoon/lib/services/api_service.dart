import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:webtoon/models/webtoon_model.dart';

class ApiService {
  static const String baseUrl =
      'https://webtoon-crawler.nomadcoders.workers.dev';
  static const String todayRoute = 'today';

  static Future<List<WebtoonModel>> getTodaysToons() async {
    final url = Uri.parse('$baseUrl/$todayRoute');
    final resp = await http.get(url);
    if (resp.statusCode == 200) {
      final List<dynamic> webtoons = jsonDecode(resp.body);
      return [for (var webtoon in webtoons) WebtoonModel.fromJson(webtoon)];
    } else {
      throw Error();
    }
  }

  static Future<WebtoonDetailModel> getToonById(String id) async {
    final url = Uri.parse('$baseUrl/$id');
    final resp = await http.get(url);
    if (resp.statusCode == 200) {
      final webtoon = jsonDecode(resp.body);
      return WebtoonDetailModel.fromJson(webtoon);
    } else {
      throw Error();
    }
  }

  static Future<List<WebtoonEpisodeModel>> getLatestEpisodesById(
      String id) async {
    final url = Uri.parse('$baseUrl/$id/episodes');
    final resp = await http.get(url);
    if (resp.statusCode == 200) {
      final webtoons = jsonDecode(resp.body);
      return [
        for (var webtoon in webtoons) WebtoonEpisodeModel.fromJson(webtoon),
      ];
    } else {
      throw Error();
    }
  }
}
