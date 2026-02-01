import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tez_xizmat/core/routes/route_names.dart';
import 'package:tez_xizmat/features/customer_chat/domain/entities/chat_room_entity.dart';
import 'package:tez_xizmat/features/customer_chat/presentation/bloc/chat_event.dart';
import 'package:tez_xizmat/features/customer_chat/presentation/bloc/chat_rooms/chat_rooms_bloc.dart';
import 'package:tez_xizmat/features/customer_chat/presentation/bloc/chat_rooms/chat_rooms_state.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  bool isSelectionMode = false;
  final Set<int> selectedIndexes = {};

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ChatRoomsBloc>().add(const GetChatRoomsE());
    });
  }

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
      selectedIndexes.clear();
      isSelectionMode = false;
    });

    // Backendda delete chat endpoint yo‘q (swaggerda ko‘rinmadi)
    // shuning uchun hozircha UI-only.
  }

  String? _normalizeImage(String? raw) {
    if (raw == null) return null;
    final v = raw.trim();
    if (v.isEmpty || v == 'null') return null;

    if (v.startsWith('http://')) return v.replaceFirst('http://', 'https://');
    if (v.startsWith('https://')) return v;
    return 'https://tezxizmatlar.uz${v.startsWith('/') ? '' : '/'}$v';
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
          isSelectionMode ? '${selectedIndexes.length} tanlangan' : 'Chatlar',
          style: const TextStyle(fontWeight: FontWeight.w700),
        ),
        actions: [
          if (!isSelectionMode)
            IconButton(
              icon: const Icon(Icons.delete_outline, color: Colors.grey),
              onPressed: () => setState(() => isSelectionMode = true),
            ),
          if (isSelectionMode)
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: selectedIndexes.isEmpty ? null : deleteSelected,
            ),
        ],
      ),
      body: Container(
        margin: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: BlocBuilder<ChatRoomsBloc, ChatRoomsState>(
          builder: (context, state) {
            if (state is ChatRoomsLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is ChatRoomsError) {
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(state.message),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () => context.read<ChatRoomsBloc>().add(const GetChatRoomsE()),
                      child: const Text("Qayta urinish"),
                    ),
                  ],
                ),
              );
            }
            if (state is ChatRoomsSuccess) {
              final rooms = state.rooms;
              if (rooms.isEmpty) {
                return const Center(child: Text("Hozircha chatlar yo‘q"));
              }

              return ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: rooms.length,
                separatorBuilder: (_, __) => const Divider(height: 24),
                itemBuilder: (context, index) {
                  final room = rooms[index];

                  // CUSTOMER uchun: chat qilayotgan odam - STAFF
                  final peerName = "${room.staff.firstName} ${room.staff.lastName}";
                  final peerImage = _normalizeImage(room.staff.image);

                  return _chatItem(
                    context: context,
                    room: room,
                    index: index,
                    title: peerName,
                    imageUrl: peerImage,
                    lastMessage: "Chatga kiring", // swaggerda room listda last msg yo‘q
                    time: _formatTime(room.createdAt),
                    unread: 0, // swaggerda unread yo‘q
                  );
                },
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Widget _chatItem({
    required BuildContext context,
    required ChatRoomEntity room,
    required int index,
    required String title,
    required String? imageUrl,
    required String lastMessage,
    required String time,
    required int unread,
  }) {
    final isSelected = selectedIndexes.contains(index);

    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onLongPress: () {
        setState(() {
          isSelectionMode = true;
          selectedIndexes.add(index);
        });
      },
      onTap: () {
        if (isSelectionMode) {
          toggleSelection(index);
        } else {
          Navigator.pushNamed(
            context,
            RouteNames.chatWithWorker,
            arguments: {
              "roomId": room.id,
              "name": title,
              "imageUrl": imageUrl, // network image bo‘ladi
            },
          );
        }
      },
      child: Row(
        children: [
          if (isSelectionMode)
            Padding(
              padding: const EdgeInsets.only(right: 12),
              child: CircleAvatar(
                radius: 12,
                backgroundColor: isSelected ? Colors.blue : Colors.grey[300],
                child: isSelected ? const Icon(Icons.check, size: 14, color: Colors.white) : null,
              ),
            ),
          CircleAvatar(
            radius: 28,
            backgroundImage: (imageUrl != null)
                ? NetworkImage(imageUrl)
                : const AssetImage("assets/circular_avatar/profile.png") as ImageProvider,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                const SizedBox(height: 4),
                Text(
                  lastMessage,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 13, color: Colors.grey),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(time, style: const TextStyle(fontSize: 11, color: Colors.grey)),
              const SizedBox(height: 6),
              if (unread > 0)
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: const BoxDecoration(color: Colors.blue, shape: BoxShape.circle),
                  child: Text(unread.toString(), style: const TextStyle(color: Colors.white, fontSize: 11)),
                ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatTime(DateTime dt) {
    final h = dt.hour.toString().padLeft(2, '0');
    final m = dt.minute.toString().padLeft(2, '0');
    return "$h:$m";
  }
}
