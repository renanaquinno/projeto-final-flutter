class ClientModel {
  int? id;
  String nome;
  String email;

  ClientModel({this.id, required this.nome, required this.email});

  // Converte um ClientModel para um Map (usado no SQLite)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': nome,
      'email': email,
    };
  }

  // Converte um Map para um ClientModel (usado ao buscar do SQLite)
  factory ClientModel.fromMap(Map<String, dynamic> map) {
    return ClientModel(
      id: map['id'],
      nome: map['nome'],
      email: map['email'],
    );
  }
}
