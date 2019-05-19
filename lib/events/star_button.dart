import 'package:flutter/material.dart';

/// Represents a callback which is called when [StarButton]
/// is toggled.
///
/// [wasStarred] tells whether the [StarButton] was starred
/// before it was toggled.
typedef ToggledCallback = void Function(bool wasStarred);

/// An button which can either be 'starred' or 'unstarred'.
///
/// It notifies of a user-press using [onToggled]. It cross
/// fades between it's starred  and  unstarred forms as per
/// [isStarred].
class StarButton extends StatelessWidget {
  final bool isStarred;
  final ToggledCallback onToggled;
  final Duration duration;

  const StarButton({
    Key key,
    @required this.isStarred,
    @required this.onToggled,
    this.duration = const Duration(milliseconds: 300),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: AnimatedCrossFade(
        duration: duration,
        firstChild: Icon(Icons.star_border, color: Colors.white),
        secondChild: Icon(Icons.star, color: Colors.white),
        crossFadeState:
            isStarred ? CrossFadeState.showSecond : CrossFadeState.showFirst,
      ),
      onPressed: () => onToggled(isStarred),
    );
  }
}
