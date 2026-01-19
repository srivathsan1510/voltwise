import 'package:google_generative_ai/google_generative_ai.dart';
import '../models/device_model.dart';

class AIService {
  late final GenerativeModel _model;

  AIService() {
    _model = GenerativeModel(
      model: 'gemini-flash-latest',
      apiKey: "AIzaSyDsNjP8BrIx6KB8WJvIzJ_hGSmC3J0gw7U",
    );
  }

Future<String> getEnergyAnalysis(List<SmartDevice> devices) async {
    String deviceData = devices.map((d) => "${d.name}: ${d.kwhUsage} kWh").join(", ");

    final prompt = '''
    Act as an Electrical Load Manager. Here is the current power consumption of a home: 
    $deviceData.
    
    The safety threshold for any device is 2.5 kWh.
    Analyze this data and provide a concise 2-sentence recommendation.
    ''';

    try {
      print("Sending request to Gemini...");
      final response = await _model.generateContent([Content.text(prompt)]);
      print("Success!");
      return response.text ?? "System Normal.";
    } catch (e) {
      print("----------------A I  E R R O R----------------");
      print(e);
      print("----------------------------------------------");
      return "Error: Check VS Code Terminal for details.";
    }
  }
}