import 'package:flutter/material.dart';
import '../../data/models/feedback_model.dart';
import '../../data/models/history_model.dart';
import '../../data/repositories/history_repository.dart';
import '../../data/datasource/remote/feedback_remote_datasource.dart';
import '../../data/datasource/local/history_local_datasource.dart';
import '../../data/datasource/remote/history_remote_datasource.dart';

class FeedbackScreen extends StatefulWidget {
  const FeedbackScreen({Key? key}) : super(key: key);

  @override
  State<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  final _feedbackController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _pageController = PageController();
  int _rating = 0;
  int _currentHistoryIndex = 0;
  List<History> _histories = [];
  bool _isLoading = true;
  
  final HistoryRepository _historyRepository = HistoryRepository(
    HistoryLocalDatasource(),
    HistoryRemoteDatasource(),
  );
  final FeedbackRemoteDataSource _feedbackRemoteDataSource = FeedbackRemoteDataSource();

  @override
  void initState() {
    super.initState();
    _loadHistories();
  }

  Future<void> _loadHistories() async {
    try {
      final histories = await _historyRepository.getHistory();
      setState(() {
        _histories = histories;
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading histories: $e');
      setState(() => _isLoading = false);
    }
  }

  String _getFaceShapeName(int shapeId) {
    final Map<int, String> shapes = {
      1: 'Oval',
      2: 'Round',
      3: 'Square',
      4: 'Heart',
      5: 'Oblong',
    };
    return shapes[shapeId] ?? 'Unknown';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: const Text(
          'Feedback',
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: _isLoading 
        ? const Center(child: CircularProgressIndicator())
        : _histories.isEmpty
        ? const Center(
            child: Text('No history found to give feedback on'),
          )
        : SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // History Carousel
                  Container(
                    height: 300,
                    child: PageView.builder(
                      controller: _pageController,
                      itemCount: _histories.length,
                      onPageChanged: (index) {
                        setState(() => _currentHistoryIndex = index);
                      },
                      itemBuilder: (context, index) {
                        final history = _histories[index];
                        return Card(
                          elevation: 4,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Prediction Image
                              Expanded(
                                child: ClipRRect(
                                  borderRadius: const BorderRadius.vertical(
                                    top: Radius.circular(4),
                                  ),
                                  child: Image.network(
                                    history.prediction.image,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              // Details
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Face Shape: ${_getFaceShapeName(history.prediction.faceShape)}',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      'Created: ${history.createdAt.toString().split(' ')[0]}',
                                      style: TextStyle(
                                        color: Colors.grey[600],
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  // Page Indicator
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      _histories.length,
                      (index) => Container(
                        width: 8,
                        height: 8,
                        margin: const EdgeInsets.symmetric(
                          vertical: 16,
                          horizontal: 4,
                        ),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _currentHistoryIndex == index
                              ? Colors.black87
                              : Colors.grey,
                        ),
                      ),
                    ),
                  ),
                  const Text(
                    'Rate your experience',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(5, (index) {
                      return IconButton(
                        icon: Icon(
                          index < _rating ? Icons.star : Icons.star_border,
                          color: Colors.amber,
                          size: 32,
                        ),
                        onPressed: () => setState(() => _rating = index + 1),
                      );
                    }),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _feedbackController,
                    maxLines: 5,
                    decoration: const InputDecoration(
                      hintText: 'Share your feedback about this recommendation...',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your feedback';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _submitFeedback,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black87,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text('Submit Feedback'),
                    ),
                  ),
                ],
              ),
            ),
          ),
    );
  }

  Future<void> _submitFeedback() async {
    if (_formKey.currentState!.validate() && _rating > 0) {
      try {
        final selectedHistory = _histories[_currentHistoryIndex];
        await _feedbackRemoteDataSource.submitFeedback(
          FeedbackModel(
            recommendationId: selectedHistory.userSelection.recommendation,
            comment: _feedbackController.text,
            rating: _rating,
          ),
        );
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Thank you for your feedback!')),
          );
          Navigator.pop(context);
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to submit feedback')),
          );
        }
      }
    }
  }
}