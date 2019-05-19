import 'package:meta/meta.dart';

/// Represents a person who the user can contact to enquire
/// things related to the fest.
///
/// Each contact has a [role] that tells what role he/she's
/// playing in the fest.
class Contact {
  final String name;
  final String role;
  final String mobile;
  final String picUrl;

  const Contact({
    @required this.name,
    @required this.role,
    @required this.mobile,
    @required this.picUrl,
  });
}

/// Represents a developer of this app.
///
/// Each developer has a [role] that tells  what did he/she
/// do as a part of developing the app.
class Developer {
  final String name;
  final String role;
  final String gitHubUsername;
  final String picAsset;

  const Developer({
    @required this.name,
    @required this.role,
    @required this.picAsset,
    @required this.gitHubUsername,
  });
}
