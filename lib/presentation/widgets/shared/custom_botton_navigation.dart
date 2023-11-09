// esta clase permite crar la una barra de botones de navegacion
// al final de la pantalla

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CustomBottonNanvigation extends StatelessWidget {
  const CustomBottonNanvigation({super.key});

  // metodo mas indicar o resaltar el boton de la barra de navegacion seleccionado 
   int getCurrentIndex( BuildContext context ) {
    final String location = GoRouterState.of(context).fullPath ?? '/';

    switch(location) {
      case '/':
        return 0;
      
      case '/categories':
        return 1;

      case '/favorites':
        return 2;
      
      default:
        return 0;
    }
  }


  // metodo para condicionar el valor del taps y navegar entre ellos
  void onItemTapped(BuildContext context, int index){
    switch(index){
      case 0:
      context.go('/');
      break;

      case 1:
      context.go('/');
      break;

      case 2:
      context.go('/favorites');
      break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      // se crean los item de los botones de navegacion
      elevation: 0,
      currentIndex: getCurrentIndex(context),
      onTap: (value) => onItemTapped(context, value),

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