import 'dart:convert';

import 'package:english_quiz/ui/end.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import './style/colors.dart';
import './widgets/janelas.dart';
import '../root/api.dart';

import 'splash.dart';

class Questions extends StatefulWidget {
  final String nome;
  const Questions({super.key, required this.nome});

  @override
  State<Questions> createState() => _QuestionsState();
}

class _QuestionsState extends State<Questions> {
  List<dynamic> questions = [];
  int indice = 0, pontos = 0, opcao = -1;
  bool respondendo = true, respondido = false;
  List<String> palavrasAlvo = [];

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
          _resetLacunasAtuais();
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
        "assets/av5.webp",
        "Parabéns, você acertou! $pontos pontos",
        context,
      );
    } else {
      Janelas.msgDialog(
        "assets/av6.webp",
        "Que pena continua com $pontos pontos",
        context,
      );
    }
    setState(() {
      respondendo = false;
      respondido = true;
    });
  }

  void responderLacunas() {
    bool todasCorretas = true;
    setState(() {
      respondendo = false;
      respondido = true;
    });

    for (int i = 0; i < palavrasAlvo.length; i++) {
      if (palavrasAlvo[i] != questions[indice]['correct'][i]) {
        todasCorretas = false;
        break;
      }
    }

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(questions[indice]['correct'].toString())),
      );
    }

    if (todasCorretas) {
      pontos++;
      Janelas.msgDialog(
        "assets/av5.webp",
        "Parabéns, você acertou! $pontos pontos",
        context,
      );
    } else {
      Janelas.msgDialog(
        "assets/av6.webp",
        "Que pena continua com $pontos pontos",
        context,
      );
    }
    setState(() {
      respondendo = false;
    });
  }

  void conferirLacunasPreenchidas() {
    respondido = true;
    for (int i = 0; i < palavrasAlvo.length; i++) {
      if (palavrasAlvo[i] == "______") {
        respondido = false;
        break;
      }
    }
  }

  void _resetLacunasAtuais() {
    if (questions.isEmpty) {
      palavrasAlvo = [];
      return;
    }

    final partes = questions[indice]['question'].toString().split('_');
    final quantidadeLacunas = partes.length - 1;
    palavrasAlvo = List.generate(quantidadeLacunas, (_) => "______");
  }

  void proxima() {
    if (indice < questions.length - 1) {
      setState(() {
        indice++;
        respondendo = true;
        respondido = false;
        opcao = -1;
        _resetLacunasAtuais();
      });
    } else {
      goToEnd();
    }
  }

  void backToSplash() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => Splash()),
    );
  }

  void goToEnd() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) =>
            End(pontos: pontos, total: questions.length, nome: widget.nome),
      ),
    );
  }

  Column lacunas(int indice) {
    List<String> partes = questions[indice]['question'].split('_');

    if (palavrasAlvo.length != partes.length - 1) {
      _resetLacunasAtuais();
    }

    return Column(
      children: [
        ...List.generate(
          partes.length,
          (i) => Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(partes[i]),
              if (i < partes.length - 1)
                DragTarget<int>(
                  builder: (context, candidateData, child) {
                    return Container(
                      margin: EdgeInsets.symmetric(vertical: 5),
                      decoration: BoxDecoration(
                        color: AppColors.c4,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(color: AppColors.c2, width: 1),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          palavrasAlvo[i],
                          style: TextStyle(color: AppColors.c1, fontSize: 14),
                        ),
                      ),
                    );
                  },
                  onAcceptWithDetails: (details) {
                    setState(() {
                      palavrasAlvo[i] =
                          questions[indice]['answers'][details.data].toString();
                      conferirLacunasPreenchidas();
                    });
                  },
                ),
            ],
          ),
        ),
      ],
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
        title: Text("Player: ${widget.nome}"),
        actions: [ElevatedButton(onPressed: goToEnd, child: Text("Concluir"))],
      ),
      body: Padding(
        padding: EdgeInsets.all(18.0),
        child: Center(
          child: questions.isEmpty
              ? CircularProgressIndicator()
              : questions[indice]['type'] == 'mult'
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  spacing: 20,
                  children: [
                    Image.asset("assets/av2.webp", width: 250,),
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
                      onPressed: respondido ? proxima : null,
                      child: Text("Próxima questão"),
                    ),
                    ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      child: LinearProgressIndicator(
                        value:
                            1 /
                            questions.length *
                            (indice + 1), // % de progresso
                        minHeight: 15, // Altura da barra
                        backgroundColor: AppColors.c3,
                        color: AppColors.c2,
                      ),
                    ),
                  ],
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  spacing: 20,
                  children: [
                    Image.asset("assets/av3.webp", width: 250,),
                    lacunas(indice),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      spacing: 20,
                      children: [
                        ...List.generate(
                          questions[indice]['answers'].length,
                          (i) => Draggable<int>(
                            data: i,
                            feedback: Container(
                              margin: EdgeInsets.symmetric(vertical: 5),
                              decoration: BoxDecoration(
                                color: AppColors.c4,
                                borderRadius: BorderRadius.circular(18),
                                border: Border.all(
                                  color: AppColors.c2,
                                  width: 1,
                                ),
                              ),
                              child: Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text(
                                  questions[indice]['answers'][i],
                                  style: TextStyle(
                                    color: AppColors.c1,
                                    fontSize: 16,
                                    fontWeight: FontWeight.normal,
                                    decoration: TextDecoration.none,
                                  ),
                                ),
                              ),
                            ),
                            childWhenDragging: Container(
                              margin: EdgeInsets.symmetric(vertical: 5),
                              decoration: BoxDecoration(
                                color: AppColors.c3,
                                borderRadius: BorderRadius.circular(18),
                                border: Border.all(
                                  color: AppColors.c2,
                                  width: 1,
                                ),
                              ),
                              child: Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text(questions[indice]['answers'][i]),
                              ),
                            ),
                            child: Container(
                              margin: EdgeInsets.symmetric(vertical: 5),
                              decoration: BoxDecoration(
                                color: AppColors.c4,
                                borderRadius: BorderRadius.circular(18),
                                border: Border.all(
                                  color: AppColors.c2,
                                  width: 1,
                                ),
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
                                padding: EdgeInsets.all(8.0),
                                child: Text(questions[indice]['answers'][i]),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    ElevatedButton(
                      onPressed: respondido && respondendo
                          ? responderLacunas
                          : null,
                      child: Text("Responder"),
                    ),
                    ElevatedButton(
                      onPressed: respondido && !respondendo ? proxima : null,
                      child: Text("Próxima questão"),
                    ),
                    ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      child: LinearProgressIndicator(
                        value:
                            1 /
                            questions.length *
                            (indice + 1), // % de progresso
                        minHeight: 15, // Altura da barra
                        backgroundColor: AppColors.c3,
                        color: AppColors.c2,
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
