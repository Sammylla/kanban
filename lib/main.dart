import 'package:flutter/material.dart';

import 'view.dart';
import 'view_model.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final vm = KanbanViewModel();
  await vm.load();
  runApp(
    MaterialApp(
      title: '領収書管理',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.blue.shade700,
          foregroundColor: Colors.white,
        ),
      ),
      home: KanbanView(vm),
    ),
  );
}
