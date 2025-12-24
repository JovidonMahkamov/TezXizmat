///Workerning asosiy chatlari pagesi
import 'package:flutter/material.dart';
import 'package:tez_xizmat/core/routes/route_names.dart';
import 'package:tez_xizmat/features/worker_chat/presentation/widgets/chat_list_worker.dart';

class WorkerChatPage extends StatefulWidget {
  const WorkerChatPage({super.key});

  @override
  State<WorkerChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<WorkerChatPage> {
  bool isSelectionMode = false;
  Set<int> selectedIndexes = {};

  final List<ChatListWorker> chats = List.generate(
    1,
        (i) => ChatListWorker(
      id: '$i',
      name: 'Jovidon Mahkamov',
      lastMessage: '+\$5 for additional person...',
      time: '08:22 AM',
      unread: 2,
    ),
  );

  void toggleSelection(int index) {
    setState(() {
      if (selectedIndexes.contains(index)) {
        selectedIndexes.remove(index);
      } else {
        selectedIndexes.add(index);
      }

      if (selectedIndexes.isEmpty) {
        isSelectionMode = false;
      }
    });
  }

  void deleteSelected() {
    setState(() {
      chats.removeWhere(
            (chat) => selectedIndexes.contains(chats.indexOf(chat)),
      );
      selectedIndexes.clear();
      isSelectionMode = false;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text(
          isSelectionMode
              ? '${selectedIndexes.length} tanlangan'
              : 'Chatlar',
          style: const TextStyle(fontWeight: FontWeight.w700),
        ),
        actions: [
          if (!isSelectionMode)
            IconButton(
              icon: const Icon(Icons.delete_outline,color: Colors.grey,),
              onPressed: () {
                setState(() {
                  isSelectionMode = true;
                });
              },
            ),
          if (isSelectionMode)
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed:
              selectedIndexes.isEmpty ? null : deleteSelected,
            ),
        ],
      ),
      body: Container(
        margin: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: chats.length,
          separatorBuilder: (_, __) => const Divider(height: 24),
          itemBuilder: (context, index) {
            return _chatItemWorker(
              context,
              chats[index],
              index,
            );
          },
        ),
      ),
    );
  }

  Widget _chatItemWorker(
      BuildContext context,
      ChatListWorker chat,
      int index,
      ) {
    final isSelected = selectedIndexes.contains(index);

    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onLongPress: () {
        setState(() {
          isSelectionMode = true;
          selectedIndexes.add(index);
        });
      },
      onTap: () async {
        if (isSelectionMode) {
          toggleSelection(index);
        } else {
          final result = await Navigator.pushNamed(
            context,
            RouteNames.chatWithCustomer,
            arguments: {
              "name": chat.name,
              "urlAsset": "assets/circular_avatar/profile.png",
            },
          );

          if (result != null && result is Map && result["lastMessage"] != null) {
            setState(() {
              chat.lastMessage = result["lastMessage"];
              chat.time = result["time"];
              chat.unread = 0;
            });
          }
        }
      },

      child: Row(
        children: [
          if (isSelectionMode)
            Padding(
              padding: const EdgeInsets.only(right: 12),
              child: CircleAvatar(
                radius: 12,
                backgroundColor:
                isSelected ? Colors.blue : Colors.grey[300],
                child: isSelected
                    ? const Icon(Icons.check,
                    size: 14, color: Colors.white)
                    : null,
              ),
            ),
          const CircleAvatar(
            radius: 28,
            backgroundImage:
            AssetImage("assets/circular_avatar/profile.png"),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(chat.name,
                    style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600)),
                const SizedBox(height: 4),
                Text(
                  chat.lastMessage,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                      fontSize: 13, color: Colors.grey),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(chat.time,
                  style: const TextStyle(
                      fontSize: 11, color: Colors.grey)),
              const SizedBox(height: 6),
              if (chat.unread > 0)
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: const BoxDecoration(
                    color: Colors.blue,
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    chat.unread.toString(),
                    style: const TextStyle(
                        color: Colors.white, fontSize: 11),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
