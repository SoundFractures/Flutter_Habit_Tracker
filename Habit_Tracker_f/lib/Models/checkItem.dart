class CheckItem {
  String text;
  bool checked;

  CheckItem(this.text, this.checked);
  Map toJson() {
    return {"text": text, "checked": checked};
  }
}
