import 'dart:developer';

import 'package:bookmark_butler/models/bookmark.dart';
import 'package:bookmark_butler/provider/bookmark_notifier.dart';
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

  @override
  Widget build(BuildContext context) {
    final notifier = Provider.of<BookmarkNotifier>(context, listen: false);
    print("_AddBookmarkScreenState.build called");

    return Scaffold(
      body: Column(
        children: [
          TextField(
            controller: urlController,
          ),
          TextField(
            controller: titleController,
          ),
          TextField(
            controller: descriptionController,
          ),
          Row(
            children: selectedTags.map((tag) => Text(tag)).toList(),
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
                await notifier.addBookmark(Bookmark(
                  urlController.text,
                  titleController.text,
                  descriptionController.text,
                  selectedTags.toList(),
                ));

                if (!mounted)
                  return; // dont proceed if the component isnt mounted anymore
                Navigator.pop(context);
              } catch (e) {
                log("Error occurred while saving the bookamrk: $e");
              }
            },
          ),
        ],
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
}
