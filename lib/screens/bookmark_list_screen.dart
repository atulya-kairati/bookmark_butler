import 'package:bookmark_butler/provider/bookmark_notifier.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BookmarkListScreen extends StatelessWidget {
  static const String route = "/BookmarkListScreen";

  const BookmarkListScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Consumer<BookmarkNotifier>(
        builder: (context, bookmarkNotifier, child) {
          if (bookmarkNotifier.loading) {
            return const CircularProgressIndicator();
          }

          return ListView.builder(
            itemCount: bookmarkNotifier.bookmarks.length,
            itemBuilder: (context, index) {
              final bookmark = bookmarkNotifier.bookmarks[index];

              return ListTile(
                key: Key("${bookmark.id}"),
                title: Text(bookmark.title),
                trailing: Text(bookmark.url),
                subtitle: Text(bookmark.description),
              );
            },
          );
        },
      ),
    );
  }
}
