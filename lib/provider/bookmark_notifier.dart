import 'dart:developer';

import 'package:bookmark_butler/models/work_packet.dart';
import 'package:bookmark_butler/models/bookmark.dart';
import 'package:bookmark_butler/repositories/bookmark_repository.dart';
import 'package:bookmark_butler/repositories/tag_repository.dart';
import 'package:flutter/material.dart';

class BookmarkNotifier extends ChangeNotifier {
  final BookmarkRepository _bookmarkRepository;
  final TagRepository _tagRepository;

  BookmarkNotifier(
    BookmarkRepository bookmarkRepository,
    TagRepository tagRepository,
  )   : _bookmarkRepository = bookmarkRepository,
        _tagRepository = tagRepository {
    // loadBookmarks();
    loadTags();
  }

  Set<String> _tags = {};
  List<String> get tags => _tags.toList();

  List<Bookmark> _bookmarks = [];
  bool _loading = false;

  WorkPacket _work = WorkPacket.none();
  set work(WorkPacket wp) {
    _bookmarks.clear();
    _work = wp;
  }

  List<Bookmark> get bookmarks => List.unmodifiable(_bookmarks);
  bool get loading => _loading;

  Future<void> loadBookmarks() async {
    _loading = true;
    notifyListeners();

    await Future.delayed(const Duration(seconds: 1));

    switch (_work.work) {
      case Work.search:
        _bookmarks = await _bookmarkRepository.bookmarkByKeyword(_work.text);
        break;
      case Work.tag:
        _bookmarks = await _bookmarkRepository.bookmarkByTag(_work.text);
        break;
      case Work.none:
        _bookmarks = await _bookmarkRepository.getBookmarks();
    }

    _loading = false;
    notifyListeners();
  }

  Future<void> loadTags() async {
    _loading = true;
    notifyListeners();
    _tags = await _tagRepository.getTags();

    _loading = false;
    notifyListeners();
  }

  Future<void> addBookmark(Bookmark bookmark) async {
    await _bookmarkRepository.saveBookmark(bookmark);
    loadBookmarks();
    saveTags(bookmark.tags);
  }

  Future<void> saveTags(List<String> tags) async {
    await _tagRepository
        .saveTags(tags.where((tag) => !_tags.contains(tag)).toList());
    loadTags();
  }

  Future<List<Bookmark>> searchBookmarks(String searchTerm) async {
    log("searchBookmarks $searchTerm");
    return _bookmarkRepository.bookmarkByKeyword(searchTerm);
  }
}
