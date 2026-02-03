import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tez_xizmat/core/di/services_locator.dart';
import 'package:tez_xizmat/features/auth/data/datasource/local/auth_local_data_source.dart';
import 'package:tez_xizmat/features/customer_chat/domain/entities/chat_message_entity.dart';
import 'package:tez_xizmat/features/customer_chat/presentation/bloc/chat_detail/chat_detail_bloc.dart';
import 'package:tez_xizmat/features/customer_chat/presentation/bloc/chat_detail/chat_detail_state.dart';
import 'package:tez_xizmat/features/customer_chat/presentation/bloc/chat_event.dart';

class ChatWithWorkerPage extends StatefulWidget {
  final int roomId;
  final String name;
  final String? imageUrl;

  const ChatWithWorkerPage({
    super.key,
    required this.roomId,
    required this.name,
    required this.imageUrl,
  });

  @override
  State<ChatWithWorkerPage> createState() => _ChatWithWorkerPageState();
}

class _ChatWithWorkerPageState extends State<ChatWithWorkerPage> {
  final ScrollController _scrollCtrl = ScrollController();
  bool _autoScroll = true;
  int _lastCount = 0;
  final TextEditingController _controller = TextEditingController();

  bool _isMeCustomer(ChatMessageEntity m) {
    // CUSTOMER UI: sender_type == "customer" bo‘lsa isMe = true
    return m.senderType == SenderType.customer;
  }

  late final ChatDetailBloc _chatBloc;

  @override
  void initState() {
    super.initState();
    _chatBloc = context.read<ChatDetailBloc>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final token = sl<AuthLocalDataSource>().getAccessToken() ?? '';
      _chatBloc.add(ChatOpenRoomE(roomId: widget.roomId, accessToken: token));
    });
    _scrollCtrl.addListener(() {
      if (!_scrollCtrl.hasClients) return;

      const threshold = 80.0; // pastdan 80px ichida bo‘lsa "bottom" deb olamiz
      final distanceToBottom =
          _scrollCtrl.position.maxScrollExtent - _scrollCtrl.offset;
      _autoScroll = distanceToBottom < threshold;
    });
  }

  @override
  void dispose() {
    _chatBloc.add(ChatDisconnectE());
    _controller.dispose();
    _scrollCtrl.dispose();
    super.dispose();
  }

  void _send() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    context.read<ChatDetailBloc>().add(
      ChatSendE(
        roomId: widget.roomId,
        text: text,
        senderType: SenderType.customer,
      ),
    );
    _controller.clear();
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
  }

  void _scrollToBottom({bool animated = true}) {
    if (!_scrollCtrl.hasClients) return;
    final target = _scrollCtrl.position.maxScrollExtent;

    if (animated) {
      _scrollCtrl.animateTo(
        target,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
      );
    } else {
      _scrollCtrl.jumpTo(target);
    }
  }

  @override
  Widget build(BuildContext context) {
    final avatarProvider = (widget.imageUrl != null)
        ? NetworkImage(widget.imageUrl!)
        : const AssetImage("assets/circular_avatar/profile.png")
              as ImageProvider;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios),
        ),
        title: Row(
          children: [
            CircleAvatar(radius: 25, backgroundImage: avatarProvider),
            SizedBox(width: 10.w),
            Text(
              widget.name,
              style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w700),
            ),
          ],
        ),
      ),
      backgroundColor: const Color(0xffF5F7FA),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 8),
            BlocConsumer<ChatDetailBloc, ChatDetailState>(
              listener: (context, state) {
                if (state is ChatDetailReady) {
                  final count = state.messages.length;

                  // Birinchi load bo'lganda ham pastga tushirib qo'yamiz
                  if (_lastCount == 0 && count > 0) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      _scrollToBottom(animated: false);
                    });
                  }

                  // Yangi message keldi
                  if (count > _lastCount) {
                    final last = state.messages.last;
                    final isMe = _isMeCustomer(last);

                    // Agar user pastda turgan bo'lsa yoki o'zi yozgan bo'lsa -> auto scroll
                    if (_autoScroll || isMe) {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        _scrollToBottom();
                      });
                    }
                  }

                  _lastCount = count;
                }
              },
              builder: (context, state) {
                if (state is ChatDetailLoading || state is ChatDetailInitial) {
                  return const Expanded(
                    child: Center(child: CircularProgressIndicator()),
                  );
                }

                if (state is ChatDetailError) {
                  return Expanded(child: Center(child: Text(state.message)));
                }

                if (state is ChatDetailReady) {
                  final messages = state.messages;

                  return Expanded(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          child: Align(
                            alignment: Alignment.center,
                            child: Text(
                              state.socketConnected ? "Online" : "Ulanish yo‘q",
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: ListView.builder(
                            controller: _scrollCtrl, //  mana shu kerak edi
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            itemCount: messages.length,
                            itemBuilder: (context, index) {
                              final msg = messages[index];
                              final isMe = _isMeCustomer(msg);

                              return _ChatBubble(
                                text: msg.text,
                                createdAt: msg.createdAt,
                                isMe: isMe,
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return const Expanded(child: SizedBox.shrink());
              },
            ),

            _buildInput(),
          ],
        ),
      ),
    );
  }

  Widget _buildInput() {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              maxLines: 5,
              minLines: 1,
              controller: _controller,
              decoration: InputDecoration(
                hintText: 'Yozing ...',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          InkWell(
            onTap: _send,
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.send, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}

class _ChatBubble extends StatelessWidget {
  final String text;
  final DateTime createdAt;
  final bool isMe;

  const _ChatBubble({
    required this.text,
    required this.createdAt,
    required this.isMe,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: isMe
            ? CrossAxisAlignment.end
            : CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.symmetric(vertical: 6),
            padding: const EdgeInsets.only(
              left: 20,
              right: 20,
              bottom: 20,
              top: 16,
            ),
            constraints: const BoxConstraints(maxWidth: 260),
            decoration: BoxDecoration(
              color: isMe ? Colors.blue : Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(16),
                topRight: const Radius.circular(16),
                bottomLeft: isMe ? const Radius.circular(16) : Radius.zero,
                bottomRight: isMe ? Radius.zero : const Radius.circular(16),
              ),
            ),
            child: Text(
              text,
              style: TextStyle(
                color: isMe ? Colors.white : Colors.black87,
                fontSize: 16.sp,
              ),
            ),
          ),
          Text(
            _formatTime(createdAt),
            style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
          ),
        ],
      ),
    );
  }

  String _formatTime(DateTime time) {
    return "${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}";
  }
}
