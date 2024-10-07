import 'package:objectbox/objectbox.dart';

@Entity()
class Bookmark {
  @Id(assignable: false)
  int id = 0;

  String url;
  String title;
  String description;
  List<String> tags;

  @Property(type: PropertyType.date)
  DateTime createdOn;

  @Property(type: PropertyType.date)
  DateTime modifiedOn;

  Bookmark(
    this.url,
    this.title,
    this.description,
    this.tags,
  )   : createdOn = DateTime.now(),
        modifiedOn = DateTime.now();

  @override
  String toString() {
    return '\nBookmark[id: $id, url: $url, title: $title, description: $description, tags: $tags, createdOn: $createdOn, modifiedOn: $modifiedOn]';
  }
}
