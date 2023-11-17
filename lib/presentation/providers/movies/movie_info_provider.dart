
// esta clase permite hacer la implementacion del cache 
// para no volver a cargar una pagina si ya fue cargada, execepto
// si el usuario quiere ver un cambio nuevo 

import 'package:cinemapedia/presentation/providers/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cinemapedia/domain/entities/movie.dart';

// implementacion del provider a ocupar
final movieInfoProvider = StateNotifierProvider<MovieMapNotifier, Map<String, Movie>>((ref) {
  
  final movieRepository = ref.watch(movieRepositoryProvider);

  return MovieMapNotifier(getMovie: movieRepository.getMovieById);
});


// funcion que regresa alfo especifico 
typedef GetMovieCallback = Future<Movie>Function(String movieId);

class MovieMapNotifier extends StateNotifier<Map<String, Movie>>{

  final GetMovieCallback getMovie;

  MovieMapNotifier({
    required this.getMovie
  }): super({});


  Future<void> loadMovie( String movieId) async{
   
   // preguntamos si la movieId esta cargada y no se hace nada
   if (state[movieId] != null ) return;

   // sino esta cargada entonces se hace la peticion http
   final movie = await getMovie(movieId);

   state = {... state, movieId: movie};
  }

}