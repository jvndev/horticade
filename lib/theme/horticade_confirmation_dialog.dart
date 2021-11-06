import 'package:flutter/material.dart';
import 'package:horticade/shared/types.dart';
import 'package:horticade/theme/horticade_theme.dart';

class HorticadeConfirmationDialog extends StatelessWidget {
  final String title;
  Widget? content;
  VoidFunc? accept;
  VoidFunc? reject;

  HorticadeConfirmationDialog({
    Key? key,
    required this.title,
    this.content,
    this.accept,
    this.reject,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> actions = [];

    if (reject != null) {
      actions.add(IconButton(
        onPressed: reject!,
        icon: const Icon(
          Icons.clear,
          color: Colors.orange,
        ),
      ));
    }

    if (accept != null) {
      actions.add(IconButton(
        onPressed: accept!,
        icon: const Icon(
          Icons.check,
          color: Colors.orange,
        ),
      ));
    }

    return AlertDialog(
      backgroundColor: HorticadeTheme.confirmationDialogBackground,
      title: Text(
        title,
        style: HorticadeTheme.confirmationDialogTitleStyle,
      ),
      actions: actions,
      content: content,
    );
  }
}
