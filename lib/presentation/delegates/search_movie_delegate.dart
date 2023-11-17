
// implementacion de la clase delegate para la funcion de busqueda de peliculas

import 'dart:async';

import 'package:cinemapedia/config/helpers/human_formats.dart';
import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:cinemapedia/domain/entities/movie.dart';


// se define la funsion SearchMoviesCallback
typedef SearchMoviesCallback = Future<List<Movie>> Function(String query); 

class SearchMovieDelegate extends SearchDelegate<Movie?>{

  // implementacion de la funsion SearchMoviesCallback
  final SearchMoviesCallback searchMovies;
  List<Movie> initialMovies;
  

  // feinicion de la propiedad StreamController que vamos a ocupar mas abajo
  StreamController<List<Movie>>  debouncedMovies = StreamController.broadcast();
  StreamController<bool>  isLoadingStream = StreamController.broadcast();

  Timer? _debounceTimer;

  SearchMovieDelegate({ 
    required this.searchMovies,
    required this.initialMovies
  }):super(
    searchFieldLabel: 'Buscar peliculas',
  );


  // metodo para limpiar los stream
  void clearStreams(){
    debouncedMovies.close();
  }


  // metodo para el query y emitir el nuevo resultado de las peliculas
  void _onQueryChanget(String query){

    isLoadingStream.add(true);

    // esto sirve para evaluar y cancelar el timer 
    if(_debounceTimer?.isActive ?? false ) _debounceTimer!.cancel();

    // definimos la cantidad de tiempo de cada ves que el usuario presiona una tecla
    _debounceTimer = Timer(const Duration(milliseconds: 500), () async {
      
      // buscar pelicula y emitir al stream
      // if(query.isEmpty){
      //   debouncedMovies.add([]);
      //   return;
      // }

      final movies = await searchMovies(query);
      initialMovies = movies;
      debouncedMovies.add(movies);
      isLoadingStream.add(false);
    });
  }


  // metodo para unificar el buildresults y el buildSuggestions ya que son muy similares
  Widget buildResultsAndSuggestions(){
    return StreamBuilder(
      // implementacion del objeto debounceMovies 
      initialData: initialMovies,
      stream: debouncedMovies.stream,
      builder: (context, snapshot) {

        final movies = snapshot.data ?? [];

        return ListView.builder(
          itemCount: movies.length,
          itemBuilder: (context, index) =>_MovieItem(
            movie: movies[index],
            onMovieSelected: (context, movie){
              clearStreams();
              close(context, movie);

            },
          )
        );

      },
    );
  }

  // @override
  // String get searchFieldLabel => 'Buscar pelicula ';


  // implementacin de la funsion de borrado en la caja de texto e indicador de progreso
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [

      // implementacion de la funcionalidad de la flecha que indica la carga 
      StreamBuilder(
        initialData: false,
        stream: isLoadingStream.stream, 
        builder: (context, snapshot) {
          if(snapshot.data ?? false) {
            return SpinPerfect(
              duration: const Duration(seconds: 20),
              spins: 10,
              infinite: true,
              child: IconButton(
                onPressed: () => query = '', 
                icon: const Icon(Icons.refresh_rounded)
              ),
            );
            
          }

          return FadeIn(
            animate: query.isNotEmpty,   // condicion para preguntar si la caja de txt esta vacia 
            // duration: const Duration(milliseconds: 200),   // tiempo de duracion para que aparesca la X de borrado
            child: IconButton(
              onPressed: () => query = '', 
              icon: const Icon(Icons.clear)
            ),
          );
        },
      ),
    ];

  }



  // implementacion de la funcion para ir hacia atras, boton de retroceder
  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: (){
        clearStreams();
        close(context, null);
      },
      icon: const Icon( Icons.arrow_back_ios_new_rounded)
    );
  }



  // implementacion del metodo cde resultados para cuando el usuario da enter en la busqueda
  @override
  Widget buildResults(BuildContext context) {

    return buildResultsAndSuggestions();
  }



  // implementacion de las respuestas y sugerencias obtenidas mediante la busqueda 
  @override
  Widget buildSuggestions(BuildContext context) {

    _onQueryChanget(query);
    return buildResultsAndSuggestions();
  }
}



// construccion del wigets para mostrar las peliculas buscadas
class _MovieItem extends StatelessWidget {

  final Movie movie;
  final Function onMovieSelected;

  const _MovieItem({
    required this.movie, 
    required this.onMovieSelected
  });

  @override
  Widget build(BuildContext context) {

    final textStyles = Theme.of(context).textTheme;
    final size = MediaQuery.of(context).size;

    return GestureDetector(
      // funsion para ir a la pelicula que se buscaba 
      onTap: (){
        onMovieSelected(context, movie);
      },

      child: FadeIn(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child:  Row(
            children: [
          
              // imagen
              SizedBox(
                width: size.width * 0.2,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: FadeInImage(
                    height: 120,
                    fit: BoxFit.cover,
                    image: NetworkImage(movie.posterPath),
                    placeholder: const AssetImage('assets/loaders/bottle-loader.gif'),
                  ),
                ),
              ),
          
              const SizedBox(width: 10),
            
              // descripcion
               SizedBox(
                width: size.width * 0.7,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // se muestra el titulo de la pelicula y se le da estilo
                    Text( movie.title, style: textStyles.titleMedium),
          
                    // se muestra la descrrion y se hace una condicion si la 
                    //descriccion es muy larga se muestran 100 letras nomas
                    ( movie.overview.length > 100 )
                    ? Text( '${movie.overview.substring(0, 100)}...')
                    : Text( movie.overview),
          
                    Row(
                      children: [
                        Icon( Icons.star_half_rounded, color: Colors.yellow.shade800),
                        
                        const SizedBox(width: 5),
          
                        Text(
                          HumanFormats.number(movie.voteAverage, 1),
                          style: textStyles.bodyMedium!.copyWith(color: Colors.yellow.shade900),
                        )
                      ],
                    )
                    
                  ],
                ),
               )
          
            ],
          ),
        ),
      ),
    ); 
    
  }
}
