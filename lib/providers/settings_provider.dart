import 'package:flutter/foundation.dart';

/// State for the "Terminal Hardware Tuning" and "Terminal Security"
/// switches on the Staff Profile page.
class SettingsProvider extends ChangeNotifier {
  bool _hapticPulse = true;
  bool _acousticTone = true;
  bool _nightShift = false; // visual selection only, does not re-theme the app
  bool _highContrastHud = false;
  bool _biometricUnlock = true;

  bool get hapticPulse => _hapticPulse;
  bool get acousticTone => _acousticTone;
  bool get nightShift => _nightShift;
  bool get highContrastHud => _highContrastHud;
  bool get biometricUnlock => _biometricUnlock;

  void setHapticPulse(bool v) {
    _hapticPulse = v;
    notifyListeners();
  }

  void setAcousticTone(bool v) {
    _acousticTone = v;
    notifyListeners();
  }

  void setNightShift(bool v) {
    _nightShift = v;
    notifyListeners();
  }

  void setHighContrastHud(bool v) {
    _highContrastHud = v;
    notifyListeners();
  }

  void setBiometricUnlock(bool v) {
    _biometricUnlock = v;
    notifyListeners();
  }
}
