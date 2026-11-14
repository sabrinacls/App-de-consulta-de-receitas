import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'meal.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  
  final TextEditingController _pesquisaController = TextEditingController();

 
  List<Meal> _receitas = [];
  bool _carregando = false;
  String? _mensagemErro;
  String? _mensagemAviso;

  @override
  void dispose() {
    _pesquisaController.dispose();
    super.dispose();
  }

 
  Future<void> _buscarReceitas() async {
    final String termo = _pesquisaController.text.trim();

   
    FocusScope.of(context).unfocus();

    
    if (termo.isEmpty) {
      setState(() {
        _receitas = [];
        _mensagemErro = null;
        _mensagemAviso =  'Pesquise pelo nome de uma receita (ex: Chicken, Pasta, Cake) para visualizar os resultados.';
      });
      return;
    }

   
    setState(() {
      _carregando = true;
      _mensagemErro = null;
      _mensagemAviso = null;
    });

   
    final Uri url = Uri.https(
      'www.themealdb.com',
      '/api/json/v1/1/search.php',
      {'s': termo},
    );

   
    try {
      final http.Response resposta = await http
          .get(url)
          .timeout(const Duration(seconds: 15));

      if (!mounted) return;

      if (resposta.statusCode == 200) {
        
        final Map<String, dynamic> dadosJson = jsonDecode(resposta.body);
        final List<dynamic>? listaMeals = dadosJson['meals'];

        setState(() {
          _carregando = false;

          if (listaMeals == null || listaMeals.isEmpty) {
            _receitas = [];
            _mensagemAviso = 'Nenhuma receita encontrada para "$termo".';
          } else {
            _receitas = listaMeals
                .map((item) => Meal.fromJson(item as Map<String, dynamic>))
                .toList();
          }
        });
      } else {
        
        setState(() {
          _carregando = false;
          _receitas = [];
          _mensagemErro =
              'Erro ao consultar a API (Código HTTP: ${resposta.statusCode}).';
        });
      }
    } catch (erro) {
    
      if (!mounted) return;
      setState(() {
        _carregando = false;
        _receitas = [];
        _mensagemErro =
            'Falha na conexão. Verifique sua internet e tente novamente.';
      });
    }
  }

 
  Widget _construirAreaResultados() {
   
    if (_carregando) {
      return const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(color: Color(0xFF4E7D5B)),
            SizedBox(height: 12),
            Text(
              'Buscando receitas...',
              style: TextStyle(fontSize: 15, color: Color(0xFF3E4E41)),
            ),
          ],
        ),
      );
    }

   
    if (_mensagemErro != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.wifi_off_rounded,
                size: 48,
                color: Color(0xFFD35400),
              ),
              const SizedBox(height: 10),
              Text(
                _mensagemErro!,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFFA04000),
                ),
              ),
            ],
          ),
        ),
      );
    }

    
    if (_mensagemAviso != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.search_off_rounded,
                size: 48,
                color: Color(0xFFE67E22),
              ),
              const SizedBox(height: 10),
              Text(
                _mensagemAviso!,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 15,
                  color: Color(0xFF3E4E41),
                ),
              ),
            ],
          ),
        ),
      );
    }

    
    if (_receitas.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            'Pesquise pelo nome de uma receita (ex: Chicken, Pasta, Cake) para visualizar os resultados.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 15,
              color: Color(0xFF5D6D60),
            ),
          ),
        ),
      );
    }

    
    return ListView.builder(
      itemCount: _receitas.length,
      itemBuilder: (context, index) {
        final Meal receita = _receitas[index];

        return Card(
          color: Colors.white,
          elevation: 2,
          margin: const EdgeInsets.only(bottom: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                    receita.imagemUrl,
                    width: 90,
                    height: 90,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Container(
                        width: 90,
                        height: 90,
                        color: const Color(0xFFEDF2EC),
                        child: const Center(
                          child: SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                        ),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: 90,
                        height: 90,
                        color: const Color(0xFFEDF2EC),
                        child: const Icon(
                          Icons.broken_image_outlined,
                          color: Color(0xFF7F8C8D),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 14),
               
                Expanded(
                  child: Text(
                    receita.nome,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF2C3E2D),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 68,
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Consulta de Receitas',
              style: TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 2),
            Text(
              'Sabrina Clemente da Silva • Vivian Gomes Leal da Rocha',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 10.5,
                color: Colors.white70,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            
            TextField(
              controller: _pesquisaController,
              textInputAction: TextInputAction.search,
              onSubmitted: (_) => _buscarReceitas(),
              decoration: InputDecoration(
                hintText: 'Digite o nome da receita (ex: Chicken, Pie)...',
                filled: true,
                fillColor: Colors.white,
                prefixIcon: const Icon(
                  Icons.search,
                  color: Color(0xFF4E7D5B),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFFC5D6C7)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFFC5D6C7)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: Color(0xFF4E7D5B),
                    width: 2,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),

            // RF02 — Botão de pesquisa destacado
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton.icon(
                onPressed: _carregando ? null : _buscarReceitas,
                icon: const Icon(Icons.restaurant_menu),
                label: const Text(
                  'Pesquisar',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE67E22),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 2,
                ),
              ),
            ),
            const SizedBox(height: 16),

            
            Expanded(
              child: _construirAreaResultados(),
            ),
          ],
        ),
      ),
    );
  }
}