import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Econol',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const EconomolPage(),
    );
  }
}

class EconomolPage extends StatefulWidget {
  const EconomolPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _EconomolPageState createState() => _EconomolPageState();
}

class _EconomolPageState extends State<EconomolPage> {
  final TextEditingController _gasolinaController = TextEditingController();
  final TextEditingController _etanolController = TextEditingController();
  String _resultado = '';

  void _calcularMelhorOpcao() {
    String gasolinaText = _gasolinaController.text.replaceAll(',', '.');
    String etanolText = _etanolController.text.replaceAll(',', '.');

    NumberFormat numberFormat = NumberFormat('0.00', 'pt_BR');
    num gasolina = numberFormat.parse(gasolinaText);
    num etanol = numberFormat.parse(etanolText);

    // ignore: unnecessary_null_comparison
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
      // Remove vírgulas e pontos
      text = text.replaceAll(',', '').replaceAll('.', '');

      // Converter para número
      num value = num.tryParse(text) ?? 0;

      // Formatar para exibição
      NumberFormat numberFormat =
          NumberFormat.currency(locale: 'pt_BR', symbol: '', decimalDigits: 2);
      String formattedText = numberFormat.format(value / 100);

      // Atualizar o texto no controlador
      controller.value = controller.value.copyWith(
        text: formattedText,
        selection: TextSelection.collapsed(offset: formattedText.length),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Econol'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _gasolinaController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Preço da gasolina'),
              onChanged: (_) => _formatarNumero(_gasolinaController),
            ),
            TextField(
              controller: _etanolController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Preço do etanol'),
              onChanged: (_) => _formatarNumero(_etanolController),
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
    );
  }
}
