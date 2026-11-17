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

    String greetingText;
    List<String> replies;

    switch (locale) {
      case 'te':
        greetingText = 'నమస్కారం! నేను కిసాన్ మిత్ర వ్యవసాయ AI సహాయకుడిని. మార్కెట్ ధరలు, పంట తెగుళ్ళు, స్ప్రే సమయాలు లేదా ఎరువుల గురించి నన్ను అడగండి.';
        replies = [
          'ఈరోజు సోయాబీన్ మార్కెట్ రేటు',
          'ఇప్పుడు మందు పిచికారీ చేయడానికి వాతావరణం సురక్షితమేనా?',
          'తెగుళ్ల నివారణ మందులు',
          'ఎకరాకు యూరియా మోతాదు',
        ];
        break;
      case 'kn':
        greetingText = 'ನಮಸ್ಕಾರ! ನಾನು ಕಿಸಾನ್ ಮಿತ್ರ ಕೃಷಿ AI ಸಹಾಯಕ. ನೀವು ಮಾರುಕಟ್ಟೆ ದರಗಳು, ಬೆಳೆ ರೋಗಗಳು, ಸಿಂಪಡಣೆ ಸಮಯ ಅಥವಾ ರಸಗೊಬ್ಬರಗಳ ಬಗ್ಗೆ ಕೇಳಬಹುದು.';
        replies = [
          'ಇಂದಿನ ಸೋಯಾಬೀನ್ ಮಾರುಕಟ್ಟೆ ದರ',
          'ಈಗ ಸಿಂಪಡಿಸಲು ಹವಾಮಾನ ಸೂಕ್ತವೇ?',
          'ಬೆಳೆ ರೋಗ ನಿಯಂತ್ರಣ',
          'ಎಕರೆಗೆ ಯೂರಿಯಾ ಪ್ರಮಾಣ',
        ];
        break;
      case 'gu':
        greetingText = 'નમસ્તે! હું કિસાનમિત્ર કૃષિ AI સહાયક છું. તમે બજાર ભાવ, પાકના રોગ, છંટકાવનો સમય અથવા ખાતર વિશે પૂછી શકો છો.';
        replies = [
          'આજનો સોયાબીન બજાર ભાવ',
          'શું અત્યારે છંટકાવ માટે હવામાન અનુકૂળ છે?',
          'પાક રોગ નિયંત્રણ દવા',
          'એકર દીઠ યુરિયા ખાતરની માત્રા',
        ];
        break;
      case 'hi':
        greetingText = 'नमस्ते! मैं किसानमित्र कृषि AI सहायक हूँ। आप मंडी भाव, फसल रोग, छिड़काव समय और खाद के बारे में पूछ सकते हैं।';
        replies = [
          'आज का सोयाबीन मंडी भाव',
          'क्या अभी छिड़काव के लिए मौसम सुरक्षित है?',
          'सोयाबीन रस्ट रोग का इलाज',
          'खेत में यूरिया की मात्रा',
        ];
        break;
      case 'mr':
        greetingText = 'नमस्कार! मी किसानमित्र कृषी AI सहाय्यक आहे. आपण बाजारभाव, पीक रोग, फवारणीच्या वेळा किंवा खतांबद्दल मराठी, हिंदी अथवा इंग्रजीत विचारू शकता.';
        replies = [
          'आजचा सोयाबीन बाजारभाव',
          'फवारणीसाठी हवामान अनुकूल आहे का?',
          'सोयाबीनवरील तांबेरा औषध',
          'मातीतील युरिया प्रमाण',
        ];
        break;
      case 'en':
      default:
        greetingText = 'Hello! I am KisanMitra AI farming assistant. You can ask me about mandi prices, crop diseases, spray timings, or fertilizers in your preferred language.';
        replies = [
          "Today's Soybean Mandi Rate",
          'Is weather safe for spraying now?',
          'Soybean Rust treatment',
          'Urea dosage per acre',
        ];
        break;
    }

    _messages.insert(
      0,
      ChatMessage(
        id: 'greet_1',
        text: greetingText,
        isUser: false,
        timestamp: DateTime.now(),
        quickReplies: replies,
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
