class GameUser {
  final String name;
  final String userId;

  GameUser({
    required this.name,
    required this.userId,
  });

  GameUser.fromJson(Map<String, Object?> json)
      : this(
          name: json['name'] as String,
          userId: json['userId'] as String,
        );

  Map<String, Object> toJson() {
    return {
      'name': name,
      'userId': userId,
    };
  }
}
