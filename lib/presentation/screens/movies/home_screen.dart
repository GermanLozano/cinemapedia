
import 'package:flutter/material.dart';

import 'package:cinemapedia/presentation/views/views.dart';
import 'package:cinemapedia/presentation/widgets/widgets.dart';

class HomeScreen extends StatelessWidget {

  static const name = 'home-screen';

  final int pageIndex;

  const HomeScreen({
    super.key, 
    required this.pageIndex, 
  });

  final viewRouters = const <Widget>[
    HomeView(),
    SizedBox(),        // <---- categorias view
    FavoritesView(), 
  ];

  @override 
  Widget build(BuildContext context) {
    return Scaffold(

      // wigets para preservar el estado de flutter 
      body: IndexedStack(
        index: pageIndex,
        children: viewRouters,
      ),

      // para contruir un boton de navegacion
      bottomNavigationBar:  CustomBottonNanvigation(currentIndex: pageIndex),
    );
  }
}


