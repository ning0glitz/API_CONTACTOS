import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<dynamic> users = []; // Lista para almacenar los datos de los usuarios
  late BuildContext dialogContext; // Contexto del diálogo de confirmación

  @override
  void initState() {
    super.initState();
    fetchUsers(); // Se llama al método para obtener los datos de los usuarios al iniciar la pantalla
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text('Contactos'),
          actions: [
            IconButton(
              icon: Icon(Icons.refresh),//ICono al refrescar los contactos
              onPressed: fetchUsers,//llama a la accion fetchUser,para refrescarlo
            ),
          ],
        ),
        body: ListView.builder(
          itemCount: users.length, // Número de elementos en la lista de usuarios
          itemBuilder: (context, index) {
            final user = users[index]; // Datos del usuario en el índice actual
            final name = user['name']['first']; // Nombre del usuario
            final email = user['email']; // Correo electrónico del usuario
            final imageUrl = user['picture']['thumbnail']; // URL de la imagen de perfil del usuario

            return ListTile(
              onLongPress: () {
                _eliminarContacto(context, user); // Acción al mantener presionado el contacto
              },
              title: Text(name), // Nombre del contacto en el ListTile
              subtitle: Text(email), // Correo electrónico del contacto en el ListTile
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: Image.network(imageUrl), // Imagen de perfil del contacto en el ListTile
              ),
              trailing: Icon(Icons.arrow_forward_ios), // Icono de flecha en el ListTile
            );
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: (){
         // Acción al presionar el botón de añadir,esto es para agregar un contacto a futuro
          }, 
          child: Icon(Icons.add), // Icono de recargar en el botón de agregar
        ),
      ),
    );
  }

  void _eliminarContacto(BuildContext context, dynamic contacto) {
    showDialog(
      context: context,
      builder: (context) {
        dialogContext = context; // Guarda una referencia al contexto del diálogo
        return AlertDialog(
          title: Text('Eliminar Contacto'),
          content: Text('¿Estás seguro de querer eliminar este contacto?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Cierra el diálogo sin eliminar el contacto
              },
              child: Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                setState(() { 
                  users.remove(contacto); // Elimina el contacto de la lista de usuarios
                });
                Navigator.pop(context); // Cierra el diálogo después de eliminar el contacto
              },
              child: Text(
                'Borrar',
                style: TextStyle(color: Colors.red),
              ),  
            ),
          ],
        );
      },
    );
  }

  Future<void> fetchUsers() async {
    try {
      print('fetchUsers called');
      const url = 'https://randomuser.me/api/?results=100';
      final response = await http.get(Uri.parse(url)); // Realiza una solicitud GET a la API
      final json = jsonDecode(response.body); // Decodifica la respuesta JSON
      setState(() {
        users = json['results']; // Actualiza la lista de usuarios con los datos obtenidos
      });
      print('fetchUsers completed');
    } catch (error) {
      print('Error al obtener datos: $error'); // Manejo de errores al obtener los datos de los usuarios
    }
  }
}
