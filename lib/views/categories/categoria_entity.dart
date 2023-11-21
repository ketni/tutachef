class Categorie {
  final String categorie;
  final bool pendente;
  final String objectId;

  Categorie({
    required this.categorie,
    required this.pendente,
    required this.objectId,
  });

  factory Categorie.fromJson(Map<String, dynamic> json) {
    return Categorie(
      categorie: json['categorie'],
      pendente: json['pendente'],
      objectId: json['objectId'],
    );
  }
}
