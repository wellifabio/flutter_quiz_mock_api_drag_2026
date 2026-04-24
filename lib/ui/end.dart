import 'package:english_quiz/ui/splash.dart';
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
  List<dynamic> resultados = [];

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
      ).showSnackBar(SnackBar(content: Text("Resultado salvo com sucesso!")));
    }
    loadEnds();
  }

  void limparArquivo() async {
    await fileManager.writeData("");
    if (mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Resultados limpos com sucesso!")));
    }
    loadEnds();
  }

  void loadEnds() async {
    String data = await fileManager.readData();
    resultados = [];
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
        resultados.add({
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
      appBar: AppBar(title: Text("Resultado")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 20,
          children: [
            Image.asset('assets/av4.webp', width: 250),
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
                  onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Splash())),
                  child: Text("Reiniciar"),
                ),
              ],
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(12.0),
                child: resultados.isNotEmpty
                    ? ListView.separated(
                        itemBuilder: (context, i) {
                          return ListTile(
                            leading: Text(
                              "${DateFormat('dd/MM/yyyy').format(DateTime.parse(resultados[i]["data"].toString()))}\n${DateFormat('hh:mm').format(DateTime.parse(resultados[i]["data"].toString()))}h",
                              textAlign: TextAlign.center,
                            ),
                            title: Text(resultados[i]["nome"]),
                            subtitle: Text(
                              "Total de questões: ${resultados[i]["total"]}",
                            ),
                            trailing: Text(
                              "Acertos: ${resultados[i]["pontos"]}",
                            ),
                          );
                        },
                        separatorBuilder: (_, _) => Divider(),
                        itemCount: resultados.length,
                      )
                    : Center(child: Text("Nenhum Resultado registrado.")),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(0,0,0,50),
              child: ElevatedButton(
                onPressed: () => SystemNavigator.pop(),
                child: Text("Encerrar"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
