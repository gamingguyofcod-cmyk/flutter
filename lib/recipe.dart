import 'package:flutter/material.dart';
import 'package:flutter_foodroute/add_to_shopping_card_screen.dart';
import 'package:flutter_foodroute/all_meals.dart'; // Recipe model ke liye

class RecipeDetailScreen extends StatefulWidget {
  final Recipe recipe; // Pura object pass kar rahe hain

  const RecipeDetailScreen({super.key, required this.recipe});

  @override
  State<RecipeDetailScreen> createState() => _RecipeDetailScreenState();
}

class _RecipeDetailScreenState extends State<RecipeDetailScreen> {
  // Brand Colors
  final Color primaryDark = Color(0xFF080C10);
  final Color accentCyan = Color(0xFF008CFF);
  final Color cardBg = Color(0xFFF4F7F9);

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? primaryDark : Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Padding(
          padding: EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundColor: isDark ? Colors.white10 : Colors.grey.shade100,
            child: IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: isDark ? Colors.white : Colors.black,
                size: 20,
              ),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ),
        title: Text(
          "Recipe Details",
          style: TextStyle(
            color: isDark ? Colors.white : primaryDark,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 12),
            child: CircleAvatar(
              backgroundColor: isDark ? Colors.white10 : Colors.grey.shade100,
              child: IconButton(
                icon: Icon(
                  widget.recipe.isFavorite
                      ? Icons.favorite
                      : Icons.favorite_border,
                  // Favorite hai to Red, warna theme ke hisab se black/white
                  color: widget.recipe.isFavorite
                      ? Colors.red
                      : (isDark ? Colors.white : Colors.black),
                  size: 20,
                ),
                onPressed: () {
                  setState(() {
                    // Direct main list ka data change ho raha hai
                    widget.recipe.isFavorite = !widget.recipe.isFavorite;
                  });
                },
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image Section
            Container(
              height: 280,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(32),
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(32),
                ),
                child: Image.network(widget.recipe.image, fit: BoxFit.cover),
              ),
            ),

            Padding(
              padding: EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.recipe.title,
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : primaryDark,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "A high-protein, nutritious meal prepared with fresh ingredients.",
                    style: TextStyle(
                      color: isDark ? Colors.white60 : Colors.grey.shade600,
                      fontSize: 14,
                    ),
                  ),

                  SizedBox(height: 24),

                  // Stats Row
                  Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: isDark ? Colors.white10 : cardBg,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildInfoItem(
                          Icons.access_time_rounded,
                          "15 min",
                          Colors.blue,
                          isDark,
                        ),
                        _buildInfoItem(
                          Icons.local_fire_department_rounded,
                          "${widget.recipe.calories} kcal",
                          Colors.orange,
                          isDark,
                        ),
                        _buildInfoItem(
                          Icons.fitness_center_rounded,
                          "38g Protein",
                          Colors.green,
                          isDark,
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 32),
                  _buildSectionTitle("Ingredients", isDark),
                  SizedBox(height: 16),
                  _buildIngredient(
                    "2 Chicken breast fillets (grilled)",
                    isDark,
                  ),
                  _buildIngredient("4 Cups mixed green salad", isDark),
                  _buildIngredient("1 Cup cherry tomatoes", isDark),
                  _buildIngredient("1 Cucumber, sliced", isDark),

                  SizedBox(height: 32),
                  _buildSectionTitle("Cooking Steps", isDark),
                  SizedBox(height: 16),
                  _buildStep(
                    1,
                    "Season chicken with salt, pepper, and herbs. Grill until golden brown.",
                    isDark,
                  ),
                  _buildStep(
                    2,
                    "Wash and chop all fresh vegetables into bite-sized pieces.",
                    isDark,
                  ),
                  _buildStep(
                    3,
                    "Toss everything in a large bowl and add your favorite dressing.",
                    isDark,
                  ),
                  SizedBox(height: 100),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isDark ? primaryDark : Colors.white,
          boxShadow: [
            BoxShadow(
              // ignore: deprecated_member_use
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: Offset(0, -5),
            ),
          ],
        ),
        child: SafeArea(
          child: ElevatedButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ShoppingListScreen()),
              );
            },
            icon: Icon(Icons.shopping_bag_outlined),
            label: Text("Add to Shopping List"),
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF008CFF),
              foregroundColor: Colors.white,
              minimumSize: Size(double.infinity, 60),
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // --- Helpers ---
  Widget _buildSectionTitle(String title, bool isDark) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: isDark ? Colors.white : primaryDark,
      ),
    );
  }

  Widget _buildInfoItem(IconData icon, String label, Color color, bool isDark) {
    return Column(
      children: [
        Icon(icon, color: color, size: 24),
        SizedBox(height: 6),
        Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : primaryDark,
          ),
        ),
      ],
    );
  }

  Widget _buildIngredient(String name, bool isDark) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(Icons.check_circle_outline, color: accentCyan, size: 20),
          SizedBox(width: 12),
          Text(
            name,
            style: TextStyle(
              fontSize: 15,
              color: isDark ? Colors.white70 : Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStep(int num, String text, bool isDark) {
    return Padding(
      padding: EdgeInsets.only(bottom: 24),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              // ignore: deprecated_member_use
              color: accentCyan.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              "$num",
              style: TextStyle(color: accentCyan, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 15,
                height: 1.5,
                color: isDark ? Colors.white70 : Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
