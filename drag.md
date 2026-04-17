# Drag and drop
Implementar drag and drop (arrastar e soltar) de um Container no Flutter envolve principalmente três widgets: **Draggable** (o item que é arrastado), **DragTarget** (a área onde o item é solto) e **Material** (para o feedback visual)

## Componentes principais
- **Draggable**: Envolve o Container original. Define o que acontece durante o arrasto (*feedback*) e o que fica no lugar original (*childWhenDragging*).
- **DragTarget**: Um widget que escuta quando um Draggable é solto sobre ele.
- **Dados (data)**: O Draggable passa informações para o DragTarget ao soltar.
### Exemplo de Código: Arrastar Container Colorido

```dart
import 'package:flutter/material.dart';

void main() => runApp(const MaterialApp(home: DragDropExample()));

class DragDropExample extends StatefulWidget {
  const DragDropExample({super.key});

  @override
  State<DragDropExample> createState() => _DragDropExampleState();
}

class _DragDropExampleState extends State<DragDropExample> {
  Color caughtColor = Colors.grey; // Cor inicial do destino

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Drag and Drop Container")),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // 1. O ITEM QUE PODE SER ARRASTADO (Draggable)
          Draggable<Color>(
            data: Colors.orangeAccent, // Dados a serem transferidos
            feedback: Container(
              color: Colors.orangeAccent.withOpacity(0.5),
              height: 100,
              width: 100,
              child: const Icon(Icons.directions_run),
            ),
            childWhenDragging: Container(
              color: Colors.grey, // Como fica o original
              height: 100,
              width: 100,
            ),
            child: Container(
              color: Colors.orangeAccent,
              height: 100,
              width: 100,
              child: const Center(child: Text("Arraste-me")),
            ),
          ),

          // 2. A ÁREA DE DESTINO (DragTarget)
          DragTarget<Color>(
            builder: (context, candidateData, rejectedData) {
              return Container(
                color: caughtColor, // Cor atualiza ao receber
                height: 100,
                width: 100,
                child: const Center(child: Text("Solte aqui")),
              );
            },
            onAccept: (color) {
              // Ação quando o item é solto com sucesso
              setState(() {
                caughtColor = color;
              });
            },
          ),
        ],
      ),
    );
  }
}
```
## Detalhes Importantes
- **feedback**: É o widget que segue o dedo/cursor. Deve ser envolvido em um Material se contiver texto ou ícones para evitar erros visuais.
- **data**: É o objeto transferido do Draggable para o DragTarget.
- **onAccept**: Onde você atualiza o estado (setState) após o item ser solto com sucesso. 
- Para cenários de reordenação em listas, o Flutter oferece o widget **ReorderableListView**.