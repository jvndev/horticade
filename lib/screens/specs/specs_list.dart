import 'package:flutter/material.dart';
import 'package:horticade/models/spec.dart';
import 'package:horticade/shared/loader.dart';
import 'package:horticade/theme/horticade_confirmation_dialog.dart';
import 'package:provider/provider.dart';

class SpecsList extends StatefulWidget {
  final List<Spec<dynamic>> selectedSpecs; // initially checked specs

  const SpecsList({Key? key, required this.selectedSpecs}) : super(key: key);

  @override
  State<SpecsList> createState() => _SpecsListState();
}

class _SpecsListState extends State<SpecsList> {
  final Map<Spec<dynamic>, bool> checked = {};

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Spec>>(
      future: Provider.of<Future<List<Spec>>>(context),
      builder: (context, snapshot) {
        Widget content;

        if (snapshot.connectionState == ConnectionState.waiting ||
            !snapshot.hasData) {
          content = Loader(
            color: Colors.orange,
            background: Colors.grey[700]!,
          );
        } else {
          List<Spec> specs = snapshot.data!;

          content = ListView.builder(
            key: Key('product_create_specs'
                '_${widget.selectedSpecs.length}'
                '_${checked.length}'),
            itemCount: specs.length,
            itemBuilder: (context, i) {
              Spec spec = specs[i];

              return ListTile(
                leading: Checkbox(
                  value: checked[spec] ?? widget.selectedSpecs.contains(spec),
                  onChanged: (state) {
                    setState(() {
                      checked[specs[i]] = state ?? false;
                    });
                  },
                ),
                title: Text(specs[i].name),
                subtitle: Text(specs[i].value),
              );
            },
          );
        }

        return HorticadeConfirmationDialog(
          title: 'Product Specifications',
          content: content,
          accept: () {
            List<Spec> ret = checked.entries
                .where((entry) => entry.value)
                .map((entry) => entry.key)
                .toList();
            ret.addAll(widget.selectedSpecs
                .where((spec) =>
                    !checked.entries.map((entry) => entry.key).contains(spec))
                .toList());

            Navigator.of(context).pop(ret);
          },
          reject: () {
            Navigator.of(context).pop();
          },
        );
      },
    );
  }
}
