import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'VentaScreen.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Ventas de la Bodega')),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('ventas').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }
          var ventas = snapshot.data!.docs;
          return ListView.builder(
            itemCount: ventas.length,
            itemBuilder: (context, index) {
              var venta = ventas[index];
              return ListTile(
                title: Text(venta['nombre_cliente']),
                subtitle: Text('Monto: \$${venta['monto']}'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => VentaScreen(ventaId: venta.id),
                    ),
                  );
                },
                trailing: IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    FirebaseFirestore.instance
                        .collection('ventas')
                        .doc(venta.id)
                        .delete();
                  },
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => VentaScreen()),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
