// ignore_for_file: library_private_types_in_public_api, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';
import 'package:xml/xml.dart' as xml;
import 'package:animations/animations.dart';

// https://www.wprssaggregator.com/twitter-rss/
// https://rss.app/myfeeds

class RSSFeedPage extends StatefulWidget {
  const RSSFeedPage({super.key});

  @override
  _RSSFeedPageState createState() => _RSSFeedPageState();
}

class _RSSFeedPageState extends State<RSSFeedPage>
    with SingleTickerProviderStateMixin {
  final String teslaFeedUrl = 'https://rss.app/feeds/b4aG90gKc02d6d4V.xml';
  final String googleFeedUrl = 'https://rss.app/feeds/5n6PvxNksAWoLb6v.xml';
  final String microsoftFeedUrl = 'https://rss.app/feeds/frqH40X7lgeLQBso.xml';
  final String mediumFeedUrl = 'https://rss.app/feeds/HARwBraf9I7mHcTB.xml';
  final String bbcNewsFeedUrl = 'https://rss.app/feeds/OOia0WmSJfl3jHgm.xml';
  final String hackerNewsFeedUrl = 'https://rss.app/feeds/ntSg65DHDWxZ6Aws.xml';
  final String instagramFeedUrl = 'https://rss.app/feeds/JqXkuDRfPlc1QJyU.xml';
  final String youtubeFeedUrl = 'https://rss.app/feeds/y0tJ4V9wwXgshRFD.xml';
  late Future<List<RSSItem>> feed;

  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 8, vsync: this);

    feed = fetchFeed(teslaFeedUrl);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<List<RSSItem>> fetchFeed(String feedUrl) async {
    final response = await http.get(Uri.parse(feedUrl));
    if (response.statusCode == 200) {
      final document = xml.XmlDocument.parse(response.body);
      final items = document.findAllElements('item');
      return items.map((node) {
        final title = node.findElements('title').single.text;
        final pubDate = node.findElements('pubDate').single.text;
        final description = node.findElements('description').single.text;
        final imageUrl = node.findElements('media:content').isNotEmpty
            ? node.findElements('media:content').single.getAttribute('url') ??
                ''
            : node.findElements('enclosure').isNotEmpty
                ? node.findElements('enclosure').single.getAttribute('url') ??
                    ''
                : '';
        final categories = node.findElements('categories').map((e) => e.text).toList();
        final comments = node.findElements('comments').isNotEmpty
            ? node.findElements('comments').single.text
            : '';
        return RSSItem(
            title: title,
            pubDate: pubDate,
            description: description,
            image: imageUrl,
            categories: categories,
            comments: comments);
      }).toList();
    } else {
      throw Exception('Failed to load feed');
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 8,
        child: Scaffold(
          appBar: AppBar(
            title: const Text(
              'Feed.',
              style: TextStyle(
                  fontSize: 23, fontWeight: FontWeight.bold, letterSpacing: 3),
            ),
            actions: [
              IconButton(
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all(Colors.white)
                ),
                onPressed: (){

                }, 
                icon: const Icon(Icons.assignment, color: Colors.black,)
              )
            ],
            bottom: TabBar(
              controller: _tabController,
              isScrollable: true,
              tabAlignment: TabAlignment.start,
              tabs: [
                Tab(
                    icon: Image.asset(
                      "assets/tesla.jpg",
                      width: 30,
                      height: 30,
                    ),
                    text: 'Tesla'),
                Tab(
                    icon: Image.asset(
                      "assets/google.jpg",
                      width: 30,
                      height: 30,
                    ),
                    text: 'Google'),
                Tab(
                    icon: Image.asset(
                      "assets/microsoft.jpg",
                      width: 30,
                      height: 30,
                    ),
                    text: 'Microsoft'),
                Tab(
                    icon: Image.asset(
                      "assets/medium.png",
                      width: 30,
                      height: 30,
                    ),
                    text: 'Medium'),
                Tab(
                    icon: Image.asset(
                      "assets/bbc-news.png",
                      width: 30,
                      height: 30,
                    ),
                    text: 'Bbc News'),
                Tab(
                    icon: Image.asset(
                      "assets/hacker-news.png",
                      width: 30,
                      height: 30,
                    ),
                    text: 'Hacker News'),
                Tab(
                    icon: Image.asset(
                      "assets/instagram.png",
                      width: 30,
                      height: 30,
                    ),
                    text: 'Instagram'),
                Tab(
                    icon: Image.asset(
                      "assets/youtube.png",
                      width: 30,
                      height: 30,
                    ),
                    text: 'Youtube'),
              ],
              indicatorColor: Colors.blue.shade500,
              labelColor: Colors.white,
              unselectedLabelColor: Colors.grey,
              // dividerHeight: 2,
              onTap: (index) {
                if (index == 0) {
                  setState(() {
                    feed = fetchFeed(teslaFeedUrl);
                  });
                } else if (index == 1) {
                  setState(() {
                    feed = fetchFeed(googleFeedUrl);
                  });
                } else if (index == 2) {
                  setState(() {
                    feed = fetchFeed(microsoftFeedUrl);
                  });
                } else if (index == 3) {
                  setState(() {
                    feed = fetchFeed(mediumFeedUrl);
                  });
                } else if (index == 4) {
                  setState(() {
                    feed = fetchFeed(bbcNewsFeedUrl);
                  });
                } else if (index == 5) {
                  setState(() {
                    feed = fetchFeed(hackerNewsFeedUrl);
                  });
                } else if (index == 6) {
                  setState(() {
                    feed = fetchFeed(instagramFeedUrl);
                  });
                } else if (index == 7) {
                  setState(() {
                    feed = fetchFeed(youtubeFeedUrl);
                  });
                }
                _tabController.animateTo(index);
              },
            ),
          ),
          body: TabBarView(
            controller: _tabController, 
            children: [
            FutureBuilder<List<RSSItem>>(
              future: feed,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                      child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Lottie.asset("assets/searching.json",
                          width: 100, height: 100),
                      const Text("Fetching news from rss feed...")
                    ],
                  ));
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No data found.'));
                } else {
                  final feedItems = snapshot.data!;
                  return ListView.builder(
                    itemCount: feedItems.length,
                    itemBuilder: (context, index) {
                      final item = feedItems[index];
                      return FeedItemTile(item: item);
                    },
                  );
                }
              },
            )
          ]),
        ));
  }
}

