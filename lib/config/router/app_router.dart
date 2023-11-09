
import 'package:go_router/go_router.dart';

import 'package:cinemapedia/presentation/screens/screens.dart';


final appRouter = GoRouter(
  initialLocation: '/home/0',
  routes: [

    GoRoute(
        path: '/home/:page',
        name: HomeScreen.name,
          builder: (context, state) {
            final pageIndex = int.parse(state.pathParameters['page'] ?? '0');

            return HomeScreen(pageIndex: pageIndex);
          },

          routes: [
            GoRoute(
            path: 'movie/:id',
            name: MovieScreen.name,
              builder: (context, state) {
                final movieId = state.pathParameters['id'] ?? 'no-id';   // Accede al parámetro 'id' de state.params

                // Utiliza el movieId obtenido en la pantalla MovieScreen
                return MovieScreen(movieId: movieId);
                },
              ),
            ]
          ),

      // configuracion para navegar entre la pelicula y regresar al home
      GoRoute(
        path: '/',
        redirect: (_, __) => '/home/0',
        
      )


    // implementacion oficial de Go Routers
    // ShellRoute(
    //   builder: (context, state, child) {
    //     return HomeScreen(childView: child);
    //   },

    //   routes: [

    //     GoRoute(
    //       path: '/',
    //       builder: (context, state) {
    //         return const HomeView();
    //       },
    //       routes: [
    //        GoRoute(
    //         path: 'movie/:id', 
    //         name: MovieScreen.name,
    //           builder: (context, state) {
    //             final movieId = state.pathParameters['id'] ?? 'no-id';   // Accede al parámetro 'id' de state.params

    //             // Utiliza el movieId obtenido en la pantalla MovieScreen
    //             return MovieScreen(movieId: movieId);
    //           },
    //         ),
    //       ]        ),

    //     GoRoute(
    //       path: '/favorites',
    //       builder: (context, state) {
    //         return const FavoritesViews();
    //       },
    //     )

    //   ]
    // )


    // implementacion mejorada de Go Routers
    // rutas padre/ hijo

    
  ]
);