import 'package:flutter/material.dart';
import '../models/organ_model.dart';
import '../services/anatomy_data_service.dart';

enum BodyAngle { front, back, left, right }
enum BodyGender { male, female }

class AnatomyProvider extends ChangeNotifier {
  // Layer visibility states
  bool _skinVisible = false;
  bool _musclesVisible = true;
  bool _bonesVisible = true;
  bool _organsVisible = true;
  bool _bloodVesselsVisible = true;
  bool _nervousSystemVisible = false;

  // Body orientation & configuration
  BodyGender _gender = BodyGender.male;
  BodyAngle _angle = BodyAngle.front;
  double _rotationY = 0.0; // In radians
  double _zoomScale = 1.0;

  // Selection
  OrganModel? _selectedOrgan;
  bool _isInfoCardExpanded = true;

  // Active layer filter preset
  String _activeLayerPreset = 'Organs';

  // Getters
  bool get skinVisible => _skinVisible;
  bool get musclesVisible => _musclesVisible;
  bool get bonesVisible => _bonesVisible;
  bool get organsVisible => _organsVisible;
  bool get bloodVesselsVisible => _bloodVesselsVisible;
  bool get nervousSystemVisible => _nervousSystemVisible;

  BodyGender get gender => _gender;
  BodyAngle get angle => _angle;
  double get rotationY => _rotationY;
  double get zoomScale => _zoomScale;
  OrganModel? get selectedOrgan => _selectedOrgan;
  bool get isInfoCardExpanded => _isInfoCardExpanded;
  String get activeLayerPreset => _activeLayerPreset;

  void toggleSkin([bool? val]) {
    _skinVisible = val ?? !_skinVisible;
    notifyListeners();
  }

  void toggleMuscles([bool? val]) {
    _musclesVisible = val ?? !_musclesVisible;
    notifyListeners();
  }

  void toggleBones([bool? val]) {
    _bonesVisible = val ?? !_bonesVisible;
    notifyListeners();
  }

  void toggleOrgans([bool? val]) {
    _organsVisible = val ?? !_organsVisible;
    notifyListeners();
  }

  void toggleBloodVessels([bool? val]) {
    _bloodVesselsVisible = val ?? !_bloodVesselsVisible;
    notifyListeners();
  }

  void toggleNervousSystem([bool? val]) {
    _nervousSystemVisible = val ?? !_nervousSystemVisible;
    notifyListeners();
  }

  void selectLayerPreset(String preset) {
    _activeLayerPreset = preset;
    switch (preset) {
      case 'Skin':
        _skinVisible = true;
        _musclesVisible = false;
        _bonesVisible = false;
        _organsVisible = false;
        _bloodVesselsVisible = false;
        _nervousSystemVisible = false;
        break;
      case 'Muscles':
        _skinVisible = false;
        _musclesVisible = true;
        _bonesVisible = true;
        _organsVisible = false;
        _bloodVesselsVisible = false;
        _nervousSystemVisible = false;
        break;
      case 'Bones':
        _skinVisible = false;
        _musclesVisible = false;
        _bonesVisible = true;
        _organsVisible = false;
        _bloodVesselsVisible = false;
        _nervousSystemVisible = false;
        break;
      case 'Organs':
        _skinVisible = false;
        _musclesVisible = false;
        _bonesVisible = true;
        _organsVisible = true;
        _bloodVesselsVisible = true;
        _nervousSystemVisible = false;
        break;
      case 'Vessels':
        _skinVisible = false;
        _musclesVisible = false;
        _bonesVisible = true;
        _organsVisible = true;
        _bloodVesselsVisible = true;
        _nervousSystemVisible = false;
        break;
      case 'Nerves':
        _skinVisible = false;
        _musclesVisible = false;
        _bonesVisible = true;
        _organsVisible = false;
        _bloodVesselsVisible = false;
        _nervousSystemVisible = true;
        break;
      case 'All':
      default:
        _skinVisible = false;
        _musclesVisible = true;
        _bonesVisible = true;
        _organsVisible = true;
        _bloodVesselsVisible = true;
        _nervousSystemVisible = true;
        break;
    }
    notifyListeners();
  }

  void setGender(BodyGender newGender) {
    _gender = newGender;
    notifyListeners();
  }

  void setAngle(BodyAngle newAngle) {
    _angle = newAngle;
    switch (newAngle) {
      case BodyAngle.front:
        _rotationY = 0.0;
        break;
      case BodyAngle.back:
        _rotationY = 3.14159; // 180 deg
        break;
      case BodyAngle.left:
        _rotationY = -1.5708; // -90 deg
        break;
      case BodyAngle.right:
        _rotationY = 1.5708; // 90 deg
        break;
    }
    notifyListeners();
  }

  void updateRotation(double delta) {
    _rotationY = (_rotationY + delta) % (2 * 3.14159265);
    notifyListeners();
  }

  void updateZoom(double scaleDelta) {
    _zoomScale = (_zoomScale * scaleDelta).clamp(0.6, 3.0);
    notifyListeners();
  }

  void resetCamera() {
    _rotationY = 0.0;
    _zoomScale = 1.0;
    _angle = BodyAngle.front;
    notifyListeners();
  }

  void selectOrgan(OrganModel? organ) {
    _selectedOrgan = organ;
    _isInfoCardExpanded = true;
    notifyListeners();
  }

  void selectOrganById(String id) {
    _selectedOrgan = AnatomyDataService.getOrganById(id);
    _isInfoCardExpanded = true;
    notifyListeners();
  }

  void clearSelection() {
    _selectedOrgan = null;
    notifyListeners();
  }

  void toggleInfoCard() {
    _isInfoCardExpanded = !_isInfoCardExpanded;
    notifyListeners();
  }
}
