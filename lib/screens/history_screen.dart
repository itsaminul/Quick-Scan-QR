import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../core/history_storage.dart';
import '../core/favorite_storage.dart'; // Make sure to create this file

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  List<String> history = [];

  @override
  void initState() {
    super.initState();
    loadHistory();
  }

  Future<void> loadHistory() async {
    history = await HistoryStorage.getHistory();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Scan History"),
        actions: [
          if (history.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_forever),
              onPressed: () async {
                await HistoryStorage.clearAll();
                loadHistory();
              },
            )
        ],
      ),
      body: history.isEmpty
          ? const Center(
        child: Text("No scan history yet"),
      )
          : ListView.builder(
        itemCount: history.length,
        itemBuilder: (context, index) {
          return Card(
            margin: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 6,
            ),
            child: ListTile(
              title: Text(
                history[index],
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Copy button
                  IconButton(
                    icon: const Icon(Icons.copy),
                    onPressed: () {
                      Clipboard.setData(
                        ClipboardData(text: history[index]),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Copied"),
                        ),
                      );
                    },
                  ),
                  // Favorite button
                  IconButton(
                    icon: const Icon(Icons.favorite_border),
                    onPressed: () async {
                      await FavoriteStorage.addFavorite(history[index]);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Added to favorites"),
                        ),
                      );
                    },
                  ),
                  // Delete button
                  IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () async {
                      await HistoryStorage.deleteItem(index);
                      loadHistory();
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
