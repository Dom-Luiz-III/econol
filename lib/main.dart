import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final TextEditingController _gasolinaController = TextEditingController();
  final TextEditingController _etanolController = TextEditingController();
  String _resultado = '';

  void _calcularMelhorOpcao() {
    String gasolinaText = _gasolinaController.text.replaceAll(',', '.');
    String etanolText = _etanolController.text.replaceAll(',', '.');

    NumberFormat numberFormat = NumberFormat('0.00', 'pt_BR');
    num gasolina = numberFormat.parse(gasolinaText);
    num etanol = numberFormat.parse(etanolText);

    if (etanol != null) {
      double proporcao = etanol / gasolina;
      if (proporcao <= 0.7) {
        _resultado = 'Abasteça com etanol.';
      } else {
        _resultado = 'Abasteça com gasolina.';
      }
    } else {
      _resultado = 'Digite valores válidos.';
    }

    setState(() {});
  }

  void _formatarNumero(TextEditingController controller) {
    String text = controller.text;
    if (text.isNotEmpty) {
      NumberFormat numberFormat = NumberFormat('0.00', 'pt_BR');
      String formattedText = numberFormat.format(double.parse(text));
      if (formattedText != text) {
        controller.value = controller.value.copyWith(
          text: formattedText,
          selection: TextSelection.collapsed(offset: formattedText.length),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Comparador de Combustível'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                controller: _gasolinaController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Preço da gasolina'),
                onEditingComplete: () => _formatarNumero(_gasolinaController),
              ),
              TextField(
                controller: _etanolController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Preço do etanol'),
                onEditingComplete: () => _formatarNumero(_etanolController),
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _calcularMelhorOpcao,
                child: const Text('Calcular'),
              ),
              const SizedBox(height: 16.0),
              Text(
                _resultado,
                style: const TextStyle(fontSize: 18.0),
              ),
            ],
          ),
        ),
      ),
    );
  }
}