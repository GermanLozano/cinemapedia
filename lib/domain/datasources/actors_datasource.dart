
// clase para hacer la fuente de datos para los actores

import 'package:cinemapedia/domain/entities/actor.dart';

abstract class ActorsDatasource {

  Future<List<Actor>> getActorsByMovie (String movieId);
  
  

} 