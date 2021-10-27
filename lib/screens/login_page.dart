import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify.dart';
import 'package:amplify_storage_s3/amplify_storage_s3.dart';
import 'package:coopserj_app/amplifyconfiguration.dart';
import 'package:coopserj_app/controllers/assinou_lgdp_controller.dart';
import 'package:coopserj_app/controllers/controllers.dart';
import 'package:coopserj_app/screens/auth_page.dart';
import 'package:coopserj_app/utils/responsive.dart';
import 'package:coopserj_app/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with WidgetsBindingObserver {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  AssinouLGDPController assinouLGDPController =
      Get.put(AssinouLGDPController());
  AssinouSCRController assinouSCRController = Get.put(AssinouSCRController());

  bool _obscureText = true;

  MaskedTextController cpfController =
      MaskedTextController(mask: '000.000.000-00');
  MaskedTextController senhaController = MaskedTextController(mask: '000000');

  MaskedTextController cpfSenhaController =
      MaskedTextController(mask: '000.000.000-00');
  MaskedTextController dataNascController =
      MaskedTextController(mask: '00/00/0000');

  //CONFIGURAÇÃO INICIAL AMPLIFY STORAGE
  void _configureAmplify() async {
    AmplifyAuthCognito authPlugin = AmplifyAuthCognito();
    AmplifyStorageS3 storagePlugin = AmplifyStorageS3();
    Amplify.addPlugin(authPlugin);
    Amplify.addPlugin(storagePlugin);

    try {
      await Amplify.configure(amplifyconfig);
      print('Successfully configured Amplify 🎉');
    } catch (e) {
      print('Could not configure Amplify ☠️');
    }
  }

  @override
  void initState() {
    super.initState();
    _configureAmplify();

    //get matriculas que já assinaram o termo
    assinouLGDPController.getAssinatura();
    assinouSCRController.getAssinatura();

    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double alturaTela =
        MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top;

    double larguraTela = MediaQuery.of(context).size.width;

    _launchURL() async {
      const url = 'https://www.coopserj.coop.br/cadastre-se';
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        throw 'Não foi possível abrir $url';
      }
    }

    _showSenha() {
      setState(() {
        _obscureText = !_obscureText;
      });
    }

    return Responsive(
      mobile: _buildLoginMobile(
        context,
        alturaTela,
        larguraTela,
        _formKey,
        cpfController,
        senhaController,
        cpfSenhaController,
        dataNascController,
        _obscureText,
        assinouLGDPController,
        assinouSCRController,
        _launchURL,
        _showSenha,
      ),
      tablet: _buildLoginMobile(
        context,
        alturaTela,
        larguraTela,
        _formKey,
        cpfController,
        senhaController,
        cpfSenhaController,
        dataNascController,
        _obscureText,
        assinouLGDPController,
        assinouSCRController,
        _launchURL,
        _showSenha,
      ),
      desktop: _buildLoginWeb(
        alturaTela,
        _formKey,
        cpfController,
        senhaController,
        cpfSenhaController,
        dataNascController,
        _obscureText,
        assinouLGDPController,
        assinouSCRController,
        _launchURL,
        _showSenha,
      ),
    );
  }
}

String _validateCPF(String value) {
  if (value.isEmpty) {
    return "Infome o CPF";
  }
  if (value.length != 14) {
    return "O CPF deve conter 11 dígitos";
  }

  return null;
}

String _validateSenha(String value) {
  if (value.isEmpty) {
    return "Infome a senha";
  }
  if (value.length != 6) {
    return "A senha deve conter 6 dígitos";
  }
  return null;
}

Widget buildDialog(MaskedTextController cpfSenhaController,
    MaskedTextController dataNascController) {
  return AlertDialog(
    title: Text("Informe seus dados:"),
    content: Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      height: 200,
      child: Form(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            TextFormField(
              controller: cpfSenhaController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "CPF:",
                prefixIcon: Icon(Icons.security_outlined),
                border: OutlineInputBorder(),
              ),
            ),
            TextFormField(
              controller: dataNascController,
              keyboardType: TextInputType.datetime,
              decoration: InputDecoration(
                labelText: "Data de Nascimento:",
                prefixIcon: Icon(Icons.date_range),
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
      ),
    ),
    actions: [
      TextButton(
        onPressed: () {
          print("cliquei!!!!!!!!");
          Get.to(
            SendEmail(
              cpf: cpfSenhaController.text,
              dataNasc: dataNascController.text,
            ),
          );
        },
        child: Text("CONFIRMAR"),
      )
    ],
  );
}

