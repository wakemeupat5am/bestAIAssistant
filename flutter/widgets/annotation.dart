import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _controller = TextEditingController();
  final List<String> _messages = [];
  late AnimatedListState _animatedList;

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      setState(() {});
    });
  }

  Future<void> _sendMessage() async {
    final message = _controller.text;
    if (message.isNotEmpty) {
      _messages.add('Я: $message');
      _controller.clear();
      setState(() {});

      // Simulate Bot response delay
      await Future.delayed(Duration(seconds: 1));

      final response = await http.post(
        Uri.parse('YOUR_BOT_API_ENDPOINT'),
        body: {'message': message},
      );

      if (response.statusCode == 200) {
        _messages.add('Гоби: ${response.body}');
      } else {
        _messages.add('Bot: Error - Failed to send message');
      }

      _animatedList.insertItem(_messages.length - 1);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(23, 23, 23, 1),
      appBar: AppBar(
        title: Text('Гоби'),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
                colors: [
                 Color.fromRGBO(187, 252, 32, 1), 
                 Color.fromRGBO(48, 224, 76, 1),
                 Color.fromRGBO(114, 235, 62, 1),
                ],
            ),
          ),
        ),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: AnimatedList(
              key: GlobalKey<AnimatedListState>(),
              initialItemCount: _messages.length,
              itemBuilder: (context, index, animation) {
                return SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(1, 0),
                    end: Offset.zero,
                  ).animate(animation),
                  child: ListTile(
                    title: Container(
                      padding: EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      child: Text(_messages[index], 
                                  style: const TextStyle(
                                    color: Color.fromRGBO(144, 144, 144, 1)),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              children: <Widget>[
                Expanded(  
                  child: TextField(
                    cursorColor: const Color.fromRGBO(144, 144, 144, 1),
                    style: const TextStyle(
                      color: Color.fromRGBO(144, 144, 144, 1),
                    ),
                    controller: _controller,
                    decoration: const InputDecoration(
                      fillColor: Color.fromRGBO(16, 16, 16, 1),  // цвет фона TextField
                      filled: true,
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Color.fromRGBO(16, 16, 16, 1)),  // цвет подчеркивания при фокусе
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Color.fromRGBO(16, 16, 16, 1)),  // цвет подчеркивания при отсутствии фокуса
                      ),
                  ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: _sendMessage,
                  style: ButtonStyle(
                    foregroundColor: MaterialStatePropertyAll(Color.fromRGBO(144, 144, 144, 1))
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
