import 'package:calisma3/data/repositories/dashboard_repository.dart';
import 'package:calisma3/data/models/post_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final dashboardControllerProvider = Provider((ref) => DashboardController(
    dashboardRepository: ref.watch(dashboardRepositoryProvider)));

class DashboardController {
  final DashboardRepository dashboardRepository;

  DashboardController({required this.dashboardRepository});

  Future<void> storePostInfoToFirebase(PostModel postModel) async {
    return dashboardRepository.storePostInfoToFirebase(postModel);
  }

  Future<List<PostModel>> fetchPosts() async {
    return dashboardRepository.fetchPosts();
  }

  Future<void> deletePost(PostModel postModel) async {
    return dashboardRepository.deletePost(postModel);
  }
}
