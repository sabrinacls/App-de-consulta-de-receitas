
class Meal {
  final String nome;
  final String imagemUrl;

  const Meal({
    required this.nome,
    required this.imagemUrl,
  });

  factory Meal.fromJson(Map<String, dynamic> json) {
    return Meal(
      nome: json['strMeal']?.toString() ?? 'Sem nome',
      imagemUrl: json['strMealThumb']?.toString() ?? '',
    );
  }
}