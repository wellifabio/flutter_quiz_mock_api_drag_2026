import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import './widgets/janelas.dart';
import '../api.dart';

import 'splash.dart';

class Questions extends StatefulWidget {
  const Questions({super.key});

  @override
  State<Questions> createState() => _QuestionsState();
}

class _QuestionsState extends State<Questions> {
  List<dynamic> questions = [];
  int indice = 0, pontos = 0;
  @override
  initState() {
    super.initState();
    carregarQuestoesAPI();
  }

  Future<void> carregarQuestoesAPI() async {
    final url = Uri.parse(Api.getQuestios());
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        setState(() {
          questions = json.decode(response.body);
        });
      } else {
        if (mounted) {
          Janelas.msgDialog(
            'Erro de conexão',
            'Status code: ${response.statusCode}',
            context,
          );
        }
      }
    } catch (e) {
      if (mounted) {
        Janelas.msgDialog("Erro de conexão", e.toString(), context);
      }
    }
  }

  void alternativa(int num) {
    if (questions[indice]['correct'] == num) {
      pontos++;
      Janelas.msgDialog(
        "Resposta correta",
        "Parabéns, você acertou! $pontos pontos",
        context,
      );
    } else {
      Janelas.msgDialog(
        "Resposta incorreta",
        "Você tem $pontos pontos",
        context,
      );
    }
    if (indice < questions.length - 1) {
      setState(() {
        indice++;
      });
    } else {
      Janelas.msgDialog("Fim do quiz", "Você fez $pontos pontos", context);
    }
  }

  void backToSplash() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => Splash()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: backToSplash,
        ),
        title: Text('Quiz'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Center(
          child: questions.isEmpty
              ? CircularProgressIndicator()
              : questions[indice]['type'] == 'mult'
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  spacing: 20,
                  children: [
                    Text(questions[indice]['question']),
                    ...List.generate(
                      questions[indice]['answers'].length,
                      (i) => ElevatedButton(
                        onPressed: () => alternativa(i + 1),
                        child: Text(questions[indice]['answers'][i]),
                      ),
                    ),
                  ],
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  spacing: 20,
                  children: [
                    Text(questions[indice]['question']),
                    ElevatedButton(
                      onPressed: () {
                        if (indice < questions.length - 1) {
                          setState(() {
                            indice++;
                          });
                        } else {
                          Janelas.msgDialog(
                            "Fim do quiz",
                            "Você fez $pontos pontos",
                            context,
                          );
                        }
                      },
                      child: Text("Próxima questão"),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
