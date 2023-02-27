import 'package:fb_chat_app/Utils/source.dart';

class GroupTile extends StatefulWidget {
  final String userName;
  final String groupId;
  final String groupName;

  const GroupTile({
    Key? key,
    required this.userName,
    required this.groupId,
    required this.groupName,
  }) : super(key: key);

  @override
  State<GroupTile> createState() => _GroupTileState();
}

class _GroupTileState extends State<GroupTile> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        nextScreen(
          context,
          ChatPage(
            userName: widget.userName,
            groupId: widget.groupId,
            groupName: widget.groupName,
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: ListTile(
          leading: CircleAvatar(
            radius: 35,
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
          title: Text(
            widget.groupName,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.w600,
            ),
          ),
          subtitle: Text(
            "Join The Conversation with ${widget.userName}",
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ),
    );
  }
}
