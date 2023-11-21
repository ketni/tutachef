import 'package:flutter/material.dart';
import 'package:tutachef_project/controllers/home_controller.dart';
import 'package:tutachef_project/core/app_core.dart';
import 'package:tutachef_project/core/widgets/custom_button.dart';
import 'package:tutachef_project/core/widgets/custom_textField.dart';
import 'package:tutachef_project/views/signup/signup_view.dart';

import '../pages_view.dart';

class LoginView extends StatelessWidget {
  LoginView({super.key, required this.controller});
  final HomeController controller;
  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    double widthScreen = MediaQuery.of(context).size.width;
    double heightScreen = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Container(
        height: heightScreen,
        width: widthScreen,
        decoration:
            const BoxDecoration(gradient: AppCore.defaultOrangeGradient),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: heightScreen * 0.1,
              ),
              SizedBox(
                height: heightScreen * 0.35,
                child: Container(
                    color: Colors.transparent,
                    child: Image.asset('assets/logo/logo-g.png')),
              ),
              const SizedBox(
                height: 10,
              ),
              CustomTextField(
                controller: emailController,
                hint: 'E-mail',
              ),
              CustomTextField(
                controller: passController,
                hint: 'Senha',
                obscure: true,
              ),
              TextButton(
                onPressed: () {
                  _mostrarRecuperacaoSenhaDialog(context);
                },
                child: const Text(
                  'Esqueci minha senha!',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              CustomButton(
                textButton: 'Login',
                function: () async {
                  bool loginSuccess = await controller.login(
                      emailController.text, passController.text, context);

                  if (loginSuccess) {
                    // Login bem-sucedido
                    successDialog(
                      context: context,
                      textSuccess:
                          'Seja bem vindo, chef! Você entrou na sua cozinha!',
                    );
                  } else {
                    // Login falhou
                    _mostrarErroLoginDialog(context);
                  }
                },
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => SignUpView(
                            controller: controller,
                          )));
                },
                child: const Text(
                  'Cadastre-se aqui!',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              const Text(
                '- Ou -',
                style: TextStyle(color: Colors.white),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: SizedBox(
                  height: 60,
                  width: 60,
                  child: Card(
                    elevation: 10,
                    child: GestureDetector(
                      child: Image.asset('assets/icons/google.png'),
                      onTap: () {
                        print('Login com Google');
                      },
                    ),
                  ),
                ),
              ),
              const SizedBox(
                width: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _mostrarErroLoginDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Erro no Login'),
          content: const Text('Login falhou. Verifique seu e-mail e senha.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void successDialog({
    required BuildContext context,
    required String textSuccess,
  }) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Sucesso'),
          content: Text(textSuccess),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();

                Navigator.of(context).push(MaterialPageRoute(
                    builder: (_) => PagesView(
                          controller: controller,
                        )));
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _mostrarRecuperacaoSenhaDialog(BuildContext context) {
    TextEditingController passController = TextEditingController();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Recuperar Senha'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const Text(
                  'Insira seu endereço de e-mail para recuperar a senha:'),
              CustomTextField(
                controller: passController,
                hint: 'Preencha seu e-mail',
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                controller.resetPassword(userEmail: passController.text);
                Navigator.of(context).pop();
                AppCore().successDialog(context,
                    'E-mail de recuperação de \n senha enviado com sucesso!');
              },
              child: const Text('Recuperar'),
            ),
          ],
        );
      },
    );
  }
}
