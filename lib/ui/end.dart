import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import '../root/file.dart';

class End extends StatefulWidget {
  final int pontos;
  final int? total;
  final String? nome;
  const End({super.key, required this.pontos, this.total, this.nome});

  @override
  State<End> createState() => _EndState();
}

class _EndState extends State<End> {
  final fileManager = FileManager();
  String fileData = "";
  List<dynamic> Endados = [];

  @override
  initState() {
    super.initState();
    loadEnds();
  }

  void saveEnd() async {
    fileData +=
        "${DateTime.now()}, ${widget.nome}, ${widget.pontos}, ${widget.total}\n";
    await fileManager.writeData(fileData);
    if (mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Endado salvo com sucesso!")));
    }
    loadEnds();
  }

  void limparArquivo() async {
    await fileManager.writeData("");
    if (mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Endados limpos com sucesso!")));
    }
    loadEnds();
  }

  void loadEnds() async {
    String data = await fileManager.readData();
    Endados = [];
    setState(() {
      fileData = data;
      carregarLista();
    });
  }

  Future<void> carregarLista() async {
    List<String> linhas = fileData != "" ? fileData.split("\n") : [];
    for (int i = 0; i < linhas.length; i++) {
      List<String> partes = linhas[i].split(",");
      if (partes.length >= 3) {
        Endados.add({
          "data": partes[0],
          "nome": partes[1],
          "pontos": partes[2],
          "total": partes.length > 3 ? partes[3] : "",
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Endado")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 40,
          children: [
            Image.asset('assets/icone.png', width: 250),
            Text(
              "Parabéns ${widget.nome ?? ''} você acertou ${widget.pontos} questões \nde um total de ${widget.total ?? 0} questões",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(onPressed: saveEnd, child: Text("Salvar")),
                ElevatedButton(onPressed: limparArquivo, child: Text("Limpar")),
                ElevatedButton(
                  onPressed: () => SystemNavigator.pop(),
                  child: Text("Encerrar"),
                ),
              ],
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(12.0),
                child: Endados.isNotEmpty
                    ? ListView.separated(
                        itemBuilder: (context, i) {
                          return ListTile(
                            leading: Text(
                              "${DateFormat('dd/MM/yyyy').format(DateTime.parse(Endados[i]["data"].toString()))}\n${DateFormat('hh:mm').format(DateTime.parse(Endados[i]["data"].toString()))}h",
                              textAlign: TextAlign.center,
                            ),
                            title: Text(Endados[i]["nome"]),
                            subtitle: Text(
                              "Total de questões: ${Endados[i]["total"]}",
                            ),
                            trailing: Text("Acertos: ${Endados[i]["pontos"]}"),
                          );
                        },
                        separatorBuilder: (_, _) => Divider(),
                        itemCount: Endados.length,
                      )
                    : Center(child: Text("Nenhum Endado registrado.")),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
