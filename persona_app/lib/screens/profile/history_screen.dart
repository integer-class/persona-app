import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../data/datasource/local/prediction_local_datasource.dart';
import '../../data/datasource/remote/prediction_remote_datasource.dart';
import '../../data/repositories/prediction_repository.dart';
import '../../data/models/history_model.dart';
import '../../router/app_router.dart'; // Import the History model

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({Key? key}) : super(key: key);

  Future<List<History>> _fetchHistory() async {
    final predictionRepository = PredictionRepository(
      PredictionLocalDataSource(),
      PredictionRemoteDataSource(),
    );
    return await predictionRepository.getHistory();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        context.go(RouteConstants.profileRoute);
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('History'),
          backgroundColor: Colors.black87,
        ),
        body: FutureBuilder<List<History>>(
          future: _fetchHistory(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text('No history found'));
            } else {
              final histories = snapshot.data!;
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3, // 3 items per row
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 94 / 139, // Maintain the aspect ratio of 94x139
                  ),
                  itemCount: histories.length,
                  itemBuilder: (context, index) {
                    final history = histories[index];
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Image Container with fixed dimensions
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Container(
                            width: 94,
                            height: 139,
                            color: Colors.black12, // Fallback background color
                            child: Image.network(
                              history.prediction.image,
                              width: 94,
                              height: 139,
                              fit: BoxFit.cover, // Ensures the image fits within dimensions
                              errorBuilder: (context, error, stackTrace) {
                                // Placeholder if image fails to load
                                return Container(
                                  color: Colors.grey,
                                  child: const Center(
                                    child: Icon(
                                      Icons.broken_image,
                                      color: Colors.white,
                                      size: 30,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                        const SizedBox(height: 5),
                      ],
                    );
                  },
                ),
              );
            }
          },
        ),
        backgroundColor: Colors.black87, // Background color
      ),
    );
  }
}