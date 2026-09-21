import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../../data/models/movie_model.dart';

class MovieCard extends StatelessWidget {
  final MovieModel movie;
  final double width;
  final double height;
  final VoidCallback? onTap;

  const MovieCard({
    super.key,
    required this.movie,
    this.width = 110,
    this.height = 160,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final posterUrl = movie.fullPosterPath;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        height: height,
        margin: const EdgeInsets.only(right: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          color: Colors.grey[900],
        ),
        clipBehavior: Clip.antiAlias,
        child: posterUrl.isNotEmpty
            ? CachedNetworkImage(
                imageUrl: posterUrl,
                width: width,
                height: height,
                fit: BoxFit.cover,
                placeholder: (context, url) => Shimmer.fromColors(
                  baseColor: Colors.grey[900]!,
                  highlightColor: Colors.grey[800]!,
                  child: Container(color: Colors.grey[900]),
                ),
                errorWidget: (context, url, error) => _buildFallbackPoster(),
              )
            : _buildFallbackPoster(),
      ),
    );
  }

  Widget _buildFallbackPoster() {
    return Container(
      color: Colors.grey[850],
      padding: const EdgeInsets.all(8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.movie, color: Colors.white54, size: 32),
          const SizedBox(height: 6),
          Text(
            movie.title,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(color: Colors.white70, fontSize: 11),
          ),
        ],
      ),
    );
  }
}
