// esta clase nos permite crear la lista de peliculas que estaran
// de manera horizontal, debajo del carrusel 

import 'package:animate_do/animate_do.dart';
import 'package:cinemapedia/config/helpers/human_formats.dart';
import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MovieHorizontalListview extends StatelessWidget {
  // argumentos a ocupar para que se lo mas flexible posible
    final List<Movie> movies;
    final String? title;
    final String? subtitle;
    final VoidCallback? loadNextpage; // para el infinity scrool
    
  const MovieHorizontalListview({
    super.key, 
    required this.movies, 
    this.title, 
    this.subtitle, 
    this.loadNextpage
    });

  @override
  Widget build(BuildContext context) {
    
    return SizedBox(
      height: 350,
      child: Column(
        children: [
          if (title != null || subtitle != null )
            _Title(title: title, subtitle: subtitle,),

          Expanded(
            child: ListView.builder(
              itemCount: movies.length,
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              itemBuilder: (context, index) {
                return FadeInRight(child: _Slide(movie: movies[index]));
              },
            ),
          )

        ],
      ),
    );
  }
}

// se crea el wigedt del slider que llamamos arriba 
class _Slide extends StatelessWidget {
  final Movie movie;

  const _Slide({required this.movie});

  @override
  Widget build(BuildContext context) {

    final textStyle = Theme.of(context).textTheme;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          //* esto es la imagen
          SizedBox(   // confifuraciones para mostrar la img de la pelucula
            width: 150,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.network(    // se manda a llamar a la pelicula
                movie.posterPath,
                fit: BoxFit.cover,    // para corregir los distintos tamallos de la img de las peliculas
                width: 150,
                loadingBuilder: (context, child, loadingProgress) {
                  if(loadingProgress != null) {
                    return const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Center(child: CircularProgressIndicator(strokeWidth: 2,)),
                    );
                  }

                  // implementat la funcionalidad de la navegacion
                  return GestureDetector(
                    onTap: () => context.push('/movie/${movie.id}'),  // navegacion a la otra pantalla 
                    child: FadeIn(child: child),
                  );
                  
                },
              ),
            ),
          ),

          const SizedBox( height: 5),

          //* Title
          SizedBox( // configuracion del titulo de la pelicula 
            width: 150,
            child: Text(
              movie.title,
              maxLines: 2,
              style: textStyle.titleSmall,
            ),
          ),

          //* Rating 
          SizedBox(
            width: 150,
            child: Row(   // configuracioin de la estrlla de rating 
              children: [
                Icon(Icons.star_half_outlined, color: Colors.yellow.shade800),
                const SizedBox(width: 3),
                Text('${movie.voteAverage}', style: textStyle.bodyMedium?.copyWith(color: Colors.yellow.shade800),),
                //const SizedBox(width: 10),
                const Spacer(),
                Text(HumanFormats.number(movie.popularity), style: textStyle.bodySmall), // muestra la cantidad de votos con formato de la popularidad de la pelicula
              
              ],
            ),
          )

        ],
      ),
    );
  }
}


// se crea un widgets unico para el titulo 
class _Title extends StatelessWidget {

  // Argumentos que vamos a ocupar 
  final String? title;
  final String? subtitle;

  const _Title({
    this.title, 
    this.subtitle
  });

  @override
  Widget build(BuildContext context) {
    // para darle estilo al titulo ocupamos 
    final titleStyle =Theme.of(context).textTheme.titleLarge;

    return Container(
      padding: const EdgeInsets.only(top: 10),
      margin: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        children: [
          // el titulo y el subtitulo son enviados desde el home_screen
          if (title != null )
            Text(title!, style: titleStyle),

            const Spacer(),
          
          if (subtitle != null )
            FilledButton.tonal(
              style: const ButtonStyle(visualDensity: VisualDensity()),
              onPressed: (){}, 
              child: Text(subtitle!),
            )

        ],
      ),
    );
  }
}