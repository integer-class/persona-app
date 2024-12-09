class Profile {
    User user;
    String avatar;

    Profile({
        required this.user,
        required this.avatar,
    });

    factory Profile.fromJson(Map<String, dynamic> json) => Profile(
        user: User.fromJson(json["user"]),
        avatar: json["avatar"],
    );

    Map<String, dynamic> toJson() => {
        "user": user.toJson(),
        "avatar": avatar,
    };
}

class User {
    int id;
    String username;
    String email;

    User({
        required this.id,
        required this.username,
        required this.email,
    });

    factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        username: json["username"],
        email: json["email"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "username": username,
        "email": email,
    };
}