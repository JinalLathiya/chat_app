import 'package:fb_chat_app/Utils/source.dart';

class GroupListPage extends StatefulWidget {
  const GroupListPage({Key? key}) : super(key: key);

  @override
  State<GroupListPage> createState() => _GroupListPageState();
}

class _GroupListPageState extends State<GroupListPage> {
  String userName = "";
  String email = "";
  AuthServices authServices = AuthServices();
  Stream? groups;
  bool isLoading = false;
  String groupName = "";

  @override
  void initState() {
    super.initState();
    gettingUserData();
  }

  //String Manipulation
  String getId(String res) {
    return res.substring(0, res.indexOf("_"));
  }

  String getName(String res) {
    return res.substring(res.indexOf("_") + 1);
  }

  gettingUserData() async {
    await HelperFunctions.getUserEmail().then((value) {
      setState(() {
        email = value!;
      });
    });
    await HelperFunctions.getUserName().then((val) {
      setState(() {
        userName = val!;
      });
    });
    await DatabaseServices(uid: FirebaseAuth.instance.currentUser?.uid)
        .getUserGroups()
        .then((snapshot) {
      setState(() {
        groups = snapshot;
      });
    });
  }

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
              onTap: () {},
              leading: const Icon(Icons.groups),
              title: const Text("GROUPS"),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 10,
              ),
            ),
            ListTile(
              onTap: () {
                nextScreen(
                  context,
                  ProfilePage(
                    userName: userName,
                    email: email,
                  ),
                );
              },
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
        title: const Text("GROUPS"),
        centerTitle: true,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {
              nextScreen(context, const SearchPage());
            },
            icon: const Icon(
              Icons.search_rounded,
              size: 22,
            ),
          )
        ],
      ),
      body: GestureDetector(
        onLongPress: () {
          ListView(
            children: [
              ListTile(
                title: const Text("Delete"),
                trailing: IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.delete,
                    color: Colors.red,
                  ),
                ),
              ),
            ],
          );
        },
        child: Container(
          alignment: Alignment.center,
          child: StreamBuilder(
              stream: groups,
              builder: (context, AsyncSnapshot snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data['groups'] != null) {
                    if (snapshot.data['groups'].length != 0) {
                      return ListView.builder(
                        itemCount: snapshot.data['groups'].length,
                        itemBuilder: (context, i) {
                          int reverseIndex =
                              snapshot.data['groups'].length - i - 1;
                          return GroupTile(
                            groupId:
                                getId(snapshot.data['groups'][reverseIndex]),
                            groupName:
                                getName(snapshot.data['groups'][reverseIndex]),
                            userName: snapshot.data['fullName'],
                          );
                        },
                      );
                    } else {
                      return noGroupWidget();
                    }
                  } else {
                    return noGroupWidget();
                  }
                } else {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: Colors.white,
                    ),
                  );
                }
              }),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        elevation: 0,
        onPressed: () {
          popUpDialog(context);
        },
        child: const Icon(
          Icons.add,
          size: 22,
        ),
      ),
    );
  }

  noGroupWidget() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () {
              popUpDialog(context);
            },
            child: const Icon(
              Icons.add_circle,
              size: 70,
              color: Colors.pinkAccent,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          const Text(
            "You Haven't Joined Any Groups, \n Tap On The Add Icon To Create a Group \n Or Also Search From The Top Search Button.",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  void popUpDialog(BuildContext context) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            title: const Text("Create a Group"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                isLoading == true
                    ? const Center(
                        child: CircularProgressIndicator(
                          color: Colors.cyanAccent,
                        ),
                      )
                    : TextField(
                        onChanged: (val) {
                          setState(() {
                            groupName = val;
                          });
                        },
                        decoration: textInputDecoration.copyWith(
                          labelText: "Group Name",
                          hintText: "Enter Your Group Name",
                          suffixIcon: const Icon(
                            Icons.group,
                            color: Colors.white,
                          ),
                        ),
                      ),
              ],
            ),
            actions: [
              SizedBox(
                height: 40,
                width: 100,
                child: FloatingActionButton.extended(
                  onPressed: () async {
                    if (groupName != "") {
                      setState(() {
                        isLoading = true;
                      });
                      DatabaseServices(
                              uid: FirebaseAuth.instance.currentUser!.uid)
                          .createGroup(
                        userName,
                        FirebaseAuth.instance.currentUser!.uid,
                        groupName,
                      )
                          .whenComplete(() {
                        isLoading = false;
                      });
                      Navigator.of(context).pop();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Group Created Successfully .. !!"),
                          backgroundColor: Colors.green,
                        ),
                      );
                    }
                  },
                  label: const Text(
                    "CREATE",
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
                width: 100,
                child: FloatingActionButton.extended(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  label: const Text(
                    "CANCEL",
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
    );
  }
}
