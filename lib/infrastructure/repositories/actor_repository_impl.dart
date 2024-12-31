
// en esta clase se implementa el respositorio para los actores

import 'package:cinemapedia/domain/datasources/actors_datasource.dart';
import 'package:cinemapedia/domain/entities/actor.dart';
import 'package:cinemapedia/domain/repositories/actors_repository.dart';

// el objetivo es que el provider pueda tomar datasource que se le indique
// y poder cambiarlos facilmente, un puente con el gestor de estado y el datasource

class ActorRespositoryImpl extends ActorsRepository {

  final ActorsDatasource datasource;
  ActorRespositoryImpl(this.datasource);
  
  @override
  Future<List<Actor>> getActorsByMovie(String movieId) {
    return datasource.getActorsByMovie(movieId);
  }

}