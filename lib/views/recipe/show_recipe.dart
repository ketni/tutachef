import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pdfLib;
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:tutachef_project/controllers/home_controller.dart';
import 'package:tutachef_project/views/reports/send_reports_view.dart';

import '../profile/user.dart';

class ShowRecipe extends StatefulWidget {
  ShowRecipe({
    super.key,
    required this.title,
    required this.ingredientes,
    required this.modoPreparo,
    required this.sugestaoChef,
    required this.src,
    required this.controller,
    required this.receitaId,
  });
  String title;
  List<String> ingredientes;
  String modoPreparo;
  String sugestaoChef;
  String src;
  String receitaId;
  final HomeController controller;

  @override
  State<ShowRecipe> createState() => _ShowRecipeState();
}

class _ShowRecipeState extends State<ShowRecipe> {
  Future<void> _requestPermissions() async {
    await Permission.manageExternalStorage.request();
    Permission.manageExternalStorage.isGranted;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _requestPermissions();
  }

  @override
  Widget build(BuildContext context) {
    User user = Provider.of<User>(context);

    double he = MediaQuery.of(context).size.height * 0.5;
    double wi = MediaQuery.of(context).size.width;

    Future<void> _saveRecipeAsPdf() async {
      // Criar um documento PDF
      final pdf = pdfLib.Document(
        pageMode: PdfPageMode.fullscreen,
      );

      ByteData data = await rootBundle.load('assets/logo/fundo.png');
      List<int> bytes = data.buffer.asUint8List();
      pdfLib.Image image = pdfLib.Image(
          height: 100,
          pdfLib.MemoryImage(Uint8List.fromList(bytes)),
          fit: pdfLib.BoxFit.contain);

      // Adicionar conteúdo ao PDF
      pdf.addPage(
        pdfLib.MultiPage(
          pageFormat: PdfPageFormat.a4.copyWith(height: 1000),
          build: (context) => [
            image,
            pdfLib.Text(widget.title,
                style: pdfLib.TextStyle(
                    fontSize: 20, fontWeight: pdfLib.FontWeight.bold)),
            pdfLib.SizedBox(height: 30),
            pdfLib.Text('Ingredientes:',
                style: pdfLib.TextStyle(
                    fontSize: 14, fontWeight: pdfLib.FontWeight.bold)),
            pdfLib.Text(widget.ingredientes
                .map((ingredient) => '• $ingredient')
                .join('\n')),
            pdfLib.SizedBox(height: 30),
            pdfLib.Text('Modo de Preparo:',
                style: pdfLib.TextStyle(
                    fontSize: 14, fontWeight: pdfLib.FontWeight.bold)),
            pdfLib.Text(widget.modoPreparo,
                textAlign: pdfLib.TextAlign.justify),
            pdfLib.SizedBox(height: 20),
            pdfLib.Row(
              children: [
                pdfLib.Text('Sugestão do Chef:   ',
                    style: pdfLib.TextStyle(
                        fontWeight: pdfLib.FontWeight.bold, fontSize: 14),
                    textAlign: pdfLib.TextAlign.justify),
                pdfLib.Text(widget.sugestaoChef),
              ],
            ),
          ],
        ),
      );

      // Obter o diretório temporário
      final directory = await getTemporaryDirectory();
      final path =
          '${directory.path}/receita_${DateTime.now().millisecondsSinceEpoch}.pdf';

      // Salvar o PDF no armazenamento externo
      final File file = File(path);
      await file.writeAsBytes(await pdf.save());
      OpenFile.open(file.path);

      // Mostrar diálogo de sucesso
      _showSuccessDialog(context,
          textContent: 'Receita salva em PDF com sucesso!');
    }

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        onPressed: () {
          Navigator.of(context).pop();
        },
        child: Icon(Icons.arrow_back, color: Colors.orange[700]),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniStartTop,
      body: SizedBox(
        width: wi,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: he * 0.5,
                width: wi,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.orange,
                      blurRadius: 10,
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                  child: Image.network(
                    widget.src,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 15,
                    ),
                    Text(
                      widget.title,
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    const Text('Ingredientes:',
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.bold)),
                    Text(widget.ingredientes
                        .toString()
                        .replaceAll(',', '\n')
                        .replaceAll('[', ' ')
                        .replaceAll(']', '')),
                    const SizedBox(
                      height: 30,
                    ),
                    const Text('Modo de Preparo:',
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.bold)),
                    Text(
                      widget.modoPreparo,
                      textAlign: TextAlign.justify,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Sugestão do Chef:   ',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        Expanded(
                          child: Wrap(
                            children: [
                              Text(
                                widget.sugestaoChef,
                                textAlign: TextAlign.justify,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        GestureDetector(
                          onTap: () => Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => SendReportView(
                                title: widget.title,
                                controller: widget.controller,
                                receitaId: widget.receitaId,
                                userEmail: user.email!,
                              ),
                            ),
                          ),
                          child: const Column(
                            children: [
                              Icon(
                                Icons.details_rounded,
                                size: 30,
                                color: Colors.red,
                              ),
                              Text('Denunciar')
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () => _showSuccessDialog(context,
                              receitaId: widget.receitaId, userId: user.userId),
                          child: Column(
                            children: [
                              Icon(
                                Icons.star_border_purple500,
                                size: 30,
                                color: Colors.amber[600],
                              ),
                              const Text('Favoritar')
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () async {
                            await _requestPermissions();

                            _saveRecipeAsPdf();
                          },
                          child: Column(
                            children: [
                              Icon(
                                Icons.picture_as_pdf,
                                size: 30,
                                color: Colors.green[700],
                              ),
                              const Text('Salvar em PDF'),
                            ],
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void _showSuccessDialog(BuildContext context,
      {String? textContent, String? userId, String? receitaId}) {
    var controller = Provider.of<HomeController>(context, listen: false);
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Sucesso'),
          content: Text(textContent ?? 'Receita adicionada aos favoritos!'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                controller.adicionarFavoritos(
                    userId: userId!, receitaId: receitaId);
                Navigator.of(context).pop(); // Fecha o diálogo
              },
              child: const Text(
                'OK',
                style: TextStyle(
                    fontSize: 18,
                    color: Colors.orange,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showErrorDialog(BuildContext context, {String? textContent}) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Erro'),
          content: Text(textContent ?? 'Erro ao salvar o PDF!'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Fecha o diálogo
              },
              child: const Text(
                'OK',
                style: TextStyle(
                    fontSize: 18,
                    color: Colors.orange,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ],
        );
      },
    );
  }
}
