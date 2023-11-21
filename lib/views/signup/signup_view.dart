import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:tutachef_project/core/user_datasource.dart';
import 'package:tutachef_project/core/widgets/custom_button.dart';
import 'package:tutachef_project/core/widgets/custom_textField.dart';

import '../../controllers/home_controller.dart';
import '../../core/widgets/custom_appbar.dart';
import '../pages_view.dart';
import '../profile/user.dart';

class SignUpView extends StatefulWidget {
  const SignUpView({super.key, required this.controller});
  final HomeController controller;

  @override
  State<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
  @override
  Widget build(BuildContext context) {
    TextEditingController emailController = TextEditingController();
    TextEditingController nameController = TextEditingController();
    TextEditingController passController = TextEditingController();
    TextEditingController confirmPassController = TextEditingController();
    TextEditingController phoneController = TextEditingController();

    final MaskTextInputFormatter phoneMaskFormatter = MaskTextInputFormatter(
        mask: '(##) #####-####', filter: {"#": RegExp(r'[0-9]')});
    bool isValidEmail(String email) {
      // Adicione aqui a lógica de validação do e-mail conforme necessário
      return RegExp(r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$').hasMatch(email);
    }

    bool validateForm() {
      if (emailController.text.isEmpty || !isValidEmail(emailController.text)) {
        // Exiba uma mensagem de erro ou faça o que for necessário
        print('Formulário inválido');
        return false;
      }
      return true;
    }

    return Scaffold(
      appBar: CustomAppBarWidget(
        controller: widget.controller,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              const SizedBox(
                height: 20,
              ),
              const Text(
                'Realize seu Cadastro',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 30,
              ),
              CustomTextField(
                controller: nameController,
                hint: 'Nome Completo...',
              ),
              CustomTextField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Campo obrigatório';
                  } else if (!isValidEmail(value)) {
                    return 'E-mail inválido';
                  }
                  return null;
                },
                controller: emailController,
                hint: 'E-mail...',
              ),
              CustomTextField(
                controller: passController,
                hint: 'Senha...',
                obscure: true,
              ),
              CustomTextField(
                controller: confirmPassController,
                hint: 'Confirme sua senha...',
                obscure: true,
              ),
              CustomTextField(
                formater: [phoneMaskFormatter],
                controller: phoneController,
                hint: 'Telefone...',
              ),
              CustomButton(
                  textButton: 'Confirmar',
                  function: () {
                    successDialog(
                        context: context,
                        textSuccess:
                            'Cadastro realizado com sucesso! \n Agora você é um Hobby Chef',
                        user: User(
                            email: emailController.text,
                            phone: phoneController.text,
                            fullname: nameController.text,
                            password: passController.text,
                            type: 'hobby-chef'));
                  })
            ],
          ),
        ),
      ),
    );
  }

  void successDialog(
      {required BuildContext context,
      required String textSuccess,
      required User user}) {
    UserDataSource userDataSource = UserDataSource();
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
                userDataSource.signUpFromApi(user);
                userDataSource.logInFromApi(
                    email: user.email!,
                    password: user.password!,
                    context: context);
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => PagesView(
                          controller: widget.controller,
                        )));
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  bool isValidEmail(String email) {
    // Utilizando uma expressão regular para validar o formato do e-mail
    final RegExp emailRegex =
        RegExp(r'^[a-zA-Z0-9._-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    return emailRegex.hasMatch(email);
  }
}
