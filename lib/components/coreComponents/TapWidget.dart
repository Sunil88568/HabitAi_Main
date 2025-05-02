import 'package:flutter/material.dart';

class TapWidget extends StatelessWidget { final Function()? onTap;
final Function()? onLongPress;
final Widget? child;
final bool removeClickEffect;
const TapWidget(
    {super.key, this.onTap, this.onLongPress, this.child, this.removeClickEffect = false});
@override
Widget build(BuildContext context) {
  return Material(
      color: Colors.transparent, child: InkWell(
    splashColor: removeClickEffect ? Colors.transparent : null,
    highlightColor:removeClickEffect ? Colors.transparent : null,
    onTap: onTap, onLongPress: onLongPress, child: child,
  )); }
}
