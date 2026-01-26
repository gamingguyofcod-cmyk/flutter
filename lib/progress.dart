import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

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

  // AAPKE BRAND COLORS
  final Color darkNavy = const Color(0xFF008CFF);
  final Color cyanAccent = const Color.fromARGB(255, 255, 255, 255);
  final Color slateGrey = const Color.fromARGB(255, 78, 77, 77);

  // Mock Data
  final Map<String, List<double>> barData = {
    "Weekly": [1800, 1400, 1200, 2100, 1600, 2300, 1500],
    "Monthly": [1900, 2100, 1700, 2400],
  };

  @override
  Widget build(BuildContext context) {
    bool isDaily = selectedPeriod == "Daily";

    // --- DATA CALCULATION (Plus Logic) ---
    // Jab Weekly/Monthly ho to base data mein current values plus kar rahe hain
    List<double> currentMacros = isDaily
        ? [widget.protein, widget.carbs, widget.fat]
        : [40 + widget.protein, 30 + widget.carbs, 30 + widget.fat];

    double displayCalories;
    if (isDaily) {
      displayCalories = widget.calories;
    } else {
      List<double> base = List.from(barData[selectedPeriod]!);
      base[0] =
          base[0] + widget.calories; // First index pe aaj ka data add kiya
      displayCalories = base.reduce((a, b) => a + b) / base.length;
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Color.fromARGB(
          255,
          255,
          255,
          255,
        ), // Cyan ki jagah Navy Blue for premium feel
        elevation: 0,
        title: Text(
          "Progress & Statistics",
          style: TextStyle(
            color: Color.fromARGB(255, 1, 1, 1),
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          children: [
            _buildTimeSelector(),
            const SizedBox(height: 24),
            _buildBarChartCard(isDaily, displayCalories),
            const SizedBox(height: 16),
            _buildMacroPieCard(currentMacros, displayCalories, isDaily),
            const SizedBox(height: 16),
            _buildAchievementCard(),
          ],
        ),
      ),
    );
  }

  // --- TIME SELECTOR (Original UI) ---
  Widget _buildTimeSelector() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F1F1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: ["Daily", "Weekly", "Monthly"].map((label) {
          bool isActive = selectedPeriod == label;
          return Expanded(
            child: GestureDetector(
              onTap: () => setState(() => selectedPeriod = label),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: isActive ? darkNavy : Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  label,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: isActive ? cyanAccent : slateGrey,
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

  // --- BAR CHART CARD (Original UI) ---
  Widget _buildBarChartCard(bool isDaily, double calories) {
    List<double> currentData;
    if (isDaily) {
      currentData = [calories];
    } else {
      currentData = List.from(barData[selectedPeriod]!);
      currentData[0] = currentData[0] + widget.calories;
    }

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "$selectedPeriod Calories vs. Goal",
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 30),
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
                        if (isDaily) return const Text("Today");
                        if (selectedPeriod == "Monthly") {
                          return Text("W${val.toInt() + 1}");
                        }
                        return Text(
                          ['M', 'T', 'W', 'T', 'F', 'S', 'S'][val.toInt() % 7],
                        );
                      },
                    ),
                  ),
                  leftTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                gridData: const FlGridData(show: false),
                borderData: FlBorderData(show: false),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- PIE CHART CARD (Original UI) ---
  Widget _buildMacroPieCard(
    List<double> currentMacros,
    double totalCalories,
    bool isDaily,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "$selectedPeriod Macro Split",
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              SizedBox(
                width: 120,
                height: 120,
                child: PieChart(
                  PieChartData(
                    sectionsSpace: 2,
                    centerSpaceRadius: 0,
                    sections: [
                      PieChartSectionData(
                        color: darkNavy,
                        value: currentMacros[0],
                        radius: 70,
                        title: '',
                      ),
                      PieChartSectionData(
                        color: Color.fromRGBO(1, 1, 1, 1),
                        value: currentMacros[2],
                        radius: 70,
                        title: '',
                      ),
                      PieChartSectionData(
                        color: slateGrey,
                        value: currentMacros[1],
                        radius: 70,
                        title: '',
                      ),
                      PieChartSectionData(
                        color: const Color(0xFFFFB74D),
                        value: totalCalories,
                        radius: 70,
                        title: '',
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  children: [
                    _macroDetail(
                      "Calories",
                      "${totalCalories.toInt()} kcal",
                      totalCalories / 3000,
                      const Color(0xFFFFB74D),
                    ),
                    _macroDetail(
                      "Protein",
                      "${currentMacros[0].toInt()}g",
                      currentMacros[0] / 150,
                      darkNavy,
                    ),
                    _macroDetail(
                      "Carbs",
                      "${currentMacros[1].toInt()}g",
                      currentMacros[1] / 250,
                      Colors.grey,
                    ),
                    _macroDetail(
                      "Fat",
                      "${currentMacros[2].toInt()}g",
                      currentMacros[2] / 100,
                      Colors.black,
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
          color: x == 0 ? darkNavy : (isOver ? slateGrey : darkNavy),
          width: 18,
          borderRadius: BorderRadius.circular(4),
        ),
      ],
    );
  }

  Widget _macroDetail(String label, String val, double prog, Color col) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
              Text(
                val,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 5),
          LinearProgressIndicator(
            value: prog.clamp(0.0, 1.0),
            backgroundColor: Colors.grey.shade200,
            color: col,
            minHeight: 5,
          ),
        ],
      ),
    );
  }

  Widget _buildAchievementCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: darkNavy, // Premium feel ke liye achievement card dark kar diya
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: [
          _achievementTile(
            Icons.stars,
            "Calorie Goal Progress",
            "Syncing daily data...",
            cyanAccent,
          ),
          const Divider(color: Colors.white24),
          _achievementTile(
            Icons.fitness_center,
            "Protein Target",
            "You're hitting your goals!",
            Colors.white,
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
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      subtitle: Text(
        sub,
        style: const TextStyle(fontSize: 12, color: Colors.white70),
      ),
    );
  }
}
