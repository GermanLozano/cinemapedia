
// clase para la implementacion de la vista de favoritos 

import 'package:cinemapedia/presentation/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cinemapedia/presentation/providers/providers.dart';

class FavoritesView extends ConsumerStatefulWidget {
  const FavoritesView({super.key});

  @override
  FavoritesViewState createState() => FavoritesViewState();
}

class FavoritesViewState extends ConsumerState<FavoritesView> {

  bool isLastPage = false;
  bool isLoading = false;

  // init state para acceder al provider favoriteMoviesProvider
  @override
  void initState() {
    super.initState();
    
    loadNextPage();

  }

  // metodo para cargar la siguien pagina en el infinityScroll
  void loadNextPage() async{

    if( isLoading || isLastPage ) return;
    isLoading = true;

    final movies = await ref.read(favoriteMoviesProvider.notifier).loadNextPage();
    isLoading = false ;

    if( movies.isEmpty){
      isLastPage = true;
    }

  } 

  @override
  Widget build(BuildContext context) {

    // leemos el Mapa de peliculas y lo convertimos en una lista 
    final favoriteMovies = ref.watch(favoriteMoviesProvider).values.toList();

    return Scaffold(
      body: MovieMasonry(movies: favoriteMovies)
    );
  }
}