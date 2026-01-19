import 'dart:math';
import '../models/device_model.dart';
import 'package:flutter/material.dart';

class SimulationService extends ChangeNotifier {
  List<SmartDevice> devices = [];
  List<double> usageHistory = [];
  
  double totalEnergyConsumed = 450.0;
  double currentBill = 0.0;
  final double ratePerUnit = 8.0;

  final Random _random = Random();

  SimulationService() {
    devices = [
      SmartDevice(id: '1', name: 'Living Room AC', iconAsset: 'ac_unit', kwhUsage: 1.2),
      SmartDevice(id: '2', name: 'Smart Fridge', iconAsset: 'kitchen', kwhUsage: 0.4),
      SmartDevice(id: '3', name: 'Gaming PC', iconAsset: 'computer', kwhUsage: 0.6),
      SmartDevice(id: '4', name: 'Water Heater', iconAsset: 'water_drop', kwhUsage: 0.0), 
    ];
    _startSimulation();
  }

  void _startSimulation() {
    Stream.periodic(const Duration(seconds: 1)).listen((_) {
      
      bool spike = _random.nextInt(10) > 7;

      devices = devices.map((device) {
        double change;
        if (spike) {
          change = (_random.nextDouble() * 1.5) * (_random.nextBool() ? 1 : -1); 
        } else {
          change = (_random.nextDouble() * 0.1) - 0.05;
        }

        double newUsage = (device.kwhUsage + change).clamp(0.0, 5.0);
        
        return SmartDevice(
          id: device.id,
          name: device.name,
          iconAsset: device.iconAsset,
          kwhUsage: double.parse(newUsage.toStringAsFixed(2)),
          isSafe: newUsage < 3.5,
        );
      }).toList();

      double currentLoadKw = devices.fold(0, (sum, item) => sum + item.kwhUsage);
      
      double kwhAdded = currentLoadKw / 3600;
      totalEnergyConsumed += kwhAdded;
      currentBill = totalEnergyConsumed * ratePerUnit;

      usageHistory.add(currentLoadKw);
      if (usageHistory.length > 50) usageHistory.removeAt(0);

      notifyListeners();
    });
  }
}