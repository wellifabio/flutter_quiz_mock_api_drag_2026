import '../lib/ui/style/theme.dart';
import '../lib/ui/splash.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Teste preenchimento que questões', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(title: 'Anotações', theme: AppTheme.appTheme, home: Splash()),
    );

    await tester.pumpAndSettle();
    await tester.enterText(find.byKey(Key('nome')), 'João da Silva');
    await tester.pump(const Duration(seconds: 1));
    await tester.tap(find.byKey(Key('iniciar')));
    await tester.pump(const Duration(seconds: 1));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(Key('op2')));
    await tester.pump(const Duration(seconds: 1));
    await tester.tap(find.byKey(Key('responder')));
    await tester.pump(const Duration(seconds: 1));
    await tester.tap(find.byKey(Key('ok')));
    await tester.pump(const Duration(seconds: 3));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(Key('proxima')));
    await tester.pump(const Duration(seconds: 1));
    await tester.tap(find.byKey(Key('op3')));
    await tester.pump(const Duration(seconds: 1));
    await tester.tap(find.byKey(Key('responder')));
    await tester.pump(const Duration(seconds: 1));
    await tester.tap(find.byKey(Key('ok')));
    await tester.pump(const Duration(seconds: 3));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(Key('proxima')));
    await tester.pump(const Duration(seconds: 1));
    final objeto1 = find.byKey(const Key('op1'));
    final objeto2 = find.byKey(const Key('op2'));
    final objeto3 = find.byKey(const Key('op3'));
    final alvo0 = find.byKey(const Key('lacuna0'));
    final alvo1 = find.byKey(const Key('lacuna1'));
    final alvo2 = find.byKey(const Key('lacuna2'));
    final objectCenter1 = tester.getCenter(objeto1);
    final targetCenter1 = tester.getCenter(alvo1);
    final objectCenter2 = tester.getCenter(objeto2);
    final targetCenter2 = tester.getCenter(alvo0);
    final objectCenter3 = tester.getCenter(objeto3);
    final targetCenter3 = tester.getCenter(alvo2);
    final gesture1 = await tester.startGesture(objectCenter1);
    await tester.pump();
    await gesture1.moveTo(targetCenter1);
    await tester.pumpAndSettle();
    await gesture1.up();
    await tester.pumpAndSettle();
    final gesture2 = await tester.startGesture(objectCenter2);
    await tester.pump();
    await gesture2.moveTo(targetCenter2);
    await tester.pumpAndSettle();
    await gesture2.up();
    await tester.pumpAndSettle();
    final gesture3 = await tester.startGesture(objectCenter3);
    await tester.pump();
    await gesture3.moveTo(targetCenter3);
    await tester.pumpAndSettle();
    await gesture3.up();
    await tester.pumpAndSettle();
    await tester.pump(const Duration(seconds: 1));
    await tester.tap(find.byKey(Key('responder')));
    await tester.pump(const Duration(seconds: 1));
    await tester.tap(find.byKey(Key('ok')));
    await tester.pump(const Duration(seconds: 3));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(Key('proxima')));
    await tester.pump(const Duration(seconds: 1));
    await tester.tap(find.byKey(Key('concluir')));
    await tester.pump(const Duration(seconds: 1));
    await tester.pumpAndSettle();
    await tester.pump(const Duration(seconds: 10));
  });
}
