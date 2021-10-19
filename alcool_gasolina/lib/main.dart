import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(
    home: Home(),
    debugShowCheckedModeBanner: false,
  ));
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  //Variáveis
  TextEditingController alcoolController = TextEditingController();
  TextEditingController gasolinaController = TextEditingController();
  String _resultado = "Informe os valores";
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  //Método
  void _calculaCombustivelIdeal() {
    double vAlcool = double.parse(alcoolController.text.replaceAll(',', '.'));
    double vGasolina = double.parse(
        gasolinaController.text.replaceAll(',', '.'));
    double proporcao = vAlcool / vGasolina;

    /*if(proporcao < 0.7){
      _resultado = "Abasteça com Álcool";
    } else{
      _resultado = "Abasteça com Gasolina"
    }*/

    setState(() {
      _resultado =
      (proporcao < 0.7) ? "Abasteça com Álcool" : "Abasteça com Gasolina";
      FocusScope.of(context).unfocus(); //abaixar o teclado
    });
  }
    void _reset() {
      setState(() {
        alcoolController.text = "";
        gasolinaController.text = "";
        _resultado = "Informe os valores";
        FocusScope.of(context).unfocus(); //abaixar o teclado
      });
    }



  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        centerTitle: true,
        title: const Text("Álcool ou Gasolina?"),
        actions: [
          IconButton(
            onPressed: () => _reset(),
            icon: const Icon(Icons.refresh), //Icone de reload
            color: Colors.grey,
          )
        ],
        flexibleSpace: Container( //Fundo degradê
          decoration: const BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: <Color>[Colors.green, Colors.blue, Colors.yellow])),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(10.0, 0, 10.0, 0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 20,),
              const Icon(
                Icons.local_gas_station,
                size: 140.0,
                color: Colors.lightGreen,
              ),
              TextFormField(
                controller: alcoolController,
                validator: (value) => value!.isEmpty ? "Informe o valor do Álcool" : null,
                keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                    signed: false
                ),
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.blue, fontSize: 26.0),
                decoration: const InputDecoration(
                  labelText: "Valor do Álcool",
                  labelStyle: TextStyle(color: Colors.blue)
                ),
              ),
              TextFormField(
                controller: gasolinaController,
                validator: (value) => value!.isEmpty ? "Informe o valor da Gasolina" : null,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                  signed: false
                ),
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.blue, fontSize: 26.0),
                decoration: const InputDecoration(
                    labelText: "Valor da Gasolina",
                    labelStyle: TextStyle(color: Colors.blue)
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20, bottom:20),
              child: SizedBox(
                height: 60.0,
                child: ElevatedButton(
                  onPressed: (){
                    if(_formKey.currentState!.validate()){
                      _calculaCombustivelIdeal();
                    }
                  },
                  child: const Text("Verificar"),
                ),
              ),
              ),
              Text(
                _resultado,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.lightBlue[900], fontSize: 26
                ),
              )
            ],
          ),
        )
      ),
    );
  }
}
