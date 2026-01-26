import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_foodroute/all_meals.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_foodroute/favorites.dart';
import 'package:flutter_foodroute/recipe.dart' hide Recipe;
import 'package:flutter_foodroute/search.dart';
import 'package:flutter_foodroute/setting_and_profile.dart';
import 'progress.dart';

class Meals extends StatefulWidget {
  const Meals({super.key});

  @override
  State<Meals> createState() => _MealsState();
}

class _MealsState extends State<Meals> {
  int _currentIndex = 0;

  // Global variables for tracking
  double currentCalories = 0;
  double currentProtein = 0;
  double currentCarbs = 0;
  double currentFat = 0;

  // Targets
  final double targetCalories = 2000;
  final double targetProtein = 65;
  final double targetCarbs = 200;
  final double targetFat = 50;

  // Function to update nutrition data from child
  void _updateNutrition(double cal, double pro, double carb, double fat) {
    setState(() {
      currentCalories += cal;
      currentProtein += pro;
      currentCarbs += carb;
      currentFat += fat;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Screens list (Passing data and callback to MealsContent)
    final List<Widget> screens = [
      MealsContent(
        calories: currentCalories,
        protein: currentProtein,
        carbs: currentCarbs,
        fat: currentFat,
        onMealAdded: _updateNutrition,
      ),
      Progress(
        calories: currentCalories,
        protein: currentProtein,
        carbs: currentCarbs,
        fat: currentFat,
      ),
      const SearchScreen(),
      const FavoritesScreen(),
      const Progress(),
    ];

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.dark,
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        body: screens[_currentIndex],
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(color: Colors.grey.shade100, width: 1),
            ),
          ),
          child: BottomNavigationBar(
            currentIndex: _currentIndex,
            onTap: (index) => setState(() => _currentIndex = index),
            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.white,
            selectedItemColor: const Color(0xFF008CFF),
            unselectedItemColor: Colors.grey,
            selectedLabelStyle: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
            unselectedLabelStyle: const TextStyle(fontSize: 12),
            elevation: 0,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.restaurant_menu),
                label: "Meals",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.auto_graph),
                label: "Progress",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.search),
                label: "Search",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.favorite),
                label: "Favorites",
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MealsContent extends StatefulWidget {
  final double calories;
  final double protein;
  final double carbs;
  final double fat;
  final Function(double, double, double, double) onMealAdded;

  const MealsContent({
    super.key,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fat,
    required this.onMealAdded,
  });

  @override
  State<MealsContent> createState() => _MealsContentState();
}

class _MealsContentState extends State<MealsContent> {
  String username = ""; // Variable to store name

  @override
  void initState() {
    super.initState();
    _loadUsername(); // Screen load hote hi naam uthao
  }

