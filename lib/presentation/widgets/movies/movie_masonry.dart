
// clase para la implementacion de la vista con estilo masonry

import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/presentation/widgets/movies/movie_poster_link.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class MovieMasonry extends StatefulWidget {

  final List<Movie> movies;
  final VoidCallback? loadNextPage;

  const MovieMasonry({
    super.key, 
    required this.movies, 
    this.loadNextPage
  });

  @override
  State<MovieMasonry> createState() => _MovieMasonryState();
}

class _MovieMasonryState extends State<MovieMasonry> {
  
  // todo initState

  // todo disponse

  @override
  Widget build(BuildContext context) {
    // configuracion del masonry gridViw
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: MasonryGridView.count(
        crossAxisCount: 3,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        itemCount: widget.movies.length,
        itemBuilder: (context, index) {
          
          if( index==1 ){
            const SizedBox(height: 40);
            return MoviePosterLink( movie: widget.movies[index]);
          }
          return MoviePosterLink( movie: widget.movies[index]);
        },
      ),
    );
  }
}
