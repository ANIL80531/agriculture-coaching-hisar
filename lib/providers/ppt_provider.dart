import 'package:flutter/material.dart';
import '../models/ppt_model.dart';
import '../services/mock_database.dart';
import '../services/storage_service.dart';

class PptProvider extends ChangeNotifier {
  List<PptDeck> _decks = [];
  PptDeck? _activeDeck;
  int _currentSlideIndex = 0;
  bool _isFullScreen = false;
  bool _showNotes = true;

  List<PptDeck> get decks => _decks;
  PptDeck? get activeDeck => _activeDeck;
  int get currentSlideIndex => _currentSlideIndex;
  bool get isFullScreen => _isFullScreen;
  bool get showNotes => _showNotes;

  PptSlide? get currentSlide {
    if (_activeDeck == null || _activeDeck!.slides.isEmpty) return null;
    if (_currentSlideIndex >= 0 && _currentSlideIndex < _activeDeck!.slides.length) {
      return _activeDeck!.slides[_currentSlideIndex];
    }
    return null;
  }

  PptProvider() {
    _loadDecks();
  }

  Future<void> _loadDecks() async {
    final initial = MockDatabase.getInitialPptDecks();
    final custom = await StorageService.getSharedPpts();
    _decks = [...custom, ...initial];
    notifyListeners();
  }

  PptDeck? getDeckById(String deckId) {
    try {
      return _decks.firstWhere((d) => d.id == deckId);
    } catch (_) {
      return null;
    }
  }

  List<PptDeck> getDecksForCourse(String courseId) {
    return _decks.where((d) => d.courseId == courseId).toList();
  }

  // --- Presentation Viewer Controls ---

  void openDeck(PptDeck deck) {
    _activeDeck = deck;
    _currentSlideIndex = 0;
    _isFullScreen = false;
    _showNotes = true;
    notifyListeners();
  }

  void closeDeck() {
    _activeDeck = null;
    _currentSlideIndex = 0;
    _isFullScreen = false;
    notifyListeners();
  }

  void nextSlide() {
    if (_activeDeck != null && _currentSlideIndex < _activeDeck!.slides.length - 1) {
      _currentSlideIndex++;
      notifyListeners();
    }
  }

  void previousSlide() {
    if (_currentSlideIndex > 0) {
      _currentSlideIndex--;
      notifyListeners();
    }
  }

  void goToSlide(int index) {
    if (_activeDeck != null && index >= 0 && index < _activeDeck!.slides.length) {
      _currentSlideIndex = index;
      notifyListeners();
    }
  }

  void toggleFullScreen() {
    _isFullScreen = !_isFullScreen;
    notifyListeners();
  }

  void toggleNotes() {
    _showNotes = !_showNotes;
    notifyListeners();
  }

  // --- Educator PPT Upload / Sharing ---

  Future<void> sharePptDeck(PptDeck newDeck) async {
    _decks.insert(0, newDeck);
    final customList = _decks.where((d) => !d.id.startsWith('ppt_1')).toList();
    await StorageService.saveSharedPpts(customList);
    notifyListeners();
  }
}
