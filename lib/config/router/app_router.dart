
import 'package:go_router/go_router.dart';
import 'package:cinemapedia/presentation/screens/screens.dart';


final appRouter = GoRouter(
  initialLocation: '/',
  routes: [

    GoRoute(
      path: '/',
      name: HomeScreen.name,
      builder: (context, state) => const HomeScreen(),
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
  ]
);