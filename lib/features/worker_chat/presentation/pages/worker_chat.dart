import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';
import 'package:tez_xizmat/core/routes/route_names.dart';
import 'package:tez_xizmat/features/auth/presentation/widgets/elevated_button_widget.dart';
import 'package:tez_xizmat/features/customer_chat/domain/entities/chat_room_entity.dart';
import 'package:tez_xizmat/features/customer_chat/presentation/bloc/chat_delete/chat_delete_bloc.dart';
import 'package:tez_xizmat/features/customer_chat/presentation/bloc/chat_delete/chat_delete_state.dart';
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
  List<ChatRoomEntity> _roomsCache = [];
  bool _loadingDialogOpen = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ChatRoomsBloc>().add(const GetChatRoomsE());
    });
  }

  void _showLoading() {
    if (_loadingDialogOpen) return;
    _loadingDialogOpen = true;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );
  }

  void _hideLoading() {
    if (!_loadingDialogOpen) return;
    _loadingDialogOpen = false;
    if (Navigator.canPop(context)) Navigator.pop(context);
  }

  void _clearSelection() {
    setState(() {
      selectedIndexes.clear();
      isSelectionMode = false;
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

  Future<void> deleteSelected() async {
    if (_roomsCache.isEmpty || selectedIndexes.isEmpty) return;

    // index -> roomId
    final roomIds = selectedIndexes
        .where((i) => i >= 0 && i < _roomsCache.length)
        .map((i) => _roomsCache[i].id)
        .toList();

    if (roomIds.isEmpty) return;

    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Chatni o‘chirish", style: TextStyle(fontWeight: FontWeight.w500, fontSize: 22),),
        content: Text("${roomIds.length} ta chatni o‘chirmoqchimisiz?", style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w500, color: Colors.black),),
        actions: [
          Row(
            children: [
              Expanded(
                child: ElevatedWidget(
                  onPressed: () => Navigator.pop(context, false),
                  text: 'Bekor qilish',
                  backgroundColor: Colors.blue,
                  textColor: Colors.white,
                ),
              ),
              SizedBox(width: 10.w,),
              Expanded(
                child: ElevatedWidget(
                  onPressed: () => Navigator.pop(context, true),
                  text: 'O‘chirish',
                  backgroundColor: Colors.red,
                  textColor: Colors.white,
                ),
              ),
            ],
          ),
        ],
      ),
    );

    if (ok != true) return;

    // Multi delete event (Bloc ichida for bilan birma-bir delete qiladi)
    context.read<ChatDeleteBloc>().add(DeleteChatsE(roomIds: roomIds));
  }

  String? _normalizeImage(String? raw) {
    if (raw == null) return null;
    final v = raw.trim();
    if (v.isEmpty || v == 'null') return null;
    if (v.startsWith('http://')) return v.replaceFirst('http://', 'https://');
    if (v.startsWith('https://')) return v;
    return 'https://tezxizmatlar.uz${v.startsWith('/') ? '' : '/'}$v';
  }

  String onlyTextFromLastMessage(dynamic lastMessage) {
    if (lastMessage == null) return "";

    // Agar API lastMessage ni string qilib yuborsa
    if (lastMessage is String) {
      final s = lastMessage.trim();

      // Ba'zan string ko'rinishida "{id:..., text: ...}" kelib qolishi mumkin
      // Shunda ichidan "text:" qismidan keyin ajratib olishga urinib ko'ramiz
      if (s.startsWith('{') && s.contains('text:')) {
        final afterText = s.split('text:').last;
        // "sender_type:" kelgunga qadar olish
        final cut = afterText.split(', sender_type:').first;
        return cut.replaceAll('}', '').trim();
      }

      return s;
    }
    if (lastMessage is Map) {
      return (lastMessage['text'] ?? '').toString();
    }

    // Agar boshqa object bo'lsa, oxirgi chora:
    return lastMessage.toString();
  }
  int _safeUnread(String v) => int.tryParse(v) ?? 0;


  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<ChatDeleteBloc, ChatDeleteState>(
          listener: (context, state) {
            if (state is ChatDeleteLoading) {
              _showLoading();
            } else {
              _hideLoading();
            }

            if (state is ChatDeleteSuccess) {
              _clearSelection();
              context.read<ChatRoomsBloc>().add(const GetChatRoomsE());

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("${state.deletedCount} ta chat o‘chirildi"),
                ),
              );
            }

            if (state is ChatDeleteError) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(state.message)));
            }
          },
        ),
      ],
      child: Scaffold(
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
                onPressed: selectedIndexes.isEmpty
                    ? null
                    : () => deleteSelected(),
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
                return ListView.builder(
                  physics: const AlwaysScrollableScrollPhysics(),
                  itemCount: 6,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12, top: 20),
                      child: Shimmer.fromColors(
                        baseColor: const Color(0xffF2F2F2),
                        highlightColor: const Color(0xffFBFBFB),
                        child: Container(
                          height: 100,
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 56,
                                height: 56,
                                decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(height: 14, width: double.infinity, color: Colors.white),
                                    const SizedBox(height: 8),
                                    Container(height: 12, width: 120, color: Colors.white),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              }
              if (state is ChatRoomsError) {
                return Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(state.message),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: () => context.read<ChatRoomsBloc>().add(
                          const GetChatRoomsE(),
                        ),
                        child: const Text("Qayta urinish"),
                      ),
                    ],
                  ),
                );
              }
              if (state is ChatRoomsSuccess) {
                final rooms = state.rooms;
                _roomsCache =rooms;
                if (rooms.isEmpty) {
                  return const Center(child: Text("Hozircha chatlar yo‘q"));
                }

                return ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: rooms.length,
                  separatorBuilder: (_, __) => const Divider(height: 24),
                  itemBuilder: (context, index) {
                    final room = rooms[index];
                    final lastText = onlyTextFromLastMessage(room.lastMessage);

                    // STAFF uchun peer = CUSTOMER
                    final peerName =
                        "${room.customer.firstName} ${room.customer.lastName}";
                    final peerImage = _normalizeImage(room.customer.image);

                    return _item(
                      room: room,
                      index: index,
                      name: peerName,
                      imageUrl: peerImage,
                      lastMessage: lastText.isEmpty ? "_" : lastText,
                      time: _formatTime(room.createdAt),
                      unread: _safeUnread(room.unreadedMessageCount),
                    );
                  },
                );
              }
              return const SizedBox.shrink();
            },
          ),
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
      onTap: () async {
        if (isSelectionMode) {
          toggleSelection(index);
          return;
        }

        await Navigator.pushNamed(
          context,
          RouteNames.chatWithCustomer,
          arguments: {"roomId": room.id, "name": name, "imageUrl": imageUrl},
        );

        //  Chat detail’dan back bo‘lib qaytgan zahoti listni yangilaymiz
        if (!context.mounted) return;
        context.read<ChatRoomsBloc>().add(const GetChatRoomsE());
      },
      child: Column(
        children: [
          Row(
            children: [
              if (isSelectionMode)
                Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: CircleAvatar(
                    radius: 12,
                    backgroundColor: isSelected
                        ? Colors.blue
                        : Colors.grey[300],
                    child: isSelected
                        ? const Icon(Icons.check, size: 14, color: Colors.white)
                        : null,
                  ),
                ),
              CircleAvatar(
                radius: 28,
                backgroundImage: (imageUrl != null)
                    ? NetworkImage(imageUrl)
                    : const AssetImage("assets/profile/per.png")
                          as ImageProvider,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
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
                  Text(
                    time,
                    style: const TextStyle(fontSize: 11, color: Colors.grey),
                  ),
                  const SizedBox(height: 6),
                  if (unread > 0)
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: const BoxDecoration(
                        color: Colors.blue,
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        unread.toString(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                        ),
                      ),
                    ),
                ],
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
