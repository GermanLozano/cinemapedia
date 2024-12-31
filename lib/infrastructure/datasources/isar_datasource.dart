// clase para la implementacion del DataBase y el Repositorio del DataBase

import 'package:path_provider/path_provider.dart';

import 'package:cinemapedia/domain/datasources/local_storage_datasource.dart';
import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:isar/isar.dart';



class IsarDatasource extends LocalStorageDatasource {
  
  late Future<Isar> db;

  IsarDatasource() {
    db = openDB();
  }

  Future<Isar> openDB() async {

    //abrimos la base de datos
    if ( Isar.instanceNames.isEmpty ) {
      final dir = await getApplicationDocumentsDirectory();
      return await Isar.open([ MovieSchema ], inspector: true, directory: dir.path);
    }

    // o devolvemos la instancia que ya existia
    return Future.value(Isar.getInstance());
  }

  // implementamos lo metodis necesarios
  @override
  Future<bool> isMovieFavorite(int movieId) async {
    final isar = await db;

    final Movie? isFavoriteMovie = await isar.movies
      .filter()
      .idEqualTo(movieId)
      .findFirst();

    return isFavoriteMovie != null;
  }

  @override
  Future<void> toggleFavorite(Movie movie) async {
    
    final isar = await db;

    // para actualizar ocupamos lo siguien
    final favoriteMovie = await isar.movies
      .filter()
      .idEqualTo(movie.id)
      .findFirst();
      
      // ahora preguntamos
    if ( favoriteMovie != null ) {
      // Borramos
      isar.writeTxnSync(() => isar.movies.deleteSync( favoriteMovie.isarId! ));
      return;
    }

    // Insertamos
    isar.writeTxnSync(() => isar.movies.putSync(movie));

  }

  
  @override
  Future<List<Movie>> loadMovies({int limit = 10, offset = 0}) async {
    
    final isar = await db;

    return isar.movies.where()
      .offset(offset)
      .limit(limit)
      .findAll();
  }

 }
