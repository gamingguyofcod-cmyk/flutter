import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_foodroute/recipe.dart';

// --- Model Sahi Kiya Gaya ---
class Recipe {
  final String title;
  final String image;
  final String calories;
  final List<String> tags; // List banayi taaki multiple tags aa sakein
  bool isFavorite;

  Recipe({
    required this.title,
    required this.image,
    required this.calories,
    this.tags = const [], // Default empty list
    this.isFavorite = false,
  });
}

// --- Global List with Tags ---
List<Recipe> allRecipes = [
  // --- HIGH PROTEIN (1-19) ---
  Recipe(
    title: "Grilled Chicken",
    image:
        'https://images.unsplash.com/photo-1598103442097-8b74394b95c6?w=400&q=80',
    calories: "450",
    tags: ["High Protein"],
  ),
  Recipe(
    title: "Beef Steak",
    image:
        'https://images.unsplash.com/photo-1544025162-d76694265947?w=400&q=80',
    calories: "600",
    tags: ["High Protein"],
  ),
  Recipe(
    title: "Chicken Burger",
    image:
        'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=400&q=80',
    calories: "520",
    tags: ["High Protein"],
  ),
  Recipe(
    title: "Salmon Fillet",
    image:
        'https://images.unsplash.com/photo-1467003909585-2f8a72700288?w=400&q=80',
    calories: "400",
    tags: ["High Protein"],
  ),
  Recipe(
    title: "Lamb Chops",
    image:
        'https://images.unsplash.com/photo-1551183053-bf91a1d81141?w=400&q=80',
    calories: "650",
    tags: ["High Protein"],
  ),
  Recipe(
    title: "Beef Lasagna",
    image:
        'https://images.unsplash.com/photo-1504674900247-0877df9cc836?w=400&q=80',
    calories: "620",
    tags: ["High Protein"],
  ),
  Recipe(
    title: "Butter Chicken",
    image:
        'https://images.unsplash.com/photo-1588166524941-3bf61a9c41db?w=400&q=80',
    calories: "680",
    tags: ["High Protein"],
  ),
  Recipe(
    title: "BBQ Ribs",
    image:
        'https://images.unsplash.com/photo-1529193591184-b1d58069ecdd?w=400&q=80',
    calories: "750",
    tags: ["High Protein"],
  ),
  Recipe(
    title: "Chicken Tikka",
    image:
        'https://images.unsplash.com/photo-1599487488170-d11ec9c172f0?w=400&q=80',
    calories: "410",
    tags: ["High Protein"],
  ),
  Recipe(
    title: "Lobster Roll",
    image:
        'https://images.unsplash.com/photo-1599487488170-d11ec9c172f0?w=400&q=80',
    calories: "460",
    tags: ["High Protein"],
  ),
  Recipe(
    title: "Duck Confit",
    image: 'https://tastychow.com/wp-content/uploads/2025/07/0_2-99.png',
    calories: "540",
    tags: ["High Protein"],
  ),
  Recipe(
    title: "Pork Belly",
    image: 'https://tastychow.com/wp-content/uploads/2025/07/0_2-99.png',
    calories: "720",
    tags: ["High Protein"],
  ),
  Recipe(
    title: "Chicken Alfredo",
    image: 'https://tastychow.com/wp-content/uploads/2025/07/0_2-99.png',
    calories: "640",
    tags: ["High Protein"],
  ),
  Recipe(
    title: "Steak Fries",
    image:
        'https://images.unsplash.com/photo-1573080496219-bb080dd4f877?w=400&q=80',
    calories: "510",
    tags: ["High Protein"],
  ),
  Recipe(
    title: "Club Sandwich",
    image:
        'https://images.unsplash.com/photo-1528735602780-2552fd46c7af?w=400&q=80',
    calories: "440",
    tags: ["High Protein"],
  ),
  Recipe(
    title: "Roast Turkey",
    image:
        'https://images.unsplash.com/photo-1518492104633-130d0cc84637?w=400&q=80',
    calories: "500",
    tags: ["High Protein"],
  ),
  Recipe(
    title: "Shrimp Scampi",
    image:
        'https://images.unsplash.com/photo-1565557623262-b51c2513a641?w=400&q=80',
    calories: "380",
    tags: ["High Protein"],
  ),
  Recipe(
    title: "Grilled Shrimp",
    image:
        'https://images.unsplash.com/photo-1534604973900-c43ab4c2e0ab?w=400&q=80',
    calories: "270",
    tags: ["High Protein"],
  ),

  // --- KETO (20-37) ---
  Recipe(
    title: "Avocado Toast",
    image:
        'https://images.unsplash.com/photo-1525351484163-7529414344d8?w=400&q=80',
    calories: "280",
    tags: ["Keto"],
  ),
  Recipe(
    title: "Sushi Platter",
    image:
        'https://images.unsplash.com/photo-1579871494447-9811cf80d66c?w=400&q=80',
    calories: "350",
    tags: ["Keto"],
  ),
  Recipe(
    title: "Margherita Pizza",
    image:
        'https://images.unsplash.com/photo-1513104890138-7c749659a591?w=400&q=80',
    calories: "700",
    tags: ["Keto"],
  ),
  Recipe(
    title: "Pasta Carbonara",
    image:
        'https://images.unsplash.com/photo-1612874742237-6526221588e3?w=400&q=80',
    calories: "550",
    tags: ["Keto"],
  ),
  Recipe(
    title: "Fish and Chips",
    image:
        'https://images.unsplash.com/photo-1519708227418-c8fd9a32b7a2?w=400&q=80',
    calories: "580",
    tags: ["Keto"],
  ),
  Recipe(
    title: "Smoothie Bowl",
    image:
        'https://images.unsplash.com/photo-1494390248081-4e521a5940db?w=400&q=80',
    calories: "310",
    tags: ["Keto"],
  ),
  Recipe(
    title: "Poke Bowl",
    image:
        'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=400&q=80',
    calories: "430",
    tags: ["Keto"],
  ),
  Recipe(
    title: "Pancakes with Syrup",
    image:
        'https://images.unsplash.com/photo-1528207776546-365bb710ee93?w=400&q=80',
    calories: "450",
    tags: ["Keto"],
  ),
  Recipe(
    title: "Tacos Al Pastor",
    image:
        'https://images.unsplash.com/photo-1565299624946-b28f40a0ae38?w=400&q=80',
    calories: "480",
    tags: ["Keto"],
  ),
  Recipe(
    title: "Pad Thai",
    image:
        'https://images.unsplash.com/photo-1559339352-11d035aa65de?w=400&q=80',
    calories: "490",
    tags: ["Keto"],
  ),
  Recipe(
    title: "Apple Pie",
    image: 'https://tastychow.com/wp-content/uploads/2025/07/0_2-99.png',
    calories: "380",
    tags: ["Keto"],
  ),
  Recipe(
    title: "French Onion Soup",
    image: 'https://tastychow.com/wp-content/uploads/2025/07/0_2-99.png',
    calories: "310",
    tags: ["Keto"],
  ),
  Recipe(
    title: "Mushroom Risotto",
    image:
        'https://images.unsplash.com/photo-1476124369491-e7addf5db371?w=400&q=80',
    calories: "420",
    tags: ["Keto"],
  ),
  Recipe(
    title: "Eggplant Parmesan",
    image: 'https://tastychow.com/wp-content/uploads/2025/07/0_2-99.png',
    calories: "390",
    tags: ["Keto"],
  ),

  // --- VEGAN (38-56) ---
  Recipe(
    title: "Veggie Salad",
    image:
        'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?w=400&q=80',
    calories: "320",
    tags: ["Vegan"],
  ),
  Recipe(
    title: "Greek Salad",
    image:
        'https://images.unsplash.com/photo-1540189549336-e6e99c3679fe?w=400&q=80',
    calories: "250",
    tags: ["Vegan"],
  ),
  Recipe(
    title: "Fruit Salad",
    image: 'https://tastychow.com/wp-content/uploads/2025/07/0_2-99.png',
    calories: "150",
    tags: ["Vegan"],
  ),
  Recipe(
    title: "Quinoa Bowl",
    image: 'https://tastychow.com/wp-content/uploads/2025/07/0_2-99.png',
    calories: "290",
    tags: ["Vegan"],
  ),
  Recipe(
    title: "Veggie Burger",
    image:
        'https://images.unsplash.com/photo-1550547660-d9450f859349?w=400&q=80',
    calories: "460",
    tags: ["Vegan"],
  ),
  Recipe(
    title: "Falafel Wrap",
    image: 'https://tastychow.com/wp-content/uploads/2025/07/0_2-99.png',
    calories: "370",
    tags: ["Vegan"],
  ),
  Recipe(
    title: "Tomato Soup",
    image:
        'https://images.unsplash.com/photo-1547592166-23ac45744acd?w=400&q=80',
    calories: "180",
    tags: ["Vegan"],
  ),
  Recipe(
    title: "Caesar Salad",
    image:
        'https://images.unsplash.com/photo-1550304943-4f24f54ddde9?w=400&q=80',
    calories: "330",
    tags: ["Vegan"],
  ),
];

