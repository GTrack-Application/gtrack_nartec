import 'package:flutter/material.dart';
import 'package:gtrack_mobile_app/constants/app_icons.dart';
import 'package:gtrack_mobile_app/global/widgets/buttons/icon_button_widget.dart';

class IdentityScreen extends StatelessWidget {
  const IdentityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Identity'),
      ),
      body: Column(children: [
        IconButtonWidget(
          icon: AppIcons.capture,
          text: 'Capture',
          onPressed: () {},
        )
      ]),
    );
  }
}
