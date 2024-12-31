// implementacion del repositorio para la fuente de datos 
// de almacenamiento local 

import 'package:cinemapedia/domain/entities/movie.dart';

abstract class LocalStorageRepository {
  // para altervar las peliculas favoritas
  Future<void> toggleFavorite(Movie movie);

  // para saber si la pelicula es favorita
  Future<bool> isMovieFavorite(int movieId);

  // para cargar las peliculas 
  Future<List<Movie>> loadMovies({int limit=10, offset=0});
} 