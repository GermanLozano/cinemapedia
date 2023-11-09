// esta clase permite crar la una barra de botones de navegacion
// al final de la pantalla

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CustomBottonNanvigation extends StatelessWidget {

  final int currentIndex;

  const CustomBottonNanvigation({
    super.key, 
    required this.currentIndex
  });


  // metodo para condicionar el valor del taps y navegar entre ellos
  void onItemTapped(BuildContext context, int index){
    switch(index){
      case 0:
        context.go('/home/0');
        break;

      case 1:
        context.go('/home/1');
        break;

      case 2:
        context.go('/home/2');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: (value) => onItemTapped(context, value),
      elevation: 0,

      // se crean los item de los botones de navegacion
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home_max),
          label: 'Inicio'
        ),

        BottomNavigationBarItem(
          icon: Icon(Icons.label_outline),
          label: 'Categorias'
        ),

        BottomNavigationBarItem(
          icon: Icon(Icons.favorite_outline),
          label: 'Favoritos'
        )
      ],
    );
  }
}