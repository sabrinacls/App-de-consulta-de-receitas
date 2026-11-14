
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:consultar_receitas/main.dart';

void main() {
  testWidgets(
    'Verifica os elementos da tela inicial',
    (WidgetTester tester) async {
      // Inicializa o aplicativo
      await tester.pumpWidget(const ReceitaFacilApp());

      // Confirma que o título está visível
      expect(
        find.text('Consulta de Receitas'),
        findsOneWidget,
      );

      // Confirma que existe um campo de pesquisa
      expect(
        find.byType(TextField),
        findsOneWidget,
      );

      // Confirma que existe o botão de pesquisa
      expect(
        find.text('Pesquisar'),
        findsOneWidget,
      );

      // Confirma que a tela inicial é uma HomePage
      expect(
        find.textContaining('Pesquise pelo nome'),
        findsOneWidget,
      );
    },
  );
}