import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MaterialApp(
    home: ConversorMoedas(),
  ));
}

class ConversorMoedas extends StatefulWidget {
  @override
  _ConversorMoedasState createState() => _ConversorMoedasState();
}

class _ConversorMoedasState extends State<ConversorMoedas> {
  double? valor;
  String moedaSelecionada = 'USD';
  double? resultado;

  Future<void> converterMoeda() async {
    String url =
        'https://api.exchangerate-api.com/v4/latest/USD'; // API de conversão de moedas

    http.Response response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      Map<String, dynamic> dados = json.decode(response.body);
      double taxa = double.parse(dados['rates'][moedaSelecionada].toString());
      setState(() {
        resultado = valor! * taxa;
      });
    } else {
      throw Exception('Falha ao carregar dados da API');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Conversor de Moedas'),
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextField(
              decoration: InputDecoration(labelText: 'Valor em USD'),
              keyboardType: TextInputType.number,
              onChanged: (value) {
                setState(() {
                  valor = double.tryParse(value);
                });
              },
            ),
            SizedBox(height: 20.0),
            DropdownButton<String>(
              value: moedaSelecionada,
              onChanged: (String? newValue) {
                setState(() {
                  moedaSelecionada = newValue!;
                });
              },
              items: <String>['USD', 'BRL' ,'EUR', 'JPY', 'GBP', 'CAD']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: converterMoeda,
              child: Text('Converter'),
            ),
            SizedBox(height: 20.0),
            Text(resultado != null ? "Valor convertido: $resultado $moedaSelecionada" : ''),
          ],
        ),
      ),
    );
  }
}