import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/article_model.dart';
import 'detail_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ApiService _apiService = ApiService();
  late Future<List<Article>> _articlesFuture;

  @override
  void initState() {
    super.initState();
    _articlesFuture = _apiService.fetchArticles();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('SpaceNews Core')),
      body: FutureBuilder<List<Article>>(
        future: _articlesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No news available.'));
          }

          final articles = snapshot.data!;
          final headline = articles.first;
          final newsFeed = articles.sublist(1);

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => DetailPage(article: headline))),
                  child: Card(
                    margin: const EdgeInsets.all(12),
                    clipBehavior: Clip.antiAlias,
                    child: Column(
                      children: [
                        Image.network(headline.imageUrl, height: 200, width: double.infinity, fit: BoxFit.cover, 
                          errorBuilder: (c, o, s) => const Icon(Icons.broken_image, height: 200)),
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Text(headline.title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        )
                      ],
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: Text('Latest News', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                ),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: newsFeed.length,
                  itemBuilder: (context, index) {
                    final item = newsFeed[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      child: ListTile(
                        leading: Image.network(item.imageUrl, width: 80, fit: BoxFit.cover,
                          errorBuilder: (c, o, s) => const Icon(Icons.broken_image, width: 80)),
                        title: Text(item.title, maxLines: 2, overflow: TextOverflow.ellipsis),
                        subtitle: Text(item.newsSite),
                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => DetailPage(article: item))),
                      ),
                    );
                  },
                )
              ],
            ),
          );
        },
      ),
    );
  }
}