import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/assessment_model.dart';

class AssessmentDetailScreen extends StatefulWidget {
  final Assessment assessment;

  const AssessmentDetailScreen({super.key, required this.assessment});

  @override
  State<AssessmentDetailScreen> createState() => _AssessmentDetailScreenState();
}

class _AssessmentDetailScreenState extends State<AssessmentDetailScreen> {
  bool isFavorite = false;

  @override
  void initState() {
    super.initState();
    _loadFavorite();
  }

  Future<void> _loadFavorite() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      isFavorite = prefs.getBool('fav_${widget.assessment.id}') ?? false;
    });
  }

  Future<void> _toggleFavorite() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      isFavorite = !isFavorite;
      prefs.setBool('fav_${widget.assessment.id}', isFavorite);
    });
  }

  @override
  Widget build(BuildContext context) {
    final a = widget.assessment;

    return Scaffold(
      appBar: AppBar(title: Text(a.title)),
      body: Column(
        children: [
          Hero(
            tag: a.id,
            child: Image.network(a.imageUrl, height: 200, fit: BoxFit.cover),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(a.description),
          ),
          IconButton(
            icon: Icon(
              isFavorite ? Icons.favorite : Icons.favorite_border,
              color: Colors.red,
            ),
            onPressed: _toggleFavorite,
          ),
        ],
      ),
    );
  }
}
