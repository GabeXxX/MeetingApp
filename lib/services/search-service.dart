import 'package:algolia/algolia.dart';

class SearchService {
  static final Algolia algolia = Algolia.init(
    applicationId: 'O96XHQB7XU',
    apiKey: '2dd6debdeeaedd21fa5f6a7e053f0912',
  );

  Future<AlgoliaQuerySnapshot> searchUser(String name) async {
    Future<AlgoliaQuerySnapshot> querySnap =
        algolia.instance.index('user_data').search(name).getObjects();
    return querySnap;
  }
}
