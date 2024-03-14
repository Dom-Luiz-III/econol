import 'package:flutter/material.dart';
import 'package:econol/core/calculo.dart';

class EconomolPage extends StatefulWidget {
  const EconomolPage({required Key? key}) : super(key: key);

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

    num gasolina = parseNumber(gasolinaText);
    num etanol = parseNumber(etanolText);

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
      text = text.replaceAll(',', '').replaceAll('.', '');
      num value = num.tryParse(text) ?? 0;
      String formattedText = formatCurrency(value / 100);

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