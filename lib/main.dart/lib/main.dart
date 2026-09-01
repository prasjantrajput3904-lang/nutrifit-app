import 'package:flutter/material.dart';

void main() {
  runApp(const NutriFitApp());
}

class NutriFitApp extends StatelessWidget {
  const NutriFitApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NutriFit Tracker',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      home: const MainDashboardScreen(),
    );
  }
}

class FoodItem {
  final String id;
  final String name;
  final String unitType;
  final double calPerUnit;
  final double proteinPerUnit;
  final double carbsPerUnit;
  final double fatPerUnit;
  double quantity;

  FoodItem({
    required this.id,
    required this.name,
    required this.unitType,
    required this.calPerUnit,
    required this.proteinPerUnit,
    required this.carbsPerUnit,
    required this.fatPerUnit,
    this.quantity = 0,
  });

  double get totalCalories => quantity * calPerUnit;
  double get totalProtein => quantity * proteinPerUnit;
  double get totalCarbs => quantity * carbsPerUnit;
  double get totalFat => quantity * fatPerUnit;
}

class MainDashboardScreen extends StatefulWidget {
  const MainDashboardScreen({super.key});

  @override
  State<MainDashboardScreen> createState() => _MainDashboardScreenState();
}

class _MainDashboardScreenState extends State<MainDashboardScreen> {
  int _currentIndex = 0;

  final List<FoodItem> _foods = [
    FoodItem(
      id: 'chapati',
      name: 'Chapati (Roti)',
      unitType: 'piece',
      calPerUnit: 104,
      proteinPerUnit: 3.1,
      carbsPerUnit: 20.0,
      fatPerUnit: 0.5,
    ),
    FoodItem(
      id: 'rice',
      name: 'Cooked White Rice',
      unitType: 'gm',
      calPerUnit: 1.30,
      proteinPerUnit: 0.027,
      carbsPerUnit: 0.28,
      fatPerUnit: 0.003,
    ),
    FoodItem(
      id: 'dal',
      name: 'Dal Tadka / Moong Dal',
      unitType: 'gm',
      calPerUnit: 1.10,
      proteinPerUnit: 0.065,
      carbsPerUnit: 0.15,
      fatPerUnit: 0.03,
    ),
    FoodItem(
      id: 'paneer',
      name: 'Paneer (Raw/Cooked)',
      unitType: 'gm',
      calPerUnit: 2.65,
      proteinPerUnit: 0.18,
      carbsPerUnit: 0.02,
      fatPerUnit: 0.21,
    ),
    FoodItem(
      id: 'soya',
      name: 'Soya Chunks (Boiled)',
      unitType: 'gm',
      calPerUnit: 1.70,
      proteinPerUnit: 0.25,
      carbsPerUnit: 0.10,
      fatPerUnit: 0.01,
    ),
    FoodItem(
      id: 'boiled_egg',
      name: 'Boiled Egg (Whole)',
      unitType: 'piece',
      calPerUnit: 78,
      proteinPerUnit: 6.3,
      carbsPerUnit: 0.6,
      fatPerUnit: 5.3,
    ),
  ];

  double get totalCalories =>
      _foods.fold(0, (sum, item) => sum + item.totalCalories);
  double get totalProtein =>
      _foods.fold(0, (sum, item) => sum + item.totalProtein);
  double get totalCarbs =>
      _foods.fold(0, (sum, item) => sum + item.totalCarbs);
  double get totalFat =>
      _foods.fold(0, (sum, item) => sum + item.totalFat);

