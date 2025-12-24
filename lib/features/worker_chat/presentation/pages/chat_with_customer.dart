/// workerning bitta user chati
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tez_xizmat/features/auth/presentation/widgets/elevated_button_widget.dart';
import 'package:tez_xizmat/features/auth/presentation/widgets/text_field_widget_2.dart';
import 'package:tez_xizmat/features/customer_chat/presentation/widgets/chat_bubble_widget.dart';
import 'package:tez_xizmat/features/customer_chat/presentation/widgets/chat_message.dart';

class ChatWithCustomerPage extends StatefulWidget {
  final String name;
  final String urlAsset;
  const ChatWithCustomerPage({super.key, required this.name, required this.urlAsset});

  @override
  State<ChatWithCustomerPage> createState() => _ChatWithWorkerPageState();
}

class _ChatWithWorkerPageState extends State<ChatWithCustomerPage> {
  final TextEditingController _controller = TextEditingController();

  final List<ChatMessage> messages = [
    ChatMessage(
      id: '1',
      text: 'Salom!',
      createdAt: DateTime.now().subtract(const Duration(minutes: 5)),
      isMe: true,
    ),
    ChatMessage(
      id: '2',
      text: 'Salom! Qanday muammo bor?',
      createdAt: DateTime.now().subtract(const Duration(minutes: 4)),
      isMe: false,
    ),
    ChatMessage(
      id: '3',
      text: 'Kranni ta’mirlash kerak edi',
      createdAt: DateTime.now().subtract(const Duration(minutes: 3)),
      isMe: true,
    ),
  ];
  String? lastSentMessage;

  void sendMessage() {
    if (_controller.text.trim().isEmpty) return;

    setState(() {
      lastSentMessage = _controller.text;

      messages.add(
        ChatMessage(
          id: DateTime.now().toString(),
          text: _controller.text,
          createdAt: DateTime.now(),
          isMe: true,
        ),
      );
    });

    _controller.clear();
  }


  void deleteMessage(int index) {
    setState(() {
      messages.removeAt(index);
    });

    /// 🔌 WebSocket:
    /// socket.send({"type":"delete","id":message.id});
  }
  void editMessage(ChatMessage message) {
    final controller = TextEditingController(text: message.text);

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: Colors.white,
        title:  Text('Xabarni tahrirlash',style: TextStyle(fontSize: 18.sp,fontWeight: FontWeight.w600),),
        content: TextFieldWidgetTwo(text: "", obscureText: false,controller: controller,maxLine: 5,mixLine: 1,),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Bekor',style: TextStyle(color: Colors.red),),
          ),
          SizedBox(width: 30.w,),
          ElevatedWidget(
            onPressed: (){setState(() {
              message.text = controller.text;
            });
            Navigator.pop(context);}, text: "Saqlash",size: 150, backgroundColor: Color(0xff1778F2), textColor:  Colors.white,),
        ],
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(
              context,
              {
                "lastMessage": lastSentMessage ?? messages.last.text,
                "time": TimeOfDay.now().format(context),
              },
            );
          },
          icon: const Icon(Icons.arrow_back_ios),
        ),
        title: Row(
          children: [
            CircleAvatar(
              radius: 25,
              backgroundImage: AssetImage(widget.urlAsset),
            ),
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
            _buildDateHeader(),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  final msg = messages[index];
                  return ChatBubble(
                    message: msg,
                    onDelete: () => deleteMessage(index),
                    onEdit: () => editMessage(msg),
                  );
                },
              ),
            ),

            _buildInput(),
          ],
        ),
      ),
    );
  }

  Widget _buildDateHeader() {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Text(
        'December 25, 2025',
        style: TextStyle(color: Colors.grey.shade600),
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
            onTap: sendMessage,
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.send, color: Colors.white),
            ),
          )
        ],
      ),
    );
  }
}
