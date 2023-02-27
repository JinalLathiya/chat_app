import 'package:fb_chat_app/Utils/source.dart';

class ChatPage extends StatefulWidget {
  final String userName;
  final String groupId;
  final String groupName;

  const ChatPage({
    Key? key,
    required this.userName,
    required this.groupId,
    required this.groupName,
  }) : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  Stream<QuerySnapshot>? chats;
  TextEditingController messageController = TextEditingController();
  String admin = " ";

  void hideKeyword(BuildContext context) {
    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
      currentFocus.focusedChild?.unfocus();
    }
  }

  @override
  void initState() {
    getChatAndAdmin();
    super.initState();
  }

  getChatAndAdmin() {
    DatabaseServices().getChats(widget.groupId).then((val) {
      setState(() {
        chats = val;
      });
    });
    DatabaseServices().getGroupAdmin(widget.groupId).then((value) {
      setState(() {
        admin = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.groupName),
        centerTitle: true,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {
              nextScreen(
                context,
                GroupInfoPage(
                  groupId: widget.groupId,
                  groupName: widget.groupName,
                  adminName: admin,
                ),
              );
            },
            icon: const Icon(
              Icons.info,
            ),
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          // Chat Messages Here
          Expanded(
            flex: 8,
            child: chatMessage(),
          ),
          Container(
            alignment: Alignment.bottomCenter,
            width: MediaQuery.of(context).size.width,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              width: MediaQuery.of(context).size.width,
              color: Colors.white,
              child: TextFormField(
                controller: messageController,
                style: const TextStyle(
                  color: Colors.black,
                ),
                decoration: InputDecoration(
                  hintText: "Send a Message ...",
                  suffixIcon: IconButton(
                    icon: const Icon(
                      Icons.send,
                      color: Colors.black,
                    ),
                    onPressed: () {
                      sendMessage();
                      hideKeyword(context);
                    },
                  ),
                  hintStyle: const TextStyle(
                    fontSize: 20,
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  chatMessage() {
    return StreamBuilder(
      stream: chats,
      builder: (context, AsyncSnapshot snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                physics: const BouncingScrollPhysics(),
                itemCount: snapshot.data.docs.length,
                itemBuilder: (context, i) {
                  return MessageTile(
                    message: snapshot.data.docs[i]['message'],
                    sender: snapshot.data.docs[i]['sender'],
                    sentByMe:
                        widget.userName == snapshot.data.docs[i]['sender'],
                  );
                },
              )
            : Container();
      },
    );
  }

  void sendMessage() {
    if (messageController.text.isNotEmpty) {
      Map<String, dynamic> chatMessageApp = {
        "message": messageController.text,
        "sender": widget.userName,
        "time": DateTime.now().millisecondsSinceEpoch,
      };
      DatabaseServices().sendMessage(widget.groupId, chatMessageApp);
      setState(() {
        messageController.clear();
      });
    }
  }
}
