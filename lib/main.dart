import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_foodroute/firebase_options.dart';
import 'package:flutter_foodroute/log_in.dart';

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

List<Recipe> allRecipes = [
  Recipe(
    title: "Grilled Chicken",
    image: "https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=400",
    calories: "450 kcal",
  ),
  Recipe(
    title: "Avocado Toast",
    image: "https://images.unsplash.com/photo-1525351484163-7529414344d8?w=400",
    calories: "320 kcal",
  ),
  Recipe(
    title: "Fruit Salad",
    image: "https://images.unsplash.com/photo-1490645935967-10de6ba17061?w=400",
    calories: "150 kcal",
  ),
  Recipe(
    title: "Salmon Steak",
    image: "https://images.unsplash.com/photo-1467003909585-2f8a72700288?w=400",
    calories: "550 kcal",
  ),
];

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Default Status Bar setup
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
  );

  runApp(const FoodRouteApp());
}

// main.dart ke top par ye global variable bana dein
ValueNotifier<ThemeMode> themeNotifier = ValueNotifier(ThemeMode.light);

class FoodRouteApp extends StatelessWidget {
  const FoodRouteApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeNotifier,
      builder: (_, ThemeMode currentMode, _) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          themeMode: currentMode, // Switch se ye change hoga
          theme: ThemeData(
            brightness: Brightness.light,
            primaryColor: Color(0xFF008CFF),
          ),
          darkTheme: ThemeData(
            brightness: Brightness.dark,
            scaffoldBackgroundColor: Color(0xFF080C10), // Aapka Brand Dark
            primaryColor: Color(0xFF008CFF), // Aapka Brand Cyan
          ),
          home: WelcomePage(),
        );
      },
    );
  }
}

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Welcome page hamesha dark overlay ke sath behtar lagti hai background image ki wajah se
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        body: Stack(
          children: [
            // Background Image
            Positioned.fill(
              child: RotatedBox(
                quarterTurns: 3,
                child: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('asset/welcome_bg.jpg'),
                      fit: BoxFit.cover,
                      colorFilter: ColorFilter.mode(
                        Colors.black45,
                        BlendMode.darken,
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // Content
            SafeArea(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30.0),
                  child: Column(
                    children: [
                      SizedBox(height: 40),
                      // Logo Icon with Brand Gradient
                      Center(
                        child: Container(
                          height: 69,
                          width: 100,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              colors: [Color(0xFF008CFF), Color(0xFF18FFFF)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                          ),
                          child: Icon(
                            Icons.restaurant_menu,
                            color: Colors.white,
                            size: 50,
                          ),
                        ),
                      ),

                      SizedBox(height: 20),
                      Text(
                        "FoodRoute",
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        "Your nutrition companion",
                        style: TextStyle(fontSize: 16, color: Colors.white70),
                      ),

                      SizedBox(height: 40),
                      Text(
                        "Start your 4-day nutrition journey",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 18,
                          color: Color(0xFF008CFF), // Brand Cyan
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        "1 day preparation + 3 days full access\nDiscover over 210 healthy recipes",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 14, color: Colors.white),
                      ),

                      SizedBox(height: 30),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20.0),
                        child: Column(
                          children: [
                            _buildCheckItem("Over 210 delicious recipes"),
                            _buildCheckItem("Intelligent meal planning"),
                            _buildCheckItem("Nutrition tracking"),
                            _buildCheckItem("Shopping lists"),
                          ],
                        ),
                      ),

                      SizedBox(height: 40),
                      // Action Button
                      SizedBox(
                        width: double.infinity,
                        height: 55,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF008CFF),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 5,
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => LoginPage(),
                              ),
                            );
                          },
                          child: Text(
                            "Start free trial",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: 15),
                      Text(
                        "No credit card required • Cancel anytime",
                        style: TextStyle(fontSize: 12, color: Colors.white60),
                      ),
                      SizedBox(height: 30),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCheckItem(String text) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 11.4),
      child: Row(
        children: [
          Icon(Icons.check_circle, color: Color(0xFF008CFF), size: 22),
          SizedBox(width: 15),
          Text(
            text,
            style: TextStyle(
              fontSize: 15,
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
