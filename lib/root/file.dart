import 'dart:io';
import 'package:path_provider/path_provider.dart';

class FileManager {
  // 1. Encontrar o local para salvar o arquivo
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  // 2. Criar uma referência ao arquivo
  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/quizresults.txt');
  }

  // 3. Escrever dados no arquivo
  Future<File> writeData(String data) async {
    final file = await _localFile;
    // Escreve a string no arquivo
    return file.writeAsString(data);
  }

  // 4. Ler dados do arquivo
  Future<String> readData() async {
    try {
      final file = await _localFile;
      // Lê o arquivo
      String contents = await file.readAsString();
      return contents;
    } catch (e) {
      // Se houver erro, retorna uma string vazia
      return "";
    }
  }
}
