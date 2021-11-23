import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:convert';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  List _todoList = [];
  late Map<String, dynamic> _ultimoRemovido;
  late int _indiceUltimoRemovido;

  @override
  void initState() {
    super.initState();
    _lerDados().then((value) {
      setState(() {
        _todoList = json.decode(value!);
      });
    });
  }

  Future<File> _abreArquivo() async {
    final diretorio = await getApplicationDocumentsDirectory();
    return File("${diretorio.path}/todoList.json");
  }

  Future<String?> _lerDados() async {
    try {
      final arquivo = await _abreArquivo();
      return arquivo.readAsString();
    } catch(e) {
      return null;
    }
  }

  Future<File> _salvarDados() async {
    String dados = json.encode(_todoList);
    final file = await _abreArquivo();
    return file.writeAsString(dados);
  }

  Widget widgetToDo(BuildContext context, int index) {
    return Dismissible(
        key: Key(DateTime.now().microsecondsSinceEpoch.toString()),
        background: Container(
          color: Colors.red,
          child: const Align(
            alignment: Alignment(0.90, 0),
            child: Icon(Icons.delete_sweep_outlined, color: Colors.white),
          ),
        ),
        direction: DismissDirection.endToStart,
        child:  CheckboxListTile(
          title: Text(_todoList[index]["titulo"]),
          value: _todoList[index]["realizado"],
          secondary: CircleAvatar(
            backgroundColor: Theme.of(context).colorScheme.secondary,
            child: Icon(
                _todoList[index]["realizado"] ? Icons.check : Icons.error,
                color: Theme.of(context).colorScheme.primary
            ),
          ),
          onChanged: (value) {
            setState(() {
              _todoList[index]["realizado"] = value;
              _salvarDados();
            });
          },
        ),
        onDismissed: (direction) {
          setState(() {
            _ultimoRemovido = Map.from(_todoList[index]);
            _indiceUltimoRemovido = index;
            _todoList.removeAt(index);
            _salvarDados();
          });
          //mostrar a opção (com snackbar) para desfazer..
          //paramos aqui
        }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

