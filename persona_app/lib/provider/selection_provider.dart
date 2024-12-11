import 'package:flutter/material.dart';
import '../../data/models/prediction_model.dart';

class SelectionProvider with ChangeNotifier {
  Accessory? selectedHairstyle;
  Accessory? selectedGlasses;
  Accessory? selectedEarrings;

  void updateSelection(String category, Accessory? accessory) {
    if (category == 'hairstyle') {
      selectedHairstyle = accessory;
    } else if (category == 'glasses') {
      selectedGlasses = accessory;
    } else if (category == 'earrings') {
      selectedEarrings = accessory;
    }
    notifyListeners();
  }

  void resetSelections() {
    selectedHairstyle = null;
    selectedGlasses = null;
    selectedEarrings = null;
    notifyListeners();
  }
}