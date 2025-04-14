import 'package:cloud_firestore/cloud_firestore.dart';

class ChatController {
  Future<String?> getOrCreateChatId(String uid) async {
    final userDoc = FirebaseFirestore.instance.collection('users').doc(uid);
    final userSnapshot = await userDoc.get();

    if (userSnapshot.exists && userSnapshot.data()!.containsKey('chatId')) {
      return userSnapshot['chatId'];
    } else {
      // Buat chat baru
      final newChatDoc = FirebaseFirestore.instance.collection('chats').doc();
      await newChatDoc.set({
        'createdAt': FieldValue.serverTimestamp(),
        'users': [uid, 'relawan-placeholder'], // Ganti dengan id relawan nanti
      });

      await userDoc.set({'chatId': newChatDoc.id}, SetOptions(merge: true));
      return newChatDoc.id;
    }
  }
}
