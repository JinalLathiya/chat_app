import 'package:fb_chat_app/Utils/source.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    const MyApp(),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isSignIn = false;

  @override
  void initState() {
    super.initState();
    getUserLoggedINStatus();
  }

  getUserLoggedINStatus() async {
    await HelperFunctions.getUserLoggedIn().then((value) {
      if (value != null) {
        setState(() {
          isSignIn = value;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      debugShowCheckedModeBanner: false,
      home: isSignIn ? const GroupListPage() : const LoginPage(),
      // home: GroupListPage(),
    );
  }
}
