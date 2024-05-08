import 'package:flutter/material.dart';
import 'package:aviefriky/db_helper.dart';
import 'package:aviefriky/update_user.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Aplikasi Barang',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Color.fromARGB(255, 0, 81, 202),
        ),
        useMaterial3: true,
      ),
      home: LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 66, 170, 255),
        title: Text('AviefRiky'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextField(
                  controller: _usernameController,
                  decoration: InputDecoration(
                    hintText: 'Username',
                    contentPadding: EdgeInsets.symmetric(horizontal: 20),
                    border: InputBorder.none,
                  ),
                ),
              ),
              SizedBox(height: 20),
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: 'Password',
                    contentPadding: EdgeInsets.symmetric(horizontal: 20),
                    border: InputBorder.none,
                  ),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MyHomePage(title: 'Aplikasi Barang'),
                    ),
                  );
                },
                child: Text('Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _namaController = TextEditingController();
  final _nimController = TextEditingController();
  List<Map<String, dynamic>> dataList = [];

  void _saveData() async {
    final nama = _namaController.text;
    final nim = _nimController.text;
    int insertId = await DatabaseHelper.insertUser(nama, nim);
    print(insertId);

    List<Map<String, dynamic>> updatedData = await DatabaseHelper.getData();
    setState(() {
      dataList = updatedData;
    });

    _namaController.text = '';
    _nimController.text = '';
  }

  @override
  void initState() {
    _fetchUsers();
    super.initState();
  }

  void _fetchUsers() async {
    List<Map<String, dynamic>> userList = await DatabaseHelper.getData();
    setState(() {
      dataList = userList;
    });
  }

  void _delete(int docId) async {
    // ignore: unused_local_variable
    int id = await DatabaseHelper.deleteData(docId);

    List<Map<String, dynamic>> updatedData = await DatabaseHelper.getData();
    setState(() {
      dataList = updatedData;
    });
  }

  void fetchData() async {
    List<Map<String, dynamic>> fetchedData = await DatabaseHelper.getData();
    setState(() {
      dataList = fetchedData;
    });
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
        backgroundColor: const Color.fromARGB(255, 66, 170, 255),
        title: Text(widget.title),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            children: [
              Column(
                children: [
                  TextFormField(
                    controller: _namaController,
                    decoration: const InputDecoration(hintText: 'Nama Barang'),
                  ),
                  TextFormField(
                    controller: _nimController,
                    decoration: const InputDecoration(hintText: 'NIM'),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
              ElevatedButton(
                onPressed: _saveData,
                child: const Text('Tambah'),
              ),
              SizedBox(height: 30),
              Expanded(
                child: ListView.builder(
                  itemCount: dataList.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(dataList[index]['nama']),
                      subtitle: Text(dataList[index]['nim']),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(
                              Icons.edit,
                              color: Colors.green[400],
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      UpdateUser(userId: dataList[index]['id']),
                                ),
                              ).then((result) {
                                if (result == true) {
                                  fetchData();
                                }
                              });
                            },
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.delete,
                              color: Colors.red[400],
                            ),
                            onPressed: () {
                              _delete(dataList[index]['id']);
                            },
                          ),
                        ],
                      ),
                    );
                  },
                ),
              )
            ],
          ),
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
