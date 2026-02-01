import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_foodroute/meals.dart';

class Progress extends StatefulWidget {
  final double calories;
  final double protein;
  final double carbs;
  final double fat;

  const Progress({
    super.key,
    this.calories = 0,
    this.protein = 0,
    this.carbs = 0,
    this.fat = 0,
  });

  @override
  State<Progress> createState() => _ProgressState();
}

class _ProgressState extends State<Progress> {
  String selectedPeriod = "Weekly";

  // BRAND COLORS - Navy Blue Theme
  final Color blue = Color(0xFF008CFF); // Proper Navy Blue
  final Color blue2 = Color.fromARGB(200, 5, 112, 219);
  final Color slateGrey = Color(0xFF4E4D4D);

  // Mock Data
  final Map<String, List<double>> barData = {
    "Weekly": [1800, 1400, 1200, 2100, 1600, 2300, 1500],
    "Monthly": [1900, 2100, 1700, 2400],
  };

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    bool isDaily = selectedPeriod == "Daily";

    // --- DATA CALCULATION ---0xFF008CFF
    List<double> currentMacros = isDaily
        ? [widget.protein, widget.carbs, widget.fat]
        : [40 + widget.protein, 30 + widget.carbs, 30 + widget.fat];

    double displayCalories;
    if (isDaily) {
      displayCalories = widget.calories;
    } else {
      List<double> base = List.from(barData[selectedPeriod]!);
      base[0] = base[0] + widget.calories;
      displayCalories = base.reduce((a, b) => a + b) / base.length;
    }

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new,
            color: isDark ? blue : Colors.black,
          ),
          onPressed: () {
            // Navigator.pop ki jagah direct MealsPage par bhejien
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const Meals(),
              ), // MealsPage aapki class ka naam hona chahiye
            );
          },
        ),
        title: Text(
          "Progress & Statistics",
          style: TextStyle(
            color: isDark ? Colors.white : Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          children: [
            _buildTimeSelector(isDark),
            SizedBox(height: 24),
            _buildBarChartCard(isDaily, displayCalories, isDark),
            SizedBox(height: 16),
            _buildMacroPieCard(currentMacros, displayCalories, isDaily, isDark),
            SizedBox(height: 16),
            _buildAchievementCard(),
          ],
        ),
      ),
    );
  }

  // --- TIME SELECTOR (Navy Blue Theme) ---
  Widget _buildTimeSelector(bool isDark) {
    return Container(
      padding: EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: isDark ? Colors.white10 : Color(0xFFF1F1F1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: ["Daily", "Weekly", "Monthly"].map((label) {
          bool isActive = selectedPeriod == label;
          return Expanded(
            child: GestureDetector(
              onTap: () => setState(() => selectedPeriod = label),
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: isActive ? blue : Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  label,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: isActive
                        ? Colors.white
                        : (isDark ? Colors.white70 : slateGrey),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  // --- BAR CHART CARD ---
  Widget _buildBarChartCard(bool isDaily, double calories, bool isDark) {
    List<double> currentData;
    if (isDaily) {
      currentData = [calories];
    } else {
      currentData = List.from(barData[selectedPeriod]!);
      currentData[0] = currentData[0] + widget.calories;
    }

    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? Color(0xFF1A1F24) : Colors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "$selectedPeriod Calories vs. Goal",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: isDark ? Colors.white : Colors.black,
            ),
          ),
          SizedBox(height: 30),
          SizedBox(
            height: 180,
            child: BarChart(
              BarChartData(
                maxY: 3500,
                barGroups: List.generate(currentData.length, (index) {
                  return _group(
                    index,
                    currentData[index],
                    currentData[index] > 2500,
                  );
                }),
                titlesData: FlTitlesData(
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (val, meta) {
                        TextStyle style = TextStyle(
                          color: isDark ? Colors.white54 : Colors.grey,
                          fontSize: 10,
                        );
                        if (isDaily) return Text("Today", style: style);
                        if (selectedPeriod == "Monthly") {
                          return Text("W${val.toInt() + 1}", style: style);
                        }
                        return Text(
                          ['M', 'T', 'W', 'T', 'F', 'S', 'S'][val.toInt() % 7],
                          style: style,
                        );
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                gridData: FlGridData(show: false),
                borderData: FlBorderData(show: false),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- PIE CHART CARD ---
  // --- PIE CHART CARD (UI Friendly & Synced) ---
  Widget _buildMacroPieCard(
    List<double> currentMacros,
    double totalCalories,
    bool isDaily,
    bool isDark,
  ) {
    // Premium UI Colors
    Color proteinColor = Color(0xFF18FFFF);
    Color carbsColor = Color(0xFFFFB74D);
    Color fatColor = Color(0xFF81C784);

    // Check if there's any data to show
    bool hasData =
        totalCalories > 0 ||
        (currentMacros[0] + currentMacros[1] + currentMacros[2]) > 0;

    return Container(
      padding: EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: isDark ? Color(0xFF1A1F24) : Colors.white,
        borderRadius: BorderRadius.circular(28),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Macro Distribution",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: isDark ? Colors.white : Color(0xFF080C10),
            ),
          ),
          SizedBox(height: 25),
          if (!hasData)
            // --- NO DATA FOUND UI ---
            Center(
              child: Column(
                children: [
                  SizedBox(height: 20),
                  Icon(
                    Icons.pie_chart_outline_rounded,
                    size: 60,
                    // ignore: deprecated_member_use
                    color: Colors.grey.withOpacity(0.3),
                  ),
                  SizedBox(height: 12),
                  Text(
                    "No Data Found",
                    style: TextStyle(
                      color: isDark ? Colors.white54 : Colors.grey,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    "Log some meals to see your progress",
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                  SizedBox(height: 20),
                ],
              ),
            )
          else
            // --- ACTUAL CHART UI ---
            Row(
              children: [
                SizedBox(
                  width: 130,
                  height: 130,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      PieChart(
                        PieChartData(
                          sectionsSpace: 4,
                          centerSpaceRadius: 45,
                          sections: [
                            PieChartSectionData(
                              color: proteinColor,
                              value: currentMacros[0],
                              radius: 12,
                              showTitle: false,
                            ),
                            PieChartSectionData(
                              color: carbsColor,
                              value: currentMacros[1],
                              radius: 12,
                              showTitle: false,
                            ),
                            PieChartSectionData(
                              color: fatColor,
                              value: currentMacros[2],
                              radius: 12,
                              showTitle: false,
                            ),
                          ],
                        ),
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "${totalCalories.toInt()}",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w900,
                              color: isDark ? Colors.white : Colors.black,
                            ),
                          ),
                          Text(
                            "kcal",
                            style: TextStyle(fontSize: 10, color: Colors.grey),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 25),
                Expanded(
                  child: Column(
                    children: [
                      _macroDetail(
                        "Protein",
                        "${currentMacros[0].toInt()}g",
                        currentMacros[0] / 150,
                        proteinColor,
                        isDark,
                      ),
                      _macroDetail(
                        "Carbs",
                        "${currentMacros[1].toInt()}g",
                        currentMacros[1] / 250,
                        carbsColor,
                        isDark,
                      ),
                      _macroDetail(
                        "Fat",
                        "${currentMacros[2].toInt()}g",
                        currentMacros[2] / 100,
                        fatColor,
                        isDark,
                      ),
                    ],
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }

  BarChartGroupData _group(int x, double y, bool isOver) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y,
          color: x == 0 ? blue2 : (isOver ? Colors.redAccent : blue),
          width: 18,
          borderRadius: BorderRadius.circular(4),
        ),
      ],
    );
  }

  Widget _macroDetail(
    String label,
    String val,
    double prog,
    Color col,
    bool isDark,
  ) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label, style: TextStyle(fontSize: 12, color: Colors.grey)),
              Text(
                val,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Colors.black,
                ),
              ),
            ],
          ),
          SizedBox(height: 5),
          LinearProgressIndicator(
            value: prog.clamp(0.0, 1.0),
            backgroundColor: isDark ? Colors.white10 : Colors.grey.shade200,
            color: col,
            minHeight: 5,
          ),
        ],
      ),
    );
  }

  Widget _buildAchievementCard() {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: blue2,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: [
          _achievementTile(
            Icons.stars,
            "Calorie Goal Progress",
            "Syncing daily data...",
            Colors.orangeAccent,
          ),
          Divider(color: Colors.white24),
          _achievementTile(
            Icons.fitness_center,
            "Protein Target",
            "You're hitting your goals!",
            Colors.greenAccent,
          ),
        ],
      ),
    );
  }

  Widget _achievementTile(IconData icon, String title, String sub, Color col) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Colors.white10,
        child: Icon(icon, color: col),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      subtitle: Text(
        sub,
        style: TextStyle(fontSize: 12, color: Colors.white70),
      ),
    );
  }
}
