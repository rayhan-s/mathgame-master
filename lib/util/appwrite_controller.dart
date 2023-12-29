import 'package:appwrite/appwrite.dart';

class AppwriteController {
  late final Databases database;

  AppwriteController() {
    init();
  }

  void init() {
    final client = Client()
        .setEndpoint('https://cloud.appwrite.io/v1')
        .setProject('658d7d32b54287c45f4c');

    database = Databases(client);
  }

  Future<void> sendUserAnswer(String userAnswer, String documentId) async {
    try {
      await database.createDocument(
        collectionId: '658d8b5e81b5cd98f2bd',
        data: {
          'userAnswer': userAnswer,
        },
        databaseId: '658d7d50896fd39ab79b',
        documentId: documentId,
      );
    } catch (e) {
      print('Error sending user answer: $e');
    }
  }
}
