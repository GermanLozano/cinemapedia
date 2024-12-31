# cinemapedia

# dev

1. Copiar el .env.template y renombrarlo a .env
2. Cambiar las variables de entorno (THE_MOVIEBD)
3. cambios en la entidad, hay que ejecutar el comando 
````
flutter pub run build_runner build


# produccion 
para cambiar el nombre de la aplicacion:
´´´
flutter pub run change_app_package_name:main com.germanlozano.cinemapedia
´´´

para cambiar el icono de la aplicacion
´´´
dart run flutter_launcher_icons
´´´

para cambiar el splash screen
´´´
dart run flutter_native_splash:create
´´´

para android AAB (para sacar el build an app bundle)
´´´
flutter build appbundle
´´´
