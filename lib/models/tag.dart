import 'package:objectbox/objectbox.dart';

@Entity()
class Tag {
  @Id(assignable: false)
  int id = 0;

  @Unique()
  final String tag;

  Tag(this.tag);

  @override
  String toString() {
    return tag;
  }
}
