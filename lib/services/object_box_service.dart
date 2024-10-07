import 'package:bookmark_butler/models/bookmark.dart';
import 'package:bookmark_butler/objectbox.g.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

class ObjectBoxService {
  late final Store _store;
  late final Box<Bookmark> _bookmarks;

  static ObjectBoxService? _service;

  ObjectBoxService._create(this._store) {
    _bookmarks = _store.box<Bookmark>();
  }

  static Future<ObjectBoxService> init() async {
    try {
      final docsDir = await getApplicationDocumentsDirectory();
      final store =
          await openStore(directory: p.join(docsDir.path, "bookmarks-obj"));

      _service = ObjectBoxService._create(store);

      return _service!;
    } catch (e) {
      throw Exception("Failed to initialize ObjectBoxService: $e");
    }
  }

  factory ObjectBoxService() {
    if (_service == null) {
      throw Exception(
          "ObjectBoxService not initialised. Call init() before using the service/");
    }

    return _service!;
  }

  Future<List<Bookmark>> getBookmarks() async {
    return _bookmarks.getAllAsync();
  }

  Future<int> format() async {
    return _bookmarks.removeAllAsync();
  }

  Future<int> saveOrUpdateBookmark(Bookmark bookmark) async {
    bookmark.modifiedOn = DateTime.now();

    if (bookmark.id == 0) {
      bookmark.createdOn = DateTime.now();
    }

    return _bookmarks.putAsync(bookmark);
  }

  Future<List<Bookmark>> getBookmarksByTag(String tag) async {
    final tagQuery = _bookmarks
        .query(Bookmark_.tags.containsElement(tag, caseSensitive: false))
        .build();

    return tagQuery.findAsync();
  }

  Future<List<Bookmark>> fuzzySearch(String keyword) async {
    final fuzzyQuery = _bookmarks
        .query(Bookmark_.title.contains(keyword, caseSensitive: false) |
            Bookmark_.description.contains(keyword, caseSensitive: false) |
            Bookmark_.url.contains(keyword, caseSensitive: false))
        .build();

    return fuzzyQuery.findAsync();
  }

  Future<bool> removeBookmark(int id) async {
    return _bookmarks.removeAsync(id);
  }
}
