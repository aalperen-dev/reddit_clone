import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:reddit_clone/core/constants/firebase_constants.dart';
import 'package:reddit_clone/core/providers/firebase_provider.dart';
import 'package:reddit_clone/core/type_defs.dart';
import 'package:reddit_clone/models/comment_model.dart';
import 'package:reddit_clone/models/post_model.dart';

import '../../../core/failure.dart';
import '../../../models/community_model.dart';

final postRepositoryProvider = Provider((ref) {
  return PostRepository(firestore: ref.watch(firestoreProvider));
});

class PostRepository {
  final FirebaseFirestore _firestore;

  PostRepository({
    required FirebaseFirestore firestore,
  }) : _firestore = firestore;

  FutureVoid addPost(PostModel post) async {
    try {
      return right(
        _posts.doc(post.id).set(post.toMap()),
      );
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(
        Failure(
          message: e.toString(),
        ),
      );
    }
  }

  Stream<List<PostModel>> fetchUserPosts(
    List<CommunityModel> communities,
  ) {
    return _posts
        .where('communityName',
            whereIn: communities.map((e) => e.name).toList())
        .orderBy(
          'createdAt',
          descending: true,
        )
        .snapshots()
        .map(
          (event) => event.docs
              .map((e) => PostModel.fromMap(e.data() as Map<String, dynamic>))
              .toList(),
        );
  }

  FutureVoid deletePost(
    PostModel postModel,
  ) async {
    try {
      return right(
        _posts.doc(postModel.id).delete(),
      );
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(
        Failure(
          message: e.toString(),
        ),
      );
    }
  }

  void upvote(
    PostModel postModel,
    String userId,
  ) async {
    if (postModel.downvotes.contains(userId)) {
      _posts.doc(postModel.id).update({
        'downvotes': FieldValue.arrayRemove([userId])
      });
    }

    if (postModel.upvotes.contains(userId)) {
      _posts.doc(postModel.id).update({
        'upvotes': FieldValue.arrayRemove([userId])
      });
    } else {
      _posts.doc(postModel.id).update({
        'upvotes': FieldValue.arrayUnion([userId])
      });
    }
  }

  void downvote(
    PostModel postModel,
    String userId,
  ) async {
    if (postModel.upvotes.contains(userId)) {
      _posts.doc(postModel.id).update({
        'upvotes': FieldValue.arrayRemove([userId])
      });
    }

    if (postModel.downvotes.contains(userId)) {
      _posts.doc(postModel.id).update({
        'downvotes': FieldValue.arrayRemove([userId])
      });
    } else {
      _posts.doc(postModel.id).update({
        'downvotes': FieldValue.arrayUnion([userId])
      });
    }
  }

  Stream<PostModel> getPostsById(String postId) {
    return _posts.doc(postId).snapshots().map(
          (event) => PostModel.fromMap(event.data() as Map<String, dynamic>),
        );
  }

  FutureVoid addComment(CommentModel commentModel) async {
    try {
      return right(_comments.doc(commentModel.id).set(commentModel.toMap()));
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(message: e.toString()));
    }
  }

  CollectionReference get _posts =>
      _firestore.collection(FirebaseConstants.postsCollection);
  CollectionReference get _comments =>
      _firestore.collection(FirebaseConstants.commentsCollection);
}
