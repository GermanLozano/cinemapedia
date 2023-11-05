// esta clase permite crar la una barra de botones de navegacion
// al final de la pantalla

import 'package:flutter/material.dart';

class CustomBottonNanvigation extends StatelessWidget {
  const CustomBottonNanvigation({super.key});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      // se crean los item de los botones de navegacion
      elevation: 0,
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