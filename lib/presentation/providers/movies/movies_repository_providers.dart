

import 'package:cinemapedia/infrastructure/datasources/moviedb_datasource.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cinemapedia/infrastructure/repositories/movie_respository_impl.dart';

// este repositorio es inmutable 
final movieRepositoryProvider = Provider((ref) {
return MovieRepositoryImpl( MoviedbDatasource() );
});