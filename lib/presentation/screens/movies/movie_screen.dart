// esta clase nos permite contruir todo lo relacionado
// a una pelicula en particular, titulo, poster y descriccion

import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/presentation/providers/providers.dart';

class MovieScreen extends ConsumerStatefulWidget {
  static const name = 'movie-screen';

  final String movieId;

  const MovieScreen({super.key, required this.movieId});

  @override
  MovieScreenState createState() => MovieScreenState();
}

// clase de estado
class MovieScreenState extends ConsumerState<MovieScreen> {
  @override
  void initState() {
    super.initState();

    // realizamos la peticion http
    ref.read(movieInfoProvider.notifier).loadMovie(widget.movieId);
    ref.read(actorsByMovieProvider.notifier).loadActors(widget.movieId);
  }

  @override
  Widget build(BuildContext context) {
    final Movie? movie = ref.watch(movieInfoProvider)[widget.movieId];

    // preguntamos si movie esta vacio se hace la peticion http
    if (movie == null) {
      return const Scaffold(
          body: Center(child: CircularProgressIndicator(strokeWidth: 2)));
    }

    // diseño de la pagina al entrar en la pelicula
    return Scaffold(
      body: CustomScrollView(
        physics:
            const ClampingScrollPhysics(), // no permite el rebote de elasticidad en algunos S.O
        slivers: [
          _CustomSliverAppBar(movie: movie),
          SliverList(
              delegate: SliverChildBuilderDelegate(
                  (context, index) => _MovieDetails(movie: movie),
                  childCount: 1))
        ],
      ),
    );
  }
}

// se construye el wiget para la descriccion de la pelicula
class _MovieDetails extends StatelessWidget {
  final Movie movie;

  const _MovieDetails({required this.movie});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final textStyles = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // imagen pequea de la parte de abajo
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.network(
                  movie.posterPath,
                  width: size.width * 0.3,
                ),
              ),

              const SizedBox(width: 10),

              // descriccion de la pelicula
              SizedBox(
                width: (size.width - 40) * 0.7,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(movie.title,
                        style: textStyles.titleLarge), // titulo de la movie
                    Text(movie.overview) // descriccionde la movie
                  ],
                ),
              )
            ],
          ),
        ),

        // generos de la pelicula
        Padding(
          padding: const EdgeInsets.all(8),
          child: Wrap(
            children: [
              ...movie.genreIds.map((gender) => Container(
                    margin: const EdgeInsets.only(right: 10),
                    child: Chip(
                      label: Text(gender),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                    ),
                  ))
            ],
          ),
        ),

        _ActorByMovie(movieId: movie.id.toString()),

        const SizedBox(height: 50),
      ],
    );
  }
}

// se contruyen los actores para mostrarlos
class _ActorByMovie extends ConsumerWidget {
  final String movieId;

  const _ActorByMovie({required this.movieId});

  @override
  Widget build(BuildContext context, ref) {
    final actorsByMovie = ref.watch(actorsByMovieProvider);

    // se pregunta si actorsByMovie es = null, significa que esta cargando los actores
    if (actorsByMovie[movieId] == null) {
      return const CircularProgressIndicator(strokeWidth: 2);
    }

    final actors = actorsByMovie[movieId]!;

    // construccion para mostrar los actores en pantalla
    return SizedBox(
      height: 300,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: actors.length,
        itemBuilder: (context, index) {
          final actor = actors[index];

          return Container(
            padding: const EdgeInsets.all(8.0),
            width: 135,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // foto del actor
                FadeInRight(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.network(
                      actor.profilePath,
                      height: 180,
                      width: 135,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),

                const SizedBox(height: 5),

                // nombre del actor
                Text(actor.name, maxLines: 2),
                Text(actor.character ?? '',
                    maxLines: 2,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        overflow: TextOverflow
                            .ellipsis) // le da negrita al texti y si es muy largo hace los 3 punticos (...)
                    ),
              ],
            ),
          );
        },
      ),
    );
  }
}

// metodo para saber si la pelicula esta en favoritas en la base de datos
final isFavoriteProvider = FutureProvider.family.autoDispose((ref, int movieId) {
  final localStorageRepository = ref.watch(localStorageRepositoryProvider);
  // si esta en favoritos
  return localStorageRepository.isMovieFavorite(movieId);
});

// se contruyen los sliver por aparte para no tenner todo el codigo metido en un solo lugar
class _CustomSliverAppBar extends ConsumerWidget {
  final Movie movie;

  const _CustomSliverAppBar({required this.movie});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isFavoriteFuture = ref.watch(isFavoriteProvider(movie.id));

    // para obtener el tamaño de la pantalla
    final size = MediaQuery.of(context).size;

    // configuraciones del sliver
    return SliverAppBar(
      backgroundColor: Colors.black,
      expandedHeight: size.height * 0.7,
      foregroundColor: Colors.white,
      actions: [
        IconButton(
          onPressed: () async{

            // ref.read(localStorageRepositoryProvider)
            //   .toggleFavorite(movie);

            // hacemos el llamado al Provider para eliminar y agregar favoritos automaticamente
            await ref.read(favoriteMoviesProvider.notifier)
              .toggleFavorite(movie);

            ref.invalidate(isFavoriteProvider(movie.id));

          },
          icon: isFavoriteFuture.when(
            loading: () => const CircularProgressIndicator(strokeWidth: 2 ),
            data: (isFavorite) => isFavorite 
              ? const Icon( Icons.favorite_rounded, color: Colors.red )
              : const Icon( Icons.favorite_border ), 
            error: (_, __) => throw UnimplementedError(), 
          ),

          //icon: const Icon(Icons.favorite_border)   // para cuando no es favorito
          //icon: const Icon(Icons.favorite_rounded, color: Colors.red,)
        )
      ],
      flexibleSpace: FlexibleSpaceBar(
        // espacion flexible de nuestro appbar
        titlePadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        // title: Text(
        //  movie.title,
        //  style: const TextStyle(fontSize: 20),
        //  textAlign: TextAlign.start,
        // ),

        // para mostrar el poster de la pelicula
        background: Stack(
          children: [
            SizedBox.expand(
              child: Image.network(
                movie.posterPath,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress != null) return const SizedBox();

                  return FadeIn(child: child);
                },
              ),
            ),

            // implementacion del metodo _CustomGradient para no reescribir tanto codigo
            // gradiente del incono de favoritos
            const _CustomGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                stops: [
                  0.0,
                  0.2
                ],
                colors: [
                  Colors.black54,
                  Colors.transparent,
                ]),

            // gradientes para cuando el poster es blanco y no se puede leer el titulo
            const _CustomGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: [0.7, 1.0],
                colors: [Colors.transparent, Colors.black54]),

            // gradinete para ver la flcha de retorno en caso de poster blancos y no se vea
            const _CustomGradient(
                begin: Alignment.topLeft,
                stops: [0.0, 0.3],
                colors: [Colors.black87, Colors.transparent]),
          ],
        ),
      ),
    );
  }
}

// implementacion del wigets para reutilizar los SizedBox.expand de los gradientes
class _CustomGradient extends StatelessWidget {
  final AlignmentGeometry begin;
  final AlignmentGeometry end;
  final List<double> stops;
  final List<Color> colors;

  const _CustomGradient(
      {this.begin = Alignment.centerLeft,
      this.end = Alignment.centerRight,
      required this.stops,
      required this.colors});

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: DecoratedBox(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: begin, end: end, stops: stops, colors: colors))),
    );
  }
}
