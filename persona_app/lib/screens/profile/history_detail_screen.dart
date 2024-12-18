import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../data/models/history_model.dart';
import '../../data/repositories/history_repository.dart';
import '../../router/app_router.dart';
import '../../data/datasource/local/history_local_datasource.dart';
import '../../data/datasource/remote/history_remote_datasource.dart';

class HistoryDetailScreen extends StatefulWidget {
  final History history;

  const HistoryDetailScreen({Key? key, required this.history})
      : super(key: key);

  @override
  _HistoryDetailScreenState createState() => _HistoryDetailScreenState();
}

class _HistoryDetailScreenState extends State<HistoryDetailScreen> {
  final TextEditingController _noteController = TextEditingController();
  final HistoryRepository _historyRepository = HistoryRepository(
    HistoryLocalDatasource(),
    HistoryRemoteDatasource(),
  );
  bool isEditing = false;

  @override
  void initState() {
    super.initState();
    _noteController.text = widget.history.note ?? '';
  }

  void _toggleEdit() {
    setState(() {
      isEditing = !isEditing;
    });
  }

  Future<void> _saveNote() async {
    try {
      await _historyRepository.updateHistoryNote(
        widget.history.id,
        _noteController.text,
      );
      setState(() {
        isEditing = false;
        widget.history.note = _noteController.text;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Note saved successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to save note')),
      );
    }
  }

  String _getFaceShapeName(int shapeId) {
    // Convert face shape ID to name
    Map<int, String> faceShapes = {
      1: 'Oval',
      2: 'Round',
      3: 'Square',
      4: 'Heart',
      5: 'Diamond',
      // Add more face shapes as needed
    };
    return faceShapes[shapeId] ?? 'Unknown';
  }

  String _getHairStyleName(int styleId) {
    Map<int, String> hairStyles = {
      // Male hairstyles
      1: 'Pompadour',
      2: 'Undercut',
      3: 'Comb-over fade',
      4: 'Man bun',
      5: 'French crop',
      6: 'High skin fade',
      7: 'Side part',
      8: 'Flat top',
      9: 'Side-swept brush-up',
      10: 'Buzzcut',
      11: 'Crew cut',
      12: 'Shoulder-length hair',
      13: 'Textured Quiff',

      // Female hairstyles
      14: 'Long layers',
      15: 'Bob cut',
      16: 'Side-swept bangs',
      17: 'Long layers with volume on top',
      18: 'Asymmetrical Bob',
      19: 'Pixie Cut with Volume',
      20: 'Soft, wispy bangs',
      21: 'Long, Soft layers',
      22: 'Side-parted styles',
      23: 'Long, side-swept bangs',
      24: 'Chin-length bob',
      25: 'Wavy lob',
    };
    return hairStyles[styleId] ?? 'Unknown Style';
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        context.go(RouteConstants.historyRoute);
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => context.go(RouteConstants.historyRoute),
          ),
          title: Text('History Detail', style: TextStyle(color: Colors.white)),
          actions: [
            if (!isEditing)
              IconButton(
                icon: Icon(Icons.edit, color: Colors.white),
                onPressed: _toggleEdit,
              )
            else
              IconButton(
                icon: Icon(Icons.save, color: Colors.white),
                onPressed: _saveNote,
              ),
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              // Face analysis popup
              _buildFaceAnalysisPopup(),

              // Image section
              Padding(
                padding: const EdgeInsets.all(15),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                    widget.history.prediction.image,
                    fit: BoxFit.cover,
                  ),
                ),
              ),

              // Note section
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Notes:',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    TextField(
                      controller: _noteController,
                      enabled: isEditing,
                      maxLines: 3,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: 'Add your notes here...',
                        hintStyle: TextStyle(color: Colors.grey),
                        border: OutlineInputBorder(),
                        enabled: isEditing,
                      ),
                    ),
                  ],
                ),
              ),
              // Navigation Buttons Section (Disabled)
              Container(
                padding: EdgeInsets.symmetric(vertical: 20),
                color: Colors.black,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // Hair Style Button
                    _buildSelectionButton(
                      'Hair Styles',
                      'assets/images/hairstyle.png',
                      widget.history.userSelection.selectedHairStyle,
                    ),
                    // Glasses Button
                    _buildSelectionButton(
                      'Glasses',
                      'assets/images/glasses.png',
                      widget.history.userSelection.selectedAccessories
                              .isNotEmpty
                          ? widget.history.userSelection.selectedAccessories[0]
                          : null,
                    ),
                    // Earrings Button (if applicable)
                    if (widget
                            .history.userSelection.selectedAccessories.length >
                        1)
                      _buildSelectionButton(
                        'Earrings',
                        'assets/images/accessorry.png',
                        widget.history.userSelection.selectedAccessories[1],
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFaceAnalysisPopup() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 224, 146, 146).withOpacity(0.9),
            borderRadius: BorderRadius.circular(25),
            boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 8)],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.face, color: Colors.white70),
              SizedBox(width: 8),
              Text(
                'Face Shape: ${_getFaceShapeName(widget.history.prediction.faceShape)}',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSelectionSection(String title, int selectedId) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Icon(
            title == 'Hairstyle' ? Icons.cut : Icons.accessibility,
            color: Colors.grey,
          ),
          SizedBox(width: 8),
          Text(
            '$title ID: $selectedId',
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildSelectionButton(String label, String imagePath, int? selectedId) {
  String getAccessoryName(int id) {
    Map<int, String> accessories = {
      // Glasses (Unisex)
      1: 'Transparent frames',
      2: 'Full-rimmed frames', 
      3: 'Wooden frames',
      4: 'Square glasses',
      5: 'Round glasses',
      6: 'Browline glasses',
      7: 'Colored oval glasses',
      8: 'Oval glasses',
      9: 'Semi-rimless',
      10: 'Rectangular glasses',

      // Earrings (Female)
      11: 'Hoop earrings',
      12: 'Teardrop earrings',
      13: 'Geometric earrings',
      14: 'Long dangle earrings',
      15: 'Circular earrings',
      16: 'Round or hoops earrings',
      17: 'Long and slender earrings',
      18: 'Teardrop earrings curved',
      19: 'Angular earrings',
      20: 'Wide hoop earrings',
      21: 'Wide cascading earrings',
      22: 'Curved circular earrings',
      23: 'Linear earrings',
      24: 'Chandelier earrings',
      25: 'Triangle earrings',
      26: 'Stud earrings',
    };
    return accessories[id] ?? 'Unknown Accessory';
  }

  return Column(
    children: [
      Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          border: Border.all(color: Colors.grey),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(25),
          child: Image.asset(
            imagePath,
            width: 50,
            height: 50,
            color: Colors.grey,
          ),
        ),
      ),
      SizedBox(height: 10),
      Text(
        label == 'Hair Styles' && selectedId != null
            ? _getHairStyleName(selectedId)
            : (selectedId != null ? getAccessoryName(selectedId) : label),
        style: TextStyle(color: Colors.grey, fontSize: 12),
        textAlign: TextAlign.center,
      ),
      if (selectedId != null)
        Text(
          '#$selectedId',
          style: TextStyle(color: Colors.grey, fontSize: 10),
        ),
    ],
  );
}
}
