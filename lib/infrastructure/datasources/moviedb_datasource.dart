
import 'package:dio/dio.dart';

import 'package:cinemapedia/config/constants/environment.dart';
import 'package:cinemapedia/domain/datasources/movies_datasource.dart';

import 'package:cinemapedia/infrastructure/models/models.dart';
import 'package:cinemapedia/infrastructure/mappers/mappers.dart';

import 'package:cinemapedia/domain/entities/entities.dart';


class MoviedbDatasource extends MoviesDatasource{

  // configuracion del dio
  final dio = Dio( BaseOptions(
    baseUrl: 'https://api.themoviedb.org/3',
    queryParameters: {
      'api_key': Environment.theMovieDbKey,
      'language': 'es-MX',
    }

  ));

  // metodo para no repetir los mismos procesos 
  List<Movie> _jsonToMovies( Map<String,dynamic> json){

    final movieDBResponse = MovieDbResponse.fromJson(json);

    final List<Movie> movies = movieDBResponse.results
    .where((moviedb) => moviedb.posterPath != 'no-poster')
    .map(
      (moviedb) => MovieMapper.movieDBToEntity(moviedb)
    ).toList();

    return movies;
  }


  // metodo para hacer la peticion https de la nueva lista de peliculas
  @override
  Future<List<Movie>> getNowPlaying({int page = 1}) async {

    final response = await dio.get('/movie/now_playing',
      queryParameters: {
        'page': page
      }
    );

    return _jsonToMovies(response.data);
  }
  
  // peticion de las peluculas populares 
  @override
  Future<List<Movie>> getPopular({int page = 1}) async {
    
    final response = await dio.get('/movie/popular',
      queryParameters: {
        'page': page
      }
    );

    return _jsonToMovies(response.data);    
  }

  // peticion de las peluculas proximas a salir 
  @override
  Future<List<Movie>> getUpcoming({int page = 1}) async {
    
    final response = await dio.get('/movie/upcoming',
      queryParameters: {
        'page': page
      }
    );

    return _jsonToMovies(response.data);    
  }

  // peticion de las peluculas mejor calificadas 
  @override
  Future<List<Movie>> getTopRated({int page = 1}) async {
    
    final response = await dio.get('/movie/top_rated',
      queryParameters: {
        'page': page
      }
    );

    return _jsonToMovies(response.data);    
  }
  

  // para llamar la pelicula por el id
  @override
  Future<Movie> getMovieById(String id) async{

    final response = await dio.get('/movie/$id');
    
    // preguntamos para validar en caso de buscar una pelicula que no existe
    if (response.statusCode != 200) throw Exception('Movie with id: $id not found'); 

    // hacemos el mapeo
    final movieDetails = MovieDetails.fromJson( response.data);

    // ahora hacemos el mapper 
    final Movie movie = MovieMapper.movieDetailsToEntity(movieDetails);

    return movie;
  }
  

  // para buscar la pelicula 
  @override
  Future<List<Movie>> searchMovies(String query) async{

    if(query.isEmpty) return[];

    final response = await dio.get('/search/movie',
      queryParameters: {
        'query': query
      }
    );

    return _jsonToMovies(response.data);    
  }
  

  // para obtener las peliculas similares   
  @override
  Future<List<Movie>> getSimilarMovies(int movieId) async {

    final response = await dio.get('/movie/$movieId/similar');
    return _jsonToMovies(response.data);

  }
  

  // para obtener lo videos del triller de youtube 
  @override
  Future<List<Video>> getYoutubeVideosById(int movieId) async {

    final response = await dio.get('/movie/$movieId/videos');
    final moviedbVideosResponse = MoviedbVideosResponse.fromJson(response.data);
    final videos = <Video>[];

    for (final moviedbVideo in moviedbVideosResponse.results) {
      if( moviedbVideo.site == 'YouTube' ){
        final video = VideoMapper.moviedbVideoToEntity(moviedbVideo);
        videos.add(video);
      }
    }

    return videos;
  }
  
}