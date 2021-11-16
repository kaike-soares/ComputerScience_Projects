import 'package:app_weather_map/widgets/clima_widget.dart';
import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:http/http.dart' as http;
import 'package:app_weather_map/model/clima_model.dart';
import 'dart:convert';

//Atalho: stf+tab
class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late ClimaModel climaModel;
  bool _carregando = false;

  final List<String> _cidades = [
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
  void initState() {
    super.initState();
    carregaClima();
  }

  carregaClima() async {
    setState(() {
      _carregando = true;
    });
    const String _apiURL = "api.openweathermap.org";
    const String _path = "/data/2.5/weather";
    const String _appid = ""; //Chave de API
    const String _units = "metric";
    const String _lang = "pt_br";

    final _parametros = {
      "q": _cidadeSelecionada,
      "appid": _appid,
      "units": _units,
      "lang": _lang
    };

    //essa linha faz a requisição para a API externa:
    final climaResponse =
        await http.get(Uri.https(_apiURL, _path, _parametros));

    //APENAS para testar:
    //print("Url acessada: ${climaResponse.request!.url.toString()}");
    //print(climaResponse.body);

    if (climaResponse.statusCode == 200) {
      setState(() {
        _carregando = false;
        climaModel = ClimaModel.fromJson(jsonDecode(climaResponse.body));
      });
    }
  }

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
              selectedItem: _cidadeSelecionada,
              items: _cidades,
              showSelectedItems: true,
              showSearchBox: true,
              maxHeight: height - padding.top - 60,
              onChanged: (value) {
                setState(() {
                  _cidadeSelecionada = value!;
                  carregaClima();
                });
              },
            ),
            Expanded(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(6),
                  child: _carregando
                      ? const CircularProgressIndicator(
                          strokeWidth: 3.0,
                          valueColor: AlwaysStoppedAnimation(Colors.blue))
                      : climaModel != null
                          ? ClimaWidget(climaModel: climaModel)
                          : Text(
                              "Sem dados para exibir",
                              style: Theme.of(context).textTheme.headline4,
                            ),
                ),
                Padding(
                    padding: EdgeInsets.all(8),
                    child: _carregando
                        ? Text("Carregando...",
                            style: Theme.of(context).textTheme.headline5)
                        : IconButton(
                            onPressed: carregaClima,
                            icon: const Icon(Icons.refresh),
                            iconSize: 50,
                            tooltip: "Recarregar",
                            color: Colors.blue,
                          ))
              ],
            ))
          ],
        ),
      ),
    );
  }
}
