
// clase para la implementacion de la vista con estilo masonry

import 'package:flutter/material.dart';
import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import 'movie_poster_link.dart';


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
  
  // implementacion del Infinity Scroll
  final scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    
    scrollController.addListener(() { 
      if ( widget.loadNextPage == null ) return;

      if ( (scrollController.position.pixels + 100) >= scrollController.position.maxScrollExtent ) {
        widget.loadNextPage!();
      }

    });

  }

  // implementacion del dispose
  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    // configuracion del masonry gridViw
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: MasonryGridView.count(
        controller: scrollController,
        crossAxisCount: 3,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        itemCount: widget.movies.length,
        itemBuilder: (context, index) {

          // configuracion para que se vea algo desordenado la lista de peliculas favoritas
           if ( index == 1 ) {
            return Column(
              children: [
                const SizedBox(height: 40 ),
                MoviePosterLink( movie: widget.movies[index] )
              ],
            );
          }
          
          return MoviePosterLink( movie: widget.movies[index] );
        },
      ),
    );
  }
}
