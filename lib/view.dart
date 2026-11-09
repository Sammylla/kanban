import 'package:flutter/material.dart';

import 'model.dart';
import 'view_model.dart';

final names = ['受け取り前', '受け取り済み', '会計に引き渡し済み'];
final labels = ['受け取り前', '受け取り済み', '会計に引き渡し済み'];
final colors = [Colors.blue.shade50, Colors.blue.shade50, Colors.blue.shade50];

class KanbanView extends StatefulWidget {
  final KanbanViewModel vm;
  const KanbanView(this.vm, {super.key});

  @override
  State<KanbanView> createState() => _KanbanViewState();
}

class _KanbanViewState extends State<KanbanView> {
  final input = TextEditingController();

  void add() {
    widget.vm.add(input.text);
    input.clear();
  }

  Widget taskCard(Task t) {
    final s = t.status;
    final buttons = Wrap(
      spacing: 4,
      children: [
        if (s > 0)
          TextButton(
            onPressed: () => widget.vm.move(t, s - 1),
            child: Text('← ${labels[s - 1]}へ'),
          ),
        if (s < 2)
          FilledButton(
            onPressed: () => widget.vm.move(t, s + 1),
            child: Text('${labels[s + 1]}へ →'),
          ),
      ],
    );
    return Card(
      child: ListTile(title: Text(t.title), subtitle: buttons),
    );
  }

  Widget lane(int s) {
    final cards = [
      for (final t in widget.vm.tasks)
        if (t.status == s) taskCard(t),
    ];
    return SizedBox(
      width: 300,
      child: Card(
        color: colors[s],
        child: Column(
          children: [
            ListTile(title: Text(names[s]), trailing: Text('${cards.length}件')),
            Expanded(child: ListView(children: cards)),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    input.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final field = TextField(
      controller: input,
      decoration: InputDecoration(
        labelText: '領収書の内容',
        hintText: '例：文房具代（11月9日・1,200円）',
        border: OutlineInputBorder(),
      ),
    );
    final button = ValueListenableBuilder(
      valueListenable: input,
      builder: (context, value, child) => FilledButton.icon(
        onPressed: value.text.isEmpty ? null : add,
        icon: Icon(Icons.add),
        label: Text('受け取り前に追加'),
      ),
    );
    final entry = Card(
      child: Padding(
        padding: EdgeInsets.all(12),
        child: Column(
          children: [
            field,
            Align(alignment: Alignment.centerRight, child: button),
          ],
        ),
      ),
    );
    final board = ListenableBuilder(
      listenable: widget.vm,
      builder: (context, child) => ListView(
        scrollDirection: Axis.horizontal,
        children: [for (int s = 0; s < 3; s++) lane(s)],
      ),
    );

    return Scaffold(
      appBar: AppBar(title: Text('領収書管理')),
      body: Column(
        children: [
          entry,
          Expanded(child: board),
        ],
      ),
    );
  }
}
