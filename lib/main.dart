import 'package:bookmark_butler/provider/bookmark_notifier.dart';
import 'package:bookmark_butler/repositories/bookmark_repository.dart';
import 'package:bookmark_butler/repositories/tag_repository.dart';
import 'package:bookmark_butler/screens/add_bookmark_screen.dart';
import 'package:bookmark_butler/screens/bookmark_list_screen.dart';
import 'package:bookmark_butler/screens/home_screen.dart';
import 'package:bookmark_butler/screens/setting_screen.dart';
import 'package:bookmark_butler/services/object_box_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await ObjectBoxService.init();

  runApp(MultiProvider(
    providers: allProviders,
    child: const MyApp(),
  ));
}

List<SingleChildWidget> get allProviders {
  return [
    Provider<ObjectBoxService>(create: (_) => ObjectBoxService()),
    Provider<BookmarkRepository>(
      create: (context) => BookmarkRepository(
        Provider.of<ObjectBoxService>(context, listen: false),
      ),
    ),
    Provider<TagRepository>(
      create: (context) => TagRepository(
        Provider.of<ObjectBoxService>(context, listen: false),
      ),
    ),
    ChangeNotifierProvider<BookmarkNotifier>(
      create: (context) => BookmarkNotifier(
        Provider.of<BookmarkRepository>(context, listen: false),
        Provider.of<TagRepository>(context, listen: false),
      ),
    ),
  ];
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bookmark Butler',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      routes: {
        BookmarkListScreen.route: (_) => const BookmarkListScreen(),
        AddBookmarkScreen.route: (_) => const AddBookmarkScreen(),
        HomeScreen.route: (_) => const HomeScreen(),
        SettingScreen.route: (_) => const SettingScreen(),
      },
      initialRoute: HomeScreen.route,
    );
  }
}
