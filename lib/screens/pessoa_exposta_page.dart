import 'package:coopserj_app/repositories/repositories.dart';
import 'package:coopserj_app/utils/responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:get/get.dart';

class PessoaExpostaPage extends StatefulWidget {
  final int matricula;
  final String senha;

  const PessoaExpostaPage({
    Key key,
    @required this.matricula,
    @required this.senha,
  }) : super(key: key);
  @override
  _PessoaExpostaPageState createState() => _PessoaExpostaPageState();
}

class _PessoaExpostaPageState extends State<PessoaExpostaPage> {
  MaskedTextController senhaController = MaskedTextController(mask: "000000");
  PessoaExpostaPostRepository pessoaExpostaPostRepository =
      PessoaExpostaPostRepository();
  bool isPessoaExposta = false;
  int protocolo;

  int selectedListTile = 0;

  @override
  void initState() {
    super.initState();
    var data = DateTime.now().toString().substring(0, 19);

    var codigo = widget.matricula.toString() + " " + data;
    protocolo = codigo.hashCode;
  }

  @override
  Widget build(BuildContext context) {
    final alturaTela =
        MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top;

    salvarFormulario() {
      Get.dialog(
        AlertDialog(
          title: Text("Confirme sua senha"),
          content: TextField(
            controller: senhaController,
            keyboardType: TextInputType.number,
            obscureText: true,
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.lock_outline),
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
                onPressed: () {
                  if (senhaController.text.compareTo(widget.senha) == 0) {
                    pessoaExpostaPostRepository.saveInfo({
                      "codigo": protocolo,
                      "data": DateTime.now().toString().substring(0, 23),
                      "matricula": widget.matricula,
                      "situacao": selectedListTile == 1 ? 'S' : 'N'
                    });

                    Get.back();
                    Get.back();
                    Get.back();

                    Get.snackbar(
                      "Realizado com sucesso!",
                      "",
                      colorText: Colors.white,
                      backgroundColor: Colors.green[700],
                      snackPosition: SnackPosition.BOTTOM,
                    );
                  } else {
                    Get.back();

                    senhaController.text = "";

                    Get.snackbar(
                      "Senha incorreta!",
                      "Tente novamente.",
                      backgroundColor: Colors.red,
                      colorText: Colors.white,
                      padding: EdgeInsets.all(30),
                      snackPosition: SnackPosition.BOTTOM,
                      duration: Duration(seconds: 4),
                    );
                  }
                },
                child: Text("CONFIRMAR")),
          ],
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Pessoa exposta",
          style: TextStyle(
            color: Theme.of(context).primaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 2,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            // mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                """Segundo as regras de previd??ncia complementar, considera-se Pessoa Politicamente Exposta o agente p??blico que desempenha ou tenha desempenhado, nos ??ltimos cinco anos, cargo, emprego ou fun????o p??blica relevante, assim como seus parentes na linha direta, at?? o primeiro grau, c??njuge, companheiro(a) e enteado(a), representantes e outras pessoas de seu relacionamento pr??ximo.""",
                style: TextStyle(fontSize: 18),
                textAlign: TextAlign.justify,
              ),
              const SizedBox(height: 20),
              Text(
                "S??o Pessoas Politicamente Expostas brasileiras:",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              _buildTopicos(
                "I ???",
                " os detentores de mandatos eletivos dos Poderes Executivo e Legislativo da Uni??o;",
              ),
              const SizedBox(height: 10),
              _buildTopicos(
                "II ???",
                " os ocupantes de cargo no Poder Executivo da Uni??o:",
              ),
              const SizedBox(height: 15),
              Text(
                "a) de ministro de Estado ou equiparado;",
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 10),
              Text(
                "b) de natureza especial ou equivalente; ",
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 10),
              Text(
                "c) de presidente, vice-presidente e diretor, ou equivalentes, de autarquias, funda????es p??blicas, empresas p??blicas ou sociedades de economia mista; e",
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 10),
              Text(
                "d) do Grupo Dire????o e Assessoramento Superiores ??? DAS, n??vel 6, e equivalentes",
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 20),
              _buildTopicos(
                "III ???",
                " os membros do Conselho Nacional de Justi??a, do Supremo Tribunal Federal e dos Tribunais Superiores;",
              ),
              const SizedBox(height: 10),
              _buildTopicos(
                "IV ???",
                " os membros do Conselho Nacional do Minist??rio P??blico, o Procurador-Geral da Rep??blica, o Vice Procurador Geral da Rep??blica, o Procurador-Geral do Trabalho, o Procurador-Geral da Justi??a Militar, os Subprocuradores Gerais da Rep??blica e os Procuradores-Gerais de Justi??a dos Estados e do Distrito Federal;",
              ),
              const SizedBox(height: 10),
              _buildTopicos(
                "V ???",
                " os membros do Tribunal de Contas da Uni??o e o Procurador-Geral do Minist??rio P??blico junto ao Tribunal de Contas da Uni??o;",
              ),
              const SizedBox(height: 10),
              _buildTopicos(
                "VI ???",
                " os governadores de Estado e do Distrito Federal, os presidentes de Tribunal de Justi??a, de Assembleia Legislativa ou da C??mara Distrital, e os presidentes de Tribunal ou Conselho de Contas de Estado, de Munic??pios e do Distrito Federal; e",
              ),
              const SizedBox(height: 10),
              _buildTopicos(
                "VII ???",
                " os prefeitos e os presidentes de C??mara Municipal das capitais de Estado.",
              ),
              const SizedBox(height: 30),
              Column(
                children: <Widget>[
                  RadioListTile(
                    title: const Text(
                      'Sim, eu me enquadro na condi????o de Pessoa Politicamente Exposta.',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    value: 1,
                    groupValue: selectedListTile,
                    onChanged: (value) {
                      setState(() {
                        selectedListTile = value;
                        isPessoaExposta = true;
                      });
                    },
                  ),
                  RadioListTile(
                    title: const Text(
                      'N??o, eu n??o me enquadro na condi????o de Pessoa Politicamente Exposta.',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    value: 2,
                    groupValue: selectedListTile,
                    onChanged: (value) {
                      setState(() {
                        selectedListTile = value;
                        isPessoaExposta = true;
                      });
                    },
                  ),
                ],
              ),
              /*Row(
                children: [
                  Checkbox(
                    value: isPessoaExposta,
                    onChanged: (value) {
                      setState(() {
                        isPessoaExposta = !isPessoaExposta;
                      });
                    },
                  ),
                  Expanded(
                    child: Text(
                      "Sim, eu me enquadro na condi????o de Pessoa Politicamente Exposta.",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),*/
              const SizedBox(height: 30),
              _enviarButton(
                alturaTela,
                context,
                salvarFormulario,
                isPessoaExposta,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget _buildTopicos(String topico, String text) {
  return RichText(
    text: TextSpan(
      text: topico,
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
      children: [
        TextSpan(
          text: text,
          style: TextStyle(
            fontWeight: FontWeight.w300,
          ),
        )
      ],
    ),
  );
}

Widget _enviarButton(
  double alturaTela,
  BuildContext context,
  Function salvarFormulario,
  bool isPessoaExposta,
) {
  return Container(
    height: alturaTela * 0.055, //45,
    width: Responsive.isDesktop(context)
        ? MediaQuery.of(context).size.width * 0.4
        : MediaQuery.of(context).size.width * 0.73,

    child: ElevatedButton(
      onPressed: isPessoaExposta ? salvarFormulario : null,
      style: ElevatedButton.styleFrom(
        primary: Theme.of(context).primaryColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50.0),
          side: BorderSide(color: Theme.of(context).primaryColor),
        ),
      ),
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Text(
          "ENVIAR",
          style: TextStyle(
            color: Colors.white,
            fontSize: alturaTela * 0.025,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    ),
  );
}