class AllMealsScreen extends StatefulWidget {
  const AllMealsScreen({super.key});

  @override
  State<AllMealsScreen> createState() => _AllMealsScreenState();
}

class _AllMealsScreenState extends State<AllMealsScreen> {
  // Brand Colors
  final Color primaryDark = Color(0xFF080C10);
  final Color accentCyan = Color(0xFF18FFFF); // Updated to your brand Cyan

  String selectedFilter = "All"; // Filter track karne ke liye
  List<Recipe> displayedRecipes = [];

  @override
  void initState() {
    super.initState();
    displayedRecipes = allRecipes; // Shuru mein saari recipes dikhayen
  }

  // --- Filter Logic ---
  void _applyFilter(String filter) {
    setState(() {
      selectedFilter = filter;
      if (filter == "All") {
        displayedRecipes = allRecipes;
      } else {
        displayedRecipes = allRecipes
            .where((recipe) => recipe.tags.contains(filter))
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? primaryDark : Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new,
            color: isDark ? Colors.white : Colors.black,
            size: 20,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "All Recipes",
          style: TextStyle(
            color: isDark ? Colors.white : Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
      body: Column(
        children: [
          // --- Horizontal Filter Chips ---
          SizedBox(height: 10),
          SizedBox(
            height: 45,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 20),
              children: ["All", "High Protein", "Keto", "Vegan"].map((filter) {
                bool isSelected = selectedFilter == filter;
                return GestureDetector(
                  onTap: () => _applyFilter(filter),
                  child: Container(
                    margin: EdgeInsets.only(right: 12),
                    padding: EdgeInsets.symmetric(horizontal: 22),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? accentCyan
                          : (isDark ? Colors.white10 : Color(0xFFF4F7F9)),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      filter,
                      style: TextStyle(
                        color: isSelected
                            ? Colors.black
                            : (isDark ? Colors.white60 : Color(0xFF7D8C9B)),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),

          SizedBox(height: 10),

          // --- Recipe Grid ---
          Expanded(
            child: GridView.builder(
              padding: EdgeInsets.all(20),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.75,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemCount: displayedRecipes.length,
              itemBuilder: (context, index) {
                return _buildRecipeItem(
                  context,
                  displayedRecipes[index],
                  isDark,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecipeItem(BuildContext context, Recipe recipe, bool isDark) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? Color(0xFF1A1F24) : Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isDark ? Colors.white10 : Colors.grey.shade100,
        ),
        boxShadow: [
          if (!isDark)
            BoxShadow(
              // ignore: deprecated_member_use
              color: Colors.black.withOpacity(0.04),
              blurRadius: 12,
              offset: Offset(0, 4),
            ),
        ],
      ),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            RecipeDetailScreen(recipe: recipe),
                      ),
                    ).then((_) => setState(() {}));
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(24),
                    ),
                    child: CachedNetworkImage(
                      imageUrl: recipe.image,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity,
                      placeholder: (context, url) => Center(
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: accentCyan,
                        ),
                      ),
                      errorWidget: (context, url, error) => Icon(Icons.error),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      recipe.title,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: isDark ? Colors.white : Color(0xFF080C10),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 4),
                    Text(
                      "${recipe.calories} kcal",
                      style: TextStyle(
                        color: accentCyan,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Positioned(
            top: 10,
            right: 10,
            child: GestureDetector(
              onTap: () {
                setState(() {
                  recipe.isFavorite = !recipe.isFavorite;
                });
                if (recipe.isFavorite) {
                  _showSuccessToast(context, "Added to Favorites!");
                }
              },
              child: Container(
                padding: EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: isDark
                      ? Colors.black45
                      // ignore: deprecated_member_use
                      : Colors.white.withOpacity(0.8),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  recipe.isFavorite
                      ? Icons.favorite_rounded
                      : Icons.favorite_border_rounded,
                  color: recipe.isFavorite
                      ? Colors.redAccent
                      : (isDark ? Colors.white70 : Colors.black45),
                  size: 20,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showSuccessToast(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        // ignore: deprecated_member_use
        backgroundColor: accentCyan.withOpacity(0.9),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        duration: Duration(milliseconds: 1500),
      ),
    );
  }
}
