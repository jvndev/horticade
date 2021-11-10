import 'package:horticade/screens/wrapper.dart';
import 'package:horticade/services/auth.dart';
import 'package:horticade/services/image.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  ImageService.cleanImageCache();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamProvider(
      create: (context) => AuthService.userStream,
      initialData: null,
      child: const MaterialApp(
        title: 'Horticade',
        home: Wrapper(),
      ),
    );
  }
}
