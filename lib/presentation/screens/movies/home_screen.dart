
import 'package:flutter/material.dart';

import 'package:cinemapedia/presentation/widgets/widgets.dart';
import 'package:cinemapedia/presentation/views/views.dart';

class HomeScreen extends StatefulWidget {

  static const name = 'home-screen';

  final int pageIndex;

  const HomeScreen({
    super.key, 
    required this.pageIndex, 
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}


// este mixin es necesario para mantener el estado en el PageView
class _HomeScreenState extends State<HomeScreen> with AutomaticKeepAliveClientMixin {

  late PageController pageController;

  @override
  void initState() {
    super.initState();

    pageController = PageController(
      keepPage: true
    );
    
  }


  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }


  final viewRouters = const <Widget>[
    HomeView(),
    PopularView(),        // <---- categorias view
    FavoritesView(), 
  ];

  @override 
  Widget build(BuildContext context) {
    super.build(context);

    if( pageController.hasClients ){
      pageController.animateToPage(
        widget.pageIndex, 
        curve: Curves.easeInOut,
        duration: const Duration(milliseconds: 250), 
      );
    }

    return Scaffold(

      // wigets para preservar el estado de flutter 
      body: PageView(
        // esto evitara el rebote 
        physics: const NeverScrollableScrollPhysics(),
        controller: pageController,
        children: viewRouters,
      ),

      // para contruir un boton de navegacion
      bottomNavigationBar:  CustomBottonNanvigation(
        currentIndex: widget.pageIndex
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
  
}

