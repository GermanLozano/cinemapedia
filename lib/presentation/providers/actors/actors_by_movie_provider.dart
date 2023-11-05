
// estos son los actores de las peliculas 

import 'package:cinemapedia/domain/entities/actor.dart';
import 'package:cinemapedia/presentation/providers/actors/actors_repository_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// implementacion del provider a ocupar
final actorsByMovieProvider = StateNotifierProvider<ActorsByMovieNotifier, Map<String, List<Actor>>>((ref) {
  
  final actorsRepository = ref.watch(actorsRepositoryProvider );

  return ActorsByMovieNotifier (getActors: actorsRepository.getActorsByMovie);
});


// funcion que regresa alfo especifico 
typedef GetActorsCallback = Future<List<Actor>>Function(String movieId);

class ActorsByMovieNotifier extends StateNotifier<Map<String, List<Actor>>>{

  final GetActorsCallback getActors;

  ActorsByMovieNotifier({
    required this.getActors
  }): super({});


  Future<void> loadActors( String movieId) async{
   
   // preguntamos si la movieId esta cargada y no se hace nada
   if (state[movieId] != null ) return;

   // sino esta cargada entonces se hace la peticion http
   final List<Actor> actors = await getActors(movieId);

   state = {... state, movieId: actors };
  }

}