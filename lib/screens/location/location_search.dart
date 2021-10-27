import 'package:firebase/models/location.dart';
import 'package:firebase/services/location.dart';
import 'package:firebase/shared/constants.dart';
import 'package:firebase/shared/loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

class LocationSearch extends StatefulWidget {
  final dynamic onSelected;

  const LocationSearch({Key? key, required this.onSelected}) : super(key: key);

  @override
  State<LocationSearch> createState() => _LocationSearchState();
}

class _LocationSearchState extends State<LocationSearch> {
  final TextEditingController textEditingController = TextEditingController();
  final LocationService locationService = LocationService();
  Location? selectedLocation;

  @override
  Widget build(BuildContext context) {
    return TypeAheadFormField<Location>(
      loadingBuilder: (context) => const Loader(
        color: Colors.orange,
        background: Colors.white,
      ),
      suggestionsCallback: locationService.search,
      itemBuilder: (context, location) =>
          ListTile(title: Text(location.address)),
      onSuggestionSelected: (location) {
        widget.onSelected(location);

        setState(() {
          textEditingController.text = location.address;
        });
      },
      noItemsFoundBuilder: (context) => const Text(
        'No Addresses Found',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
      textFieldConfiguration: TextFieldConfiguration(
        controller: textEditingController,
        decoration: textFieldDecoration('Address'),
      ),
    );
  }
}
