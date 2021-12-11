import 'package:flutter/material.dart';
import 'package:practice_animated_tesla_car/constanins.dart';
import 'package:practice_animated_tesla_car/home_controller.dart';
import 'package:practice_animated_tesla_car/screens/components/temp_btn.dart';

class TempDetails extends StatelessWidget {
  const TempDetails({
    Key? key,
    required HomeController controller,
  })  : _controller = controller,
        super(key: key);

  final HomeController _controller;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(defaultPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 120,
            child: Row(
              children: [
                TempBtn(
                  isActive: _controller.isCoolSelected,
                  svgSrc: 'assets/icons/coolShape.svg',
                  title: 'Cool',
                  press: _controller.updateCoolSelectedTab,
                ),
                const SizedBox(width: defaultPadding),
                TempBtn(
                  isActive: !_controller.isCoolSelected,
                  svgSrc: 'assets/icons/heatShape.svg',
                  title: 'Heat',
                  activeColor: redColor,
                  press: _controller.updateCoolSelectedTab,
                ),
              ],
            ),
          ),
          Spacer(),
          // 温度調整
          Column(
            children: [
              IconButton(
                // デフォルトのパディングゼロにする
                padding: EdgeInsets.zero,
                onPressed: () {},
                icon: Icon(Icons.arrow_drop_up, size: 48),
              ),
              Text(
                "29" + "\u2103",
                style: TextStyle(fontSize: 86),
              ),
              IconButton(
                // デフォルトのパディングゼロにする
                padding: EdgeInsets.zero,
                onPressed: () {},
                icon: Icon(Icons.arrow_drop_down, size: 48),
              ),
            ],
          ),

          Spacer(),
          //
          Text("CURRENT TEMPERATURE"),
          const SizedBox(height: defaultPadding),
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Inside'.toUpperCase(),
                  ),
                  Text(
                    "20" + "\u2103",
                    style: Theme.of(context).textTheme.headline5,
                  ),
                ],
              ),
              const SizedBox(width: defaultPadding),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Inside'.toUpperCase(),
                    style: TextStyle(color: Colors.white54),
                  ),
                  Text(
                    "35" + "\u2103",
                    style: Theme.of(context)
                        .textTheme
                        .headline5!
                        .copyWith(color: Colors.white54),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
