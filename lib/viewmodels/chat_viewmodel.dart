import 'package:flutter/foundation.dart';
import 'package:record/record.dart';
import 'package:audioplayers/audioplayers.dart';
import '../models/chat_model.dart';
import '../services/api_service.dart';

class ChatViewModel extends ChangeNotifier {
  final ApiService _apiService;
  final AudioPlayer _audioPlayer = AudioPlayer();
  final AudioRecorder _audioRecorder = AudioRecorder();

  final List<ChatMessage> _messages = [];
  bool _isSending = false;
  bool _isRecording = false;
  bool _isPlaying = false;
  String? _recordingPath;

  ChatViewModel({ApiService? apiService})
      : _apiService = apiService ?? ApiService() {
    _initDefaultGreeting();
  }

  List<ChatMessage> get messages => _messages;
  bool get isSending => _isSending;
  bool get isRecording => _isRecording;
  bool get isPlaying => _isPlaying;

  void _initDefaultGreeting() {
    _messages.add(
      ChatMessage(
        id: 'greet_1',
        text: 'नमस्कार! मी किसानमित्र कृषी AI सहाय्यक आहे. आपण बाजारभाव, पीक रोग, फवारणीच्या वेळा किंवा खतांबद्दल मराठी, हिंदी अथवा इंग्रजीत विचारू शकता.',
        isUser: false,
        timestamp: DateTime.now(),
        quickReplies: [
          'आजचा सोयाबीन बाजारभाव',
          'फवारणीसाठी हवामान अनुकूल आहे का?',
          'सोयाबीनवरील तांबेरा औषध',
          'मातीतील युरिया प्रमाण',
        ],
      ),
    );
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

  // Voice recording
  Future<void> startRecording() async {
    try {
      if (await _audioRecorder.hasPermission()) {
        _isRecording = true;
        notifyListeners();
        // Record voice note
        await _audioRecorder.start(const RecordConfig(), path: '');
      }
    } catch (e) {
      print('[ChatViewModel] startRecording error: $e');
      _isRecording = false;
      notifyListeners();
    }
  }

  Future<void> stopRecordingAndSend(String locale) async {
    try {
      final path = await _audioRecorder.stop();
      _isRecording = false;
      notifyListeners();

      if (path != null) {
        _recordingPath = path;
        // In full app, send voice audio to /stt or directly to /chat
        // For demonstration, send voice transcribed query
        await sendMessage('आजचा कोल्हापूर व सांगली सोयाबीन बाजारभाव काय आहे?', locale);
      }
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
    _audioRecorder.dispose();
    super.dispose();
  }
}