  // Memory se username nikalne ka function
  void _loadUsername() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      // Agar 'username' nahi mila toh "User" dikhayega
      username = prefs.getString('username') ?? "User";
    });
  }

  // Controllers to capture user input
  final TextEditingController calController = TextEditingController();
  final TextEditingController proteinController = TextEditingController();
  final TextEditingController carbController = TextEditingController();
  final TextEditingController fatController = TextEditingController();

  void _showAddMealPopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 25),
        child: Container(
          padding: const EdgeInsets.all(25),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30),
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Log Meal",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "Custom Entry",
                          style: TextStyle(color: Colors.grey, fontSize: 13),
                        ),
                      ],
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close),
                    ),
                  ],
                ),
                const SizedBox(height: 25),
                const Text(
                  "Calories",
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 10),
                _buildPopupField("e.g. 450", calController),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: _buildMacroInput(
                        "Protein (g)",
                        "28",
                        proteinController,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildMacroInput(
                        "Carbs (g)",
                        "45",
                        carbController,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildMacroInput("Fat (g)", "12", fatController),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => Navigator.pop(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey.shade100,
                          foregroundColor: Colors.black54,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          elevation: 0,
                        ),
                        child: const Text("Cancel"),
                      ),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          // Convert text to double and send back
                          double c = double.tryParse(calController.text) ?? 0;
                          double p =
                              double.tryParse(proteinController.text) ?? 0;
                          double carb =
                              double.tryParse(carbController.text) ?? 0;
                          double f = double.tryParse(fatController.text) ?? 0;

                          widget.onMealAdded(c, p, carb, f);

                          // Clear controllers
                          calController.clear();
                          proteinController.clear();
                          carbController.clear();
                          fatController.clear();

                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF008CFF),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          elevation: 0,
                        ),
                        child: const Text("Save Meal"),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPopupField(String hint, TextEditingController controller) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: const Color(0xFFF8F8F8),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 15,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _buildMacroInput(
    String label,
    String hint,
    TextEditingController controller,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        _buildPopupField(hint, controller),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Recipe> featuredRecipes = allRecipes.take(4).toList();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        // 'const' yahan se hata diya hai taake variable use ho sake
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Good Morning, $username", // Ab yahan dynamic name aayega
              style: const TextStyle(
                color: Color(0xFF080C10), // Aapka brand dark color
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Text(
              "Friday, Jan 2, 2026",
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: InkWell(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsScreen()),
              ),
              child: const CircleAvatar(
                backgroundColor: Color(0xFF008CFF), // Aapka brand cyan color
                child: Icon(Icons.person, color: Color(0xFF080C10)),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Today's Meals",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildMealCard(context),
            const SizedBox(height: 12),
            _buildAddMealButton(context),
            const SizedBox(height: 25),
            const Text(
              "Macro Overview",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildMacroCard(),
            const SizedBox(height: 30),
            _buildFavoritesHeader(context),
            const SizedBox(height: 16),
            _buildRecipeGrid(context, featuredRecipes),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildMealCard(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const RecipeDetailScreen(
            title: "Omelette Sandwich",
            imagePath:
                'https://images.unsplash.com/photo-1525351484163-7529414344d8?w=200',
          ),
        ),
      ),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade100),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                'https://images.unsplash.com/photo-1525351484163-7529414344d8?w=200',
                width: 60,
                height: 60,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 12),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "08:00 AM • Breakfast",
                    style: TextStyle(color: Colors.grey, fontSize: 11),
                  ),
                  Text(
                    "Omelette Sandwich",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                  Text(
                    "320 kcal",
                    style: TextStyle(
                      color: Colors.blue,
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

  Widget _buildAddMealButton(BuildContext context) {
    return InkWell(
      onTap: () => _showAddMealPopup(context),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        height: 55,
        decoration: BoxDecoration(
          color: const Color(0xFF2196F3).withOpacity(0.05),
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add, color: Color(0xFF008CFF)),
            Text(
              " Add meal",
              style: TextStyle(
                color: Color(0xFF008CFF),
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMacroCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Column(
        children: [
          _macroRow(
            "Calories",
            "${widget.calories.toInt()}/2000",
            widget.calories / 2000,
            Colors.green,
          ),
          _macroRow(
            "Protein",
            "${widget.protein.toInt()}/65g",
            widget.protein / 65,
            Colors.blue,
          ),
          _macroRow(
            "Carbs",
            "${widget.carbs.toInt()}/200g",
            widget.carbs / 200,
            Colors.orange,
          ),
          _macroRow(
            "Fat",
            "${widget.fat.toInt()}/50g",
            widget.fat / 50,
            Colors.redAccent,
          ),
        ],
      ),
    );
  }

  Widget _macroRow(String l, String v, double p, Color c) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(l, style: const TextStyle(fontSize: 12, color: Colors.grey)),
              Text(
                v,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: p > 1.0 ? 1.0 : p, // Progress bar max 1.0 tak hi jaye
              backgroundColor: Colors.grey.shade100,
              color: c,
              minHeight: 6,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFavoritesHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          "Favorite Recipes",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        TextButton(
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AllMealsScreen()),
          ),
          child: const Text(
            "See All",
            style: TextStyle(color: Color(0xFF008CFF)),
          ),
        ),
      ],
    );
  }

  Widget _buildRecipeGrid(BuildContext context, List<Recipe> recipes) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.72,
        crossAxisSpacing: 15,
        mainAxisSpacing: 15,
      ),
      itemCount: recipes.length,
      itemBuilder: (c, i) {
        final recipe = recipes[i];
        return InkWell(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => RecipeDetailScreen(
                title: recipe.title,
                imagePath: recipe.image,
              ),
            ),
          ),
          borderRadius: BorderRadius.circular(24),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: Colors.grey.shade100),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 3,
                  child: Stack(
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(24),
                        ),
                        child: Image.network(
                          recipe.image,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: double.infinity,
                        ),
                      ),
                      Positioned(
                        top: 12,
                        right: 12,
                        child: GestureDetector(
                          onTap: () => setState(
                            () => recipe.isFavorite = !recipe.isFavorite,
                          ),
                          child: CircleAvatar(
                            radius: 18,
                            backgroundColor: Colors.white.withOpacity(0.9),
                            child: Icon(
                              recipe.isFavorite
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              size: 20,
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
                  padding: const EdgeInsets.all(15),
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
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        "${recipe.calories} kcal",
                        style: const TextStyle(
                          color: Color(0xFF008CFF),
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
      },
    );
  }
}
