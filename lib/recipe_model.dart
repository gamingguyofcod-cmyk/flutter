class Recipe {
  final String title;
  final String image;
  final String calories;
  bool isFavorite;

  Recipe({
    required this.title,
    required this.image,
    required this.calories,
    this.isFavorite = false,
  });
}

// Ye list global hai, pure app mein kahin bhi access ho sakti hai
List<Recipe> allRecipes = [
  Recipe(
    title: "Grilled Chicken",
    image: "https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=400",
    calories: "450",
  ),
  Recipe(
    title: "Beef Burger",
    image: "https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=400",
    calories: "600",
  ),
  // Aur recipes add karein...
];
