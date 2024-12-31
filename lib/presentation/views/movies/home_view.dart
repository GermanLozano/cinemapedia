
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:cinemapedia/presentation/providers/providers.dart';
import 'package:cinemapedia/presentation/widgets/widgets.dart';

class HomeView extends ConsumerStatefulWidget {
  const HomeView({super.key});

  @override
  HomeViewState createState() => HomeViewState();
}

class HomeViewState extends ConsumerState<HomeView> with AutomaticKeepAliveClientMixin{
  @override
  void initState() {
    super.initState();

    // el puente para mandar a llamar la siguiente pagina
    ref.read(nowPlayingMoviesProvider.notifier).loadNextPage();
    ref.read(popularMoviesProvider.notifier).loadNextPage();
    ref.read(topRatedMoviesProvider.notifier).loadNextPage();
    ref.read(upcomingMoviesProvider.notifier).loadNextPage();

  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final initialLoading = ref.watch(initialLoadingProvider);

    // preguntamos si el initialLouding esta en true
    if (initialLoading) return const FullScreenLoader();

    // esperamos que la app se termine de cargar para remover el splash screen
    FlutterNativeSplash.remove();

    // se manda a llamar la sublista para mostrarla
    final slideShowMovies = ref.watch(moviesSlideshowProvider);
    final nowPlayingMovies = ref.watch(nowPlayingMoviesProvider);
    final toRatedMovies = ref.watch(topRatedMoviesProvider);
    final upcomingMovies = ref.watch(upcomingMoviesProvider);

     return CustomScrollView(  // crea efectos de desplazamientos personalizados
      slivers: [

        const SliverAppBar(
          floating: true,
          flexibleSpace: FlexibleSpaceBar(
            title: CustomAppbar(),
          ),
        ),
        
       SliverList(
          delegate: SliverChildBuilderDelegate((context, index) {
        return Column(
          children: [
            //const CustomAppbar(),

            MoviesSlideshow(movies: slideShowMovies),

            // se manda a llamar la sublista de peliculas
            MovieHorizontalListview(
              movies: nowPlayingMovies,
              title: 'En cine',
              subtitle: 'Lunes 20',
              loadNextpage: () =>
                  ref.read(nowPlayingMoviesProvider.notifier).loadNextPage(),
            ),

            // se manda a llamar la lista de peluculas para mostras en horizontal

            MovieHorizontalListview(
              movies: upcomingMovies,
              title: 'Proximamente',
              subtitle: 'En este mes',
              loadNextpage: () =>
                  ref.read(upcomingMoviesProvider.notifier).loadNextPage(),
            ),

            // ya no estara aqui, ahora es parte del menu inferior
            // MovieHorizontalListview(
            //   movies: popularMovies,
            //   title: 'Populares',
            //   // subtitle: '',
            //   loadNextpage: () => ref
            //       .read(popularMoviesProvider.notifier)
            //       .loadNextPage(),
            // ),

            MovieHorizontalListview(
              movies: toRatedMovies,
              title: 'Mejor calificada',
              subtitle: 'De siempre',
              loadNextpage: () =>
                  ref.read(topRatedMoviesProvider.notifier).loadNextPage(),
            ),

            const SizedBox(height: 10),
          ],
        );
      }, childCount: 1)),
    ]);
  }
  
  @override
  bool get wantKeepAlive => true;
}