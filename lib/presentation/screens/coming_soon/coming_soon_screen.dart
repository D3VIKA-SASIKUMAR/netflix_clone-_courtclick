import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/models/movie_model.dart';
import '../../bloc/coming_soon/coming_soon_bloc.dart';
import '../../bloc/coming_soon/coming_soon_event.dart';
import '../../bloc/coming_soon/coming_soon_state.dart';
import '../../widgets/error_view.dart';
import '../details/details_screen.dart';

class ComingSoonScreen extends StatefulWidget {
  const ComingSoonScreen({super.key});

  @override
  State<ComingSoonScreen> createState() => _ComingSoonScreenState();
}

class _ComingSoonScreenState extends State<ComingSoonScreen> {
  final ScrollController _scrollController = ScrollController();
  final Set<int> _remindedMovieIds = {};

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isBottom) {
      context.read<ComingSoonBloc>().add(LoadMoreUpcomingMovies());
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.85);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: const Color(0xFF121212),
        elevation: 0,
        title: Row(
          children: [
            CircleAvatar(
              radius: 12,
              backgroundColor: Colors.red[700],
              child: const Icon(Icons.notifications, color: Colors.white, size: 14),
            ),
            const SizedBox(width: 8),
            const Text(
              'Notifications',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
      body: BlocBuilder<ComingSoonBloc, ComingSoonState>(
        builder: (context, state) {
          if (state is ComingSoonLoading || state is ComingSoonInitial) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.red),
            );
          }

          if (state is ComingSoonError) {
            return ErrorView(
              message: state.message,
              onRetry: () {
                context
                    .read<ComingSoonBloc>()
                    .add(const FetchUpcomingMovies());
              },
            );
          }

          if (state is ComingSoonLoaded) {
            return RefreshIndicator(
              color: Colors.red,
              backgroundColor: Colors.black,
              onRefresh: () async {
                context
                    .read<ComingSoonBloc>()
                    .add(const FetchUpcomingMovies(isRefresh: true));
              },
              child: ListView.builder(
                controller: _scrollController,
                itemCount: (state.isFetchingMore
                        ? state.movies.length + 1
                        : state.movies.length) +
                    1, // +1 for Notifications header
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return _buildNotificationHeader();
                  }

                  final movieIndex = index - 1;
                  if (movieIndex >= state.movies.length) {
                    return const Padding(
                      padding: EdgeInsets.symmetric(vertical: 24),
                      child: Center(
                        child: CircularProgressIndicator(color: Colors.red),
                      ),
                    );
                  }

                  final movie = state.movies[movieIndex];
                  return _buildUpcomingCard(context, movie);
                },
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildNotificationHeader() {
    return Container(
      color: const Color(0xFF424242),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        children: [
          _buildNotificationItem(
            imageAsset: 'assets/images/Rectangle 2.png',
            title: 'El Chapo',
            subtitle: 'New Arrival',
            date: 'Nov 6',
          ),
          const SizedBox(height: 8),
          _buildNotificationItem(
            imageAsset: 'assets/images/Rectangle 3.png',
            title: 'Peaky Blinders',
            subtitle: 'New Arrival',
            date: 'Nov 6',
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationItem({
    required String imageAsset,
    required String title,
    required String subtitle,
    required String date,
  }) {
    return Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: Image.asset(
            imageAsset,
            width: 110,
            height: 55,
            fit: BoxFit.cover,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                subtitle,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                date,
                style: TextStyle(
                  color: Colors.grey[400],
                  fontSize: 10,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildUpcomingCard(BuildContext context, MovieModel movie) {
    final isReminded = _remindedMovieIds.contains(movie.id);
    final backdropUrl = movie.fullBackdropPath.isNotEmpty
        ? movie.fullBackdropPath
        : movie.fullPosterPath;

    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 16:9 Backdrop Image
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => MovieDetailsScreen(movie: movie),
                ),
              );
            },
            child: AspectRatio(
              aspectRatio: 16 / 9,
              child: backdropUrl.isNotEmpty
                  ? CachedNetworkImage(
                      imageUrl: backdropUrl,
                      fit: BoxFit.cover,
                      errorWidget: (context, url, error) => Container(
                        color: Colors.grey[900],
                        child: const Icon(Icons.movie, size: 50, color: Colors.white30),
                      ),
                    )
                  : Container(color: Colors.grey[900]),
            ),
          ),

          const SizedBox(height: 12),

          // Date & Actions Row
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _formatReleaseDate(movie.releaseDate),
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        movie.title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          if (isReminded) {
                            _remindedMovieIds.remove(movie.id);
                          } else {
                            _remindedMovieIds.add(movie.id);
                          }
                        });
                      },
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            isReminded ? Icons.notifications : Icons.notifications_none,
                            color: Colors.white,
                            size: 24,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            isReminded ? 'Reminded' : 'Remind Me',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 24),
                    GestureDetector(
                      onTap: () {},
                      child: const Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.share, color: Colors.white, size: 24),
                          SizedBox(height: 4),
                          Text(
                            'Share',
                            style: TextStyle(color: Colors.white, fontSize: 10),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 8),

          // Overview & Genre Tags
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  movie.overview ?? 'No overview available for this upcoming release.',
                  maxLines: 4,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Steamy • Soapy • Slow Burn • Suspenseful • Teen • Mystery',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatReleaseDate(String? rawDate) {
    if (rawDate == null || rawDate.isEmpty) return 'Season 1 Coming December 14';
    final parts = rawDate.split('-');
    if (parts.length < 3) return 'Season 1 Coming ($rawDate)';
    final monthInt = int.tryParse(parts[1]) ?? 12;
    final day = parts[2];

    final months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    final monthName = months[(monthInt - 1).clamp(0, 11)];

    return 'Season 1 Coming $monthName $day';
  }
}
