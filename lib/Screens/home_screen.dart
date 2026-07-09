import 'package:flutter/material.dart';
import 'package:myapp/Listas/datos.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  
  final listainstrumentos = instrumentos;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: listainstrumentos.length,
        itemBuilder: (context, index) {
          return Card(
            child: ListTile(
              title: Text(listainstrumentos[index].nombre),
              leading: Image.network(
                listainstrumentos[index].imagen,
                width: 50,
                height: 75,
                fit: BoxFit.cover,
              ),
              onTap: () {
                context.push('/detalle', extra: listainstrumentos[index]);
              },
            ),
          );
        },
      ),
    );
  }
}
