import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:practice_animated_tesla_car/constanins.dart';
import 'package:practice_animated_tesla_car/home_controller.dart';
// import 'package:practice_animated_tesla_car/models/TyrePsi.dart';

// import 'components/battery_status.dart';
// import 'components/door_lock.dart';
// import 'components/temp_details.dart';
// import 'components/tesla_bottom_navigationbar.dart';
// import 'components/tmp_btn.dart';
// import 'components/tyre_psi_card.dart';
// import 'components/tyres.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  final HomeController _controller = HomeController();

  late AnimationController _batteryAnimationController;
  late Animation<double> _animationBattery;
  late Animation<double> _animationBatteryStatus;

  late AnimationController _tempAnimationController;
  late Animation<double> _animationCarShift;
  late Animation<double> _animationTempShowInfo;
  late Animation<double> _animationCoolGlow;

  late AnimationController _tyreAnimationController;
  // We want to animate each tyre one by one
  late Animation<double> _animationTyre1Psi;
  late Animation<double> _animationTyre2Psi;
  late Animation<double> _animationTyre3Psi;
  late Animation<double> _animationTyre4Psi;

  late List<Animation<double>> _tyreAnimations;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        return Scaffold(
          body: SafeArea(
            child: LayoutBuilder(builder: (context, constraints) {
              return Stack(
                alignment: Alignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: constraints.maxHeight * 0.1),
                    child: SvgPicture.asset(
                      "assets/icons/Car.svg",
                      width: double.infinity,
                    ),
                  ),
                  Positioned(
                    right: constraints.maxWidth * 0.05,
                    child: DoorLock(
                      isLock: _controller.isRightDoorLock,
                      press: _controller.updateRightDoorLock,
                    ),
                  ),
                ],
              );
            }),
          ),
        );
      },
    );
  }
}

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
