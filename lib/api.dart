class Api {
  static const String baseUrl =
      'https://raw.githubusercontent.com/wellifabio/senai2026/refs/heads/main/ds/assets/mockup';

  static String getQuestios() {
    return '$baseUrl/quizingles.json';
  }
}
