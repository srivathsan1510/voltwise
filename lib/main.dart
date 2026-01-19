import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'services/simulation_service.dart';
import 'models/device_model.dart';
import 'services/ai_service.dart';
import 'widgets/power_chart.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => SimulationService())],
      child: const VoltWiseApp(),
    ),
  );
}

class VoltWiseApp extends StatelessWidget {
  const VoltWiseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF0F172A),
        textTheme: GoogleFonts.outfitTextTheme(
          Theme.of(context).textTheme,
        ).apply(bodyColor: Colors.white),
      ),
      home: const DashboardScreen(),
    );
  }
}

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final AIService _aiService = AIService();
  bool _isAnalyzing = false;

  void _runAIAnalysis(List<SmartDevice> devices) async {
    setState(() => _isAnalyzing = true);
    String result = await _aiService.getEnergyAnalysis(devices);
    if (!mounted) return;
    setState(() => _isAnalyzing = false);

    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1E293B),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Row(
              children: [
                Icon(Icons.psychology, color: Color(0xFF38BDF8), size: 28),
                SizedBox(width: 12),
                Text(
                  "Gemini Insight",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              result,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.white70,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF38BDF8),
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  "Apply Recommendation",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final simulation = Provider.of<SimulationService>(context);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "VoltWise",
                        style: GoogleFonts.audiowide(
                          fontSize: 28,
                          color: const Color(0xFF38BDF8),
                        ),
                      ),
                      const Text(
                        "Home Grid Monitor",
                        style: TextStyle(color: Colors.white54, fontSize: 12),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          const Color(0xFF38BDF8).withOpacity(0.2),
                          Colors.transparent,
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: const Color(0xFF38BDF8).withOpacity(0.3),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const Text(
                          "Current Bill",
                          style: TextStyle(fontSize: 10, color: Colors.white54),
                        ),
                        Text(
                          "₹${simulation.currentBill.toStringAsFixed(2)}",
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF38BDF8),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              SizedBox(
                height: 180,
                child: PowerChart(history: simulation.usageHistory),
              ),

              const SizedBox(height: 24),
              const Text(
                "Connected Load",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white70,
                ),
              ),
              const SizedBox(height: 12),

              Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 4.2,
                  ),
                  itemCount: simulation.devices.length,
                  itemBuilder: (context, index) {
                    return DeviceCard(device: simulation.devices[index]);
                  },
                ),
              ),
            ],
          ),
        ),
      ),

      floatingActionButton: FloatingActionButton.extended(
        onPressed: _isAnalyzing
            ? null
            : () => _runAIAnalysis(simulation.devices),
        backgroundColor: const Color(0xFF38BDF8),
        elevation: 10,
        icon: _isAnalyzing
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  color: Colors.black,
                  strokeWidth: 2,
                ),
              )
            : const Icon(Icons.bolt, color: Colors.black),
        label: Text(
          _isAnalyzing ? "Scanning..." : "Optimize AI",
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

class DeviceCard extends StatelessWidget {
  final SmartDevice device;
  const DeviceCard({super.key, required this.device});

  @override
  Widget build(BuildContext context) {
    IconData getIcon(String name) {
      switch (name) {
        case 'ac_unit':
          return Icons.ac_unit;
        case 'kitchen':
          return Icons.kitchen;
        case 'computer':
          return Icons.computer;
        case 'water_drop':
          return Icons.water_drop;
        default:
          return Icons.device_unknown;
      }
    }

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [const Color(0xFF1E293B), const Color(0xFF0F172A)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: device.isSafe
              ? Colors.white10
              : Colors.redAccent.withOpacity(0.8),
          width: 1,
        ),
        boxShadow: [
          if (!device.isSafe)
            BoxShadow(
              color: Colors.redAccent.withOpacity(0.2),
              blurRadius: 12,
              spreadRadius: 2,
            ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.black26,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                getIcon(device.iconAsset),
                color: device.isSafe ? Colors.white70 : Colors.redAccent,
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    device.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 13, color: Colors.white60),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "${device.kwhUsage} kW",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: device.isSafe
                          ? Colors.white
                          : const Color(0xFFFF5252),
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
}
