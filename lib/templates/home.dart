import 'package:flutter/material.dart';
import 'package:econol/core/calculo.dart';
import 'package:econol/templates/sobre.dart';

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
        actions: [
          IconButton(
            icon: const Icon(Icons.info),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SobrePage()),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 25.0),
              TextField(
                controller: _gasolinaController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Preço da Gasolina',
                  prefixIcon: Icon(Icons.local_gas_station),
                ),
                onChanged: (_) => _formatarNumero(_gasolinaController),
              ),
              const SizedBox(height: 20.0),
              TextField(
                controller: _etanolController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Preço do Etanol',
                  prefixIcon: Icon(Icons.local_drink),
                ),
                onChanged: (_) => _formatarNumero(_etanolController),
              ),
              const SizedBox(height: 30.0),
              Center(
                child: SizedBox(
                  width: 250,
                  child: FloatingActionButton.extended(
                    onPressed: () {
                      _calcularMelhorOpcao();
                      if (!_showResult) {}
                    },
                    elevation: 0,
                    label: const Text(
                      'Calcular',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    icon: const Icon(Icons.calculate),
                  ),
                ),
              ),
              AnimatedContainer(
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeInOut,
                height: _showResult ? 300 : 0,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 20.0),
                    AnimatedOpacity(
                      duration: const Duration(milliseconds: 500),
                      opacity: _showResult ? 1.0 : 0.0,
                      child: Column(
                        children: [
                          const SizedBox(height: 20.0),
                          Text(
                            _resultado,
                            style: const TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          if (_showResult && _resultado.contains('gasolina'))
                            Image.asset(
                              'assets/images/gasolina.png',
                              width: 200,
                              height: 200,
                            ),
                          if (_showResult && _resultado.contains('etanol'))
                            Image.asset(
                              'assets/images/cana.png',
                              width: 200,
                              height: 200,
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
