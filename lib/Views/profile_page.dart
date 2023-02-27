import 'package:fb_chat_app/Utils/source.dart';

class ProfilePage extends StatefulWidget {
  final String userName;
  final String email;

  const ProfilePage({
    Key? key,
    required this.userName,
    required this.email,
  }) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  AuthServices authServices = AuthServices();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          padding: const EdgeInsets.only(
            left: 50,
            right: 50,
            top: 100,
            bottom: 200,
          ),
          children: <Widget>[
            const Icon(
              Icons.account_circle_rounded,
              size: 180,
              color: Colors.white,
            ),
            const SizedBox(
              height: 50,
            ),
            const Divider(
              thickness: 1,
              color: Colors.white,
            ),
            const SizedBox(
              height: 10,
            ),
            ListTile(
              onTap: () {
                nextScreen(
                  context,
                  const GroupListPage(),
                );
              },
              leading: const Icon(Icons.groups),
              selectedColor: Colors.pinkAccent,
              selected: true,
              title: const Text("GROUPS"),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 10,
              ),
            ),
            ListTile(
              onTap: () {},
              leading: const Icon(Icons.person),
              title: const Text("PROFILE"),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 10,
              ),
            ),
            ListTile(
              onTap: () async {
                showDialog(
                    barrierDismissible: false,
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text("LOGOUT"),
                        content: const Text("Are You Sure Want to Logout? "),
                        actions: [
                          SizedBox(
                            height: 40,
                            width: 80,
                            child: FloatingActionButton.extended(
                              onPressed: () async {
                                await authServices.signOut();
                                Navigator.of(context).pushAndRemoveUntil(
                                    MaterialPageRoute(
                                      builder: (context) => const LoginPage(),
                                    ),
                                    (route) => false);
                              },
                              label: const Text(
                                "YES",
                                style: TextStyle(
                                  fontSize: 18,
                                  letterSpacing: 2,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 40,
                            width: 80,
                            child: FloatingActionButton.extended(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              label: const Text(
                                "NO",
                                style: TextStyle(
                                  fontSize: 18,
                                  letterSpacing: 2,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 4,
                          ),
                        ],
                      );
                    });
              },
              leading: const Icon(Icons.logout_rounded),
              selectedColor: Colors.pinkAccent,
              title: const Text("LOG OUT"),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 10,
              ),
            ),
          ],
        ),
      ),
      appBar: AppBar(
        title: const Text("Profile Page"),
        centerTitle: true,
        elevation: 0,
      ),
      body: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Icon(
              Icons.account_circle_rounded,
              size: 160,
              color: Colors.white,
            ),
            const SizedBox(
              height: 120,
            ),
            Row(
              children: [
                const Text(
                  "Full Name : ",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                Text(
                  widget.userName,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 40,
            ),
            Row(
              children: [
                const Text(
                  "Email : ",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                Text(
                  widget.email,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 120,
            ),
          ],
        ),
      ),
    );
  }
}



