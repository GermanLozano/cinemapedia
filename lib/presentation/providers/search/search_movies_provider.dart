
// implementacion de la clase para los provider de la busqueda 
// de las peliculas

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/presentation/providers/providers.dart';


final searchQueryProvider = StateProvider<String >((ref) => '');

// metodo para las peliculas previamente buscadas 
final searchedMoviesProvider = StateNotifierProvider<SearchedMoviesNotifier, List<Movie>>((ref) {

  final movieRepository = ref.read(movieRepositoryProvider);

  return  SearchedMoviesNotifier(
    searchMovies: movieRepository.searchMovies, 
    ref: ref
  );
});

// creamos el notifier 
typedef SearchMoviesCallback = Future<List<Movie>> Function(String query);

class SearchedMoviesNotifier extends StateNotifier<List<Movie>> {

  final SearchMoviesCallback searchMovies;
  final Ref ref;

  SearchedMoviesNotifier({ 
    required this.searchMovies,
    required this.ref
  }): super([]);

  Future<List<Movie>> searMoviesByQuery ( String query ) async {

    final List<Movie> movies = await searchMovies(query);
    ref.read(searchQueryProvider.notifier).update((state) => query);
    
    state = movies;
    return movies;
  }

}