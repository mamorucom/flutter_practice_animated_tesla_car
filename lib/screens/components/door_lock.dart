import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:practice_animated_tesla_car/constanins.dart';

///
/// ドアロックWidget
///
class DoorLock extends StatelessWidget {
  const DoorLock({
    Key? key,
    required this.isLock,
    required this.press,
  }) : super(key: key);

  final isLock;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: press,
      // アニメーション切り替えWidget
      child: AnimatedSwitcher(
        duration: defaultDuration,
        // Curves class - ちょっとジャンプするようなエフェクトを採用
        // https://api.flutter.dev/flutter/animation/Curves-class.html
        switchInCurve: Curves.easeInOutBack,
        // トランジション
        transitionBuilder: (child, animation) => ScaleTransition(
          scale: animation,
          child: child,
        ),

        /// ValueKeyをつけないとFlutterは同じWidgetと判断してしまい、
        /// アニメーションが発動しない
        child: isLock
            ? SvgPicture.asset(
                "assets/icons/door_lock.svg",
                key: ValueKey("lock"),
              )
            : SvgPicture.asset(
                "assets/icons/door_unlock.svg",
                key: ValueKey("unlock"),
              ),
      ),
    );
  }
}
