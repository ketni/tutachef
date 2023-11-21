class Report {
  final String report;
  final bool pendente;
  final String objectId;
  final String createdAt;
  final String emailUser;
  final String receitaId;

  Report(
      {required this.report,
      required this.pendente,
      required this.objectId,
      required this.createdAt,
      required this.emailUser,
      required this.receitaId});

  factory Report.fromJson(Map<String, dynamic> json) {
    return Report(
        report: json['report'],
        pendente: json['pendente'],
        objectId: json['objectId'],
        createdAt: json['createdAt'],
        emailUser: json['user'],
        receitaId: json['receitaId']);
  }
}
