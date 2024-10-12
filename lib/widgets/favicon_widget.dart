import 'package:bookmark_butler/services/url_service.dart';
import 'package:flutter/material.dart';

class FaviconWidget extends StatelessWidget {
  const FaviconWidget({
    super.key,
    required this.url,
  });

  final String url;

  @override
  Widget build(BuildContext context) {
    return Image.network(
      height: 32,
      width: 32,
      "https://icons.duckduckgo.com/ip3/${baseUrl(url)}.ico",
      // "https://logo.clearbit.com/${baseUrl(url)}",
      errorBuilder: (context, error, stackTrace) {
        return const Icon(
          Icons.public,
          size: 32,
        );
      },
    );
  }
}
