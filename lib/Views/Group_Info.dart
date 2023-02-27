import 'package:fb_chat_app/Utils/source.dart';

class GroupInfoPage extends StatefulWidget {
  final String groupId;
  final String groupName;
  final String adminName;

  const GroupInfoPage({
    Key? key,
    required this.groupId,
    required this.groupName,
    required this.adminName,
  }) : super(key: key);

  @override
  State<GroupInfoPage> createState() => _GroupInfoPageState();
}

class _GroupInfoPageState extends State<GroupInfoPage> {
  Stream? members;

  @override
  void initState() {
    getMembers();
    super.initState();
  }

  getMembers() async {
    DatabaseServices(uid: FirebaseAuth.instance.currentUser!.uid)
        .getGroupMembers(widget.groupId)
        .then((val) {
      setState(() {
        members = val;
      });
    });
  }

  String getName(String r) {
    return r.substring(r.indexOf("_") + 1);
  }

  String getId(String res) {
    return res.substring(0, res.indexOf("_"));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Group Info"),
        centerTitle: true,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {
              showDialog(
                barrierDismissible: false,
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Text("Exit Group"),
                    content: const Text("Are You Sure Want To Exit the Group?"),
                    actions: [
                      SizedBox(
                        height: 40,
                        width: 80,
                        child: FloatingActionButton.extended(
                          onPressed: () async {
                            DatabaseServices(
                                    uid: FirebaseAuth.instance.currentUser!.uid)
                                .toggleGroupJoinExit(widget.groupId,
                                    getName(widget.adminName), widget.groupName)
                                .whenComplete(
                              () {
                                nextScreenReplace(
                                    context, const GroupListPage());
                              },
                            );
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
                    ],
                  );
                },
              );
            },
            icon: const Icon(
              Icons.remove_circle_outlined,
              color: Colors.red,
            ),
          ),
        ],
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 10,
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: Colors.cyanAccent,
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 25,
                    backgroundColor: Colors.white,
                    child: Text(
                      widget.groupName.substring(0, 1).toUpperCase(),
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                        fontSize: 20,
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Expanded(
                      child: Column(
                    children: [
                      Text(
                        "Group : ${widget.groupName}",
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Admin : ${widget.adminName}",
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  )),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            StreamBuilder(
              stream: members,
              builder: (context, AsyncSnapshot snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data["members"] != null) {
                    if (snapshot.data["members"].length != 0) {
                      return ListView.builder(
                        shrinkWrap: true,
                        itemCount: snapshot.data["members"].length,
                        itemBuilder: (context, i) {
                          return Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 10,
                            ),
                            child: ListTile(
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 10),
                              leading: CircleAvatar(
                                radius: 35,
                                backgroundColor: Colors.white,
                                child: Text(
                                  getName(snapshot.data["members"][i])
                                      .substring(0, 1)
                                      .toUpperCase(),
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 20,
                                  ),
                                ),
                              ),
                              title: Text(
                                getName(snapshot.data["members"][i])
                                    .toUpperCase(),
                                style: const TextStyle(
                                  color: Colors.white,
                                  letterSpacing: 1,
                                  fontSize: 22,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    } else {
                      return const Center(
                        child: Text(
                          "No Members Found",
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      );
                    }
                  } else {
                    return const Center(
                      child: Text(
                        "No Members Found",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    );
                  }
                } else {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: Colors.white,
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
