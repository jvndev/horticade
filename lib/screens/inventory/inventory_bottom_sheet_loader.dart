import 'package:flutter/material.dart';
import 'package:horticade/shared/loader.dart';
import 'package:horticade/theme/horticade_theme.dart';

class InventoryBottomSheetLoader extends StatelessWidget {
  const InventoryBottomSheetLoader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        BottomSheet(
            onClosing: () {},
            builder: (context) {
              return Container(
                decoration: HorticadeTheme.bottomSheetDecoration,
                child: Loader(
                  color: Colors.orange,
                  background: HorticadeTheme.scaffoldBackground!,
                ),
              );
            }),
      ],
    );
  }
}
