import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:multi_dropdown/multi_dropdown.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class User {
  final String name;
  final int id;

  User({required this.name, required this.id});

  @override
  String toString() {
    return 'User(name: $name, id: $id)';
  }
}

class _MyHomePageState extends State<MyHomePage> {
  final _formKey = GlobalKey<FormState>();

  final controller = MultiSelectController<User>();

  @override
  Widget build(BuildContext context) {
    var items = [
      DropdownItem(label: 'Nepal', value: User(name: 'Nepal', id: 1)),
      DropdownItem(label: 'Australia', value: User(name: 'Australia', id: 6)),
      DropdownItem(label: 'India', value: User(name: 'India', id: 2)),
      DropdownItem(label: 'China', value: User(name: 'China', id: 3)),
      DropdownItem(label: 'USA', value: User(name: 'USA', id: 4)),
      DropdownItem(label: 'UK', value: User(name: 'UK', id: 5)),
      DropdownItem(label: 'Germany', value: User(name: 'Germany', id: 7)),
      DropdownItem(label: 'France', value: User(name: 'France', id: 8)),
    ];
    return Scaffold(
        backgroundColor: Colors.white,
       );
  }
}