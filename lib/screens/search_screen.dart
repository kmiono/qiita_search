import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http; // httpという変数を通して、httpパッケージにアクセス
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:qiita_search/models/article.dart';
import 'package:qiita_search/models/user.dart';
import 'package:qiita_search/widgets/article_container.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  List<Article> articles = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Qiita Search'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 12,
              horizontal: 36,
            ),
            child: TextField(
              style: TextStyle(
                fontSize: 18,
                color: Colors.black,
              ),
              decoration: InputDecoration(
                hintText: '検索ワードを入力してください',
              ),
              onSubmitted: (String value) async {
                final results = await searchQiita(value);
                setState(() => articles = results);
              },
            ),
          ),
          ArticleContainer(
            article: Article(
              title: 'test',
              user: User(
                id: 'qii-taro',
                profileImageUrl:
                    'https://firebasestorage.googleapis.com/v0/b/gs-expansion-test.appspot.com/o/unknown_person.png?alt=media',
              ),
              createdAt: DateTime.now(),
              tags: ['Flutter', 'dart'],
              url: 'https://example.com',
            ),
          ),
        ],
      ),
    );
  }

  Future<List<Article>> searchQiita(String keyword) async {
    // 1. http通信に必要なデータを準備をする
    //   - URL、クエリパラメータの設定
    final url = Uri.https('qiita.com', '/api/v2/items', {
      'query': 'title:$keyword',
      'per_page': '10',
    });
    //   - アクセストークンの取得
    final String token = dotenv.env['QIITA_ACCESS_TOKEN'] ?? '';

    // 2. Qiita APIにリクエストを送る
    final http.Response res = await http.get(url, headers: {
      'Authorization': 'Bearer $token',
    });

    // 3. 戻り値をArticleクラスの配列に変換
    // 4. 変換したArticleクラスの配列を返す(returnする)
    if (res.statusCode == 200) {
      // レスポンスをモデルクラスへ変換
      final List<dynamic> body = jsonDecode(res.body);
      return body.map((dynamic json) => Article.fromJson(json)).toList();
    } else {
      return [];
    }
  }
}
