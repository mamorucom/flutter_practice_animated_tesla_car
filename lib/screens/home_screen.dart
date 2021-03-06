import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:practice_animated_tesla_car/constanins.dart';
import 'package:practice_animated_tesla_car/home_controller.dart';
import 'package:practice_animated_tesla_car/models/tyre_psi.dart';
import 'package:practice_animated_tesla_car/screens/components/battery_status.dart';
import 'package:practice_animated_tesla_car/screens/components/door_lock.dart';
import 'package:practice_animated_tesla_car/screens/components/temp_details.dart';
import 'package:practice_animated_tesla_car/screens/components/tesla_bottom_navigationbar.dart';
import 'package:practice_animated_tesla_car/screens/components/tyre_psi_card.dart';
import 'package:practice_animated_tesla_car/screens/components/tyres.dart';

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

  ///
  /// バッテリーアニメーション設定
  ///
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
      curve: Interval(0.0, 0.5),
    );

    _animationBatteryStatus = CurvedAnimation(
      parent: _batteryAnimationController,
      // _animationBatteryのアニメーション終了から60ms後に開始
      // so 360～600ms
      curve: Interval(0.6, 1),
    );
  }

  ///
  /// 温度アニメーション設定
  ///
  void setupTempAnimation() {
    _tempAnimationController = AnimationController(
      vsync: this,
      duration: Duration(
        milliseconds: 1500,
      ),
    );

    _animationCarShift = CurvedAnimation(
      parent: _tempAnimationController,
      // 最初ちょっと待ってから動く
      curve: Interval(0.2, 0.4),
    );

    _animationTempShowInfo = CurvedAnimation(
      parent: _tempAnimationController,
      curve: Interval(0.45, 0.65),
    );

    _animationCoolGlow = CurvedAnimation(
      parent: _tempAnimationController,
      curve: Interval(0.6, 1),
    );
  }

  ///
  ///
  ///
  void setupTyreAnimation() {
    _tyreAnimationController = AnimationController(
        vsync: this, duration: Duration(milliseconds: 1200));

    /// tyreStatusControllerのFuture.Delayedの処理より、
    /// 400ms遅れるのでそれに合わせる
    /// 120 * 0.34 = 408
    _animationTyre1Psi = CurvedAnimation(
        parent: _tyreAnimationController, curve: Interval(0.34, 0.5));
    _animationTyre2Psi = CurvedAnimation(
        parent: _tyreAnimationController, curve: Interval(0.5, 0.66));
    _animationTyre3Psi = CurvedAnimation(
        parent: _tyreAnimationController, curve: Interval(0.66, 0.82));
    _animationTyre4Psi = CurvedAnimation(
        parent: _tyreAnimationController, curve: Interval(0.82, 1));
    _tyreAnimations = [
      _animationTyre1Psi,
      _animationTyre2Psi,
      _animationTyre3Psi,
      _animationTyre4Psi,
    ];
  }

  @override
  void initState() {
    setupBatteryAnimation();
    setupTempAnimation();
    setupTyreAnimation();

    super.initState();
  }

  @override
  void dispose() {
    _batteryAnimationController.dispose();
    _tempAnimationController.dispose();
    _tyreAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      // アニメーションリスナブル-アニメーション
      // 多分このアニメーションコントローラーが更新されるたびにビルドされるようになっている
      animation: Listenable.merge([
        _controller,
        _batteryAnimationController,
        _tempAnimationController,
        _tempAnimationController,
      ]),
      builder: (context, _) {
        // print(_animationBattery.value);
        // print(_animationBatteryStatus.value);
        print(_animationCarShift.value);
        return Scaffold(
          bottomNavigationBar: TeslaBottomNavigationBar(
            onTap: (index) {
              if (index == 1)
                _batteryAnimationController.forward();
              else if (_controller.selectedBottomTab == 1 && index != 1)
                _batteryAnimationController.reverse(from: 0.7);

              if (index == 2)
                _tempAnimationController.forward();
              else if (_controller.selectedBottomTab == 2 && index != 2)
                _tempAnimationController.reverse(from: 0.4);

              if (index == 3)
                _tyreAnimationController.forward();
              else if (_controller.selectedBottomTab == 3 && index != 3)
                _tyreAnimationController.reverse();

              _controller.showTyreController(index);
              _controller.tyreStatusController(index);
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
                  // 車体
                  Positioned(
                    left: constraints.maxWidth / 2 * _animationCarShift.value,
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
                        ? constraints.maxHeight * 0.13
                        : constraints.maxHeight / 2,
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
                        ? constraints.maxHeight * 0.17
                        : constraints.maxHeight / 2,
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
                  Opacity(
                    opacity: _animationBattery.value,
                    child: SvgPicture.asset("assets/icons/Battery.svg",
                        width: constraints.maxWidth * 0.45),
                  ),

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
                  // Temp
                  Positioned(
                    height: constraints.maxHeight,
                    width: constraints.maxWidth,
                    top: 60 * (1 - _animationTempShowInfo.value),
                    child: Opacity(
                      opacity: _animationTempShowInfo.value,
                      child: TempDetails(controller: _controller),
                    ),
                  ),
                  Positioned(
                    right: -180 * (1 - _animationCoolGlow.value),
                    child: AnimatedSwitcher(
                      duration: defaultDuration,
                      child: _controller.isCoolSelected
                          ? Image.asset(
                              'assets/images/Cool_glow_2.png',
                              key: UniqueKey(),
                              width: 200,
                            )
                          : Image.asset(
                              'assets/images/Hot_glow_4.png',
                              key: UniqueKey(),
                              width: 200,
                            ),
                    ),
                  ),

                  // Tyre
                  if (_controller.isShowTyre) ...tyres(constraints),
                  if (_controller.isShowTyreStatus)
                    // 空気圧表示グリッド
                    GridView.builder(
                      itemCount: 4,
                      physics: NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: defaultPadding,
                        crossAxisSpacing: defaultPadding,
                        childAspectRatio:
                            constraints.maxWidth / constraints.maxHeight,
                      ),
                      itemBuilder: (context, index) => ScaleTransition(
                        scale: _tyreAnimations[index],
                        child: TyrePsiCard(
                          isBottomTwoTyre: index > 1,
                          tyrePsi: demoPsiList[index],
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
