import 'package:flutter/material.dart';
import 'package:flutter_foodroute/all_meals.dart';
import 'package:flutter_foodroute/recipe.dart' hide Recipe;
import 'package:cached_network_image/cached_network_image.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  // 1. Search logic ke liye variables
  List<Recipe> filteredRecipes = [];
  String searchQuery = "";

  @override
  void initState() {
    super.initState();
    // Shuru mein saari recipes dikhayenge
    filteredRecipes = allRecipes;
  }

  void _filterRecipes(String query) {
    setState(() {
      searchQuery = query;
      filteredRecipes = allRecipes
          .where(
            (recipe) =>
                recipe.title.toLowerCase().contains(query.toLowerCase()),
          )
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF1D2A3A)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Discover Recipes",
          style: TextStyle(
            color: Color(0xFF1D2A3A),
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
            child: TextField(
              onChanged: (value) =>
                  _filterRecipes(value), // Type karte hi filter hoga
              decoration: InputDecoration(
                hintText: "Search for Pizza, Pasta...",
                hintStyle: const TextStyle(color: Colors.grey),
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                filled: true,
                fillColor: const Color(0xFFF4F7F9),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),

          // Horizontal Filters (Aapka design)
          const SizedBox(height: 10),
          SizedBox(
            height: 45,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              children: [
                _buildFilterChip("All", true),
                _buildFilterChip("High Protein", false),
                _buildFilterChip("Keto", false),
                _buildFilterChip("Vegan", false),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.fromLTRB(20, 25, 20, 15),
            child: Text(
              "${filteredRecipes.length} Recipes found",
              style: const TextStyle(
                color: Color(0xFF9EABB8),
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),

          // Recipe Grid
          Expanded(
            child: filteredRecipes.isEmpty
                ? const Center(child: Text("No recipes found!"))
                : GridView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.75,
                          crossAxisSpacing: 15,
                          mainAxisSpacing: 15,
                        ),
                    itemCount: filteredRecipes.length,
                    itemBuilder: (context, index) {
                      final recipe = filteredRecipes[index];
                      return _buildRecipeCard(context, recipe);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, bool isSelected) {
    return Container(
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.symmetric(horizontal: 22),
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xFF008CFF) : const Color(0xFFF4F7F9),
        borderRadius: BorderRadius.circular(12),
      ),
      alignment: Alignment.center,
      child: Text(
        label,
        style: TextStyle(
          color: isSelected ? Colors.white : const Color(0xFF7D8C9B),
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
      ),
    );
  }

  Widget _buildRecipeCard(BuildContext context, Recipe recipe) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => RecipeDetailScreen(
              title: recipe.title,
              imagePath: recipe.image,
            ),
          ),
        ).then(
          (_) => setState(() {}),
        ); // Detail se wapas aane par dil ka color update ho jaye
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(20),
                    ),
                    child: CachedNetworkImage(
                      imageUrl: recipe.image,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity,
                      placeholder: (context, url) =>
                          Container(color: Colors.grey[100]),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
                    ),
                  ),

                  // 🔥 SEARCH SCREEN FAV BUTTON LOGIC:
                  Positioned(
                    top: 10,
                    right: 10,
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          recipe.isFavorite =
                              !recipe.isFavorite; // Toggle Favorite
                        });

                        // User ko feedback dena
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              recipe.isFavorite
                                  ? "Added to Favorites"
                                  : "Removed",
                            ),
                            duration: const Duration(milliseconds: 500),
                          ),
                        );
                      },
                      child: CircleAvatar(
                        radius: 16,
                        backgroundColor: Colors.white.withOpacity(0.9),
                        child: Icon(
                          recipe.isFavorite
                              ? Icons.favorite
                              : Icons.favorite_border,
                          size: 18,
                          color: recipe.isFavorite
                              ? Colors.red
                              : Colors.black87,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    recipe.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: Color(0xFF1D2A3A),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    "${recipe.calories} kcal",
                    style: const TextStyle(
                      color: Color(0xFF008CFF),
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
