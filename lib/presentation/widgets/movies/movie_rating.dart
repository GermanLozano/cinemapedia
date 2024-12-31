
// clase para implementar el manejo del reiting de las peliculas 

import 'package:cinemapedia/config/helpers/human_formats.dart';
import 'package:flutter/material.dart';

class MovieRating extends StatelessWidget {

  final double voteAverage;

  const MovieRating({
    super.key,
    required this.voteAverage
  });

  @override
  Widget build(BuildContext context) {

    final textStyle = Theme.of(context).textTheme;

    return SizedBox(
      width: 150,
      child: Row(
        children: [
          Icon(Icons.star_half_outlined, color: Colors.yellow.shade800),

          const SizedBox(width: 3),

          Text(HumanFormats.number(voteAverage, 1),
          style: textStyle.bodyMedium
            ?.copyWith(color: Colors.yellow.shade800)),

        ],
      ),
    );
  }
}