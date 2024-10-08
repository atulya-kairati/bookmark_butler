enum Work { search, tag, none }

class WorkPacket {
  final Work work;
  final String text;

  WorkPacket.none()
      : work = Work.none,
        text = "";
  WorkPacket.search(this.text) : work = Work.search;
  WorkPacket.tag(this.text) : work = Work.tag;
}
