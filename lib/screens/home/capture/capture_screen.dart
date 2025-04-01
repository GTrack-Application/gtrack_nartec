import 'package:flutter/material.dart';
import 'package:gtrack_nartec/features/capture/cubits/capture_cubit.dart';
import 'package:gtrack_nartec/global/common/colors/app_colors.dart';
import 'package:gtrack_nartec/global/widgets/buttons/card_icon_button.dart';

class CaptureScreen extends StatefulWidget {
  const CaptureScreen({super.key});

  @override
  State<CaptureScreen> createState() => _CaptureScreenState();
}

class _CaptureScreenState extends State<CaptureScreen> {
  final gridDelegate = const SliverGridDelegateWithFixedCrossAxisCount(
    crossAxisCount: 2,
    childAspectRatio: 1.6,
    crossAxisSpacing: 20,
    mainAxisSpacing: 50,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Capture'),
        backgroundColor: AppColors.pink,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              gridDelegate: gridDelegate,
              itemBuilder: (context, index) {
                final icon = CaptureCubit.get(context)
                    .mainScreens(context)[index]['icon'];
                final onPressed = CaptureCubit.get(context)
                    .mainScreens(context)[index]['onTap'];
                final text = CaptureCubit.get(context)
                    .mainScreens(context)[index]['text'];

                return CardIconButton(
                  icon: icon,
                  onPressed: onPressed,
                  text: text,
                );
              },
              itemCount: CaptureCubit.get(context).mainScreens(context).length,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 50),
            ),
          ],
        ),
      ),
    );
  }
}
