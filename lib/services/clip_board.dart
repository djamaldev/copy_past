class ClipBoardManager {
  int? id;
  String? text;

  ClipBoardManager({
    this.id,
    this.text,
  });

  @override
  String toString() {
    return 'ClipBoardManager{id: $id, text: $text}';
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'text': text,
    };
  }

  ClipBoardManager.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    text = json['text'];
  }
}
