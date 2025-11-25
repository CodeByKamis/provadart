import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class GerenciarUsuario extends StatefulWidget {
  final String nomeUsuario;

  const GerenciarUsuario({super.key, required this.nomeUsuario});

  @override
  State<GerenciarUsuario> createState() => _GerenciarUsuarioState();
}

class _GerenciarUsuarioState extends State<GerenciarUsuario> {
  final TextEditingController nomeController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController senhaController = TextEditingController();

  String? userId;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    carregarDadosUsuario();
  }

  Future<void> carregarDadosUsuario() async {
    final query = await FirebaseFirestore.instance
        .collection("usuarios")
        .where("nome", isEqualTo: widget.nomeUsuario)
        .get();

    if (query.docs.isNotEmpty) {
      final doc = query.docs.first;

      userId = doc.id;
      nomeController.text = doc["nome"];
      emailController.text = doc["email"];
      senhaController.text = doc["senha"];
    }

    setState(() => loading = false);
  }

  void mostrarMsg(String msg, bool sucesso) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: sucesso ? Colors.green : Colors.red,
        content: Text(msg),
      ),
    );
  }

  Future<void> confirmarEdicao() async {
    if (userId == null) return;

    await FirebaseFirestore.instance.collection("usuarios").doc(userId).update({
      "nome": nomeController.text.trim(),
      "email": emailController.text.trim(),
      "senha": senhaController.text.trim(),
    });

    mostrarMsg("Usuário editado com sucesso!", true);

    Future.delayed(const Duration(milliseconds: 500), () {
      Navigator.pushReplacementNamed(context, "/catalogo", arguments: nomeController.text.trim());
    });
  }

  Future<void> deletarConta() async {
    if (userId == null) return;

    await FirebaseFirestore.instance.collection("usuarios").doc(userId).delete();

    mostrarMsg("Usuário deletado com sucesso!", true);

    Future.delayed(const Duration(milliseconds: 500), () {
      Navigator.pushNamedAndRemoveUntil(context, "/", (route) => false);
    });
  }

  void cancelarEdicao() {
    mostrarMsg("Edição cancelada!", true);

    Future.delayed(const Duration(milliseconds: 500), () {
      Navigator.pushReplacementNamed(context, "/catalogo", arguments: widget.nomeUsuario);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          color: const Color(0xFFF8DCC6),
          child: SafeArea(
            child: Row(
              children: [
                Image.asset("assets/logo.png", height: 90),
                const SizedBox(width: 10),
                const Text(
                  "Naruto Store",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFE77C2C),
                  ),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () {},
                  child: Image.asset("assets/user.png", height: 35),
                ),
                const SizedBox(width: 20),
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamedAndRemoveUntil(context, "/", (route) => false);
                  },
                  child: Image.asset("assets/logout.png", height: 35),
                ),
              ],
            ),
          ),
        ),
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(25),
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    const Text(
                      "CONFIGURAÇÃO DE USUÁRIO",
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFE77C2C),
                      ),
                    ),
                    const SizedBox(height: 30),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(25),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8DCC6),
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: Column(
                        children: [
                          campo("Nome", nomeController),
                          const SizedBox(height: 15),
                          campo("Email", emailController),
                          const SizedBox(height: 15),
                          campo("Senha", senhaController, senha: true),
                        ],
                      ),
                    ),
                    const SizedBox(height: 40),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          onPressed: confirmarEdicao,
                          style: estiloBotao(Colors.green),
                          child: const Text("Confirmar"),
                        ),
                        ElevatedButton(
                          onPressed: deletarConta,
                          style: estiloBotao(Colors.red),
                          child: const Text("Deletar"),
                        ),
                        ElevatedButton(
                          onPressed: cancelarEdicao,
                          style: estiloBotao(Colors.orange),
                          child: const Text("Cancelar"),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
      bottomNavigationBar: Container(
        height: 90,
        color: const Color(0xFFF8DCC6),
        child: const Center(
          child: Text(
            "Naruto Store",
            style: TextStyle(
              fontSize: 50,
              fontWeight: FontWeight.bold,
              color: Color(0xFFE77C2C),
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration estiloCampo(String label) {
    return InputDecoration(
      labelText: label,
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
    );
  }

  Widget campo(String label, TextEditingController controller, {bool senha = false}) {
    return TextField(
      controller: controller,
      obscureText: senha,
      decoration: estiloCampo(label),
    );
  }

  ButtonStyle estiloBotao(Color cor) {
    return ElevatedButton.styleFrom(
      backgroundColor: cor,
      foregroundColor: Colors.white,
      minimumSize: const Size(120, 45),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }
}
