import 'dart:developer';

import 'package:bookmark_butler/models/bookmark.dart';
import 'package:bookmark_butler/models/work_packet.dart';
import 'package:bookmark_butler/provider/bookmark_notifier.dart';
import 'package:bookmark_butler/screens/add_bookmark_screen.dart';
import 'package:bookmark_butler/screens/bookmark_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  static const route = "HomeScreen/";
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final notifier = Provider.of<BookmarkNotifier>(context, listen: false);
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, AddBookmarkScreen.route);
        },
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
              child: SearchAnchor.bar(
                suggestionsBuilder: (context, controller) {
                  return (controller.text.length < 3)
                      ? []
                      : [
                          FutureBuilder<List<Bookmark>>(
                            future: notifier.searchBookmarks(controller.text),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const LinearProgressIndicator();
                              }
                              if (snapshot.hasError) {
                                // TODO: Handle error properly
                                return const LinearProgressIndicator();
                              }
                              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                                return const Center(child: Text("No match!"));
                              }

                              final bookmarks = snapshot.data!;

                              return Column(
                                children: bookmarks
                                    .map((b) => ListTile(
                                          key: Key(b.id.toString()),
                                          title: Text(b.title),
                                          trailing: Text(b.url),
                                          subtitle: Text(b.description),
                                        ))
                                    .toList(),
                              );
                            },
                          )
                        ];
                },
              ),
            ),
          ),
          Expanded(
            flex: 10,
            child: Consumer<BookmarkNotifier>(
              builder: (context, bookmarkNotifier, child) {
                if (bookmarkNotifier.loading) {
                  return const CircularProgressIndicator();
                }

                return ListView.builder(
                  itemCount: bookmarkNotifier.tags.length + 1,
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      return Card(
                        child: ListTile(
                          title: const Text("All"),
                          onTap: () {
                            bookmarkNotifier.work = WorkPacket.none();
                            bookmarkNotifier.loadBookmarks();
                            Navigator.pushNamed(
                                context, BookmarkListScreen.route);
                          },
                        ),
                      );
                    }

                    final tag = bookmarkNotifier.tags[index - 1];

                    return ListTile(
                      title: Text(tag),
                      onTap: () {
                        bookmarkNotifier.work = WorkPacket.tag(tag);
                        bookmarkNotifier.loadBookmarks();
                        Navigator.pushNamed(context, BookmarkListScreen.route);
                      },
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
