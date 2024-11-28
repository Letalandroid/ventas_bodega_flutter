import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class VentaScreen extends StatefulWidget {
  final String? ventaId;

  VentaScreen({this.ventaId});

  @override
  _VentaScreenState createState() => _VentaScreenState();
}

class _VentaScreenState extends State<VentaScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nombreClienteController;
  late TextEditingController _dniClienteController;
  late TextEditingController _montoController;
  late TextEditingController _empleadoAtendioController;
  late TextEditingController _codigoEmpleadoController;
  late DateTime _fechaVenta;

  @override
  void initState() {
    super.initState();
    _nombreClienteController = TextEditingController();
    _dniClienteController = TextEditingController();
    _montoController = TextEditingController();
    _empleadoAtendioController = TextEditingController();
    _codigoEmpleadoController = TextEditingController();
    _fechaVenta = DateTime.now();

    if (widget.ventaId != null) {
      _loadVentaData(widget.ventaId!);
    }
  }

  _loadVentaData(String ventaId) async {
    var venta = await FirebaseFirestore.instance
        .collection('ventas')
        .doc(ventaId)
        .get();
    setState(() {
      _nombreClienteController.text = venta['nombre_cliente'];
      _dniClienteController.text = venta['dni_cliente'];
      _montoController.text = venta['monto'].toString();
      _empleadoAtendioController.text = venta['empleado_atendio'];
      _codigoEmpleadoController.text = venta['codigo_empleado'];
      _fechaVenta = (venta['fecha'] as Timestamp).toDate();
    });
  }

  _saveVenta() async {
    if (_formKey.currentState!.validate()) {
      var ventaData = {
        'nombre_cliente': _nombreClienteController.text,
        'dni_cliente': _dniClienteController.text,
        'monto': double.parse(_montoController.text),
        'empleado_atendio': _empleadoAtendioController.text,
        'codigo_empleado': _codigoEmpleadoController.text,
        'fecha': _fechaVenta,
      };

      if (widget.ventaId == null) {
        // Crear nueva venta
        await FirebaseFirestore.instance.collection('ventas').add(ventaData);
      } else {
        // Editar venta existente
        await FirebaseFirestore.instance
            .collection('ventas')
            .doc(widget.ventaId)
            .update(ventaData);
      }

      Navigator.pop(context);
    }
  }

  _selectDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _fechaVenta,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _fechaVenta) {
      setState(() {
        _fechaVenta = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.ventaId == null ? 'Registrar Venta' : 'Editar Venta'),
        ),
        body: Padding(
        padding: const EdgeInsets.all(16.0),
    child: Form(
    key: _formKey,
    child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
    TextFormField(
    controller: _nombreClienteController,
    decoration: InputDecoration(labelText: 'Nombre Cliente'),
    validator: (value) {
    if (value!.isEmpty) {
    return 'Por favor ingresa el nombre del cliente';
    }
    return null;
    },
    ),
    TextFormField(
    controller: _dniClienteController,
    decoration: InputDecoration(labelText: 'DNI Cliente'),
    validator: (value) {
    if (value!.isEmpty) {
    return 'Por favor ingresa el DNI del cliente';
    }
    return null;
    },
    ),
    TextFormField(
    controller: _montoController,
    decoration: InputDecoration(labelText: 'Monto de la Venta'),
    keyboardType: TextInputType.number,
    validator: (value) {
    if (value!.isEmpty) {
    return 'Por favor ingresa el monto de la venta';
    }
    return null;
    },
    ),
    TextFormField(
    controller: _empleadoAtendioController,
    decoration: InputDecoration(labelText: 'Empleado que atendió'),
    ),
    TextFormField(
    controller: _codigoEmpleadoController,
    decoration: InputDecoration(labelText: 'Código del Empleado'),
    ),
    ListTile(
    title: Text("Fecha de la Venta: ${_fechaVenta.toLocal()}"),
    trailing: Icon(Icons.calendar_today),
    onTap: () => _selectDate(context),
    ),
    SizedBox(height: 20),
    ElevatedButton(
    onPressed: _saveVenta,
    child: Text('Guardar Venta')),
      ],
    ),
    ),
        ),
    );
  }
}

