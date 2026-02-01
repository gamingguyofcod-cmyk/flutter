import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_foodroute/all_meals.dart';
import 'package:flutter_foodroute/recipe.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_foodroute/favorites.dart';
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

  double currentCalories = 0;
  double currentProtein = 0;
  double currentCarbs = 0;
  double currentFat = 0;

  final Color primaryDark = Color(0xFF080C10);
  final Color accentCyan = Color(0xFF008CFF);

  void _updateNutrition(double cal, double pro, double carb, double fat) {
    setState(() {
      currentCalories += cal;
      currentProtein += pro;
      currentCarbs += carb;
      currentFat += fat;
    });
  }

  // --- Exit Confirmation Dialog ---
  Future<bool> _showExitDialog(BuildContext context) async {
    return await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            backgroundColor: Color(0xFF1A1F24),
            title: Text("Exit App", style: TextStyle(color: Colors.white)),
            content: Text(
              "Do you want to close the app?",
              style: TextStyle(color: Colors.white70),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text("No", style: TextStyle(color: Colors.grey)),
              ),
              TextButton(
                onPressed: () => SystemNavigator.pop(), // App close kar dega
                child: Text("Yes", style: TextStyle(color: Color(0xFF008CFF))),
              ),
            ],
          ),
        ) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;

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
      SearchScreen(),
      FavoritesScreen(),
    ];

    // 🔥 PopScope lagaya hai taaki back karne par Login screen na aaye
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        await _showExitDialog(context);
      },
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle(
          systemNavigationBarColor: isDark ? primaryDark : Colors.white,
          systemNavigationBarIconBrightness: isDark
              ? Brightness.light
              : Brightness.dark,
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
        ),
        child: Scaffold(
          body: IndexedStack(index: _currentIndex, children: screens),
          bottomNavigationBar: Container(
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: isDark ? Colors.white10 : Colors.grey.shade100,
                  width: 1,
                ),
              ),
            ),
            child: BottomNavigationBar(
              currentIndex: _currentIndex,
              onTap: (index) => setState(() => _currentIndex = index),
              type: BottomNavigationBarType.fixed,
              backgroundColor: isDark ? primaryDark : Colors.white,
              selectedItemColor: accentCyan,
              unselectedItemColor: Colors.grey,
              selectedLabelStyle: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
              unselectedLabelStyle: TextStyle(fontSize: 12),
              elevation: 0,
              items: [
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
  String username = "";
  final Color primaryDark = Color(0xFF080C10);
  final Color accentCyan = Color(0xFF008CFF);

  @override
  void initState() {
    super.initState();
    _loadUsername();
  }

  void _loadUsername() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      username = prefs.getString('username') ?? "User";
    });
  }

  final TextEditingController calController = TextEditingController();
  final TextEditingController proteinController = TextEditingController();
  final TextEditingController carbController = TextEditingController();
  final TextEditingController fatController = TextEditingController();

  void _showAddMealPopup(BuildContext context, bool isDark) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: EdgeInsets.symmetric(horizontal: 25),
        child: Container(
          padding: EdgeInsets.all(25),
          decoration: BoxDecoration(
            color: isDark ? Color(0xFF1A1F24) : Colors.white,
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
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Log Meal",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.white : primaryDark,
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
                      icon: Icon(
                        Icons.close,
                        color: isDark ? Colors.white : primaryDark,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 25),
                _buildPopupField("Calories", "e.g. 450", calController, isDark),
                SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: _buildMacroInput(
                        "Protein",
                        "28",
                        proteinController,
                        isDark,
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: _buildMacroInput(
                        "Carbs",
                        "45",
                        carbController,
                        isDark,
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: _buildMacroInput(
                        "Fat",
                        "12",
                        fatController,
                        isDark,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 30),
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text(
                          "Cancel",
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                    ),
                    SizedBox(width: 15),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          double c = double.tryParse(calController.text) ?? 0;
                          double p =
                              double.tryParse(proteinController.text) ?? 0;
                          double carb =
                              double.tryParse(carbController.text) ?? 0;
                          double f = double.tryParse(fatController.text) ?? 0;
                          widget.onMealAdded(c, p, carb, f);
                          calController.clear();
                          proteinController.clear();
                          carbController.clear();
                          fatController.clear();
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: accentCyan,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          padding: EdgeInsets.symmetric(vertical: 16),
                          elevation: 0,
                        ),
                        child: Text(
                          "Save Meal",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
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

  Widget _buildPopupField(
    String label,
    String hint,
    TextEditingController controller,
    bool isDark,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: isDark ? Colors.white70 : primaryDark,
          ),
        ),
        SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          style: TextStyle(color: isDark ? Colors.white : primaryDark),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colors.grey),
            filled: true,
            fillColor: isDark
                // ignore: deprecated_member_use
                ? Colors.white.withOpacity(0.05)
                : Color(0xFFF8F8F8),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMacroInput(
    String label,
    String hint,
    TextEditingController controller,
    bool isDark,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: isDark ? Colors.white70 : primaryDark,
          ),
        ),
        SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          style: TextStyle(color: isDark ? Colors.white : primaryDark),
          decoration: InputDecoration(
            hintText: hint,
            filled: true,
            fillColor: isDark
                // ignore: deprecated_member_use
                ? Colors.white.withOpacity(0.05)
                : Color(0xFFF8F8F8),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    List<Recipe> featuredRecipes = allRecipes.take(4).toList();

    return Scaffold(
      backgroundColor: isDark ? primaryDark : Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Good Morning, $username",
              style: TextStyle(
                color: isDark ? Colors.white : primaryDark,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              "Friday, Jan 2, 2026",
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ],
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: InkWell(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SettingsScreen()),
              ),
              child: CircleAvatar(
                // ignore: deprecated_member_use
                backgroundColor: accentCyan.withOpacity(0.2),
                child: Icon(Icons.person, color: accentCyan),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _sectionTitle("Today's Meals", isDark),
            SizedBox(height: 16),
            _buildMealCard(context, isDark),
            SizedBox(height: 12),
            _buildAddMealButton(context, isDark),
            SizedBox(height: 25),
            _sectionTitle("Macro Overview", isDark),
            SizedBox(height: 16),
            _buildMacroCard(isDark),
            SizedBox(height: 30),
            _buildFavoritesHeader(context, isDark),
            SizedBox(height: 16),
            _buildRecipeGrid(context, featuredRecipes, isDark),
            SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(String title, bool isDark) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: isDark ? Colors.white : primaryDark,
      ),
    );
  }

  Widget _buildMealCard(BuildContext context, bool isDark) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark ? Color(0xFF1A1F24) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? Colors.white10 : Colors.grey.shade100,
        ),
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
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "08:00 AM • Breakfast",
                  style: TextStyle(color: Colors.grey, fontSize: 11),
                ),
                Text(
                  "Omelette Sandwich",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: isDark ? Colors.white : primaryDark,
                  ),
                ),
                Text(
                  "320 kcal",
                  style: TextStyle(
                    color: accentCyan,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddMealButton(BuildContext context, bool isDark) {
    return InkWell(
      onTap: () => _showAddMealPopup(context, isDark),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        height: 55,
        decoration: BoxDecoration(
          // ignore: deprecated_member_use
          color: accentCyan.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add_rounded, color: accentCyan),
            Text(
              " Add meal",
              style: TextStyle(color: accentCyan, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMacroCard(bool isDark) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? Color(0xFF1A1F24) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark ? Colors.white10 : Colors.grey.shade100,
        ),
      ),
      child: Column(
        children: [
          _macroRow(
            "Calories",
            "${widget.calories.toInt()}/2000",
            widget.calories / 2000,
            Colors.green,
            isDark,
          ),
          _macroRow(
            "Protein",
            "${widget.protein.toInt()}/65g",
            widget.protein / 65,
            accentCyan,
            isDark,
          ),
          _macroRow(
            "Carbs",
            "${widget.carbs.toInt()}/200g",
            widget.carbs / 200,
            Colors.orange,
            isDark,
          ),
          _macroRow(
            "Fat",
            "${widget.fat.toInt()}/50g",
            widget.fat / 50,
            Colors.redAccent,
            isDark,
          ),
        ],
      ),
    );
  }

  Widget _macroRow(String l, String v, double p, Color c, bool isDark) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(l, style: TextStyle(fontSize: 12, color: Colors.grey)),
              Text(
                v,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : primaryDark,
                ),
              ),
            ],
          ),
          SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: p.clamp(0.0, 1.0),
              backgroundColor: isDark ? Colors.white12 : Colors.grey.shade100,
              color: c,
              minHeight: 6,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFavoritesHeader(BuildContext context, bool isDark) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _sectionTitle("Favorite Recipes", isDark),
        TextButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AllMealsScreen()),
            ).then((_) {
              if (mounted) setState(() {});
            });
          },
          child: Text(
            "See All",
            style: TextStyle(color: accentCyan, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }

  // 1. Apni State class mein sabse upar ye list define karein:
  Widget _buildRecipeGrid(
    BuildContext context,
    List<Recipe> recipes,
    bool isDark,
  ) {
    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.75,
        crossAxisSpacing: 15,
        mainAxisSpacing: 15,
      ),
      itemCount: recipes.length,
      itemBuilder: (c, i) {
        final recipe = recipes[i];

        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => RecipeDetailScreen(recipe: recipe),
              ),
            ).then((_) {
              if (mounted) setState(() {}); // Wapis aane par UI refresh karein
            });
          },
          child: Container(
            decoration: BoxDecoration(
              color: isDark ? Color(0xFF1A1F24) : Colors.white,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: isDark ? Colors.white10 : Colors.grey.shade100,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
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
                        ),
                      ),
                      // --- SEARCH SCREEN WALI LOGIC ---
                      Positioned(
                        top: 10,
                        right: 10,
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              // Direct model ki property toggle karein
                              recipe.isFavorite = !recipe.isFavorite;
                            });
                          },
                          child: CircleAvatar(
                            radius: 15,
                            backgroundColor: isDark
                                ? Color.fromARGB(0, 0, 0, 0)
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
                          color: isDark ? Colors.white : Color(0xFF080C10),
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        "${recipe.calories} kcal",
                        style: TextStyle(
                          color: Color(0xFF008CFF), // Aapka Cyan Accent
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
