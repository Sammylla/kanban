class Task {
  String title;
  int status; // 0:受け取り前 1:受け取り済み 2:会計に引き渡し済み
  Task(this.title, [this.status = 0]);
}
