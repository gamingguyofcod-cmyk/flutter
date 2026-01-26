import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_foodroute/favorites.dart';
import 'package:flutter_foodroute/recipe.dart'; // RecipeDetailScreen ke liye

// --- Model aur Global List ---
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

// Ye Global List hai jo dono screens share karengi
List<Recipe> allRecipes = [
  Recipe(
    title: "Grilled Chicken",
    image:
        'https://images.unsplash.com/photo-1598103442097-8b74394b95c6?w=400&q=80',
    calories: "450",
  ),
  Recipe(
    title: "Veggie Salad",
    image:
        'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?w=400&q=80',
    calories: "320",
  ),
  Recipe(
    title: "Beef Steak",
    image:
        'https://images.unsplash.com/photo-1544025162-d76694265947?w=400&q=80',
    calories: "600",
  ),
  Recipe(
    title: "Pasta Carbonara",
    image:
        'https://images.unsplash.com/photo-1612874742237-6526221588e3?w=400&q=80',
    calories: "550",
  ),
  Recipe(
    title: "Salmon Fillet",
    image:
        'https://images.unsplash.com/photo-1467003909585-2f8a72700288?w=400&q=80',
    calories: "400",
  ),
  Recipe(
    title: "Chicken Burger",
    image:
        'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=400&q=80',
    calories: "520",
  ),
  Recipe(
    title: "Avocado Toast",
    image:
        'https://images.unsplash.com/photo-1525351484163-7529414344d8?w=400&q=80',
    calories: "280",
  ),
  Recipe(
    title: "Sushi Platter",
    image:
        'https://images.unsplash.com/photo-1579871494447-9811cf80d66c?w=400&q=80',
    calories: "350",
  ),
  Recipe(
    title: "Mushroom Risotto",
    image:
        'https://images.unsplash.com/photo-1476124369491-e7addf5db371?w=400&q=80',
    calories: "420",
  ),
  Recipe(
    title: "Tacos Al Pastor",
    image:
        'https://images.unsplash.com/photo-1565299624946-b28f40a0ae38?w=400&q=80',
    calories: "480",
  ),
  Recipe(
    title: "Margherita Pizza",
    image:
        'https://images.unsplash.com/photo-1513104890138-7c749659a591?w=400&q=80',
    calories: "700",
  ),
  Recipe(
    title: "Lamb Chops",
    image:
        'https://images.unsplash.com/photo-1551183053-bf91a1d81141?w=400&q=80',
    calories: "650",
  ),
  Recipe(
    title: "Greek Salad",
    image:
        'https://images.unsplash.com/photo-1540189549336-e6e99c3679fe?w=400&q=80',
    calories: "250",
  ),
  Recipe(
    title: "Shrimp Scampi",
    image:
        'https://images.unsplash.com/photo-1565557623262-b51c2513a641?w=400&q=80',
    calories: "380",
  ),
  Recipe(
    title: "Beef Lasagna",
    image:
        'https://images.unsplash.com/photo-1504674900247-0877df9cc836?w=400&q=80',
    calories: "620",
  ),
  Recipe(
    title: "Pancakes with Syrup",
    image:
        'https://images.unsplash.com/photo-1528207776546-365bb710ee93?w=400&q=80',
    calories: "450",
  ),
  Recipe(
    title: "Smoothie Bowl",
    image:
        'https://images.unsplash.com/photo-1494390248081-4e521a5940db?w=400&q=80',
    calories: "310",
  ),
  Recipe(
    title: "Fish and Chips",
    image:
        'https://images.unsplash.com/photo-1519708227418-c8fd9a32b7a2?w=400&q=80',
    calories: "580",
  ),
  Recipe(
    title: "Pad Thai",
    image:
        'https://images.unsplash.com/photo-1559339352-11d035aa65de?w=400&q=80',
    calories: "490",
  ),
  Recipe(
    title: "Tomato Soup",
    image:
        'https://images.unsplash.com/photo-1547592166-23ac45744acd?w=400&q=80',
    calories: "180",
  ),
  Recipe(
    title: "Club Sandwich",
    image:
        'https://images.unsplash.com/photo-1528735602780-2552fd46c7af?w=400&q=80',
    calories: "440",
  ),
  Recipe(
    title: "Roast Turkey",
    image:
        'https://images.unsplash.com/photo-1518492104633-130d0cc84637?w=400&q=80',
    calories: "500",
  ),
  Recipe(
    title: "Eggplant Parmesan",
    image: 'https://tastychow.com/wp-content/uploads/2025/07/0_2-99.png',
    calories: "390",
  ),
  Recipe(
    title: "Butter Chicken",
    image:
        'https://images.unsplash.com/photo-1588166524941-3bf61a9c41db?w=400&q=80',
    calories: "680",
  ),
  Recipe(
    title: "BBQ Ribs",
    image:
        'https://images.unsplash.com/photo-1529193591184-b1d58069ecdd?w=400&q=80',
    calories: "750",
  ),
  Recipe(
    title: "Caesar Salad",
    image:
        'https://images.unsplash.com/photo-1550304943-4f24f54ddde9?w=400&q=80',
    calories: "330",
  ),
  Recipe(
    title: "Chicken Tikka",
    image:
        'https://images.unsplash.com/photo-1599487488170-d11ec9c172f0?w=400&q=80',
    calories: "410",
  ),
  Recipe(
    title: "Lobster Roll",
    image:
        'https://images.unsplash.com/photo-1599487488170-d11ec9c172f0?w=400&q=80',
    calories: "460",
  ),
  Recipe(
    title: "Falafel Wrap",
    image: 'https://tastychow.com/wp-content/uploads/2025/07/0_2-99.png',
    calories: "370",
  ),
  Recipe(
    title: "Duck Confit",
    image: 'https://tastychow.com/wp-content/uploads/2025/07/0_2-99.png',
    calories: "540",
  ),
  Recipe(
    title: "Quinoa Bowl",
    image: 'https://tastychow.com/wp-content/uploads/2025/07/0_2-99.png',
    calories: "290",
  ),
  Recipe(
    title: "Pork Belly",
    image: 'https://tastychow.com/wp-content/uploads/2025/07/0_2-99.png',
    calories: "720",
  ),
  Recipe(
    title: "Fruit Salad",
    image: 'https://tastychow.com/wp-content/uploads/2025/07/0_2-99.png',
    calories: "150",
  ),
  Recipe(
    title: "Poke Bowl",
    image:
        'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=400&q=80',
    calories: "430",
  ),
  Recipe(
    title: "French Onion Soup",
    image: 'https://tastychow.com/wp-content/uploads/2025/07/0_2-99.png',
    calories: "310",
  ),
  Recipe(
    title: "Grilled Shrimp",
    image:
        'https://images.unsplash.com/photo-1534604973900-c43ab4c2e0ab?w=400&q=80',
    calories: "270",
  ),
  Recipe(
    title: "Chicken Alfredo",
    image: 'https://tastychow.com/wp-content/uploads/2025/07/0_2-99.png',
    calories: "640",
  ),
  Recipe(
    title: "Veggie Burger",
    image:
        'https://images.unsplash.com/photo-1550547660-d9450f859349?w=400&q=80',
    calories: "460",
  ),
  Recipe(
    title: "Steak Fries",
    image:
        'https://images.unsplash.com/photo-1573080496219-bb080dd4f877?w=400&q=80',
    calories: "510",
  ),
  Recipe(
    title: "Apple Pie",
    image: 'https://tastychow.com/wp-content/uploads/2025/07/0_2-99.png',
    calories: "380",
  ),
];

