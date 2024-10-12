import 'package:http/http.dart' as http;
import 'package:html/parser.dart' show parse;

String baseUrl(String url) {
  final uri = Uri.parse(url);
  return uri.host;
}

Future<(String, String)> getSiteInfo(String url) async {
  final uri = Uri.parse(url);
  final response = await http.get(uri);

  final dom = parse(response.body);

  final title = dom.head
          ?.querySelector('meta[property="og:title"]')
          ?.attributes['content'] ??
      dom.head?.querySelector('title')?.innerHtml ??
      "";
  final description = dom.head
          ?.querySelector('meta[property="og:description"]')
          ?.attributes['content'] ??
      dom.head
          ?.querySelector('meta[name="description"]')
          ?.attributes['content'] ??
      "";

  return (title, description);
}
