import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Catalogo extends StatefulWidget {
  final String nomeUsuario;
  const Catalogo({super.key, required this.nomeUsuario});

  @override
  State<Catalogo> createState() => _CatalogoState();
}

class _CatalogoState extends State<Catalogo> {
  List<String> figurinhaUrls = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    carregarFigurinhas();
  }

  Future<void> carregarFigurinhas() async {
    try {
      final url = Uri.parse('https://api.jikan.moe/v4/anime/20/characters');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final characters = jsonData['data'] as List;

        final List<String> urls = [];
        for (var c in characters.take(30)) {
          final imageUrl = c['character']['images']['jpg']['image_url'];
          if (imageUrl != null) urls.add(imageUrl);
        }

        setState(() {
          figurinhaUrls = urls;
          loading = false;
        });
      } else {
        setState(() {
          loading = false;
        });
      }
    } catch (e) {
      setState(() {
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: Container(
          color: const Color.fromRGBO(248, 220, 198, 1),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: SafeArea(
            child: Row(
              children: [
                Image.asset('assets/logo.png', height: 90),
                const SizedBox(width: 8),
                const Text(
                  'Naruto Store',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Color.fromRGBO(231, 124, 44, 1),
                  ),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      '/gerenciarusuario',
                      arguments: widget.nomeUsuario,
                    );
                  },
                  child: Image.asset(
                    'assets/user.png',
                    height: 35,
                    width: 35,
                  ),
                ),
                const SizedBox(width: 20),
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
                  },
                  child: Image.asset(
                    'assets/logout.png',
                    height: 35,
                    width: 35,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                const Spacer(),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/compras');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromRGBO(76, 175, 80, 1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Assinar',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                )
              ],
            ),
          ),
          const SizedBox(height: 10),
          const Center(
            child: Text(
              'FIGURINHAS NARUTO',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color.fromRGBO(231, 124, 44, 1),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: loading
                ? const Center(child: CircularProgressIndicator())
                : GridView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      childAspectRatio: 0.75,
                    ),
                    itemCount: figurinhaUrls.length,
                    itemBuilder: (context, index) {
                      return Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color.fromARGB(255, 224, 224, 224)),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(
                            figurinhaUrls[index],
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => const Icon(Icons.error),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        height: 90,
        color: const Color(0xFFF8DCC6),
        child: const Center(
          child: Text(
            'Naruto Store',
            style: TextStyle(
              fontSize: 50,
              fontWeight: FontWeight.bold,
              color: Color.fromRGBO(231, 124, 44, 1),
            ),
          ),
        ),
      ),
    );
  }
}
