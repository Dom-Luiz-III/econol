import 'package:flutter/material.dart';
import 'package:econol/core/calculo.dart';
import 'package:econol/core/button_animation.dart';

class EconomolPage extends StatefulWidget {
  const EconomolPage({Key? key}) : super(key: key);

  @override
  _EconomolPageState createState() => _EconomolPageState();
}

class _EconomolPageState extends State<EconomolPage> {
  final TextEditingController _gasolinaController = TextEditingController();
  final TextEditingController _etanolController = TextEditingController();
  String _resultado = '';

  void _calcularMelhorOpcao() {
    String gasolinaText = _gasolinaController.text.replaceAll(',', '.');
    String etanolText = _etanolController.text.replaceAll(',', '.');

    if (gasolinaText.isEmpty || etanolText.isEmpty) {
      _mostrarSnackBar('Informe os valores da gasolina e do etanol');
      return;
    }

    num gasolina = parseNumber(gasolinaText);
    num etanol = parseNumber(etanolText);

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

  void _mostrarSnackBar(String mensagem) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(mensagem),
        duration: const Duration(seconds: 2),
      ),
    );
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
            const SizedBox(height: 40.0),
            Center(
              child: SizedBox(
                width: 200,
                child: PushableButton(
                  height: 60,
                  elevation: 8,
                  hslColor: const HSLColor.fromAHSL(1.0, 120, 1.0, 0.37),
                  shadow: const BoxShadow(
                    color: Colors.grey,
                    spreadRadius: 2,
                    blurRadius: 7,
                    offset: Offset(0, 2),
                  ),
                  onPressed: _calcularMelhorOpcao,
                  width: 40,
                  child: const Text('Calcular', style: TextStyle(fontSize: 30)),
                ),
              ),
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
