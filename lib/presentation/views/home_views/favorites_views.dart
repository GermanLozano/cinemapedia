
// clase para la implementacion de la vista de favoritos 

import 'package:flutter/material.dart';

class FavoritesViews extends StatelessWidget {
  const FavoritesViews({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorites Views'),
      ),

      body: const Center(
        child: Text('Favorites'),
      ),
    );
  }
}