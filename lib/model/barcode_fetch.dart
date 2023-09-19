class BarcodeData {
  final String id;
  final String url;
  final String categories;
  final String brand;
  final String countries;
  final String grade;
  final String ecoscoreGrade;
  final String ecoscoreScore;
  final String nutrientLevels;
  final String ingredients;
  final String allergens;
  final String nutritionalInformation;

  BarcodeData({
    required this.id,
    required this.url,
    required this.categories,
    required this.brand,
    required this.countries,
    required this.grade,
    required this.ecoscoreGrade,
    required this.ecoscoreScore,
    required this.nutrientLevels,
    required this.ingredients,
    required this.allergens,
    required this.nutritionalInformation,
  });

  factory BarcodeData.fromJson(Map<String, dynamic> json) {
    final product = json['product'] ?? {};

    return BarcodeData(
      id: product['code'],
      url: product['image_small_url'] ?? "",
      categories: (product['categories_tags'] as List<dynamic>).join(', '),
      brand: product['brands'],
      countries: product['countries'],
      grade: product['nutrition_grades'],
      ecoscoreGrade: product['ecoscore_grade'],
      ecoscoreScore: product['ecoscore_score'],
      nutrientLevels: (product['nutrient_levels'] as Map<String, dynamic>)
          .entries
          .map((entry) =>
              '${entry.key}: ${entry.value.toString().toLowerCase()}')
          .join(', '),
      ingredients: product['ingredients_text'],
      allergens: product['allergens'],
      nutritionalInformation: product['nutriments'] != null
          ? '''
Energy: ${product['nutriments']['energy']} kcal
Fat: ${product['nutriments']['fat']}g
Saturated Fat: ${product['nutriments']['saturated-fat']}g
Carbohydrates: ${product['nutriments']['carbohydrates']}g
Sugars: ${product['nutriments']['sugars']}g
Proteins: ${product['nutriments']['proteins']}g
Salt: ${product['nutriments']['salt']}g
'''
          : '',
    );
  }
}
