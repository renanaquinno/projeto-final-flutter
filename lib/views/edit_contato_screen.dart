import 'package:flutter/material.dart';
import 'package:maps/models/contato_model.dart';
import 'package:maps/services/database_service.dart';

class EditContatoScreen extends StatefulWidget {
  final Contato contato;

  const EditContatoScreen({Key? key, required this.contato}) : super(key: key);

  @override
  _EditContatoScreenState createState() => _EditContatoScreenState();
}

class _EditContatoScreenState extends State<EditContatoScreen> {
  final ContatoService _databaseService = ContatoService.instance;

  late TextEditingController _nomeController;
  late TextEditingController _latitudeController;
  late TextEditingController _longitudeController;

  @override
  void initState() {
    super.initState();
    // Inicializa os controllers com os valores antigos do contato
    _nomeController = TextEditingController(text: widget.contato.nome);
    _latitudeController = TextEditingController(text: widget.contato.latitude);
    _longitudeController =
        TextEditingController(text: widget.contato.longitude);
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _latitudeController.dispose();
    _longitudeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Contato'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nomeController,
              decoration: const InputDecoration(labelText: 'Nome'),
            ),
            TextField(
              controller: _latitudeController,
              decoration: const InputDecoration(labelText: 'Latitude'),
            ),
            TextField(
              controller: _longitudeController,
              decoration: const InputDecoration(labelText: 'Longitude'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Validação: se o nome estiver vazio, não prossegue
                if (_nomeController.text.trim().isEmpty) return;

                // Atualiza ou adiciona o contato com os novos valores
                _databaseService.updateContato(
                  widget.contato.id,
                  _nomeController.text,
                  _latitudeController.text,
                  _longitudeController.text,
                );

                Navigator.pop(context);
              },
              child: const Text('Salvar'),
            ),
          ],
        ),
      ),
    );
  }
}
