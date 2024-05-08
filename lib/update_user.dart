import 'package:flutter/material.dart';
import 'package:aviefriky/db_helper.dart';

class UpdateUser extends StatefulWidget {
  const UpdateUser({Key? key, required this.userId}) : super(key: key);
  final int userId;

  @override
  State<UpdateUser> createState() => _UpdateUserState();
}

class _UpdateUserState extends State<UpdateUser> {
  final _namaController = TextEditingController();
  final _nimController = TextEditingController();

  void fetchData() async {
    Map<String, dynamic>? data =
        await DatabaseHelper.getSingleData(widget.userId);

    if (data != null) {
      _namaController.text = data['nama'];
      _nimController.text = data['nim'];
    }
  }

  @override
  void initState() {
    fetchData();
    super.initState();
  }

  void _updateData(BuildContext context) async {
    Map<String, dynamic> data = {
      'nama': _namaController.text,
      'nim': _nimController.text,
    };

    // ignore: unused_local_variable
    int id = await DatabaseHelper.updateData(widget.userId, data);
    Navigator.pop(context, true);
  }

  @override
  void dispose() {
    _namaController.dispose();
    _nimController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('Update User'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextFormField(
              controller: _namaController,
              decoration: const InputDecoration(hintText: 'Nama Barang'),
            ),
            TextFormField(
              controller: _nimController,
              decoration: const InputDecoration(hintText: 'Jumlah'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _updateData(context);
              },
              child: const Text('Save User'),
            )
          ],
        ),
      ),
    );
  }
}
