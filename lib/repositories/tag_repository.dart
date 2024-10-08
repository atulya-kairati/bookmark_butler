import 'package:bookmark_butler/models/tag.dart';
import 'package:bookmark_butler/services/object_box_service.dart';

class TagRepository {
  final ObjectBoxService _service;

  TagRepository(this._service);

  Future<Set<String>> getTags() async {
    return await _service.getTagSet();
  }

  Future<List<int>> saveTags(List<String> tags) {
    return _service.saveTags(tags.map((tag) => Tag(tag)).toList());
  }
}
