// ignore_for_file: unnecessary_null_comparison

import 'package:flutter/material.dart';
import 'package:econol/core/db_helper.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class HistoricoPrecosPage extends StatelessWidget {
  const HistoricoPrecosPage({super.key, Key? keyy});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Histórico de Preços'),
      ),
      body: FutureBuilder<List<Price>>(
        future: _fetchPrices(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Erro ao carregar os dados'));
          } else {
            return Column(
              children: [
                _buildChart(snapshot.data!, 'Gasolina'),
                _buildChart(snapshot.data!, 'Etanol'),
              ],
            );
          }
        },
      ),
    );
  }

  Future<List<Price>> _fetchPrices() async {
    return await DatabaseHelper.instance.fetchPrices();
  }

  Widget _buildChart(List<Price> prices, String title) {
    // Filtrando os dados de acordo com o tipo de combustível
    List<Price> filteredPrices = prices.where((price) {
      if (title == 'Gasolina') {
        return price.gasolina != null;
      } else {
        return price.etanol != null;
      }
    }).toList();

    // Convertendo os dados para o formato aceito pelo gráfico
    List<charts.Series<Price, int>> series = [
      charts.Series(
        id: title,
        data: filteredPrices,
        domainFn: (Price price, _) => price.id!,
        measureFn: (Price price, _) {
          if (title == 'Gasolina') {
            return price.gasolina;
          } else {
            return price.etanol;
          }
        },
        colorFn: (Price price, _) {
          if (title == 'Gasolina') {
            return const charts.Color(r: 255, g: 0, b: 0); // Vermelho
          } else {
            return const charts.Color(r: 0, g: 255, b: 0); // Verde
          }
        },
      ),
    ];

    // Criando o gráfico de linhas
    return SizedBox(
      height: 300,
      child: charts.LineChart(
        series,
        animate: true,
        defaultRenderer: charts.LineRendererConfig(
            includePoints: true, includeArea: false, strokeWidthPx: 2.0),
        domainAxis: const charts.NumericAxisSpec(
          tickProviderSpec:
              charts.BasicNumericTickProviderSpec(desiredTickCount: 0),
        ),
        primaryMeasureAxis: charts.NumericAxisSpec(
          tickFormatterSpec: charts.BasicNumericTickFormatterSpec(
            (num? value) => 'R\$${(value! / 100).toStringAsFixed(2)}',
          ),
        ),
        behaviors: [charts.SeriesLegend()],
      ),
    );
  }
}