Widget _buildLoginMobile(
  BuildContext context,
  double alturaTela,
  double larguraTela,
  GlobalKey<FormState> formKey,
  MaskedTextController cpfController,
  MaskedTextController senhaController,
  MaskedTextController cpfSenhaController,
  MaskedTextController dataNascController,
  bool obscureText,
  AssinouLGDPController assinouLGDPController,
  AssinouSCRController assinouSCRController,
  Function launchURL,
  Function showSenha,
) {
  return Scaffold(
    body: SingleChildScrollView(
      child: Container(
        width: larguraTela,
        height: alturaTela,
        // color: Colors.white,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue[50], Colors.blue],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
        ),
        child: Stack(
          children: [
            Positioned(
              top: alturaTela * 0.1,
              left: larguraTela * 0.33,
              child: Container(
                width: MediaQuery.of(context).size.width * 0.31, //130,
                height: alturaTela * 0.16, //130,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('images/logo.png'),
                    fit: BoxFit.scaleDown,
                  ),
                ),
              ),
            ),
            Positioned(
              top: alturaTela * 0.3,
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 50.0, horizontal: 32.0),
                width: MediaQuery.of(context).size.width,
                height: alturaTela,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(90),
                    topRight: Radius.circular(90),
                  ),
                ),
                child: Form(
                  key: formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        validator: _validateCPF,
                        keyboardType: TextInputType.number,
                        controller: cpfController,
                        decoration: InputDecoration(
                          hintText: "CPF",
                          prefixIcon: Icon(Icons.account_circle),
                        ),
                      ),
                      const SizedBox(height: 10.0),
                      TextFormField(
                        obscureText: obscureText,
                        validator: _validateSenha,
                        controller: senhaController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          hintText: "Senha",
                          prefixIcon: Icon(Icons.lock),
                          suffixIcon: IconButton(
                            icon: obscureText
                                ? Icon(Icons.visibility_off)
                                : Icon(Icons.visibility),
                            onPressed: showSenha,
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomLeft,
                        child: TextButton(
                          onPressed: () {
                            Get.dialog(
                              buildDialog(
                                  cpfSenhaController, dataNascController),
                            );
                          },
                          child: Text(
                            "Esqueceu sua senha?",
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 16.0,
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: alturaTela * 0.05,
                      ),
                      SizedBox(
                        height: alturaTela * 0.062,
                        child: ElevatedButton(
                          onPressed: () {
                            if (formKey.currentState.validate()) {
                              formKey.currentState.save();

                              Get.to(
                                AuthPage(
                                  cpf: cpfController.text,
                                  senha: senhaController.text,
                                  assinaturaLGDP:
                                      assinouLGDPController.assinatura,
                                  assinaturaSCR:
                                      assinouSCRController.assinatura,
                                ),
                              );

                              /*Get.to(
                                    AuthPage(
                                      cpf: cpfController.text,
                                      senha: senhaController.text,
                                    ),
                                  );*/
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            primary: Colors.blue,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50.0),
                              side: BorderSide(
                                color: Colors.blue,
                              ),
                            ),
                          ),
                          child: Center(
                            child: Text(
                              "Login",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: alturaTela * 0.03, //20.0,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          //Get.to(Cadastro());
                          launchURL();
                        },
                        child: Text(
                          "Ainda não é um associado? Cadastre-se!",
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: alturaTela * 0.02, //16.0,
                            fontStyle: FontStyle.normal,
                            fontWeight: FontWeight.w600,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

Widget _buildLoginWeb(
  double alturaTela,
  GlobalKey<FormState> formKey,
  MaskedTextController cpfController,
  MaskedTextController senhaController,
  MaskedTextController cpfSenhaController,
  MaskedTextController dataNascController,
  bool obscureText,
  AssinouLGDPController assinouLGDPController,
  AssinouSCRController assinouSCRController,
  Function launchURL,
  Function showSenha,
) {
  return Scaffold(
    body: Container(
      width: double.infinity,
      height: double.infinity,
      child: Row(
        children: [
          Expanded(
            flex: 5,
            child: Container(
              decoration: BoxDecoration(
                color: Color(0xFF005AE6),
                image: DecorationImage(
                  image: AssetImage("images/loginWeb.jpg"),
                  fit: BoxFit.scaleDown,
                ),
              ),
            ),
          ),
          Expanded(
            flex: 4,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 90, vertical: 40),
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    child: Image.asset("images/logo.png"),
                  ),
                  const SizedBox(height: 20),
                  Form(
                    key: formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextFormField(
                          validator: _validateCPF,
                          keyboardType: TextInputType.number,
                          controller: cpfController,
                          decoration: InputDecoration(
                            hintText: "CPF",
                            prefixIcon: Icon(Icons.account_circle),
                          ),
                        ),
                        const SizedBox(height: 10.0),
                        TextFormField(
                          obscureText: obscureText,
                          validator: _validateSenha,
                          controller: senhaController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            hintText: "Senha",
                            prefixIcon: Icon(Icons.lock),
                            suffixIcon: IconButton(
                              icon: obscureText
                                  ? Icon(Icons.visibility_off)
                                  : Icon(Icons.visibility),
                              onPressed: showSenha,
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.bottomLeft,
                          child: TextButton(
                            onPressed: () {
                              Get.dialog(
                                buildDialog(
                                    cpfSenhaController, dataNascController),
                              );
                            },
                            child: Text(
                              "Esqueceu sua senha?",
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 16.0,
                                fontStyle: FontStyle.italic,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: alturaTela * 0.15,
                        ),
                        SizedBox(
                          width: alturaTela * 0.40,
                          height: alturaTela * 0.062, //50.0,
                          child: ElevatedButton(
                            onPressed: () {
                              if (formKey.currentState.validate()) {
                                formKey.currentState.save();

                                Get.to(
                                  AuthPage(
                                    cpf: cpfController.text,
                                    senha: senhaController.text,
                                    assinaturaLGDP:
                                        assinouLGDPController.assinatura,
                                    assinaturaSCR:
                                        assinouSCRController.assinatura,
                                  ),
                                );

                                /*Get.to(
                                      AuthPage(
                                        cpf: cpfController.text,
                                        senha: senhaController.text,
                                      ),
                                    );*/
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              primary: Colors.blue,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50.0),
                                side: BorderSide(
                                  color: Colors.blue,
                                ),
                              ),
                            ),
                            child: Center(
                              child: Text(
                                "Login",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: alturaTela * 0.03, //20.0,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            //Get.to(Cadastro());
                            launchURL();
                          },
                          child: Text(
                            "Ainda não é um associado? Cadastre-se!",
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: alturaTela * 0.02, //16.0,
                              fontStyle: FontStyle.normal,
                              fontWeight: FontWeight.w600,
                              decoration: TextDecoration.underline,
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
        ],
      ),
    ),
  );
}
