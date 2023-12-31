import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:sample_note_app/service/hive_service.dart';

import 'add_note_page.dart';
import 'model/note_model.dart';

class NotesPage extends StatelessWidget {
  const NotesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notlarım'),
        automaticallyImplyLeading: false,scrolledUnderElevation: 0,
      ),
      body: ValueListenableBuilder(
        valueListenable: Hive.box<Note>('notes').listenable(),
        builder: (context, Box<Note> box, _) {
          if (box.values.isEmpty) {
            return Center(child: Text('Henüz not yok.'));
          }
          return ListView.builder(
            itemCount: box.values.length,
            padding: EdgeInsets.only(bottom: 16.0),
            itemBuilder: (context, index) {
              final note = box.getAt(index);
              return Card(
                elevation: 4,
                margin: EdgeInsets.symmetric(horizontal: 16,vertical: 8),
                child: ListTile(
                  contentPadding: EdgeInsets.all(16),
                  title: Text(note!.title),
                  subtitle: Text(note.content),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () async {
                      final hiveService = HiveService<Note>(boxName: 'notes');
                      await hiveService.init();
                      await hiveService.removeItem(note.id);
                    },
                  ),
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
