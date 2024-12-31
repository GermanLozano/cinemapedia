// esta clase nos permite cortar de cero a 6 pelicilas 
// para no moestras todo el listado de peliculas en el carrusel
// provider de solo lectura 

import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'movies_providers.dart';

final moviesSlideshowProvider = Provider<List<Movie>>((ref){

  // leo el provider que esta en home_screen
  final nowPlayingMovies = ref.watch(nowPlayingMoviesProvider);

  // pregunto si esta vasio que me retorne un arreglo vacio
  if(nowPlayingMovies.isEmpty) return[];

  // sino, que me haga una sublista de la lista de peluculas de cero a 6 
  return nowPlayingMovies.sublist(0,6);

});
