import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:satyavratnova_task2/screens/feed_screen.dart';
import '../models/post_model.dart';
import '../widgets/post_card.dart';
import 'map_screen.dart';

class HomeScreen extends StatefulWidget {
  final String cityName;

  const HomeScreen({super.key, required this.cityName});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _bottomNavIndex = 0;
  final List<PostModel> _posts = getDummyPosts();

  final List<String> _tabs = ['Post', 'Nova', 'News', 'Article'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ));
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6F7),
      body: SafeArea(
        child: Column(
          children: [
            _buildAppBar(),
            _buildTabBar(),
            Expanded(child: _buildFeed()),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNav(),
      floatingActionButton: _buildFAB(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Widget _buildAppBar() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => FeedScreen(),
                ),
              );
            },
            child: const Icon(Icons.menu, size: 24, color: Color(0xFF1A1A1A)),
          ),

          RichText(
            text: const TextSpan(
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                letterSpacing: -0.5,
              ),
              children: [
                TextSpan(
                    text: 'BHARAT',
                    style: TextStyle(color: Color(0xFF1A1A1A))),
                TextSpan(
                  text: 'N',
                  style: TextStyle(color: Color(0xFF2B3A8C)),
                ),
                TextSpan(
                  text: '◉',
                  style: TextStyle(
                    color: Color(0xFF2B3A8C),
                    fontSize: 18,
                  ),
                ),
                TextSpan(
                    text: 'VA',
                    style: TextStyle(color: Color(0xFF1A1A1A))),
              ],
            ),
          ),

          GestureDetector(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => MapScreen(cityName: widget.cityName),
              ),
            ),
            child: Container(
              padding:
              const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: const Color(0xFFF0F2FA),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                    color: const Color(0xFF2B3A8C).withOpacity(0.2),
                    width: 1),
              ),
              child: Row(
                children: [
                  const Icon(Icons.location_on,
                      size: 13, color: Color(0xFF2B3A8C)),
                  const SizedBox(width: 4),
                  Text(
                    widget.cityName,
                    style: const TextStyle(
                      fontSize: 13,
                      color: Color(0xFF2B3A8C),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          TabBar(
            controller: _tabController,
            tabs: _tabs
                .map((t) => Tab(
              child: Text(
                t,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ))
                .toList(),
            labelColor: const Color(0xFF2B3A8C),
            unselectedLabelColor: const Color(0xFF999999),
            indicatorColor: const Color(0xFF2B3A8C),
            indicatorWeight: 2.5,
            indicatorSize: TabBarIndicatorSize.label,
            dividerColor: const Color(0xFFE8E8E8),
          ),
        ],
      ),
    );
  }

  Widget _buildFeed() {
    return TabBarView(
      controller: _tabController,
      children: [
        ListView.builder(
          padding: EdgeInsets.zero,
          itemCount: _posts.length,
          itemBuilder: (ctx, i) => PostCard(post: _posts[i]),
        ),
        ..._tabs
            .skip(1)
            .map(
              (_) => Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.newspaper_outlined,
                    size: 48, color: Color(0xFFCCCCCC)),
                const SizedBox(height: 12),
                Text(
                  'Coming soon',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[400],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBottomNav() {
    final items = [
      {'icon': Icons.home_outlined, 'activeIcon': Icons.home},
      {'icon': Icons.search_outlined, 'activeIcon': Icons.search},
      {'icon': Icons.bar_chart_outlined, 'activeIcon': Icons.bar_chart},
      {'icon': Icons.play_circle_outline, 'activeIcon': Icons.play_circle},
      {'icon': Icons.notifications_outlined, 'activeIcon': Icons.notifications},
      {'icon': Icons.person_outline, 'activeIcon': Icons.person},
    ];

    return Container(
      height: 60,
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Color(0xFFEEEEEE), width: 1)),
      ),
      child: Row(
        children: List.generate(items.length, (i) {
          if (i == 2) return const Spacer();
          final isActive = _bottomNavIndex == i;
          return Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _bottomNavIndex = i),
              behavior: HitTestBehavior.opaque,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    isActive
                        ? items[i]['activeIcon'] as IconData
                        : items[i]['icon'] as IconData,
                    size: 22,
                    color: isActive
                        ? const Color(0xFF2B3A8C)
                        : const Color(0xFF999999),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildFAB() {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        color: const Color(0xFF2B3A8C),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF2B3A8C).withOpacity(0.4),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: const Icon(Icons.add, color: Colors.white, size: 26),
    );
  }
}