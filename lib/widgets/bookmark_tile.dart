import 'package:bookmark_butler/models/bookmark.dart';
import 'package:bookmark_butler/screens/add_bookmark_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

class BookmarkTile extends StatelessWidget {
  const BookmarkTile({
    super.key,
    required this.bookmark,
  });

  final Bookmark bookmark;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        key: Key("${bookmark.id}"),
        leading: const FlutterLogo(),
        title: Text(bookmark.title),
        subtitle: Text(
          bookmark.description,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          softWrap: false,
        ),
        trailing: IconButton(
          onPressed: () {
            Navigator.pushNamed(
              context,
              AddBookmarkScreen.route,
              arguments: bookmark,
            );
          },
          icon: const Icon(Icons.edit),
        ),
        onTap: () => _launchUrl(bookmark.url),
        onLongPress: () {
          Clipboard.setData(ClipboardData(text: bookmark.url));
        },
      ),
    );
  }

  Future<void> _launchUrl(String url) async {
    if (!await launchUrl(Uri.parse(url))) {
      throw Exception('Could not launch $url');
    }
  }
}
