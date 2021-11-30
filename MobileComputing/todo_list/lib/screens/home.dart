import 'package:flutter/material.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'dart:convert';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List _todoList = [];
  final _todoController = TextEditingController();
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
    } catch (e) {
      return null;
    }
  }

  Future<File> _salvarDados() async {
    String dados = json.encode(_todoList);
    final file = await _abreArquivo();
    return file.writeAsString(dados);
  }

  void _adicionaTarefa() {
    setState(() {
      Map<String, dynamic> novoToDo = {};
      novoToDo["titulo"] = _todoController.text;
      novoToDo["realizado"] = false;
      _todoController.text = "";
      _todoList.add(novoToDo);
      _salvarDados();
    });
  }

  Future<void> _reordenaLista() async {
    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      _todoList.sort((a, b) {
        if(a["realizado"] && !b["realizado"]) return 1;
        if(!a["realizado"] && b["realizado"]) return -1;
        return 0;
      });
    });
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
        child: CheckboxListTile(
          title: Text(_todoList[index]["titulo"]),
          value: _todoList[index]["realizado"],
          secondary: CircleAvatar(
            backgroundColor: Theme.of(context).colorScheme.secondary,
            child: Icon(
                _todoList[index]["realizado"] ? Icons.check : Icons.error,
                color: Theme.of(context).colorScheme.primary),
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

          final snack = SnackBar(
            content: Text("Tarefa \"${_ultimoRemovido["titulo"]}\" removida!"),
            duration: const Duration(seconds: 4),
            action: SnackBarAction(
              label: "Desfazer",
              onPressed: () {
                setState(() {
                  _todoList.insert(_indiceUltimoRemovido, _ultimoRemovido);
                  _salvarDados();
                });
              },
            ),
          );
          //remove, se houver, a snackbar atual
          ScaffoldMessenger.of(context).removeCurrentSnackBar();

          //exibe a snackbar do item removido
          ScaffoldMessenger.of(context).showSnackBar(snack);
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("ToDo List"),
          centerTitle: true,
        ),
        body: Builder(
            builder: (context) => Column(
              children: [
                Container(
                  padding: const EdgeInsets.fromLTRB(17, 1, 7, 1),
                  child: Row(
                    children: [
                      Expanded(
                          child: TextField(
                            controller: _todoController,
                            maxLength: 90,
                            decoration:
                            const InputDecoration(labelText: "Nova Tarefa"),
                          )),
                      SizedBox(
                        height: 45,
                        width: 45,
                        child: FloatingActionButton(
                          child: const Icon(Icons.save),
                          onPressed: () {
                            if (_todoController.text.isEmpty) {
                              final snackAlerta = SnackBar(
                                content: const Text("Não pode ser vazio!"),
                                duration: const Duration(seconds: 4),
                                action: SnackBarAction(
                                  label: "Ok",
                                  onPressed: () {
                                    ScaffoldMessenger.of(context)
                                        .removeCurrentSnackBar();
                                  },
                                ),
                              );
                              ScaffoldMessenger.of(context)
                                  .removeCurrentSnackBar();
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackAlerta);
                            } else {
                              _adicionaTarefa();
                            }
                          },
                        ),
                      )
                    ],
                  ),
                ),
                const Padding(padding: EdgeInsets.only(top: 10)),
                Expanded(
                    child: RefreshIndicator(
                      onRefresh: _reordenaLista,
                      child: ListView.builder(
                        itemBuilder: widgetToDo,
                        itemCount: _todoList.length,
                        padding: const EdgeInsets.only(top: 10),
                      ),
                    )
                )
              ],
            )
        )
    );
  }
}

