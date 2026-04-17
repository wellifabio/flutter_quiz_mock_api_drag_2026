import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:quiz/style/colors.dart';
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
  int indice = 0, pontos = 0, opcao = -1;
  bool respondendo = true;

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

  void responder() {
    if (questions[indice]['correct'] - 1 == opcao) {
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
    setState(() {
      respondendo = false;
    });
  }

  void proxima() {
    if (indice < questions.length - 1) {
      setState(() {
        indice++;
        respondendo = true;
        opcao = -1;
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
                    RadioGroup<int>(
                      onChanged: (value) => setState(() {
                        opcao = value!;
                      }),
                      groupValue: opcao,
                      child: Column(
                        children: [
                          ...List.generate(
                            questions[indice]['answers'].length,
                            (i) => RadioListTile(
                              title: Text(questions[indice]['answers'][i]),
                              value: i,
                              enabled: respondendo,
                            ),
                          ),
                        ],
                      ),
                    ),
                    ElevatedButton(
                      onPressed: opcao == -1 || !respondendo ? null : responder,
                      child: Text("Responder"),
                    ),
                    ElevatedButton(
                      onPressed: respondendo ? null : proxima,
                      child: Text("Próxima questão"),
                    ),
                  ],
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  spacing: 20,
                  children: [
                    Text(questions[indice]['question']),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      spacing: 20,
                      children: [
                        ...List.generate(
                          questions[indice]['answers'].length,
                          (i) => Container(
                            margin: const EdgeInsets.symmetric(vertical: 5),
                            decoration: BoxDecoration(
                              color: AppColors.c4,
                              borderRadius: BorderRadius.circular(18),
                              border: Border.all(color: AppColors.c2, width: 1),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.t2,
                                  spreadRadius: 2,
                                  blurRadius: 5,
                                  offset: Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(questions[indice]['answers'][i]),
                            ),
                          ),
                        ),
                      ],
                    ),
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
