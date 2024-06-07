import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:search/widgets/annotation.dart';

class MainApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _controller = TextEditingController();

  // Future<void> _sendData() async {
  //   final response = await http.post(
  //     Uri.parse('YOUR_API_ENDPOINT'),
  //     body: {'data': _controller.text},
  //   );

  //   if (response.statusCode == 200) {
  //     Navigator.push(
  //       context,
  //       MaterialPageRoute(builder: (context) => Annotation()),
  //     );
  //   } else {
  //     throw Exception('Failed to send data');
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(8, 8, 8, 1),
      body: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Center(
          child: Container(
            height: 200,
            padding: EdgeInsets.all(8.0),
            decoration: BoxDecoration(
                gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                       Color.fromRGBO(187, 252, 32, 1), 
                       Color.fromRGBO(48, 224, 76, 1),
                        Color.fromRGBO(114, 235, 62, 1),
                      ],
              ),
              border: Border.all(color: Colors.black45),
              borderRadius: BorderRadius.circular(45.0),
            ),
            child: Column(
              children: [
                Spacer(),
                Text("Введите тему", 
                      style: TextStyle(
                           fontSize: 22, 
                           fontWeight: FontWeight.bold
                ),),
                Spacer(),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                        child: TextField(
                          controller: _controller,
                          style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 15
                          ),
                          decoration: const InputDecoration(
                                border: InputBorder.none,
                                labelStyle: TextStyle(
                            color: Colors.green,  // цвет метки
                          ),
                              hintStyle: TextStyle(
                                fontWeight: FontWeight.normal,
                                color: Colors.black,  // цвет подсказки
                          ),
                          hintText: "Да-да, писать сюда"
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.send),
                        onPressed: (){
                             Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => ChatPage()),
                              );
                        }, //_sendData,
                        style: ButtonStyle(
                          foregroundColor: MaterialStatePropertyAll(Colors.black)
                        ),
                      ),
                    ],
                  ),
                ),
                Spacer(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
