class LeaderboardUser {
  final String id;
  final String name;
  final int points;
  final String? image;

  LeaderboardUser({
    required this.id,
    required this.name,
    required this.points,
    this.image,
  });

  factory LeaderboardUser.fromJson(Map<String, dynamic> json) {
    return LeaderboardUser(
      id: json['id'] ?? '',
      name: json['name'] ?? 'Anonymous',
      points: json['points'] ?? 0,
      image: json['image'],
    );
  }
}