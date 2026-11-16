import 'package:flutter/foundation.dart';
import 'package:audioplayers/audioplayers.dart';
import '../models/chat_model.dart';
import '../services/api_service.dart';

class ChatViewModel extends ChangeNotifier {
  final ApiService _apiService;
  final AudioPlayer _audioPlayer = AudioPlayer();

  final List<ChatMessage> _messages = [];
  bool _isSending = false;
  bool _isRecording = false;
  bool _isPlaying = false;

  ChatViewModel({ApiService? apiService})
      : _apiService = apiService ?? ApiService() {
    _initDefaultGreeting();
  }

  List<ChatMessage> get messages => _messages;
  bool get isSending => _isSending;
  bool get isRecording => _isRecording;
  bool get isPlaying => _isPlaying;

  void _initDefaultGreeting() {
    initGreetingForLocale('mr');
  }

  void initGreetingForLocale(String locale) {
    if (_messages.isNotEmpty && _messages.first.id == 'greet_1') {
      _messages.removeAt(0);
    }
    final isEn = locale == 'en';
    final isHi = locale == 'hi';

    _messages.insert(
      0,
      ChatMessage(
        id: 'greet_1',
        text: isEn
            ? 'Hello! I am KisanMitra AI farming assistant. You can ask me about mandi prices, crop diseases, spray timings, or fertilizers in your preferred language.'
            : isHi
                ? 'नमस्ते! मैं किसानमित्र कृषि AI सहायक हूँ। आप मंडी भाव, फसल रोग, छिड़काव समय और खाद के बारे में पूछ सकते हैं।'
                : 'नमस्कार! मी किसानमित्र कृषी AI सहाय्यक आहे. आपण बाजारभाव, पीक रोग, फवारणीच्या वेळा किंवा खतांबद्दल मराठी, हिंदी अथवा इंग्रजीत विचारू शकता.',
        isUser: false,
        timestamp: DateTime.now(),
        quickReplies: isEn
            ? [
                "Today's Soybean Mandi Rate",
                'Is weather safe for spraying now?',
                'Soybean Rust treatment',
                'Urea dosage per acre',
              ]
            : isHi
                ? [
                    'आज का सोयाबीन मंडी भाव',
                    'क्या अभी छिड़काव के लिए मौसम सुरक्षित है?',
                    'सोयाबीन रस्ट रोग का इलाज',
                    'खेत में यूरिया की मात्रा',
                  ]
                : [
                    'आजचा सोयाबीन बाजारभाव',
                    'फवारणीसाठी हवामान अनुकूल आहे का?',
                    'सोयाबीनवरील तांबेरा औषध',
                    'मातीतील युरिया प्रमाण',
                  ],
      ),
    );
    notifyListeners();
  }

  Future<void> sendMessage(String text, String locale) async {
    final trimmed = text.trim();
    if (trimmed.isEmpty) return;

    // Add user message immediately
    final userMsg = ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      text: trimmed,
      isUser: true,
      timestamp: DateTime.now(),
    );
    _messages.add(userMsg);
    _isSending = true;
    notifyListeners();

    try {
      final history = _messages
          .take(6)
          .map((m) => {'role': m.isUser ? 'user' : 'assistant', 'content': m.text})
          .toList();

      final reply = await _apiService.sendChatMessage(
        message: trimmed,
        locale: locale,
        history: history,
      );

      _messages.add(reply);
    } catch (e) {
      _messages.add(
        ChatMessage(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          text: 'माफ करा, उत्तर मिळवण्यात अडचण आली. कृपया पुन्हा प्रयत्न करा.',
          isUser: false,
          timestamp: DateTime.now(),
        ),
      );
    } finally {
      _isSending = false;
      notifyListeners();
    }
  }

  // Voice recording simulation
  Future<void> startRecording() async {
    try {
      _isRecording = true;
      notifyListeners();
    } catch (e) {
      _isRecording = false;
      notifyListeners();
    }
  }

  Future<void> stopRecordingAndSend(String locale) async {
    try {
      _isRecording = false;
      notifyListeners();
      // Send voice transcribed query
      await sendMessage('आजचा कोल्हापूर व सांगली सोयाबीन बाजारभाव काय आहे?', locale);
    } catch (e) {
      _isRecording = false;
      notifyListeners();
    }
  }

  Future<void> playAudio(String url) async {
    try {
      _isPlaying = true;
      notifyListeners();
      await _audioPlayer.play(UrlSource(url));
      _audioPlayer.onPlayerComplete.listen((_) {
        _isPlaying = false;
        notifyListeners();
      });
    } catch (e) {
      _isPlaying = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }
}
