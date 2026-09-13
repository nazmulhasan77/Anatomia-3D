import 'package:flutter/material.dart';
import '../models/user_profile_model.dart';
import '../services/anatomy_data_service.dart';

class UserProvider extends ChangeNotifier {
  UserProfileModel _profile = AnatomyDataService.defaultProfile;

  UserProfileModel get profile => _profile;

  bool isOrganBookmarked(String organId) {
    return _profile.bookmarkedOrganIds.contains(organId.toLowerCase());
  }

  void toggleBookmark(String organId) {
    final lower = organId.toLowerCase();
    final updatedList = List<String>.from(_profile.bookmarkedOrganIds);
    if (updatedList.contains(lower)) {
      updatedList.remove(lower);
    } else {
      updatedList.add(lower);
    }
    _profile = _profile.copyWith(bookmarkedOrganIds: updatedList);
    notifyListeners();
  }

  void addPoints(int points) {
    final newPoints = _profile.quizPoints + points;
    final newLevel = (newPoints / 80).floor() + 1; // 80 XP per level
    _profile = _profile.copyWith(
      quizPoints: newPoints,
      level: newLevel,
    );
    notifyListeners();
  }

  void incrementCompletedChapters() {
    _profile = _profile.copyWith(
      chaptersCompleted: _profile.chaptersCompleted + 1,
    );
    notifyListeners();
  }
}
