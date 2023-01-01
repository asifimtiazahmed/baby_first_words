import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

import 'package:baby_f_words/models/items.dart';

class FileHandler {
  //Needs to be a singleton class, 1 instance for the whole project

  FileHandler.privateConstructor();
  static final FileHandler instance = FileHandler.privateConstructor();

  static File? _file;
  static const String _fileName = 'items_file.txt';
  static Set<Item> itemSet = {}; //Using set item to have the object be inside a set that can be later made to string

  //Get the data file
  Future<File> get file async {
    if (_file != null) return _file!;

    _file = await _initFile();
    return _file!;
  }

  Future<File> _initFile() async {
    final directory = await getApplicationDocumentsDirectory();
    final path = directory.path;
    return File('$path/$_fileName');
  }

  Future<void> writeItem(Item item) async {
    final File fl = await file;
    itemSet.add(item);
    final itemListMap = itemSet.map((e) => e.toJson()).toList();
    await fl.writeAsString(jsonEncode(itemListMap));
  }

  Future<List<Item>> readItems() async {
    final File fl = await file;
    final content = await fl.readAsString();

    final List<dynamic> jsonData = jsonDecode(content);
    final List<Item> items = jsonData
        .map(
          (e) => Item.fromJson(e as Map<String, dynamic>),
        )
        .toList();
    return items;
  }

  Future<void> deleteItem(Item item) async {
    final File fl = await file;

    itemSet.removeWhere((e) => e == item);
    final itemListMap = itemSet.map((e) => e.toJson()).toList();

    await fl.writeAsString(jsonEncode(itemListMap));
  }

  Future<void> updateItem({
    required int id,
    required Item updatedItem,
  }) async {
    itemSet.removeWhere((e) => e.name == updatedItem.name);
    await writeItem(updatedItem);
  }
}
