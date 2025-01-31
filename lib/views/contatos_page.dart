import 'package:flutter/material.dart';

class ContactsPage extends StatefulWidget {
  const ContactsPage({super.key});

  @override
  State<ContactsPage> createState() => _ContactsPageState();
}

class _ContactsPageState extends State<ContactsPage> {
  // Lista inicial de contatos
  List<Map<String, String>> contacts = [
    {"name": "Alice Souza", "phone": "(11) 98765-4321"},
    {"name": "Bruno Lima", "phone": "(21) 99874-5678"},
    {"name": "Carla Mendes", "phone": "(31) 97654-1234"},
  ];

  // Método para exibir um diálogo e adicionar um novo contato
  void _addContact() {
    String newName = "";
    String newPhone = "";

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Novo Contato"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: const InputDecoration(labelText: "Nome"),
                onChanged: (value) {
                  newName = value;
                },
              ),
              TextField(
                decoration: const InputDecoration(labelText: "Telefone"),
                keyboardType: TextInputType.phone,
                onChanged: (value) {
                  newPhone = value;
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Cancelar"),
            ),
            ElevatedButton(
              onPressed: () {
                if (newName.isNotEmpty && newPhone.isNotEmpty) {
                  setState(() {
                    contacts.add({"name": newName, "phone": newPhone});
                  });
                  Navigator.of(context).pop();
                }
              },
              child: const Text("Adicionar"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Lista de Contatos"),
        backgroundColor: Colors.yellow,
      ),
      body: ListView.builder(
        itemCount: contacts.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: const Icon(Icons.person, color: Colors.blue),
            title: Text(contacts[index]["name"]!),
            subtitle: Text(contacts[index]["phone"]!),
            trailing: IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () {
                setState(() {
                  contacts.removeAt(index);
                });
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addContact,
        backgroundColor: Colors.yellow,
        child: const Icon(Icons.add, color: Colors.green),
      ),
    );
  }
}
