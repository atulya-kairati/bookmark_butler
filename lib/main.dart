import 'package:bookmark_butler/provider/bookmark_notifier.dart';
import 'package:bookmark_butler/repositories/bookmark_repository.dart';
import 'package:bookmark_butler/services/object_box_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await ObjectBoxService.init();

  runApp(MultiProvider(
    providers: [
      Provider<ObjectBoxService>(create: (_) => ObjectBoxService()),
      Provider<BookmarkRepository>(
        create: (context) => BookmarkRepository(
          Provider.of<ObjectBoxService>(context, listen: false),
        ),
      ),
      ChangeNotifierProvider<BookmarkNotifier>(
        create: (context) => BookmarkNotifier(
          Provider.of<BookmarkRepository>(context, listen: false),
        ),
      ),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: Scaffold(
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
      ),
    );
  }
}
