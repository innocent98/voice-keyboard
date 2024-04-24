import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:speech_to_text/speech_to_text.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final SpeechToText _speech = SpeechToText();
  bool _isListening = false;
  String _recognizedText = '';

  @override
  void initState() {
    super.initState();
    _initSpeech();
  }

  @override
  void dispose() {
    super.dispose();
    _speech.stop();
  }

  void _initSpeech() async {
    try {
      bool available = await _speech.initialize();
      if (available) {
        _speech.listen(onResult: (result) {
          setState(() {
            _recognizedText = result.recognizedWords;
          });
        });
      } else {
        // Handle speech recognition unavailable case (e.g., show a message)
        print('Speech recognition unavailable');
      }
    } on PlatformException catch (e) {
      // Handle platform-specific errors
      print('Platform error: ${e.code} - ${e.message}');
    }
  }

  void _toggleListening() async {
    _initSpeech(); // Call initialization first
    print(_isListening);
    if (!_isListening) {
      await _speech.listen(onResult: (result) {
        setState(() {
          _recognizedText = result.recognizedWords;
        });
      });
      setState(() => _isListening = true);
    } else {
      await _speech.stop();
      setState(() => _isListening = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: Scaffold(
          appBar: AppBar(
            title: const Text('Voiced Base Keyboard'),
          ),
          body: Column(
            children: [
              Expanded(
                child: TextField(
                  maxLines: null,
                  readOnly: true,
                  decoration: const InputDecoration(
                    hintText: 'Speak or type your text here',
                  ),
                  controller: TextEditingController(text: _recognizedText),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Standard keyboard buttons (can be implemented using a custom widget or keyboard library)
                  TextButton(
                    onPressed: () => print('Button 1 Pressed'),
                    child: const Text('Button 1'),
                  ),
                  TextButton(
                    onPressed: () => print('Button 2 Pressed'),
                    child: const Text('Button 2'),
                  ),
                  // ... more buttons
                  FloatingActionButton(
                    onPressed: _toggleListening,
                    child: Icon(_isListening ? Icons.mic : Icons.mic_off),
                  ),
                ],
              ),
            ],
          ),
        ));
  }
}
