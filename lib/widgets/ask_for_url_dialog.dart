import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Future<T?> askForUrl<T>(
  BuildContext context,
  void Function(String) onSubmit,
) {
  final controller = TextEditingController();
  return showAdaptiveDialog<T>(
      context: context,
      builder: (context) {
        return Dialog(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text("Enter the URL"),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: controller,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () async {
                        final url = await Clipboard.getData("text/plain");
                        if (url != null) {
                          controller.text = url.text!;
                        }
                      },
                      icon: const Icon(Icons.copy),
                    )
                  ],
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.of(context).pop();
                    onSubmit(controller.text);
                  },
                  label: const Text("Fetch"),
                )
              ],
            ),
          ),
        );
      });
}