class AllMealsScreen extends StatefulWidget {
  const AllMealsScreen({super.key});

  @override
  State<AllMealsScreen> createState() => _AllMealsScreenState();
}

class _AllMealsScreenState extends State<AllMealsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "All Recipes",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        actions: [
          // Favorites screen par jane ka button
          IconButton(
            icon: const Icon(Icons.favorite, color: Colors.red),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const FavoritesScreen(),
                ),
              ).then((_) => setState(() {}));
            },
          ),
        ],
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(20),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.72,
          crossAxisSpacing: 15,
          mainAxisSpacing: 15,
        ),
        itemCount: allRecipes.length,
        itemBuilder: (context, index) {
          return _buildRecipeItem(context, allRecipes[index]);
        },
      ),
    );
  }

  Widget _buildRecipeItem(BuildContext context, Recipe recipe) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade100),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10),
        ],
      ),
      child: Stack(
        children: [
          // Main Content Column
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RecipeDetailScreen(
                          title: recipe.title,
                          imagePath: recipe.image,
                        ),
                      ),
                    ).then((_) => setState(() {}));
                  },
                  child: ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(20),
                    ),
                    // 🔥 PURANA IMAGE.NETWORK REPLACE KIYA:
                    child: CachedNetworkImage(
                      imageUrl: recipe.image,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity,
                      // Jab image load ho rahi ho:
                      placeholder: (context, url) => Container(
                        color: Colors.grey[50],
                        child: const Center(
                          child: SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                        ),
                      ),
                      // Agar image load na ho sake:
                      errorWidget: (context, url, error) => Container(
                        color: Colors.grey[100],
                        child: const Icon(
                          Icons.broken_image,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      recipe.title,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "${recipe.calories} kcal",
                      style: const TextStyle(color: Colors.blue, fontSize: 12),
                    ),
                  ],
                ),
              ),
            ],
          ),

          // Favorite Icon (Floating on top)
          Positioned(
            top: 8,
            right: 8,
            child: GestureDetector(
              onTap: () {
                setState(() {
                  recipe.isFavorite = !recipe.isFavorite;
                });

                if (recipe.isFavorite) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Added to Favorites!"),
                      duration: Duration(milliseconds: 700),
                    ),
                  );
                }
              },
              child: CircleAvatar(
                backgroundColor: Colors.white.withOpacity(0.9),
                radius: 16,
                child: Icon(
                  recipe.isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: recipe.isFavorite ? Colors.red : Colors.grey,
                  size: 18,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
