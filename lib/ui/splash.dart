import 'dart:async';

import 'package:flutter/material.dart';
import 'package:quiz/ui/questions.dart';
import 'style/colors.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> with TickerProviderStateMixin {
  late AnimationController _emtra1, _emtra2, _emtra3;
  late AnimationController _sai1, _sai2, _sai3;
  double _move1 = 0, _move2 = 0, _move3 = 0;

  @override
  void initState() {
    super.initState();
    startEntrada();
  }

  void entrada() {
    _emtra1 =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300))
          ..addListener(() {
            setState(() {
              _move1 = _emtra1.value * 300 - 300;
            });
          });
    _emtra2 =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300))
          ..addListener(() {
            setState(() {
              _move2 = _emtra2.value * 500 - 500;
            });
          });
    _emtra3 =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300))
          ..addListener(() {
            setState(() {
              _move3 = _emtra3.value * 700 - 700;
            });
          });
  }

  void saida() {
    _sai1 =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300))
          ..addListener(() {
            setState(() {
              _move1 = _sai1.value * 700;
            });
          });
    _sai2 =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300))
          ..addListener(() {
            setState(() {
              _move2 = _sai2.value * 700;
            });
          });
    _sai3 =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300))
          ..addListener(() {
            setState(() {
              _move3 = _sai3.value * 700;
            });
          });
  }

  void startEntrada() {
    _move1 = -300;
    _move2 = -500;
    _move3 = -700;
    entrada();
    _emtra1.forward();
    Timer(Duration(milliseconds: 300), () => _emtra2.forward());
    Timer(Duration(milliseconds: 600), () => _emtra3.forward());
  }

  void startSaida() {
    saida();
    _sai3.forward();
    Timer(Duration(milliseconds: 300), () => _sai2.forward());
    Timer(Duration(milliseconds: 600), () => _sai1.forward());
    if (mounted) {
      Timer(Duration(milliseconds: 900), () => goToQuestions());
    }
  }

  void goToQuestions() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => Questions()),
    );
  }

  @override
  void dispose() {
    _sai1.dispose();
    _sai2.dispose();
    _sai3.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: AppColors.c3,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 30,
            children: [
              Transform.translate(
                offset: Offset(0, _move1),
                child: Text(
                  "Quiz de\nInglês",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 22,
                    color: AppColors.c1,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Transform.translate(
                offset: Offset(0, _move2),
                child: GestureDetector(
                  onTap: () {
                    //Recarregar a página
                    setState(() {
                      startEntrada();
                    });
                  },
                  child: Image.asset("assets/av1.webp", height: 200),
                ),
              ),
              Transform.translate(
                offset: Offset(0, _move3),
                child: ElevatedButton(
                  onPressed: () => {
                    setState(() {
                      startSaida();
                    }),
                  },
                  child: Text("Iniciar"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