  final double targetCalories = 2200;
  final double targetProtein = 120;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'NutriFit Tracker',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.teal.shade700,
        foregroundColor: Colors.white,
      ),
      body: _currentIndex == 0 ? _buildMealTrackerTab() : _buildWeeklyStatsTab(),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (idx) => setState(() => _currentIndex = idx),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.restaurant_menu),
            label: 'Daily Log',
          ),
          NavigationDestination(
            icon: Icon(Icons.analytics_outlined),
            label: 'Weekly Trends',
          ),
        ],
      ),
    );
    Widget _buildMealTrackerTab() {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        _buildNutritionalSummaryCard(),
        const SizedBox(height: 12),
        _buildSmartHealthTip(),
        const SizedBox(height: 16),
        const Text(
          'Today\'s Meals & Items',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        ..._foods.map((food) => _buildFoodItemCard(food)),
      ],
    );
  }

  Widget _buildNutritionalSummaryCard() {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Calories Consumed',
                        style: TextStyle(color: Colors.grey, fontSize: 13)),
                    Text(
                      '${totalCalories.toStringAsFixed(0)} / ${targetCalories.toStringAsFixed(0)} kcal',
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                CircularProgressIndicator(
                  value: (totalCalories / targetCalories).clamp(0.0, 1.0),
                  backgroundColor: Colors.grey.shade200,
                  color: Colors.teal,
                  strokeWidth: 6,
                ),
              ],
            ),
            const Divider(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildMacroCol('Protein', '${totalProtein.toStringAsFixed(1)}g',
                    Colors.orange),
                _buildMacroCol(
                    'Carbs', '${totalCarbs.toStringAsFixed(1)}g', Colors.blue),
                _buildMacroCol(
                    'Fats', '${totalFat.toStringAsFixed(1)}g', Colors.purple),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMacroCol(String label, String val, Color color) {
    return Column(
      children: [
        Text(label,
            style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
        const SizedBox(height: 4),
        Text(
          val,
          style: TextStyle(
              fontSize: 16, fontWeight: FontWeight.bold, color: color),
        ),
      ],
    );
  }

  Widget _buildSmartHealthTip() {
    String tipMessage;
    Color alertColor = Colors.teal.shade50;
    Color iconColor = Colors.teal;

    if (totalProtein < (targetProtein * 0.5)) {
      tipMessage =
          '💡 Tip: Protein is low today! Add 50g boiled soya chunks (25g protein) or 100g paneer to hit your recovery goals.';
      alertColor = Colors.amber.shade50;
      iconColor = Colors.amber.shade800;
    } else if (totalCalories > targetCalories) {
      tipMessage =
          '⚠️ Calorie limit reached. Opt for green salads or clear soups for remaining meals.';
      alertColor = Colors.red.shade50;
      iconColor = Colors.red.shade700;
    } else {
      tipMessage =
          '✅ Good job! Your macronutrient balance is on track today.';
    }

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: alertColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: iconColor.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Icon(Icons.tips_and_updates, color: iconColor),
  }
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              tipMessage,
              style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey.shade800),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFoodItemCard(FoodItem food) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: Row(
          children: [
            Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(food.name,
                      style: const TextStyle(
                          fontSize: 15, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 4),
                  Text(
                    '${food.totalCalories.toStringAsFixed(0)} kcal | ${food.totalProtein.toStringAsFixed(1)}g P',
                    style: TextStyle(
                        fontSize: 12, color: Colors.teal.shade700),
                  ),
                ],
              ),
            ),
            if (food.unitType == 'piece')
              Row(
                children: [
                  IconButton.filledTonal(
                    visualDensity: VisualDensity.compact,
                    icon: const Icon(Icons.remove, size: 18),
                    onPressed: () {
                      if (food.quantity > 0) {
                        setState(() => food.quantity -= 1);
                      }
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(
                      '${food.quantity.toInt()} pcs',
                      style: const TextStyle(
                          fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                  ),
                  IconButton.filled(
                    visualDensity: VisualDensity.compact,
                    icon: const Icon(Icons.add, size: 18),
                    onPressed: () {
                      setState(() => food.quantity += 1);
                    },
                  ),
                ],
              )
            else
              Row(
                children: [
                  IconButton.filledTonal(
                    visualDensity: VisualDensity.compact,
                    icon: const Icon(Icons.remove, size: 18),
                    onPressed: () {
                      if (food.quantity >= 50) {
                        setState(() => food.quantity -= 50);
                      }
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(
                      '${food.quantity.toInt()}g',
                      style: const TextStyle(
                          fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                  ),
                  IconButton.filled(
                    visualDensity: VisualDensity.compact,
                    icon: const Icon(Icons.add, size: 18),
                    onPressed: () {
                      setState(() => food.quantity += 50);
                    },
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildWeeklyStatsTab() {
    final List<Map<String, dynamic>> weeklyData = [
      {'day': 'Mon', 'kcal': 2100, 'weight': 68.4},
      {'day': 'Tue', 'kcal': 2250, 'weight': 68.3},
      {'day': 'Wed', 'kcal': 2050, 'weight': 68.1},
      {'day': 'Thu', 'kcal': 2300, 'weight': 68.2},
      {'day': 'Fri', 'kcal': 2150, 'weight': 68.0},
      {'day': 'Sat', 'kcal': 2400, 'weight': 67.9},
      {'day': 'Sun', 'kcal': 2180, 'weight': 67.8},
    ];
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        const Text(
          'Weekly Weight & Calorie Overview',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Net Trend: -0.6 kg this week (Healthy Deficit)',
                    style: TextStyle(
                        color: Colors.green, fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                ...weeklyData.map(
                  (d) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(d['day'],
                            style:
                                const TextStyle(fontWeight: FontWeight.w600)),
                        Text('${d['kcal']} kcal',
                            style: const TextStyle(color: Colors.grey)),
                        Text('${d['weight']} kg',
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.teal)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        Card(
          color: Colors.teal.shade50,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: const ListTile(
            leading: Icon(Icons.sync, color: Colors.teal),
            title: Text('Google Health Connect Sync',
                style: TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text(
                'Auto-sync ready for NutritionRecord and WeightRecord.'),
          ),
        ),
      ],
    );
  }
}
