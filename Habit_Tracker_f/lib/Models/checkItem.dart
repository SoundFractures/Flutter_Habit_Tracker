class CheckItem {
  String text;
  bool checked;

  CheckItem({this.text, this.checked});

  Map<String, dynamic> toJson() => {
        'text': text,
        'checked': checked,
      };
}
