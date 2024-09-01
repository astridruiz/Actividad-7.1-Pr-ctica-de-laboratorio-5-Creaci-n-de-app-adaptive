import 'dart:async';
import 'package:flutter/material.dart';

class ListaStreams extends StatefulWidget {
  const ListaStreams({super.key});
  @override
  State<ListaStreams> createState() => _ListaStreamsState();
}

class _ListaStreamsState extends State<ListaStreams> {
  late StreamController<List<String>> _streamController;
  late List<String> _items;

  @override
  void initState() {
    super.initState();
    _items = [];
    _streamController = StreamController<List<String>>();
    _streamController.add(_items);
  }

  @override
  void dispose() {
    _streamController.close();
    super.dispose();
  }

  void _addItem(String item) {
    _items.add(item);
    _streamController.add(_items);
  }

  void _eliminartarea(int index) {
    _items.removeAt(index);
    _streamController.add(_items);
  }

  void _editartarea(BuildContext context, int index, String currentItem) {
    TextEditingController _editartarea =
        TextEditingController(text: currentItem);
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Editar tarea'),
          content: TextField(
            controller: _editartarea,
            decoration: const InputDecoration(
              labelText: 'Nuevo valor',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                if (_editartarea.text.isNotEmpty) {
                  _items[index] = _editartarea.text;
                  _streamController.add(_items);
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Guardar'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // ignore: no_leading_underscores_for_local_identifiers
    TextEditingController _textController = TextEditingController();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Streams'),
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(9.0),
            child: TextField(
              controller: _textController,
              decoration: const InputDecoration(
                labelText: 'Nuevo item',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              if (_textController.text.isNotEmpty) {
                _addItem(_textController.text);
                _textController.clear();
              }
            },
            child: const Text('Agregar Item'),
          ),
          Expanded(
            child: StreamBuilder<List<String>>(
              stream: _streamController.stream,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No hay items en la lista'));
                }
                return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    return Card(
                      elevation: 4,
                      margin: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      child: ListTile(
                        title: Text(
                          snapshot.data![index],
                          style: const TextStyle(fontSize: 18),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () {
                                _editartarea(
                                    context, index, snapshot.data![index]);
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () {
                                _eliminartarea(index);
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
