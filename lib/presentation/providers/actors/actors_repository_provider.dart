
// clase para definir los repositorios del provider para los actores 



import 'package:cinemapedia/infrastructure/datasources/actor_moviedb_datasource.dart';
import 'package:cinemapedia/infrastructure/repositories/actor_repository_impl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// este repositorio es inmutable, de solo lectura 
final actorsRepositoryProvider = Provider((ref) {
  return ActorRespositoryImpl( ActorMovieDbDatasource() );
}); 