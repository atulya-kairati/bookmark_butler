import 'package:bookmark_butler/models/bookmark.dart';
import 'package:bookmark_butler/models/tag.dart';
import 'package:bookmark_butler/objectbox.g.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

class ObjectBoxService {
  late final Store _bookmarkStore;
  late final Store _tagStore;
  late final Box<Bookmark> _bookmarks;
  late final Box<Tag> _tags;

  static ObjectBoxService? _service;

  ObjectBoxService._create(this._bookmarkStore, this._tagStore) {
    _bookmarks = _bookmarkStore.box<Bookmark>();
    _tags = _tagStore.box<Tag>();
  }

  static Future<ObjectBoxService> init() async {
    try {
      final docsDir = await getApplicationDocumentsDirectory();
      final bookmarkStore = await openStore(
        directory: p.join(
          docsDir.path,
          "bookmarks-obj",
        ),
      );

      final tagStore = await openStore(
        directory: p.join(
          docsDir.path,
          "tags-obj",
        ),
      );

      _service = ObjectBoxService._create(bookmarkStore, tagStore);

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

  Future<Set<String>> getTagSet() async {
    return (await _tags.getAllAsync()).map((t) => t.tag).toSet();
  }

  Future<List<int>> saveTags(List<Tag> tags) async {
    return _tags.putManyAsync(tags);
  }
}
