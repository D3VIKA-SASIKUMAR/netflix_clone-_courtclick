import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/di/service_locator.dart';
import '../bloc/home/home_bloc.dart';
import '../bloc/home/home_event.dart';
import '../bloc/search/search_bloc.dart';
import '../bloc/search/search_event.dart';
import '../bloc/coming_soon/coming_soon_bloc.dart';
import '../bloc/coming_soon/coming_soon_event.dart';
import 'home/home_screen.dart';
import 'search/search_screen.dart';
import 'coming_soon/coming_soon_screen.dart';
import 'downloads/downloads_screen.dart';
import 'profile/profile_screen.dart';

class MainNavigationScreen extends StatefulWidget {
  static const path = '/main_navigation';

  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;

  late final HomeBloc _homeBloc;
  late final SearchBloc _searchBloc;
  late final ComingSoonBloc _comingSoonBloc;

  @override
  void initState() {
    super.initState();
    _homeBloc = getIt<HomeBloc>()..add(const FetchHomeData());
    _searchBloc = getIt<SearchBloc>();
    _comingSoonBloc = getIt<ComingSoonBloc>();

    // Stagger secondary tab pre-fetching to prevent network socket congestion on launch
    Future.microtask(() {
      _searchBloc.add(LoadPopularSearches());
      _comingSoonBloc.add(const FetchUpcomingMovies());
    });
  }

  @override
  void dispose() {
    _homeBloc.close();
    _searchBloc.close();
    _comingSoonBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screens = [
      BlocProvider.value(
        value: _homeBloc,
        child: const HomeScreen(),
      ),
      BlocProvider.value(
        value: _searchBloc,
        child: const SearchScreen(),
      ),
      BlocProvider.value(
        value: _comingSoonBloc,
        child: const ComingSoonScreen(),
      ),
      const DownloadsScreen(),
      const ProfileScreen(),
    ];

    return Scaffold(
      backgroundColor: Colors.black,
      body: IndexedStack(
        index: _currentIndex,
        children: screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color(0xFF121212),
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.grey[600],
        selectedFontSize: 10,
        unselectedFontSize: 10,
        items: [
          const BottomNavigationBarItem(
            icon: Icon(Icons.home_filled),
            label: 'Home',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Stack(
              clipBehavior: Clip.none,
              children: [
                const Icon(Icons.video_library_outlined),
                Positioned(
                  right: -4,
                  top: -2,
                  child: Container(
                    padding: const EdgeInsets.all(2.5),
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 14,
                      minHeight: 14,
                    ),
                    child: const Text(
                      '4',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            label: 'Coming Soon',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.file_download_outlined),
            label: 'Downloads',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.menu),
            label: 'More',
          ),
        ],
      ),
    );
  }
}
