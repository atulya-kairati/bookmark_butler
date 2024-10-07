import 'package:bookmark_butler/models/bookmark.dart';
import 'package:bookmark_butler/services/object_box_service.dart';

class BookmarkRepository {
  final ObjectBoxService _service;

  BookmarkRepository(ObjectBoxService service) : _service = service;

  Future<List<Bookmark>> getBookmarks() async {
    return _service.getBookmarks();
  }

  Future<int> saveBookmark(Bookmark bookmark) async {
    return _service.saveOrUpdateBookmark(bookmark);
  }

  Future<bool> removeById(int id) async {
    return _service.removeBookmark(id);
  }

  Future<List<Bookmark>> bookmarkByTag(String tag) {
    return _service.getBookmarksByTag(tag);
  }

  Future<List<Bookmark>> bookmarkByKeyword(String keyword) {
    return _service.fuzzySearch(keyword);
  }
}
