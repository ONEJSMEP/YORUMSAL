import 'package:flutter/material.dart';

class UserCommentsScreen extends StatelessWidget {
  const UserCommentsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Burada gerçek uygulamada API'den veya state'den kullanıcı yorumlarını çekersin
    final comments = [
      "Ev çok temizdi ve ulaşım rahattı.",
      "Ev sahibi çok ilgiliydi.",
      "Lokasyon çok iyiydi, tavsiye ederim."
    ];
    return Scaffold(
      appBar: AppBar(title: Text('Yorumlarım')),
      body: ListView.builder(
        itemCount: comments.length,
        itemBuilder: (context, index) => ListTile(
          leading: Icon(Icons.comment),
          title: Text(comments[index]),
        ),
      ),
    );
  }
}
