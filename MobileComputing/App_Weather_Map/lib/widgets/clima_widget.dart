import 'package:flutter/material.dart';
import 'package:app_weather_map/model/clima_model.dart';

class ClimaWidget extends StatelessWidget {
  const ClimaWidget({Key? key, required this.climaModel}) : super(key: key);

  final ClimaModel climaModel;

  String _primeiraMaiuscula(String s) => (s[0].toUpperCase() + s.substring(1));

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image.network(
            "https://openweathermap.org/img/wn/${climaModel.icone}@2x.png",
            fit: BoxFit.fill,
            width: 110
        ),
        Text(
            "${climaModel.temperatura.toStringAsFixed(0)}ºC",
            style: const TextStyle(fontSize: 50)
        ),
        Text(
            _primeiraMaiuscula(climaModel.descricao),
            style: const TextStyle(fontSize: 30),
            textAlign: TextAlign.center
        ),
        const SizedBox(height: 24),
        Text(
            "Temperatura Mínima: ${climaModel.tempMin.toStringAsFixed(0)}ºC",
            style: const TextStyle(fontSize: 16),
            textAlign: TextAlign.center
        ),
        const SizedBox(height: 8),
        Text(
            "Temperatura Máxima: ${climaModel.temMax.toStringAsFixed(0)}ºC",
            style: const TextStyle(fontSize: 16),
            textAlign: TextAlign.center
        ),
        const SizedBox(height: 8),
        Text(
            "Sensação Térmica: ${climaModel.sensacaoTermica.toStringAsFixed(
                0)}ºC",
            style: const TextStyle(fontSize: 16),
            textAlign: TextAlign.center
        ),
        const SizedBox(height: 8),
        Text(
            "Umidade do Ar: ${climaModel.umidade}%",
            style: const TextStyle(fontSize: 16),
            textAlign: TextAlign.center
        ),
        const SizedBox(height: 8),
        Text(
            "Visibilidade: ${climaModel.visibilidade}Km",
            style: const TextStyle(fontSize: 16),
            textAlign: TextAlign.center
        ),
        const SizedBox(height: 8),
        Text(
            "Pressão Atmosférica: ${climaModel.pressao}hPa",
            style: const TextStyle(fontSize: 16),
            textAlign: TextAlign.center
        )
      ],
    );
  }
}
