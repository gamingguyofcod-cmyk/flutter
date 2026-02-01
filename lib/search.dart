import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_foodroute/all_meals.dart';
import 'package:flutter_foodroute/meals.dart';
import 'package:flutter_foodroute/recipe.dart';
import 'package:cached_network_image/cached_network_image.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  List<Recipe> filteredRecipes = [];
  String searchQuery = "";
  String selectedFilter = "All"; // Naya variable selection track karne ke liye

  final Color navyBlue = Color(0xFF008CFF);
  final Color cyanColor = Color(0xFF008CFF); // Aapka brand color

  @override
  void initState() {
    super.initState();
    filteredRecipes = allRecipes;
  }

  // --- UPDATED FILTER LOGIC ---
  void _applyFilters() {
    setState(() {
      filteredRecipes = allRecipes.where((recipe) {
        // 1. Search Logic
        bool matchesSearch = recipe.title.toLowerCase().contains(
          searchQuery.toLowerCase(),
        );

        // 2. Chip Filter Logic
        bool matchesChip = false;
        if (selectedFilter == "All") {
          matchesChip = true;
        } else {
          // Agar tags hain toh unme check karega, warna title mein word dhundega
          matchesChip =
              recipe.tags.contains(selectedFilter) ||
              recipe.title.toLowerCase().contains(selectedFilter.toLowerCase());
        }

        return matchesSearch && matchesChip;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: isDark ? Colors.white : Color(0xFF080C10),
          ),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const Meals()),
            );
          },
        ),
        title: Text(
          "Discover Recipes",
          style: TextStyle(
            color: isDark ? Colors.white : Color(0xFF080C10),
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
            padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
            child: TextField(
              onChanged: (value) {
                searchQuery = value;
                _applyFilters();
              },
              style: TextStyle(color: isDark ? Colors.white : Colors.black),
              decoration: InputDecoration(
                hintText: "Search for Pizza, Pasta...",
                hintStyle: TextStyle(color: Colors.grey),
                prefixIcon: Icon(Icons.search, color: Colors.grey),
                filled: true,
                fillColor: isDark ? Color(0xFF1A1F24) : Color(0xFFF4F7F9),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),

          // Horizontal Filters (Updated to be Clickable)
          SizedBox(height: 10),
          SizedBox(
            height: 45,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 20),
              children: ["All", "High Protein", "Keto", "Vegan"].map((label) {
                return _buildFilterChip(label, selectedFilter == label, isDark);
              }).toList(),
            ),
          ),

          Padding(
            padding: EdgeInsets.fromLTRB(20, 25, 20, 15),
            child: Text(
              "${filteredRecipes.length} Recipes found",
              style: TextStyle(
                color: Color(0xFF9EABB8),
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),

          // Recipe Grid
          Expanded(
            child: filteredRecipes.isEmpty
                ? Center(
                    child: Text(
                      "No recipes found!",
                      style: TextStyle(
                        color: isDark
                            ? Colors.white70
                            : const Color.fromARGB(137, 255, 255, 255),
                      ),
                    ),
                  )
                : GridView.builder(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.75,
                      crossAxisSpacing: 15,
                      mainAxisSpacing: 15,
                    ),
                    itemCount: filteredRecipes.length,
                    itemBuilder: (context, index) {
                      final recipe = filteredRecipes[index];
                      return _buildRecipeCard(context, recipe, isDark);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  // --- Updated Chip Widget with OnTap ---
  Widget _buildFilterChip(String label, bool isSelected, bool isDark) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedFilter = label;
          _applyFilters();
        });
      },
      child: Container(
        margin: EdgeInsets.only(right: 12),
        padding: EdgeInsets.symmetric(horizontal: 22),
        decoration: BoxDecoration(
          color: isSelected
              ? cyanColor // Branding: Cyan color for selected
              : (isDark ? Colors.white10 : Color(0xFFF4F7F9)),
          borderRadius: BorderRadius.circular(12),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: TextStyle(
            color: isSelected
                ? Color(0xFF080C10) // Dark text on Cyan
                : (isDark ? Colors.white60 : Color(0xFF7D8C9B)),
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  Widget _buildRecipeCard(BuildContext context, Recipe recipe, bool isDark) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => RecipeDetailScreen(recipe: recipe),
          ),
        ).then((_) => setState(() {}));
      },
      child: Container(
        decoration: BoxDecoration(
          color: isDark ? Color(0xFF1A1F24) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              // ignore: deprecated_member_use
              color: Colors.black.withOpacity(isDark ? 0.3 : 0.04),
              blurRadius: 15,
              offset: Offset(0, 8),
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
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(20),
                    ),
                    child: CachedNetworkImage(
                      imageUrl: recipe.image,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity,
                      placeholder: (context, url) => Container(
                        color: isDark ? Colors.white10 : Colors.grey[100],
                      ),
                      errorWidget: (context, url, error) => Icon(Icons.error),
                    ),
                  ),
                  Positioned(
                    top: 10,
                    right: 10,
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          recipe.isFavorite = !recipe.isFavorite;
                        });
                      },
                      child: CircleAvatar(
                        radius: 16,
                        backgroundColor: isDark
                            ? Colors.black54
                            // ignore: deprecated_member_use
                            : Colors.white.withOpacity(0.9),
                        child: Icon(
                          recipe.isFavorite
                              ? Icons.favorite
                              : Icons.favorite_border,
                          size: 18,
                          color: recipe.isFavorite
                              ? Colors.red
                              : (isDark ? Colors.white : Colors.black87),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    recipe.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: isDark ? Colors.white : Colors.black,
                    ),
                  ),
                  SizedBox(height: 6),
                  Text(
                    "${recipe.calories} kcal",
                    style: TextStyle(
                      color: cyanColor, // Branding Cyan highlight
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
