import 'package:flutter/material.dart';
import 'package:flutter_foodroute/add_to_shopping_card_screen.dart';

class Recipe {
  final String title;
  final String image;
  final String calories;
  bool isFavorite; // Ye toggle hoga

  Recipe({
    required this.title,
    required this.image,
    required this.calories,
    this.isFavorite = false,
  });
}

class RecipeDetailScreen extends StatelessWidget {
  final String title;
  final String imagePath;

  const RecipeDetailScreen({
    super.key,
    required this.title,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // --- APPBAR ADDED HERE ---
      appBar: AppBar(
        backgroundColor: const Color.from(alpha: 1, red: 1, green: 1, blue: 1),
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundColor: Colors.grey.shade100,
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black, size: 20),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ),
        title: Text(
          title,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Image (Ab Stack ki zaroorat nahi kyunki back button AppBar mein hai)
            Image.network(
              imagePath,
              width: double.infinity,
              height: 250, // Thodi height kam ki hai taake content zyada dikhe
              fit: BoxFit.cover,
            ),

            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "A high-protein, nutritious salad – perfect for lunch or dinner.",
                    style: TextStyle(color: Colors.grey),
                  ),

                  const SizedBox(height: 20),
                  // Stats Row (Time, Calories, Protein)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildInfoItem(Icons.access_time, "15 min", Colors.blue),
                      _buildInfoItem(
                        Icons.local_fire_department,
                        "450 kcal",
                        Colors.orange,
                      ),
                      _buildInfoItem(Icons.egg, "38g Protein", Colors.green),
                    ],
                  ),

                  const SizedBox(height: 30),
                  const Text(
                    "Ingredients",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 15),
                  _buildIngredient("2 Chicken breast fillets (grilled)"),
                  _buildIngredient("4 Cups mixed green salad"),
                  _buildIngredient("1 Cup cherry tomatoes"),
                  _buildIngredient("1 Cucumber, sliced"),
                  _buildIngredient("1/4 Red onion, thinly sliced"),

                  const SizedBox(height: 30),
                  const Text(
                    "Instructions",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 15),
                  _buildStep(
                    1,
                    "Season chicken breast fillets with salt, pepper, and your favorite herbs. Grill for 6-7 minutes per side until fully cooked.",
                  ),
                  _buildStep(
                    2,
                    "While the chicken is grilling, wash and prepare the vegetables. Halve the cherry tomatoes, slice the cucumber, and thinly slice the red onion.",
                  ),
                  _buildStep(
                    3,
                    "In a large bowl, toss together the mixed greens, cherry tomatoes, cucumber, and red onion.",
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      // Orange Bottom Button
      // Orange Bottom Button (Updated to navigate)
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(
            left: 20,
            right: 20,
            bottom: 20,
            top: 10,
          ),
          child: ElevatedButton.icon(
            onPressed: () {
              // NAVIGATION LOGIC START
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ShoppingListScreen(),
                ),
              );
              // NAVIGATION LOGIC END
            },
            icon: const Icon(Icons.shopping_cart),
            label: const Text("Add to Shopping List"),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2196F3),
              foregroundColor: Colors.white,
              minimumSize: const Size(double.infinity, 55),
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Helpers for Detail Screen
  Widget _buildInfoItem(IconData icon, String label, Color color) {
    return Row(
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(width: 5),
        Text(
          label,
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildIngredient(String name) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(5),
            ),
          ),
          const SizedBox(width: 10),
          Text(name),
        ],
      ),
    );
  }

  Widget _buildStep(int num, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 12,
            backgroundColor: const Color(0xFF2196F3),
            child: Text(
              "$num",
              style: const TextStyle(color: Colors.white, fontSize: 12),
            ),
          ),
          const SizedBox(width: 15),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }
}
