import 'package:bookmark_butler/models/bookmark.dart';
import 'package:bookmark_butler/repositories/bookmark_repository.dart';
import 'package:flutter/material.dart';

class BookmarkNotifier extends ChangeNotifier {
  final BookmarkRepository _repository;

  BookmarkNotifier(BookmarkRepository repository) : _repository = repository {
    loadBookmarks();
  }

  List<Bookmark> _bookmarks = [];
  bool _loading = false;

  List<Bookmark> get bookmarks => List.unmodifiable(_bookmarks);
  bool get loading => _loading;

  Future<void> loadBookmarks() async {
    _loading = true;
    notifyListeners();

    await Future.delayed(const Duration(seconds: 1));
    _bookmarks = await _repository.getBookmarks();

    _loading = false;
    notifyListeners();
  }

  Future<void> addBookmark(Bookmark bookmark) async {
    await _repository.saveBookmark(bookmark);
    await loadBookmarks();
  }
}
