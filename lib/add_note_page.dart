import 'package:flutter/material.dart';
import 'package:sample_note_app/notes_page.dart';
import 'package:sample_note_app/service/hive_service.dart';

import 'model/note_model.dart';

class AddNotePage extends StatelessWidget {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController contentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Not Ekle'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: titleController,
              decoration: InputDecoration(labelText: 'Başlık'),
            ),
            SizedBox(height: 8.0),
            TextField(
              controller: contentController,
              decoration: InputDecoration(labelText: 'İçerik'),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () => addNote(context),
              child: Text('Notu Kaydet'),
            ),
          ],
        ),
      ),
    );
  }

  void addNote(BuildContext context) async {
    final hiveService = HiveService<Note>(boxName: 'notes');
    await hiveService.init(); // HiveService'i başlat ve kutuyu aç

    final String title = titleController.text;
    final String content = contentController.text;

    if (title.isNotEmpty && content.isNotEmpty) {
      final note = Note(
        id: DateTime.now().toString(), // Benzersiz bir ID için
        title: title,
        content: content,
        createdDate: DateTime.now(),
      );

      await hiveService.addItemWithCustomKey(note.id, note);

      Navigator.push(context, MaterialPageRoute(builder: (context) => NotesPage()));
    }
  }
}
