class Contato {
  final int id;
  final String nome;
  final String latitude;
  final String longitude;

  Contato({
    required this.id,
    required this.nome,
    required this.latitude,
    required this.longitude,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': nome,
      'latitude': latitude,
      'longitude': longitude,
    };
  }
}
