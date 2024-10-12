import 'dart:developer';

import 'package:bookmark_butler/models/bookmark.dart';
import 'package:bookmark_butler/provider/bookmark_notifier.dart';
import 'package:bookmark_butler/widgets/favicon_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddBookmarkScreen extends StatefulWidget {
  static const String route = "/AddBookmarkScreen";
  const AddBookmarkScreen({super.key});

  @override
  State<AddBookmarkScreen> createState() => _AddBookmarkScreenState();
}

class _AddBookmarkScreenState extends State<AddBookmarkScreen> {
  final urlController = TextEditingController();
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();

  Set<String> selectedTags = {};

  late Bookmark? savedBookmark;
  late BookmarkNotifier notifier;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      savedBookmark = ModalRoute.of(context)?.settings.arguments as Bookmark?;
      if (savedBookmark != null) {
        final bookmark = savedBookmark!;

        urlController.text = bookmark.url;
        titleController.text = bookmark.title;
        descriptionController.text = bookmark.description;
        selectedTags = bookmark.tags.toSet();

        setState(() {}); // since we updated selectedTags
      }

      notifier = Provider.of<BookmarkNotifier>(context, listen: false);
    });
  }

  @override
  Widget build(BuildContext context) {
    print("_AddBookmarkScreenState.build called $selectedTags");

    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(
              height: height * 0.16,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox.square(
                    dimension: height * 0.16,
                    child: Card(
                      // margin: EdgeInsets.all(8),
                      child: FaviconWidget(url: urlController.text),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Wrap(
                        direction: Axis.horizontal,
                        spacing: 8,
                        runSpacing: 8,
                        children: selectedTags
                            .map((tag) => Chip(label: Text(tag)))
                            .toList(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            TextField(
              controller: urlController,
              onChanged: (value) {
                setState(() {});
              },
            ),
            TextField(
              controller: titleController,
            ),
            TextField(
              controller: descriptionController,
            ),
            Autocomplete(
              optionsBuilder: (tev) {
                if (tev.text == "") {
                  return const <String>[];
                }

                return notifier.tags
                    .where((tag) => tag.contains(tev.text.toLowerCase()));
              },
              fieldViewBuilder:
                  (context, viewFieldController, focusNode, onFieldSubmitted) {
                return TextField(
                  controller: viewFieldController,
                  focusNode: focusNode,
                  decoration: const InputDecoration(
                    hintText: "Start typing a Tag",
                  ),
                  onSubmitted: (value) {
                    if (selectedTags.contains(value)) return;
                    // TODO: pop a toast when tag already exists

                    setState(() {
                      selectedTags.add(value);
                    });

                    viewFieldController.clear();

                    print(selectedTags);

                    onFieldSubmitted(); // to close the autocomplete dropdown
                  },
                );
              },
              onSelected: (option) {
                print(option);
              },
            ),
            TextButton(
              child: const Text("Save"),
              onPressed: () async {
                try {
                  await notifier.addBookmark(constructBookmark());

                  if (!mounted) {
                    return; // dont proceed if the component isnt mounted anymore
                  }
                  Navigator.pop(context);
                } catch (e) {
                  log("Error occurred while saving the bookamrk: $e");
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    urlController.dispose();
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  Bookmark constructBookmark() {
    if (savedBookmark == null) {
      return Bookmark(
        urlController.text,
        titleController.text,
        descriptionController.text,
        selectedTags.toList(),
      );
    }

    final bookmark = savedBookmark!;

    bookmark.url = urlController.text;
    bookmark.title = titleController.text;
    bookmark.description = descriptionController.text;
    bookmark.tags = selectedTags.toList();

    return bookmark;
  }
}
