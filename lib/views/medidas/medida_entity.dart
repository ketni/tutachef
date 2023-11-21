class Medida {
  final String medida;
  final bool pendente;
  final String objectId;

  Medida({
    required this.medida,
    required this.pendente,
    required this.objectId,
  });

  factory Medida.fromJson(Map<String, dynamic> json) {
    return Medida(
      medida: json['medida'],
      pendente: json['pendente'] ?? false,
      objectId: json['objectId'],
    );
  }
}
