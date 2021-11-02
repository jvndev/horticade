import 'package:horticade/models/entity.dart';
import 'package:horticade/screens/location/location_search.dart';
import 'package:horticade/services/database.dart';
import 'package:horticade/shared/constants.dart';
import 'package:horticade/theme/horticade_theme.dart';
import 'package:flutter/material.dart';

class EntityDetails extends StatefulWidget {
  Entity entity;

  EntityDetails({Key? key, required this.entity}) : super(key: key);

  @override
  State<EntityDetails> createState() => _EntityDetailsState();
}

class _EntityDetailsState extends State<EntityDetails> {
  final DatabaseService db = DatabaseService();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();

  bool _changeLocation = false;

  void locationChanged(location) async {
    Entity entity = await db.createEntity(
      Entity(
        uid: widget.entity.uid,
        name: widget.entity.name,
        location: location,
      ),
    ) as Entity; //update

    setState(() {
      widget.entity = entity;
      _changeLocation = false;
    });

    notify("Location successfuly changed");
  }

  void nameChanged() async {
    if (_formKey.currentState!.validate()) {
      await db
          .createEntity(
        Entity(
          uid: widget.entity.uid,
          name: nameController.text,
          location: widget.entity.location,
        ),
      )
          .then((entity) {
        setState(() {
          if (entity != null) {
            widget.entity = entity;
            notify("Business name successfuly changed!");
          } else {
            notify("Failed to update business name.");
          }
        });
      });
    }
  }

  void notify(String msg) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(msg),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(Icons.check),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    nameController.text = widget.entity.name;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Details'),
        backgroundColor: HorticadeTheme.appbarBackground,
        iconTheme: HorticadeTheme.appbarIconsTheme,
        actionsIconTheme: HorticadeTheme.appbarIconsTheme,
        titleTextStyle: HorticadeTheme.appbarTitleTextStyle,
      ),
      backgroundColor: HorticadeTheme.scaffoldBackground,
      body: Padding(
        padding: formPadding,
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    flex: 9,
                    child: TextFormField(
                      validator: (val) => val == null || val.isEmpty
                          ? 'Name is required'
                          : null,
                      decoration: textFieldDecoration('Name of Company'),
                      controller: nameController,
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: ElevatedButton(
                      child: const Text(
                        'Update',
                        style: HorticadeTheme.actionButtonTextStyle,
                      ),
                      onPressed: nameChanged,
                      style: HorticadeTheme.actionButtonTheme,
                    ),
                  ),
                ],
              ),
              formTextSpacer,
              !_changeLocation
                  ? Row(
                      children: [
                        Expanded(
                          flex: 9,
                          child: ListTile(
                            leading:
                                const Icon(Icons.map, color: Colors.orange),
                            title: const Text('Address'),
                            subtitle: Text(widget.entity.location.address),
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: ElevatedButton(
                            child: const Text(
                              'Change',
                              style: HorticadeTheme.actionButtonTextStyle,
                            ),
                            onPressed: () {
                              setState(() {
                                _changeLocation = true;
                              });
                            },
                            style: HorticadeTheme.actionButtonTheme,
                          ),
                        ),
                      ],
                    )
                  : Row(children: [
                      Expanded(
                        flex: 9,
                        child: LocationSearch(onSelected: locationChanged),
                      ),
                      Expanded(
                        flex: 3,
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _changeLocation = false;
                            });
                          },
                          child: const Text(
                            'Cancel',
                            style: HorticadeTheme.actionButtonTextStyle,
                          ),
                          style: HorticadeTheme.actionButtonTheme,
                        ),
                      )
                    ]),
            ],
          ),
        ),
      ),
    );
  }
}
