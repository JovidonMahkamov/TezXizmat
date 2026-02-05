import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tez_xizmat/core/routes/route_names.dart';
import 'package:tez_xizmat/features/auth/presentation/widgets/elevated_button_widget.dart';
import 'package:tez_xizmat/features/customer_chat/domain/entities/chat_room_entity.dart';
import 'package:tez_xizmat/features/customer_chat/presentation/bloc/chat_delete/chat_delete_bloc.dart';
import 'package:tez_xizmat/features/customer_chat/presentation/bloc/chat_delete/chat_delete_state.dart';
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
  List<ChatRoomEntity> _roomsCache = [];
  bool _loadingDialogOpen = false;
  Timer? _pollTimer;


  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ChatRoomsBloc>().add(const GetChatRoomsE());
    });
    _startPolling();
  }

  @override
  void dispose() {
    _stopPolling();
    super.dispose();
  }

  void _startPolling() {
    _pollTimer?.cancel();
    _pollTimer = Timer.periodic(const Duration(seconds: 3), (_) {
      if (!mounted) return;
      if (isSelectionMode) return;
      context.read<ChatRoomsBloc>().add(const GetChatRoomsE(silent: true));
    });
  }

  void _stopPolling() {
    _pollTimer?.cancel();
    _pollTimer = null;
  }

  void showLoading() {
    if (_loadingDialogOpen) return;
    _loadingDialogOpen = true;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );
  }

  void hideLoading() {
    if (!_loadingDialogOpen) return;
    _loadingDialogOpen = false;
    if (Navigator.canPop(context)) Navigator.pop(context);
  }

  void clearSelection() {
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
        backgroundColor: Colors.white,
        title: const Text("Chatni o‘chirish", style: TextStyle(fontWeight: FontWeight.w500),),
        content: Text("${roomIds.length} ta chatni o‘chirmoqchimisiz?", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),),
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
              SizedBox(width: 10,),
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

    // ❗️MUHIM: UI’ni hozircha tozalab qo‘ymaymiz, success bo‘lsa keyin tozalaymiz
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
              showLoading();
            } else {
              hideLoading();
            }

            if (state is ChatDeleteSuccess) {
              if (Navigator.canPop(context))
                Navigator.pop(context); // loading dialog yopish

              setState(() {
                selectedIndexes.clear();
                isSelectionMode = false;
              });

              // listni yangilab olamiz
              context.read<ChatRoomsBloc>().add(const GetChatRoomsE());

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("${state.deletedCount} ta chat o‘chirildi"),
                ),
              );
            }

            if (state is ChatDeleteError) {
              if (Navigator.canPop(context))
                Navigator.pop(context); // loading dialog yopish
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(state.message)));
            }
          },
        ),
      ],
      child: Scaffold(
        backgroundColor: Colors.white30,
        appBar: AppBar(
          backgroundColor: Colors.white,
          automaticallyImplyLeading: false,
          centerTitle: true,
          title: Text(
            isSelectionMode ? '${selectedIndexes.length} tanlangan' : 'Chatlar',
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 20),
              child: IconButton(
                onPressed: () {
                  if (!isSelectionMode) {
                    setState(() => isSelectionMode = true);
                    return;
                  }

                  if (selectedIndexes.isEmpty) {
                    clearSelection(); // selectiondan chiqish
                  } else {
                    deleteSelected(); // o‘chirish
                  }
                },
                icon: SvgPicture.asset(
                  "assets/home/delete.svg",
                  width: 30,
                  height: 30,
                  colorFilter: ColorFilter.mode(
                    isSelectionMode ? Colors.red : Colors.black,
                    BlendMode.srcIn,
                  ),
                ),
                tooltip: !isSelectionMode
                    ? "Tanlash"
                    : (selectedIndexes.isEmpty ? "Bekor qilish" : "O‘chirish"),
              ),
            ),
          ],

        ),
        body: BlocBuilder<ChatRoomsBloc, ChatRoomsState>(
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
              _roomsCache = rooms;
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
                  final peerName =
                      "${room.staff.firstName} ${room.staff.lastName}";
                  final peerImage = _normalizeImage(room.staff.image);
                  final lastText = onlyTextFromLastMessage(room.lastMessage);

                  return _chatItem(
                    context: context,
                    room: room,
                    index: index,
                    title: peerName,
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
      onTap: () async {
        if (isSelectionMode) {
          toggleSelection(index);
          return;
        }

        await Navigator.pushNamed(
          context,
          RouteNames.chatWithWorker,
          arguments: {"roomId": room.id, "name": title, "imageUrl": imageUrl},
        );

        // ✅ Chat detail’dan back bo‘lib qaytgan zahoti listni yangilaymiz
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
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w700,
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
