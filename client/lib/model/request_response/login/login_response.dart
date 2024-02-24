class LoginResponse {
  final String roomCode;
  final String roomPassword;
  final String gameId;
  final String userToken;

  LoginResponse({
    required this.roomCode,
    required this.roomPassword,
    required this.gameId,
    required this.userToken
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        'roomCode': String roomCode,
        'roomPassword': String roomPassword,
        'gameId': String gameId,
        'userToken': String userToken,
      } =>
        LoginResponse(
          roomCode: roomCode,
          roomPassword: roomPassword,
          gameId: gameId,
          userToken: userToken
        ),
      _ => throw const FormatException('Failed to load LoginResponse.'),
    };
  }
}