// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../controllers/home_controller.dart';
import '../../profile/user.dart';

class CardRecipe extends StatelessWidget {
  const CardRecipe(
      {Key? key,
      required this.colorStar,
      required this.tituloReceita,
      required this.ingredientes,
      required this.chef,
      required this.sugestaoChef,
      this.function})
      : super(key: key);
  final Color? colorStar;
  final String tituloReceita;
  final List<String> ingredientes;
  final String chef;
  final String sugestaoChef;
  final Function()? function;

  @override
  Widget build(BuildContext context) {
    User user = Provider.of<User>(context);
    var controller = Provider.of<HomeController>(context, listen: false);

    double widScreen = MediaQuery.of(context).size.width;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4),
      child: SizedBox(
        height: 125,
        width: widScreen * 0.9,
        child: Card(
          color: Colors.orange[50],
          elevation: 1,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
              side: const BorderSide(color: Colors.orange, width: 1.3)),
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        tituloReceita,
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w400),
                      ),
                      Row(
                        children: [
                          const Text(
                            'Ingredientes:',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            width: 180,
                            child: Text(
                              [ingredientes]
                                  .toString()
                                  .replaceAll('[', '')
                                  .replaceAll(']', ''),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          const Text(
                            'Sugestão do Chef: ',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            width: 150,
                            child: Text(
                              sugestaoChef.toString(),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          const Text(
                            'Chef:  ',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(chef),
                        ],
                      )
                    ],
                  ),
                ),
                Visibility(
                  visible: user.sessionToken != null,
                  child: GestureDetector(
                    onTap: function,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Icon(
                          Icons.star,
                          size: 30,
                          color: colorStar,
                          shadows: const [
                            Shadow(color: Colors.black, blurRadius: 1)
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
