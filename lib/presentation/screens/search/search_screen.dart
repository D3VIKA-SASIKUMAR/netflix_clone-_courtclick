import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/models/movie_model.dart';
import '../../bloc/search/search_bloc.dart';
import '../../bloc/search/search_event.dart';
import '../../bloc/search/search_state.dart';
import '../../widgets/error_view.dart';
import '../details/details_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: const Color(0xFF121212),
        elevation: 0,
        titleSpacing: 12,
        title: Container(
          height: 44,
          decoration: BoxDecoration(
            color: const Color(0xFF424242),
            borderRadius: BorderRadius.circular(4),
          ),
          child: TextField(
            controller: _searchController,
            style: const TextStyle(color: Colors.white, fontSize: 14),
            onChanged: (query) {
              context.read<SearchBloc>().add(SearchQueryChanged(query: query));
            },
            decoration: InputDecoration(
              hintText: 'Search for a show, movie, genre, e.t.c.',
              hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
              prefixIcon: Icon(Icons.search, color: Colors.grey[400], size: 22),
              suffixIcon: _searchController.text.isNotEmpty
                  ? IconButton(
                      icon: Icon(Icons.clear, color: Colors.grey[400], size: 20),
                      onPressed: () {
                        _searchController.clear();
                        context
                            .read<SearchBloc>()
                            .add(const SearchQueryChanged(query: ''));
                        setState(() {});
                      },
                    )
                  : Icon(Icons.mic, color: Colors.grey[400], size: 22),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(vertical: 11),
            ),
          ),
        ),
      ),
      body: BlocBuilder<SearchBloc, SearchState>(
        builder: (context, state) {
          if (state is SearchLoading) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.red),
            );
          }

          if (state is SearchError) {
            return ErrorView(
              message: state.message,
              onRetry: () {
                context.read<SearchBloc>().add(
                      SearchQueryChanged(query: _searchController.text),
                    );
              },
            );
          }

          if (state is SearchEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.search_off_rounded,
                        size: 70, color: Colors.grey[700]),
                    const SizedBox(height: 16),
                    Text(
                      'Oh, we couldn\'t find anything matching "${state.query}"',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Try searching for another movie title, actor, or genre.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey[500], fontSize: 13),
                    ),
                  ],
                ),
              ),
            );
          }

          if (state is PopularSearchesLoaded) {
            return _buildPopularSearchesList(context, state.movies);
          }

          if (state is SearchLoaded) {
            return _buildSearchResultsGrid(context, state.movies);
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildPopularSearchesList(
    BuildContext context,
    List<MovieModel> movies,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(16, 16, 16, 12),
          child: Text(
            'Top Searches',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: movies.length,
            itemBuilder: (context, index) {
              final movie = movies[index];
              return _buildPopularSearchItem(context, movie);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildPopularSearchItem(BuildContext context, MovieModel movie) {
    final backdropUrl = movie.fullBackdropPath.isNotEmpty
        ? movie.fullBackdropPath
        : movie.fullPosterPath;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => MovieDetailsScreen(movie: movie),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 3),
        height: 76,
        color: const Color(0xFF424242),
        child: Row(
          children: [
            SizedBox(
              width: 140,
              height: 76,
              child: backdropUrl.isNotEmpty
                  ? CachedNetworkImage(
                      imageUrl: backdropUrl,
                      fit: BoxFit.cover,
                      errorWidget: (context, url, error) => Container(
                        color: Colors.grey[850],
                        child: const Icon(Icons.movie, color: Colors.white30),
                      ),
                    )
                  : Container(color: Colors.grey[850]),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                movie.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(right: 16),
              child: Icon(
                Icons.play_circle_outline,
                color: Colors.white,
                size: 28,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchResultsGrid(
    BuildContext context,
    List<MovieModel> movies,
  ) {
    return GridView.builder(
      padding: const EdgeInsets.all(12),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 0.67,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: movies.length,
      itemBuilder: (context, index) {
        final movie = movies[index];
        final posterUrl = movie.fullPosterPath;

        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => MovieDetailsScreen(movie: movie),
              ),
            );
          },
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
              color: Colors.grey[900],
            ),
            clipBehavior: Clip.antiAlias,
            child: posterUrl.isNotEmpty
                ? CachedNetworkImage(
                    imageUrl: posterUrl,
                    fit: BoxFit.cover,
                    errorWidget: (context, url, error) => _buildGridFallback(movie),
                  )
                : _buildGridFallback(movie),
          ),
        );
      },
    );
  }

  Widget _buildGridFallback(MovieModel movie) {
    return Container(
      color: Colors.grey[850],
      padding: const EdgeInsets.all(6),
      child: Center(
        child: Text(
          movie.title,
          textAlign: TextAlign.center,
          style: const TextStyle(color: Colors.white70, fontSize: 11),
        ),
      ),
    );
  }
}
