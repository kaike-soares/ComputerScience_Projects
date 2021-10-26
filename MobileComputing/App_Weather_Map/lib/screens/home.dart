import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';


//Atalho: stf+tab
class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  List<String> _cidades = [
    "Aracaju",
    "Belém",
    "Belo Horizonte",
    "Boa Vista",
    "Brasilia",
    "Campo Grande",
    "Cuiaba",
    "Curitiba",
    "Florianópolis",
    "Fortaleza",
    "Goiânia",
    "João Pessoa",
    "Macapá",
    "Maceió",
    "Manaus",
    "Natal",
    "Palmas",
    "Porto Alegre",
    "Porto Velho",
    "Recife",
    "Rio Branco",
    "Rio de Janeiro",
    "Salvador",
    "São Luís",
    "São Paulo",
    "Teresina",
    "Vitória"
  ];

  //Cidade pré-selecionada
  String _cidadeSelecionada = "São Paulo";

  @override
  Widget build(BuildContext context) {

    double height = MediaQuery.of(context).size.height;
    var padding = MediaQuery.of(context).padding;

    return Scaffold(
      appBar: AppBar(
        title: Text(_cidadeSelecionada),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          children: [
            DropdownSearch<String>(
              mode: Mode.MENU,
              items:_cidades,
              showSelectedItems: true,
              showSearchBox: true,
              maxHeight: height - padding.top - 60,
              onChanged: (value){
                setState(() {
                  _cidadeSelecionada = value!;
                });
              },
            )
          ],
        )
      )
    );
  }
}
