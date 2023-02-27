import 'package:fb_chat_app/Utils/source.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  bool isLoading = false;
  final registerKey = GlobalKey<FormState>();
  String email = "";
  String password = "";
  String fullName = "";
  bool isObscure = false;
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
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 60),
                child: Form(
                  key: registerKey,
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
                        "Create your account now to chat and explore",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Container(
                        height: 250,
                        width: 300,
                        alignment: Alignment.center,
                        child: Image.asset("assets/3.png"),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        decoration: textInputDecoration.copyWith(
                          labelText: "Full Name",
                          hintText: "Enter Your Full Name Here",
                          suffixIcon: const Icon(
                            Icons.person,
                            color: Colors.white,
                          ),
                        ),
                        onChanged: (val) {
                          setState(() {
                            fullName = val;
                          });
                        },
                        validator: (val) {
                          if (val!.isNotEmpty) {
                            return null;
                          } else {
                            return "Name cannot be empty";
                          }
                        },
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        decoration: textInputDecoration.copyWith(
                            labelText: "Email",
                            hintText: "enter Your Email Here",
                            suffixIcon: const Icon(
                              Icons.email,
                              color: Colors.white,
                            )),
                        onChanged: (val) {
                          setState(() {
                            email = val;
                          });
                        },

                        // check tha validation
                        validator: (val) {
                          return RegExp(
                                      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                  .hasMatch(val!)
                              ? null
                              : "Please enter a valid email";
                        },
                      ),
                      const SizedBox(height: 10),
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
                        height: 30,
                      ),
                      SizedBox(
                        width: 180,
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
                            "REGISTER",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 2,
                            ),
                          ),
                          onPressed: () {
                            register();
                            if (isLoading == true) {
                              nextScreenReplace(
                                context,
                                const GroupListPage(),
                              );
                            }
                          },
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text.rich(
                        TextSpan(
                          text: "Already have an account? ",
                          style: const TextStyle(
                              color: Colors.white, fontSize: 14),
                          children: <TextSpan>[
                            TextSpan(
                              text: "Login now",
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  nextScreen(
                                    context,
                                    const LoginPage(),
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

  register() async {
    if (registerKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });
      await authServices
          .registerEmailPassword(
        fullName,
        email,
        password,
      )
          .then((value) async {
        if (value == true) {
          // Save Value in SharedPreferences
          await HelperFunctions.saveUserLoggedIn(true);
          await HelperFunctions.saveUserName(fullName);
          await HelperFunctions.saveUserEmail(email);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("$value"),
              backgroundColor: Colors.red,
            ),
          );
          setState(() {
            isLoading = false;
          });
        }
      });
    }
  }
}
