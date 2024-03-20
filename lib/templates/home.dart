import 'package:flutter/material.dart';
import 'package:econol/core/calculo.dart';
import 'package:econol/core/button_animation.dart';


class EconomolPage extends StatefulWidget {
  const EconomolPage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _EconomolPageState createState() => _EconomolPageState();
}

class _EconomolPageState extends State<EconomolPage> {
  final TextEditingController _gasolinaController = TextEditingController();
  final TextEditingController _etanolController = TextEditingController();
  String _resultado = '';
  bool _showResult = false;

  @override
  void initState() {
    super.initState();
    _gasolinaController.addListener(_updateResultVisibility);
    _etanolController.addListener(_updateResultVisibility);
  }

  void _updateResultVisibility() {
    setState(() {
      _showResult = false;
    });
  }

  void _calcularMelhorOpcao() {
    String gasolinaText = _gasolinaController.text.replaceAll(',', '.');
    String etanolText = _etanolController.text.replaceAll(',', '.');

    if (gasolinaText.isEmpty || etanolText.isEmpty) {
      _mostrarSnackBar('Informe os valores da gasolina e do etanol');
      return;
    }

    num gasolina = parseNumber(gasolinaText);
    num etanol = parseNumber(etanolText);

    // ignore: unnecessary_null_comparison
    if (etanol != null) {
      double proporcao = etanol / gasolina;
      setState(() {
        _resultado = proporcao <= 0.7
            ? 'Abasteça com etanol.'
            : 'Abasteça com gasolina.';
        _showResult = true;
      });
    } else {
      setState(() {
        _resultado = 'Digite valores válidos.';
        _showResult = true;
      });
    }
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
        title: const Text('ECONOL'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 50.0),
            TextField(
              controller: _gasolinaController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Preço da Gasolina',
                prefixIcon: Icon(Icons.local_gas_station),
              ),
              onChanged: (_) => _formatarNumero(_gasolinaController),
            ),
            const SizedBox(height: 40.0),
            TextField(
              controller: _etanolController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Preço do Etanol',
                prefixIcon: Icon(Icons.local_drink),
              ),
              onChanged: (_) => _formatarNumero(_etanolController),
            ),
            const SizedBox(height: 60.0),
            Center(
              child: SizedBox(
                width: 200,
                child: PushableButton(
                  height: 60,
                  elevation: 8,
                  hslColor: const HSLColor.fromAHSL(1.0, 0, 0, 0.5),
                  shadow: const BoxShadow(
                    color: Colors.grey,
                    spreadRadius: 2,
                    blurRadius: 7,
                    offset: Offset(0, 2),
                  ),
                  onPressed: () {
                    _calcularMelhorOpcao();
                    if (!_showResult) _scrollToResult();
                  },
                  width: 20,
                  child: const Text(
                    'Calcular',
                    style: TextStyle(
                      fontSize: 30,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeInOut,
              height: _showResult ? 50 : 0,
              child: Center(
                child: Text(
                  _resultado,
                  style: const TextStyle(fontSize: 18.0),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _scrollToResult() {
    Future.delayed(const Duration(milliseconds: 500), () {
      Scrollable.ensureVisible(context,
          alignment: 0.5, duration: const Duration(milliseconds: 500));
    });
  }
}
