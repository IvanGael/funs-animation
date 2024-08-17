// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'dart:ui';

class ImageItem {
  final String url;
  final String category;

  ImageItem({required this.url, required this.category});
}

class BlurrySearchScreen extends StatefulWidget {
  const BlurrySearchScreen({super.key});

  @override
  _BlurrySearchScreenState createState() => _BlurrySearchScreenState();
}

class _BlurrySearchScreenState extends State<BlurrySearchScreen> {
  final ScrollController _scrollController = ScrollController();
  double _blurValue = 0;
  bool _isExpanded = false;
  String? _selectedCategory;

  final List<String> categories = ['Nature', 'City', 'Animals', 'Food', 'Technology'];
  late List<ImageItem> images;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _generateImages();
  }

  void _generateImages() {
    images = List.generate(30, (index) {
      return ImageItem(
        url: 'https://picsum.photos/200/200?random=$index',
        category: categories[index % categories.length],
      );
    });
  }

  void _onScroll() {
    setState(() {
      _blurValue = (_scrollController.offset / 100).clamp(0, 10);
    });
  }

  void _filterImages(String? category) {
    setState(() {
      _selectedCategory = category;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<ImageItem> filteredImages = _selectedCategory == null
        ? images
        : images.where((image) => image.category == _selectedCategory).toList();

    return Scaffold(
      body: Stack(
        children: [
          CustomScrollView(
            controller: _scrollController,
            slivers: [
              // const SliverToBoxAdapter(
              //   child: SizedBox(height: 80),
              // ),
              SliverGrid(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      return ImageTile(
                        imageItem: filteredImages[index],
                        blurValue: _blurValue,
                      );
                    },
                    childCount: filteredImages.length,
                  ),
                )
            ],
          ),
          Positioned(
            top: 40,
            left: 0,
            right: 0,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                height: _isExpanded ? 200 : 120,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: AppBar(
                    backgroundColor: Colors.purpleAccent.shade700,
                    elevation: 0,
                    title: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: _isExpanded ? MediaQuery.of(context).size.width - 32 : 200,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left: 12),
                            child: Icon(Icons.search, color: Colors.grey),
                          ),
                          Expanded(
                            child: TextField(
                              decoration: InputDecoration(
                                hintText: 'Search photo',
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.symmetric(horizontal: 12),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    actions: [
                      IconButton(
                        icon: Icon(_isExpanded ? Icons.close : Icons.search, color: Colors.white),
                        onPressed: () {
                          setState(() {
                            _isExpanded = !_isExpanded;
                          });
                        },
                      ),
                    ],
                    bottom: _isExpanded
                        ? PreferredSize(
                            preferredSize: const Size.fromHeight(60),
                            child: Wrap(
                              children: [
                                const SizedBox(width: 12),
                                FilterChip(
                                  label: const Text('All'),
                                  selected: _selectedCategory == null,
                                  onSelected: (_) => _filterImages(null),
                                ),
                                ...categories.map((category) => Padding(
                                      padding: const EdgeInsets.only(left: 8.0),
                                      child: FilterChip(
                                        label: Text(category),
                                        selected: _selectedCategory == category,
                                        onSelected: (_) => _filterImages(category),
                                      ),
                                    )),
                                const SizedBox(width: 12),
                              ],
                            ),
                          )
                        : null,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}

class ImageTile extends StatelessWidget {
  final ImageItem imageItem;
  final double blurValue;

  const ImageTile({super.key, required this.imageItem, required this.blurValue});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Stack(
        fit: StackFit.expand,
        children: [
          ImageFiltered(
            imageFilter: ImageFilter.blur(sigmaX: blurValue, sigmaY: blurValue),
            child: Image.network(
              imageItem.url,
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            bottom: 8,
            left: 8,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.6),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                imageItem.category,
                style: const TextStyle(color: Colors.white, fontSize: 12),
              ),
            ),
          ),
        ],
      ),
    );
  }
}