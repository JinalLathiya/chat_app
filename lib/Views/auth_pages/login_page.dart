import 'package:fb_chat_app/Utils/source.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> loginKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool isObscure = false;
  String email = "";
  String password = "";
  bool isLoading = false;
  AuthServices authServices = AuthServices();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: Colors.white,
              ),
            )
          : SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 80),
                child: Form(
                  key: loginKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      const Text(
                        "Messenger",
                        style: TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        "Login now to see what they are talking!",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 30),
                      Image.asset("assets/1.png"),
                      const SizedBox(height: 60),
                      TextFormField(
                        decoration: textInputDecoration.copyWith(
                          labelText: "Email",
                          suffixIcon: const Icon(
                            Icons.email,
                            color: Colors.white,
                          ),
                        ),
                        onChanged: (val) {
                          setState(() {
                            email = val;
                          });
                        },
                        validator: (val) {
                          return RegExp(
                                      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                  .hasMatch(val!)
                              ? null
                              : "Please enter a valid email";
                        },
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        obscureText: isObscure,
                        decoration: textInputDecoration.copyWith(
                          labelText: "Password",
                          hintText: "Enter Your Password Here",
                          suffixIcon: IconButton(
                            color: Colors.white,
                            icon: Icon(
                              isObscure
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                            onPressed: () {
                              isObscure = !isObscure;
                            },
                          ),
                        ),
                        validator: (val) {
                          if (val == null || val.isEmpty) {
                            return 'Enter Password first';
                          } else if (val.length < 6) {
                            return "Password must be at least 6 characters";
                          } else {
                            return null;
                          }
                        },
                        onChanged: (val) {
                          setState(() {
                            password = val;
                          });
                        },
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                      SizedBox(
                        width: 150,
                        height: 40,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.cyanAccent,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          child: const Text(
                            "LOGIN",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              letterSpacing: 3,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          onPressed: () async {
                            login();
                            if (isLoading == true) {
                              nextScreenReplace(
                                context,
                                const GroupListPage(),
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("You Can not LOGIN"),
                                  backgroundColor: Colors.red,
                                ),
                              );
                              setState(() {
                                isLoading = false;
                              });
                            }
                          },
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Text.rich(
                        TextSpan(
                          text: "Don't have an account? ",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                          children: <TextSpan>[
                            TextSpan(
                              text: "Register here",
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  nextScreen(
                                    context,
                                    const RegisterPage(),
                                  );
                                },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  login() async {
    if (loginKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });
      await authServices
          .loginEmailPassword(
        email,
        password,
      )
          .then((value) async {
        if (value == true) {
          await DatabaseServices(uid: FirebaseAuth.instance.currentUser!.uid)
              .gettingUserData(email);
          // Save Value in SharedPreferences
          await HelperFunctions.saveUserLoggedIn(true);
          // await HelperFunctions.saveUserName(snapshot.docs[0]['fullName']);
          await HelperFunctions.saveUserEmail(email);
        }
      });
    }
  }
}