/// RSSItem is rss item model class
class RSSItem {
  final String title;
  final String pubDate;
  final String description;
  final String image;
  final List<String> categories;
  final String comments;

  RSSItem(
      {required this.title,
      required this.pubDate,
      required this.description,
      required this.image,
      required this.categories,
      required this.comments});
}

class FeedItemTile extends StatelessWidget {
  final RSSItem item;

  const FeedItemTile({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: OpenContainer(
        transitionType: ContainerTransitionType.fadeThrough,
        openBuilder: (context, _) => FeedItemDetail(item: item),
        closedElevation: 5.0,
        closedShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
          side: const BorderSide(color: Colors.white, width: 0.5)
        ),
        closedColor: Theme.of(context).cardColor,
        closedBuilder: (context, openContainer) {
          return ListTile(
            title: Column(
              children: [
                if (item.image.isNotEmpty)
                  Image.network(
                    item.image,
                    width: double.infinity,
                    height: 200,
                    fit: BoxFit.fitWidth,
                  ),
                if (item.image.isEmpty)
                  Image.asset(
                    "assets/image_not_found.png",
                    width: double.infinity,
                    height: 200,
                    fit: BoxFit.fitWidth,
                  ),
                const SizedBox(
                  height: 14,
                ),
                Text(item.title),
              ],
            ),
            subtitle: Text(item.pubDate),
            onTap: openContainer,
          );
        },
      ),
    );
  }
}

class FeedItemDetail extends StatelessWidget {
  final RSSItem item;

  const FeedItemDetail({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(item.title)
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (item.image.isNotEmpty)
                Image.network(
                  item.image,
                  width: double.infinity,
                  height: 200,
                  fit: BoxFit.fitWidth,
                ),
              if (item.image.isEmpty)
                Image.asset(
                  "assets/image_not_found.png",
                  width: double.infinity,
                  height: 200,
                  fit: BoxFit.fitWidth,
                ),
              const SizedBox(
                height: 20,
              ),
              Text(
                item.title,
              ),
              const SizedBox(height: 8),
              Text(
                item.pubDate,
              ),
              const SizedBox(height: 8),
              Text(item.description),
              const SizedBox(height: 8),
              item.categories.isNotEmpty
                  ? Wrap(
                      spacing: 6.0,
                      children: item.categories
                          .map((category) => Chip(label: Text(category)))
                          .toList(),
                    )
                  : const SizedBox.shrink(),
              const SizedBox(height: 8),
              item.comments.isNotEmpty
                  ? Text(
                      'Comments: ${item.comments}',
                    )
                  : const SizedBox.shrink(),
            ],
          ),
        ),
      ),
    );
  }
}
