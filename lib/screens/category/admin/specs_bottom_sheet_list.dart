import 'package:flutter/material.dart';
import 'package:horticade/models/spec.dart';
import 'package:horticade/services/database.dart';
import 'package:horticade/shared/constants.dart';
import 'package:horticade/shared/loader.dart';
import 'package:horticade/theme/horticade_theme.dart';
import 'package:provider/provider.dart';

class SpecsBottomSheetList extends StatelessWidget {
  final DatabaseService databaseService = DatabaseService();

  SpecsBottomSheetList({Key? key}) : super(key: key);

  List<Row> buildSpecRows(List<Spec> specs) {
    List<List<Widget>> reshuffled = [];

    if (specs.isEmpty) {
      return [];
    }

    for (int i = 1; i <= specs.length; i++) {
      Spec spec = specs[i - 1];
      Widget listTile = Expanded(
        child: ListTile(
          title: Text(spec.name),
          subtitle: Text(spec.value),
          tileColor: HorticadeTheme.cardColor,
          trailing: IconButton(
            icon: const Icon(Icons.close_outlined),
            onPressed: () {
              _deleteSpec(spec);
            },
          ),
        ),
      );

      if (i % 2 == 0) {
        reshuffled.last.add(listTile);
      } else {
        reshuffled.add([listTile]);
      }
    }

    return reshuffled.map((List<Widget> e) => Row(children: e)).toList();
  }

  Future<void> _deleteSpec(Spec spec) async {
    bool success = await databaseService.deleteSpec(spec);

    if (success) {
      toast('Specification successfully deleted.');
    } else {
      toast('Specification could not be deleted.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Spec>>(
      future: Provider.of<Future<List<Spec>>>(context),
      builder: (context, snapshat) {
        if (snapshat.connectionState == ConnectionState.waiting ||
            !snapshat.hasData) {
          return Loader(
            color: Colors.orange,
            background: HorticadeTheme.scaffoldBackground!,
          );
        } else {
          List<Spec> specs = snapshat.data!;

          return Column(
            children: buildSpecRows(specs),
          );
        }
      },
    );
  }
}
