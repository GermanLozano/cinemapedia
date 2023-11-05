
import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/presentation/providers/movies/movies_repository_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// metodo para llamar las nuevas peluclas 
final nowPlayingMoviesProvider = StateNotifierProvider<MoviesNotifier, List<Movie>>((ref) {
  final fetchMoreMovies = ref.watch(movieRepositoryProvider).getNowPlaying;
  return MoviesNotifier(
    fetchMoreMovies: fetchMoreMovies
  );
});

// metodo para llamar las peliculas populares 
final popularMoviesProvider = StateNotifierProvider<MoviesNotifier, List<Movie>>((ref) {
  final fetchMoreMovies = ref.watch(movieRepositoryProvider).getPopular;
  return MoviesNotifier(
    fetchMoreMovies: fetchMoreMovies
  );
});

// metodo para llamar las peliculas proximas a salir
final upcomingMoviesProvider = StateNotifierProvider<MoviesNotifier, List<Movie>>((ref) {
  final fetchMoreMovies = ref.watch(movieRepositoryProvider).getUpcoming;
  return MoviesNotifier(
    fetchMoreMovies: fetchMoreMovies
  );
});

// metodo para llamar las peliculas mejor calificadas
final topRatedMoviesProvider = StateNotifierProvider<MoviesNotifier, List<Movie>>((ref) {
  final fetchMoreMovies = ref.watch(movieRepositoryProvider).getTopRated;
  return MoviesNotifier(
    fetchMoreMovies: fetchMoreMovies
  );
});



typedef MovieCallback = Future<List<Movie>> Function({int page});

// para proporcionar un listado de movies 
class MoviesNotifier extends StateNotifier<List<Movie>>{

  int currentPage = 0;
  bool isLoading = false;  // bandera para controlar que no se cargen demasiadas paginas de pelicuas
  MovieCallback fetchMoreMovies;

  MoviesNotifier({
    required this.fetchMoreMovies, 
  }): super ([]);
  
  Future<void> loadNextPage() async{
    if(isLoading) return; // se pregunta por el estado de la bandera 

    isLoading = true;  // se camnbia de estado la bandera

    currentPage ++;
    final List<Movie> movies = await fetchMoreMovies(page: currentPage);
    state = [...state, ...movies];

    await Future.delayed(const Duration(milliseconds: 300));  // tiempo de chance para que las peliculas sean renderizadas y no se carguen muy rapido 

    isLoading = false; // se limpia la bandera 
  }

}
