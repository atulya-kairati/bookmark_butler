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
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, AddBookmarkScreen.route);
        },
        child: const Icon(Icons.add),
      ),
      body: Consumer<BookmarkNotifier>(
        builder: (context, bookmarkNotifier, child) {
          if (bookmarkNotifier.loading) {
            return const CircularProgressIndicator();
          }

          return ListView.builder(
            itemCount: bookmarkNotifier.tags.length,
            itemBuilder: (context, index) {
              final tag = bookmarkNotifier.tags[index];

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
    );
  }
}
