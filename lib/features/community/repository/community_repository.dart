import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:reddit_clone/core/constants/firebase_constants.dart';
import 'package:reddit_clone/core/failure.dart';
import 'package:reddit_clone/core/providers/firebase_provider.dart';
import 'package:reddit_clone/core/type_defs.dart';
import 'package:reddit_clone/models/community_model.dart';

final communityRepositoryProvider = Provider((ref) {
  return CommunityRepository(firebaseFirestore: ref.watch(firestoreProvider));
});

class CommunityRepository {
  final FirebaseFirestore _firebaseFirestore;

  CommunityRepository({required FirebaseFirestore firebaseFirestore})
      : _firebaseFirestore = firebaseFirestore;

  FutureVoid createCommunity(CommunityModel communityModel) async {
    try {
      var communityDoc = await _communities.doc(communityModel.name).get();
      if (communityDoc.exists) {
        throw 'Community with the same name already exist!';
      }

      return right(
          _communities.doc(communityModel.name).set(communityModel.toMap()));
    } on FirebaseException catch (e) {
      return left(Failure(message: e.message!));
    }
  }

  Stream<List<CommunityModel>> getUserCommunities(String uid) {
    return _communities
        .where('members', arrayContains: uid)
        .snapshots()
        .map((event) {
      List<CommunityModel> userCommunities = [];
      for (var doc in event.docs) {
        userCommunities
            .add(CommunityModel.fromMap(doc.data() as Map<String, dynamic>));
      }
      return userCommunities;
    });
  }

  Stream<CommunityModel> getCommunityByName(String name) {
    return _communities.doc(name).snapshots().map((event) =>
        CommunityModel.fromMap(event.data() as Map<String, dynamic>));
  }

  CollectionReference get _communities =>
      _firebaseFirestore.collection(FirebaseConstants.communitiesCollection);
}
