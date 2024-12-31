// implementacion de la fuente de datos de almacenamiento local (isar data base)

import 'package:cinemapedia/domain/entities/movie.dart';

abstract class LocalStorageDatasource {

  // para altervar las peliculas favoritas
  Future<void> toggleFavorite(Movie movie);

  // para saber si la pelicula es favorita
  Future<bool> isMovieFavorite(int movieId);

  // para cargar las peliculas 
  Future<List<Movie>> loadMovies({int limit=10, offset=0});

}