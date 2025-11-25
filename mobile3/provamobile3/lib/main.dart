import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'catalogo.dart';
import 'compras.dart';
import 'gerenciarusuario.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => const LoginPage(),
      },
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/catalogo':
            final nomeUsuario = settings.arguments as String;
            return MaterialPageRoute(
              builder: (_) => Catalogo(nomeUsuario: nomeUsuario),
            );
          case '/gerenciarusuario':
            final nomeUsuario = settings.arguments as String;
            return MaterialPageRoute(
              builder: (_) => GerenciarUsuario(nomeUsuario: nomeUsuario),
            );
          case '/compras':
            return MaterialPageRoute(
              builder: (_) => const Compras(),
            );
          default:
            return null;
        }
      },
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController nomeController = TextEditingController();
  final TextEditingController senhaController = TextEditingController();

  bool loading = false;

  Future<void> fazerLogin() async {
    setState(() => loading = true);

    final nome = nomeController.text.trim();
    final senha = senhaController.text.trim();

    if (nome.isEmpty || senha.isEmpty) {
      mostrarMensagem("Preencha todos os campos!");
      setState(() => loading = false);
      return;
    }

    try {
      final query = await FirebaseFirestore.instance
          .collection("usuarios")
          .where("nome", isEqualTo: nome)
          .where("senha", isEqualTo: senha)
          .get();

      if (query.docs.isNotEmpty) {
        mostrarMensagem("Login realizado com sucesso!", success: true);
        Navigator.pushReplacementNamed(
          context,
          '/catalogo',
          arguments: nome,
        );
      } else {
        mostrarMensagem("Nome ou senha incorretos!");
      }
    } catch (e) {
      mostrarMensagem("Erro ao acessar o banco.");
    }

    setState(() => loading = false);
  }

  void mostrarMensagem(String msg, {bool success = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: success ? Colors.green : Colors.red,
        content: Text(msg),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8DCC6),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "NARUTO STORE",
                style: TextStyle(
                  fontSize: 50,
                  color: Color(0xFFE77C2C),
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                "Faça login",
                style: TextStyle(
                  fontSize: 18,
                  color: Color(0xFFE77C2C),
                ),
              ),
              const SizedBox(height: 40),
              Container(
                width: 320,
                padding: const EdgeInsets.all(25),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    Image.asset(
                      "assets/logo.png",
                      height: 70,
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      "NARUTO STORE",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Text(
                      "Entre com suas credenciais",
                      style: TextStyle(fontSize: 14),
                    ),
                    const SizedBox(height: 20),
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text("Nome"),
                    ),
                    const SizedBox(height: 5),
                    TextField(
                      controller: nomeController,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: const Color(0xFFF8DCC6),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text("Senha"),
                    ),
                    const SizedBox(height: 5),
                    TextField(
                      controller: senhaController,
                      obscureText: true,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: const Color(0xFFF8DCC6),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 25),
                    SizedBox(
                      width: 170,
                      height: 45,
                      child: ElevatedButton(
                        onPressed: loading ? null : fazerLogin,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFE77C2C),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: loading
                            ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                            : const Text(
                                "Fazer Login",
                                style: TextStyle(color: Colors.white),
                              ),
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
