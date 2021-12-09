import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:practice_animated_tesla_car/constanins.dart';
import 'package:practice_animated_tesla_car/home_controller.dart';
import 'package:practice_animated_tesla_car/screens/components/battery_status.dart';
import 'package:practice_animated_tesla_car/screens/components/door_lock.dart';
import 'package:practice_animated_tesla_car/screens/components/tesla_bottom_navigationbar.dart';
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

  void setupBatteryAnimation() {
    _batteryAnimationController = AnimationController(
      vsync: this,
      // トータルアニメーション時間
      duration: Duration(
        milliseconds: 600,
      ),
    );

    // this animation start at 0 and end on half
    // means after 300 milliseconds
    _animationBattery = CurvedAnimation(
      parent: _batteryAnimationController,
      // 300msかけて終了
      curve: Interval(0, 0.5),
    );

    _animationBatteryStatus = CurvedAnimation(
      parent: _batteryAnimationController,
      // _animationBatteryのアニメーション終了から60ms後に開始
      // so 360～600ms
      curve: Interval(0.6, 1),
    );
  }

  @override
  void initState() {
    setupBatteryAnimation();
    super.initState();
  }

  @override
  void dispose() {
    _batteryAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([_controller, _batteryAnimationController]),
      builder: (context, _) {
        print(_animationBattery.value);
        // print(_animationBatteryStatus.value);
        return Scaffold(
          bottomNavigationBar: TeslaBottomNavigationBar(
            onTap: (index) {
              if (index == 1)
                _batteryAnimationController.forward();
              else if (_controller.selectedBottomTab == 1 && index != 1)
                _batteryAnimationController.reverse(from: 0.7);

              // if (index == 2)
              //   _tempAnimationController.forward();
              // else if (_controller.selectedBottomTab == 2 && index != 2)
              //   _tempAnimationController.reverse(from: 0.4);

              // if (index == 3)
              //   _tyreAnimationController.forward();
              // else if (_controller.selectedBottomTab == 3 && index != 3)
              //   _tyreAnimationController.reverse();

              // _controller.showTyreController(index);
              // _controller.tyreStatusController(index);
              // // Make sure you call it before [onBottomNavigationTabChange]
              // // タブの切り替え
              _controller.onBottomNavigationTabChange(index);
            },
            selectedTab: _controller.selectedBottomTab,
          ),
          body: SafeArea(
            child: LayoutBuilder(builder: (context, constraints) {
              return Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    height: constraints.maxHeight,
                    width: constraints.maxWidth,
                  ),

                  Positioned(
                    left: constraints.maxWidth / 2,
                    height: constraints.maxHeight,
                    width: constraints.maxWidth,
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: constraints.maxHeight * 0.1),
                      child: SvgPicture.asset(
                        "assets/icons/Car.svg",
                        width: double.infinity,
                      ),
                    ),
                  ),
                  // Door Lock
                  AnimatedPositioned(
                    duration: defaultDuration,
                    right: _controller.selectedBottomTab == 0
                        ? constraints.maxWidth * 0.05
                        : constraints.maxWidth / 2,
                    child: AnimatedOpacity(
                      duration: defaultDuration,
                      opacity: _controller.selectedBottomTab == 0 ? 1 : 0,
                      child: DoorLock(
                        isLock: _controller.isRightDoorLock,
                        press: _controller.updateRightDoorLock,
                      ),
                    ),
                  ),
                  AnimatedPositioned(
                    duration: defaultDuration,
                    left: _controller.selectedBottomTab == 0
                        ? constraints.maxWidth * 0.05
                        : constraints.maxWidth / 2,
                    child: AnimatedOpacity(
                      duration: defaultDuration,
                      opacity: _controller.selectedBottomTab == 0 ? 1 : 0,
                      child: DoorLock(
                        isLock: _controller.isLeftDoorLock,
                        press: _controller.updateLeftDoorLock,
                      ),
                    ),
                  ),
                  AnimatedPositioned(
                    duration: defaultDuration,
                    top: _controller.selectedBottomTab == 0
                        ? constraints.maxWidth * 0.13
                        : constraints.maxWidth / 2,
                    child: AnimatedOpacity(
                      duration: defaultDuration,
                      opacity: _controller.selectedBottomTab == 0 ? 1 : 0,
                      child: DoorLock(
                        isLock: _controller.isBonnetLock,
                        press: _controller.updateBonnetDoorLock,
                      ),
                    ),
                  ),
                  AnimatedPositioned(
                    duration: defaultDuration,
                    bottom: _controller.selectedBottomTab == 0
                        ? constraints.maxWidth * 0.17
                        : constraints.maxWidth / 2,
                    child: AnimatedOpacity(
                      duration: defaultDuration,
                      opacity: _controller.selectedBottomTab == 0 ? 1 : 0,
                      child: DoorLock(
                        isLock: _controller.isTrunkLock,
                        press: _controller.updateTrunkDoorLock,
                      ),
                    ),
                  ),
                  // Battery
                  SvgPicture.asset("assets/icons/Battery.svg",
                      width: constraints.maxWidth * 0.4),
                  Positioned(
                    top: 50 * (1 - _animationBatteryStatus.value),
                    height: constraints.maxHeight,
                    width: constraints.maxWidth,
                    child: Opacity(
                      opacity: _animationBatteryStatus.value,
                      child: BatteryStatus(
                        constraints: constraints,
                      ),
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
