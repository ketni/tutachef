class Ingrediente {
  final String ingrediente;
  final bool pendente;
  final String objectId;

  Ingrediente({
    required this.ingrediente,
    required this.pendente,
    required this.objectId,
  });

  factory Ingrediente.fromJson(Map<String, dynamic> json) {
    return Ingrediente(
      ingrediente: json['ingrediente'],
      pendente: json['pendente'],
      objectId: json['objectId'],
    );
  }
}
