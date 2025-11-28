import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Compras extends StatefulWidget {
  const Compras({super.key});

  @override
  State<Compras> createState() => _ComprasState();
}

class _ComprasState extends State<Compras> {
  final TextEditingController nomeController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController senhaController = TextEditingController();

  bool loading = false;

  Future<void> finalizarCompra() async {
    final nome = nomeController.text.trim();
    final email = emailController.text.trim();
    final senha = senhaController.text.trim();

    if (nome.isEmpty || email.isEmpty || senha.isEmpty) {
      mostrarMensagem("Preencha todos os campos!", false);
      return;
    }

    setState(() => loading = true);

    try {
      await FirebaseFirestore.instance.collection("usuarios").add({
        "nome": nome,
        "email": email,
        "senha": senha,
      });

      mostrarMensagem("Compra realizada com sucesso!", true);

      // Vamos passar para o Catalogo com o nome do usuário
      Navigator.pushNamedAndRemoveUntil(
        context,
        '/catalogo',
        (route) => false,
        arguments: email, // Passando email como parâmetro para o catálogo
      );
    } catch (e) {
      mostrarMensagem("Erro ao salvar compra.", false);
    }

    setState(() => loading = false);
  }

  void cancelarCompra() {
    // Mostra a mensagem "Compra cancelada!" e volta para a página de catálogo
    mostrarMensagem("Compra cancelada!", true);

    // Ao clicar em "Cancelar", navega para o Catalogo, passando o parâmetro de email
    Navigator.pushNamedAndRemoveUntil(
      context,
      '/catalogo',
      (route) => false,
      arguments: emailController.text.trim(),  // Passando o email do usuário para o Catalogo
    );
  }

  void mostrarMensagem(String msg, bool sucesso) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: sucesso ? Colors.green : Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // HEADER
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: Container(
          color: const Color(0xFFF8DCC6),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: SafeArea(
            child: Row(
              children: [
                Image.asset('assets/logo.png', height: 90),
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
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      '/gerenciarusuario',
                      arguments: 'nomeUsuario', // Passe o nome do usuário aqui
                    );
                  },
                  child: Image.asset('assets/user.png', height: 35),
                ),
                const SizedBox(width: 20),
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamedAndRemoveUntil(
                        context, '/', (route) => false);
                  },
                  child: Image.asset('assets/logout.png', height: 35),
                ),
              ],
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(25),
          child: Column(
            children: [
              // Botão Voltar abaixo da logo
              Align(
                alignment: Alignment.topLeft,
                child: ElevatedButton(
                  onPressed: () {
                    // Ao clicar no botão "Voltar", navega para o Catalogo
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      '/catalogo',
                      (route) => false,
                      arguments: emailController.text.trim(),  // Passando email para o catálogo
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFE77C2C),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(7),
                    ),
                  ),
                  child: const Text(
                    "Voltar",
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                "CARRINHO DE COMPRAS",
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFE77C2C),
                ),
              ),
              const SizedBox(height: 30),
              const Text(
                "Preço do Mensal",
                style: TextStyle(
                  fontSize: 22,
                  color: Color(0xFFE77C2C),
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8DCC6),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: const Text(
                  "R\$ 100,90",
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFE77C2C),
                  ),
                ),
              ),
              const SizedBox(height: 40),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(22),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18),
                ),
                child: const Center(
                  child: Text(
                    "Cadastrar Usuário",
                    style: TextStyle(
                      color: Color(0xFFE77C2C),
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: nomeController,
                decoration: campoEstilo("Nome"),
              ),
              const SizedBox(height: 15),
              TextField(
                controller: emailController,
                decoration: campoEstilo("Email"),
              ),
              const SizedBox(height: 15),
              TextField(
                controller: senhaController,
                obscureText: true,
                decoration: campoEstilo("Senha"),
              ),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                    width: 150,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: loading ? null : finalizarCompra,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(7),
                        ),
                      ),
                      child: loading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text(
                              "Finalizar",
                              style: TextStyle(
                                  fontSize: 20, color: Colors.white),
                            ),
                    ),
                  ),
                  SizedBox(
                    width: 150,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: cancelarCompra, // Cancelar compra
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(7),
                        ),
                      ),
                      child: const Text(
                        "Cancelar",
                        style: TextStyle(
                            fontSize: 20, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
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

  InputDecoration campoEstilo(String label) {
    return InputDecoration(
      labelText: label,
      filled: true,
      fillColor: const Color(0xFFF8DCC6),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide.none,
      ),
    );
  }
}