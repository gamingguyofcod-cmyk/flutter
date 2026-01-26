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

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.white,
      systemNavigationBarIconBrightness: Brightness.dark,
      systemNavigationBarDividerColor: Colors.transparent,
    ),
  );

  SystemChrome.setEnabledSystemUIMode(
    SystemUiMode.manual,
    overlays: [SystemUiOverlay.top, SystemUiOverlay.bottom],
  ).then((_) {
    runApp(const FoodRouteApp());
  });
}

class FoodRouteApp extends StatelessWidget {
  const FoodRouteApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const WelcomePage(),
    );
  }
}

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: Colors.black,
        systemNavigationBarIconBrightness: Brightness.light, // Buttons white
        systemNavigationBarDividerColor: Colors.transparent,
      ),
      child: Scaffold(
        extendBody: false,
        extendBodyBehindAppBar: false,

        body: Stack(
          children: [
            // Background Image
            Positioned.fill(
              child: RotatedBox(
                quarterTurns: 3,
                child: Container(
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('asset/welcome_bg.jpg'),
                      fit: BoxFit.cover,
                      colorFilter: ColorFilter.mode(
                        Color.fromARGB(100, 0, 0, 0),
                        BlendMode.darken,
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // Content
            SafeArea(
              bottom: true,
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30.0),
                  child: Column(
                    children: [
                      const SizedBox(height: 40),
                      // Logo Icon
                      Center(
                        child: Container(
                          height: 100,
                          width: 100,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              colors: [Color(0xFF4A90E2), Color(0xFF50E3C2)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                          ),
                          child: const Icon(
                            Icons.restaurant_menu,
                            color: Colors.white,
                            size: 50,
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),
                      const Text(
                        "FoodRoute",
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const Text(
                        "Your nutrition companion",
                        style: TextStyle(
                          fontSize: 16,
                          color: Color.fromARGB(255, 255, 255, 255),
                        ),
                      ),

                      const SizedBox(height: 40),
                      const Text(
                        "Start your 4-day nutrition journey",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 18,
                          color: Color(0xFF008CFF),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        "1 day preparation + 3 days full access\nDiscover over 210 healthy recipes that fit your goals",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 14, color: Colors.white),
                      ),

                      const SizedBox(height: 30),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Column(
                          children: [
                            _buildCheckItem("Over 210 delicious recipes"),
                            _buildCheckItem("Intelligent meal planning"),
                            _buildCheckItem("Nutrition tracking"),
                            _buildCheckItem("Shopping lists"),
                          ],
                        ),
                      ),

                      const SizedBox(height: 40),
                      Container(
                        width: double.infinity,
                        height: 55,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF008CFF).withOpacity(0.3),
                              blurRadius: 10,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF008CFF),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const LoginPage(),
                              ),
                            );
                          },
                          child: const Text(
                            "Start free trial",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 15),
                      const Text(
                        "No credit card required • Cancel anytime",
                        style: TextStyle(
                          fontSize: 12,
                          color: Color.fromARGB(255, 255, 255, 255),
                        ),
                      ),
                      const SizedBox(height: 30),
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
      padding: const EdgeInsets.symmetric(vertical: 11.4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const Icon(Icons.check_circle, color: Color(0xFF008CFF), size: 22),
          const SizedBox(width: 15),
          Text(
            text,
            style: const TextStyle(
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
