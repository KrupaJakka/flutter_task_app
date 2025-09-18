import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shimmer/shimmer.dart';
import '../data/assessment_model.dart';
import '../data/assessment_repository.dart';
import 'assessment_detail_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final assessmentsProvider = StreamProvider<List<Assessment>>((ref) {
  final repo = AssessmentRepository(FirebaseFirestore.instance);
  return repo.getAssessments(limit: 20);
});

class AssessmentListScreen extends ConsumerWidget {
  const AssessmentListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final assessmentsAsync = ref.watch(assessmentsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Assessments')),
      body: assessmentsAsync.when(
        data: (assessments) => RefreshIndicator(
          onRefresh: () async {
            ref.refresh(assessmentsProvider);
          },
          child: ListView.builder(
            itemCount: assessments.length,
            itemBuilder: (context, index) {
              final item = assessments[index];
              return ListTile(
                leading: Hero(
                  tag: item.id,
                  child: Image.network(
                    item.imageUrl,
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  ),
                ),
                title: Text(item.title),
                subtitle: Text(
                  item.description,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => AssessmentDetailScreen(assessment: item),
                  ),
                ),
              );
            },
          ),
        ),
        loading: () => ListView.builder(
          itemCount: 6,
          itemBuilder: (context, index) => Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: ListTile(
              leading: Container(width: 50, height: 50, color: Colors.white),
              title: Container(width: 100, height: 10, color: Colors.white),
              subtitle: Container(width: 150, height: 10, color: Colors.white),
            ),
          ),
        ),
        error: (err, _) => Center(child: Text('Error: $err')),
      ),
    );
  }
}
