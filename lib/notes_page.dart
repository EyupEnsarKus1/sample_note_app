import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:sample_note_app/service/hive_service.dart';

import 'add_note_page.dart';
import 'model/note_model.dart';

class NotesPage extends StatelessWidget {
  const NotesPage({super.key});

  void _showEditDialog(BuildContext context, Note note, int index) {
    final titleController = TextEditingController(text: note.title);
    final contentController = TextEditingController(text: note.content);

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Notu Düzenle'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(hintText: 'Başlık'),
              ),
              TextField(
                controller: contentController,
                decoration: const InputDecoration(hintText: 'İçerik'),
              ),
            ],
          ),
          actions: <Widget>[
            ElevatedButton(
              child: const Text('İptal'),
              onPressed: () => Navigator.of(dialogContext).pop(),
            ),
            ElevatedButton(
              child: const Text('Kaydet'),
              onPressed: () async {
                final hiveService = HiveService<Note>(boxName: 'notes');
                await hiveService.init();
                final updatedNote = Note(id: note.id, title: titleController.text, content: contentController.text, createdDate: note.createdDate);
                await hiveService.updateItem(note.id, updatedNote);
                Navigator.of(dialogContext).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notlarım'),
        automaticallyImplyLeading: false,
        scrolledUnderElevation: 0,
      ),
      body: ValueListenableBuilder(
        valueListenable: Hive.box<Note>('notes').listenable(),
        builder: (context, Box<Note> box, _) {
          if (box.values.isEmpty) {
            return const Center(child: Text('Henüz not yok.'));
          }
          return ListView.builder(
            itemCount: box.values.length,
            padding: const EdgeInsets.only(bottom: 16.0),
            itemBuilder: (context, index) {
              final note = box.getAt(index);
              final formattedDate = DateFormat('dd/MM/yyyy').format(note!.createdDate);

              return Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF7286D3),
                  borderRadius: BorderRadius.circular(12),
                ),
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            note.title,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Text(
                          formattedDate,
                          style: TextStyle(color: Colors.black, fontSize: 12),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(note.content),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        GestureDetector(onTap: () => _showEditDialog(context, note, index), child: const Icon(Icons.edit, color: Colors.black)),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.black),
                          onPressed: () async {
                            final hiveService = HiveService<Note>(boxName: 'notes');
                            await hiveService.init();
                            await hiveService.removeItem(note.id);
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => AddNotePage()),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
