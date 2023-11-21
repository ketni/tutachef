import 'package:flutter/material.dart';

class CardRecipeSearch extends StatelessWidget {
  final String title;
  final List<String> ingredients;
  final String chef;
  final String suggestionChef;
  final Color starColor;

  const CardRecipeSearch({
    Key? key,
    required this.title,
    required this.ingredients,
    required this.chef,
    required this.suggestionChef,
    required this.starColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      margin: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Adapte o conteúdo do Card conforme necessário
          ListTile(
            title: Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              'Chef: $chef\nSugestão do Chef: $suggestionChef',
            ),
            trailing: Icon(
              Icons.star,
              color: starColor,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Ingredientes:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                for (var ingredient in ingredients) Text('- $ingredient'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
