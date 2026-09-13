class BadgeModel {
  final String id;
  final String title;
  final String description;
  final String icon;
  final bool isUnlocked;
  final String unlockedDate;

  const BadgeModel({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    this.isUnlocked = false,
    this.unlockedDate = '',
  });
}

class UserProfileModel {
  final String name;
  final String title;
  final String email;
  final int chaptersCompleted;
  final int quizPoints;
  final int level;
  final List<BadgeModel> badges;
  final List<String> bookmarkedOrganIds;

  const UserProfileModel({
    required this.name,
    required this.title,
    required this.email,
    required this.chaptersCompleted,
    required this.quizPoints,
    required this.level,
    required this.badges,
    required this.bookmarkedOrganIds,
  });

  UserProfileModel copyWith({
    String? name,
    String? title,
    String? email,
    int? chaptersCompleted,
    int? quizPoints,
    int? level,
    List<BadgeModel>? badges,
    List<String>? bookmarkedOrganIds,
  }) {
    return UserProfileModel(
      name: name ?? this.name,
      title: title ?? this.title,
      email: email ?? this.email,
      chaptersCompleted: chaptersCompleted ?? this.chaptersCompleted,
      quizPoints: quizPoints ?? this.quizPoints,
      level: level ?? this.level,
      badges: badges ?? this.badges,
      bookmarkedOrganIds: bookmarkedOrganIds ?? this.bookmarkedOrganIds,
    );
  }
}
