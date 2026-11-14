

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Controlador do campo de pesquisa
  final TextEditingController _pesquisaController =
      TextEditingController();

  // Variáveis para controlar os estados da pesquisa
  bool _carregando = false;
  String? _resultadoPesquisa;
  String? _mensagemErro;

  // Função responsável por pesquisar receitas na API
  Future<void> _buscarReceitas() async {
    final String termo = _pesquisaController.text.trim();

    // Verifica se o campo está vazio
    if (termo.isEmpty) {
      setState(() {
        _resultadoPesquisa = 'Digite uma receita para pesquisar.';
        _mensagemErro = null;
      });
      return;
    }

    // Inicia o carregamento
    setState(() {
      _carregando = true;
      _resultadoPesquisa = null;
      _mensagemErro = null;
    });

    // Monta a URL da API TheMealDB
    final Uri url = Uri.https(
      'www.themealdb.com',
      '/api/json/v1/1/search.php',
      {'s': termo},
    );

    try {
      // Realiza a requisição HTTP
      final http.Response resposta = await http
          .get(url)
          .timeout(const Duration(seconds: 15));

      if (!mounted) return;

      // Verifica se a requisição foi bem-sucedida
      if (resposta.statusCode == 200) {
        // Converte a resposta JSON
        final Map<String, dynamic> dadosJson =
            jsonDecode(resposta.body);

        final List<dynamic>? receitas = dadosJson['meals'];

        setState(() {
          if (receitas == null || receitas.isEmpty) {
            _resultadoPesquisa =
                'Nenhuma receita encontrada para "$termo".';
          } else {
            _resultadoPesquisa =
                '${receitas.length} receita(s) encontrada(s).';
          }
        });
      } else {
        setState(() {
          _mensagemErro =
              'Erro ao consultar a API: ${resposta.statusCode}';
        });
      }
    } catch (erro) {
      if (!mounted) return;

      setState(() {
        _mensagemErro =
            'Falha na conexão. Verifique sua internet.';
      });
    } finally {
      if (mounted) {
        setState(() {
          _carregando = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _pesquisaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Consulta de Receitas'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Campo para digitar o nome da receita
            TextField(
              controller: _pesquisaController,
              textInputAction: TextInputAction.search,
              onSubmitted: (_) => _buscarReceitas(),
              decoration: const InputDecoration(
                labelText: 'Digite o nome da receita',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
              ),
            ),

            const SizedBox(height: 12),

            // Botão para iniciar a pesquisa
            ElevatedButton(
              onPressed: _carregando ? null : _buscarReceitas,
              child: const Text('Pesquisar'),
            ),

            const SizedBox(height: 20),

            // Indicador de carregamento
            if (_carregando)
              const CircularProgressIndicator(),

            // Exibe o resultado da pesquisa
            if (_resultadoPesquisa != null)
              Text(
                _resultadoPesquisa!,
                textAlign: TextAlign.center,
              ),

            // Exibe mensagens de erro
            if (_mensagemErro != null)
              Text(
                _mensagemErro!,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.red,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
