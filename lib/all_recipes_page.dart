import 'package:flutter/material.dart';
import 'models/recipe.dart';
import 'recipe_detail_page.dart';

class AllRecipesPage extends StatelessWidget {
  final String title;
  final List<Recipe> recipes;

  const AllRecipesPage({super.key, required this.title, required this.recipes});

  double _calculateSizedBoxHeight(String text, TextStyle style, double maxWidth,
      int maxLines) {
    final textPainter = TextPainter(
      text: TextSpan(text: text, style: style),
      textDirection: TextDirection.ltr,
      maxLines: maxLines,
    )
      ..layout(maxWidth: maxWidth);

    final lineHeight = textPainter.preferredLineHeight;
    final totalLines = (textPainter.size.height / lineHeight).ceil();

    return totalLines == 2 ? 40.0 : 60.0;
  }

  Color _getHealthScoreColor(double healthScore) {
    if (healthScore < 4.5) {
      return Colors.red;
    } else if (healthScore <= 7.5) {
      return Colors.yellow;
    } else {
      return Colors.green;
    }
  }

  String _formatTextForLines(String text, int maxCharsPerLine) {
    if (text.length <= maxCharsPerLine) {
      return text;
    }

    // Sisipkan manual baris baru setelah maxCharsPerLine
    return text.substring(0, maxCharsPerLine) + '\n' +
        text.substring(maxCharsPerLine);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w800,
          ),
        ),
        backgroundColor: Colors.black,
        elevation: 0,
        iconTheme: const IconThemeData(
          color: Colors.white, // Warna tombol kembali
        ),
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(15),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.825,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemCount: recipes.length,
        itemBuilder: (context, index) {
          final recipe = recipes[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => RecipeDetailPage(recipe: recipe),
                ),
              );
            },
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.white.withOpacity(0.1),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(10),
                    ),
                    child: Image.network(
                      recipe.image,
                      height: 120,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          height: 120,
                          width: double.infinity,
                          color: Colors.grey,
                          child: const Icon(Icons.error, color: Colors.white),
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 10,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          recipe.title,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 8),
                      ],
                    ),
                  ),
                  // Kotak untuk Health Score di tengah
                  Expanded(
                    child: Container(
                      alignment: Alignment.center, // Posisikan teks di tengah
                      child: Text(
                        'Health Score: ${recipe.healthScore.toStringAsFixed(
                            1)}',
                        style: TextStyle(
                          color: _getHealthScoreColor(recipe.healthScore),
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}