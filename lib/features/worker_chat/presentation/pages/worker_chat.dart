import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tez_xizmat/core/routes/route_names.dart';
import 'package:tez_xizmat/features/customer_chat/domain/entities/chat_room_entity.dart';
import 'package:tez_xizmat/features/customer_chat/presentation/bloc/chat_event.dart';
import 'package:tez_xizmat/features/customer_chat/presentation/bloc/chat_rooms/chat_rooms_bloc.dart';
import 'package:tez_xizmat/features/customer_chat/presentation/bloc/chat_rooms/chat_rooms_state.dart';

class WorkerChatPage extends StatefulWidget {
  const WorkerChatPage({super.key});

  @override
  State<WorkerChatPage> createState() => _WorkerChatPageState();
}

class _WorkerChatPageState extends State<WorkerChatPage> {
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
      if (selectedIndexes.isEmpty) isSelectionMode = false;
    });
  }

  void deleteSelected() {
    // swaggerda delete chat yo‘q, hozircha UI-only
    setState(() {
      selectedIndexes.clear();
      isSelectionMode = false;
    });
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
                    )
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

                  // STAFF uchun peer = CUSTOMER
                  final peerName = "${room.customer.firstName} ${room.customer.lastName}";
                  final peerImage = _normalizeImage(room.customer.image);

                  return _item(
                    room: room,
                    index: index,
                    name: peerName,
                    imageUrl: peerImage,
                    lastMessage: "Chatga kiring",
                    time: _formatTime(room.createdAt),
                    unread: 0,
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

  Widget _item({
    required ChatRoomEntity room,
    required int index,
    required String name,
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
            RouteNames.chatWithCustomer,
            arguments: {
              "roomId": room.id,
              "name": name,
              "imageUrl": imageUrl,
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
                Text(name, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
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
