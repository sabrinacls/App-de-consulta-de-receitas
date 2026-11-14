
class Meal {
  final String id;
  final String nome;
  final String imagemUrl;

  const Meal({
    required this.id,
    required this.nome,
    required this.imagemUrl,
  });

  factory Meal.fromJson(Map<String, dynamic> json) {
    return Meal(
      id: (json['idMeal'] ?? '').toString(),
      nome: (json['strMeal'] ?? 'Receita sem nome').toString(),
      imagemUrl: (json['strMealThumb'] ?? '').toString(),
    );
  }
}