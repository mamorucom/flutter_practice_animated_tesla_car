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
    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(builder: (context, constraints) {
          return Stack(
            alignment: Alignment.center,
            children: [
              Padding(
                padding:
                    EdgeInsets.symmetric(vertical: constraints.maxHeight * 0.1),
                child: SvgPicture.asset(
                  "assets/icons/Car.svg",
                  width: double.infinity,
                ),
              ),
              Positioned(
                right: constraints.maxWidth * 0.05,
                child: SvgPicture.asset("assets/icons/door_lock.svg"),
              ),
            ],
          );
        }),
      ),
    );
  }
}
