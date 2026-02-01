import 'package:flutter/material.dart';
import 'package:flutter_foodroute/all_meals.dart';
import 'package:flutter_foodroute/meals.dart';
// Note: Apni Meals screen ki file import zaroor karein
// import 'package:flutter_foodroute/meals.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  // Brand Colors
  final Color primaryDark = Color(0xFF080C10);
  final Color brandBlue = Color(0xFF008CFF);
  final Color cyanAccent = Color(0xFF18FFFF); // Aapka neon cyan color

  // --- 1. Ye function build se bahar rehna chahiye ---
  void refreshState() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;

    // List ko filter karna
    List<Recipe> favoriteRecipes = allRecipes
        .where((r) => r.isFavorite)
        .toList();

    return Scaffold(
      backgroundColor: isDark
          ? primaryDark
          : Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        // --- UPDATED BACK BUTTON ---
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new,
            color: isDark ? Colors.blue : primaryDark,
          ),
          onPressed: () {
            // Yeh aapko hamesha Meals screen par wapas le jayega
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => Meals(),
              ), // Apni Meals class ka naam check kar lein
            );
          },
        ),
        title: Text(
          "My Favorites",
          style: TextStyle(
            color: isDark ? Colors.white : primaryDark,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: favoriteRecipes.isEmpty
          ? _buildEmptyState(isDark)
          : GridView.builder(
              padding: EdgeInsets.all(20),
              key: ValueKey(favoriteRecipes.length), // Refresh trigger
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.72,
                crossAxisSpacing: 15,
                mainAxisSpacing: 15,
              ),
              itemCount: favoriteRecipes.length,
              itemBuilder: (context, index) {
                return _buildFavoriteCard(
                  context,
                  favoriteRecipes[index],
                  isDark,
                );
              },
            ),
    );
  }

  // --- 2. Card Widget with Refresh Logic ---
  Widget _buildFavoriteCard(BuildContext context, Recipe recipe, bool isDark) {
    return InkWell(
      onTap: () async {
        // Detail screen par jana aur wapsi ka wait karna
        // await Navigator.push(
        //   context,
        //   MaterialPageRoute(
        //     builder: (context) => RecipeDetailScreen(recipe: recipe),
        //   ),
        // );

        // Wapsi par ye function UI ko refresh kar dega
        refreshState();
      },
      borderRadius: BorderRadius.circular(24),
      child: Container(
        decoration: BoxDecoration(
          color: isDark ? Color(0xFF1A1F24) : Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isDark ? Colors.white10 : Colors.grey.shade100,
          ),
          boxShadow: [
            BoxShadow(
              // ignore: deprecated_member_use
              color: Colors.black.withOpacity(isDark ? 0.3 : 0.02),
              blurRadius: 10,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 3,
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(24),
                    ),
                    child: Image.network(
                      recipe.image,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity,
                      errorBuilder: (context, error, stackTrace) => Container(
                        color: Colors.grey,
                        child: Icon(Icons.broken_image),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 12,
                    right: 12,
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          recipe.isFavorite = false;
                        });
                      },
                      child: CircleAvatar(
                        radius: 18,
                        backgroundColor: isDark
                            ? Colors.black54
                            // ignore: deprecated_member_use
                            : Colors.white.withOpacity(0.9),
                        child: Icon(
                          Icons.favorite,
                          size: 20,
                          color: Colors.red,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.all(12),
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
                  SizedBox(height: 4),
                  Text(
                    "${recipe.calories} kcal",
                    style: TextStyle(
                      color: isDark ? cyanAccent : brandBlue,
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
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

  Widget _buildEmptyState(bool isDark) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.favorite_border_rounded,
            size: 80,
            color: isDark ? Colors.white10 : Colors.grey.shade300,
          ),
          SizedBox(height: 16),
          Text(
            "No favorites yet",
            style: TextStyle(
              color: isDark ? Colors.white70 : Colors.grey,
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 8),
          Text(
            "Start adding your favorite meals!",
            style: TextStyle(
              color: isDark ? Colors.white38 : Colors.grey.shade400,
            ),
          ),
        ],
      ),
    );
  }
}
