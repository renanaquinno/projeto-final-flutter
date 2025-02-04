import 'package:flutter/material.dart';
import 'package:maps/models/contato_model.dart';
import 'package:maps/services/database_service.dart';
import 'package:maps/views/edit_contato_screen.dart';

class ContactsPage extends StatefulWidget {
  const ContactsPage({super.key});

  @override
  State<ContactsPage> createState() => _ContactsPageState();
}

class _ContactsPageState extends State<ContactsPage> {
  final ContatoService _databaseService = ContatoService.instance;
  String? _nome = null;
  String? _latitude = null;
  String? _longitude = null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Lista de Contatos"),
        backgroundColor: Colors.yellow,
      ),
      body: _contatoList(),
      floatingActionButton: _addContatoButton(),
    );
  }

  Widget _addContatoButton() {
    return FloatingActionButton(
      onPressed: () {
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text('Add Contato'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  onChanged: (value) {
                    setState(() {
                      _nome = value;
                    });
                  },
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Nome',
                  ),
                ),
                TextField(
                  onChanged: (value) {
                    setState(() {
                      _latitude = value;
                    });
                  },
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Latitude',
                  ),
                ),
                TextField(
                  onChanged: (value) {
                    setState(() {
                      _longitude = value;
                    });
                  },
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Longitute',
                  ),
                ),
                MaterialButton(
                  color: Theme.of(context).colorScheme.primary,
                  onPressed: () {
                    if (_nome == null || _nome == "") return;
                    _databaseService.addContato(
                        _nome!, _latitude!, _longitude!);
                    setState(() {
                      _nome = null;
                      _latitude = null;
                      _longitude = null;
                    });
                    Navigator.pop(
                      context,
                    );
                  },
                  child: const Text(
                    "Salvar",
                    style: TextStyle(color: Colors.white),
                  ),
                )
              ],
            ),
          ),
        );
      },
      child: const Icon(
        Icons.add,
      ),
    );
  }

  Widget _contatoList() {
    return FutureBuilder(
      future: _databaseService.getContatos(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        return ListView.builder(
          itemCount: snapshot.data?.length ?? 0,
          itemBuilder: (context, index) {
            Contato contato = snapshot.data![index];
            return Card(
              margin:
                  const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
              elevation: 2.0,
              child: ListTile(
                  onLongPress: () {
                    _databaseService.deleteContato(contato.id);
                    setState(() {});
                  },
                  title: Text(contato.nome),
                  subtitle: Text(contato.latitude),
                  trailing: IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              EditContatoScreen(contato: contato),
                        ),
                      );
                    },
                  )),
            );
          },
        );
      },
    );
  }
}
