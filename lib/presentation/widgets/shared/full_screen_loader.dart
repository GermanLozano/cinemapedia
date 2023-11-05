
import 'package:flutter/material.dart';

class FullScreenLoader extends StatelessWidget {
  const FullScreenLoader({super.key});

    // creamos un arreglo de string
    Stream<String>getLoadingMessage(){
      final messages = <String>[
      'Cargando peliculas',
      'Comprando palomitas de maiz ',
      'Cargando Ppopulares ',
      'Llamando a mi novia',
      'Ya mero...',
      'Esto esta tardando mas de lo normal :('
    ];

    // hacemos un retorno de Stream periodicamente con tiempo de duracion
    return Stream.periodic(const Duration(milliseconds: 1200), (step){
      return messages[step];
    }).take(messages.length);
  }

  @override
  Widget build(BuildContext context) {

    // construimos el indicador de progreso con las demas configs
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Espere por favor '),
          const SizedBox(height: 10),
          const CircularProgressIndicator(strokeWidth: 2),
          const SizedBox(height: 10),

          //permite hacer un rebuild del componente cuando ocurre un evento nuevo
          StreamBuilder(
            stream: getLoadingMessage(), 
            builder: (context, snapshot){
              if (!snapshot.hasData) return const Text('Cargando...');

              return Text(snapshot.data!);
            }
          )
        ],
      ),
     );
  }
}