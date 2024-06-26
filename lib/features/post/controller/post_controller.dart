import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone/core/enums/enums.dart';
import 'package:reddit_clone/core/utils/utilities.dart';
import 'package:reddit_clone/features/auth/controller/auth_controller.dart';
import 'package:reddit_clone/features/post/repository/post_repository.dart';
import 'package:reddit_clone/features/user_profile/controller/user_profile_controller.dart';
import 'package:reddit_clone/models/comment_model.dart';
import 'package:reddit_clone/models/community_model.dart';
import 'package:reddit_clone/models/post_model.dart';
import 'package:routemaster/routemaster.dart';
import 'package:uuid/uuid.dart';

import '../../../core/providers/storage_repository_provider.dart';

final postControllerProvider =
    StateNotifierProvider<PostController, bool>((ref) {
  final postRepository = ref.watch(postRepositoryProvider);
  final storageRepository = ref.watch(storageRepositoryProvider);
  return PostController(
    postRepository: postRepository,
    ref: ref,
    storageRepository: storageRepository,
  );
});

final userPostsProvider =
    StreamProvider.family((ref, List<CommunityModel> communities) {
  final postController = ref.watch(postControllerProvider.notifier);
  return postController.fetchUserPosts(communities);
});
final guestPostsProvider = StreamProvider((ref) {
  final postController = ref.watch(postControllerProvider.notifier);
  return postController.fetchGuestPosts();
});

final getPostsByIdProvider = StreamProvider.family((ref, String postId) {
  final postController = ref.watch(postControllerProvider.notifier);
  return postController.getPostsById(postId);
});

final getPostCommentsProvider = StreamProvider.family((ref, String postId) {
  final postController = ref.watch(postControllerProvider.notifier);
  return postController.fetchPostComments(postId);
});

class PostController extends StateNotifier<bool> {
  final PostRepository _postRepository;
  final Ref _ref;
  final StorageRepository _storageRepository;

  PostController({
    required PostRepository postRepository,
    required Ref ref,
    required StorageRepository storageRepository,
  })  : _postRepository = postRepository,
        _ref = ref,
        _storageRepository = storageRepository,
        super(false);

  void shareTextPost({
    required BuildContext context,
    required String title,
    required CommunityModel selectedCommunity,
    required String description,
  }) async {
    state = true;
    String postId = const Uuid().v1();
    final user = _ref.read(userProvider)!;

    final PostModel post = PostModel(
      id: postId,
      title: title,
      communityName: selectedCommunity.name,
      communityProfilePic: selectedCommunity.avatar,
      upvotes: [],
      downvotes: [],
      commentCount: 0,
      username: user.name,
      uid: user.uid,
      type: 'text',
      createdAt: DateTime.now(),
      awards: [],
      description: description,
    );

    final res = await _postRepository.addPost(post);

    _ref
        .read(userProfileControllerProvider.notifier)
        .updateUserKarma(UserKarma.textPost);

    state = false;

    res.fold(
      (l) => showSnackbar(context, l.message),
      (r) {
        showSnackbar(context, 'Posted Succesfully');
        Routemaster.of(context).pop();
      },
    );
  }

  void shareLinkPost({
    required BuildContext context,
    required String title,
    required CommunityModel selectedCommunity,
    required String link,
  }) async {
    state = true;
    String postId = const Uuid().v1();
    final user = _ref.read(userProvider)!;

    final PostModel post = PostModel(
      id: postId,
      title: title,
      communityName: selectedCommunity.name,
      communityProfilePic: selectedCommunity.avatar,
      upvotes: [],
      downvotes: [],
      commentCount: 0,
      username: user.name,
      uid: user.uid,
      type: 'link',
      createdAt: DateTime.now(),
      awards: [],
      link: link,
    );

    final res = await _postRepository.addPost(post);

    _ref
        .read(userProfileControllerProvider.notifier)
        .updateUserKarma(UserKarma.linkPost);

    state = false;

    res.fold(
      (l) => showSnackbar(context, l.message),
      (r) {
        showSnackbar(context, 'Posted Succesfully');
        Routemaster.of(context).pop();
      },
    );
  }

  void shareImagePost({
    required BuildContext context,
    required String title,
    required CommunityModel selectedCommunity,
    required File? file,
    required Uint8List? webFile,
  }) async {
    state = true;
    String postId = const Uuid().v1();
    final user = _ref.read(userProvider)!;

    final imageRes = await _storageRepository.storeFiles(
      path: 'posts/${selectedCommunity.name}',
      id: postId,
      file: file,
      webFile: webFile,
    );

    imageRes.fold(
      (l) => showSnackbar(context, l.message),
      (r) async {
        final PostModel post = PostModel(
          id: postId,
          title: title,
          communityName: selectedCommunity.name,
          communityProfilePic: selectedCommunity.avatar,
          upvotes: [],
          downvotes: [],
          commentCount: 0,
          username: user.name,
          uid: user.uid,
          type: 'image',
          createdAt: DateTime.now(),
          awards: [],
          link: r,
        );

        final res = await _postRepository.addPost(post);

        _ref
            .read(userProfileControllerProvider.notifier)
            .updateUserKarma(UserKarma.imagePost);

        state = false;

        res.fold(
          (l) => showSnackbar(context, l.message),
          (r) {
            showSnackbar(context, 'Posted Succesfully');
            Routemaster.of(context).pop();
          },
        );
      },
    );
  }

  Stream<List<PostModel>> fetchUserPosts(List<CommunityModel> communities) {
    if (communities.isNotEmpty) {
      return _postRepository.fetchUserPosts(communities);
    }

    return Stream.value([]);
  }

  Stream<List<PostModel>> fetchGuestPosts() {
    return _postRepository.fetchGuestPosts();
  }

  void deletePost(
    PostModel postModel,
    BuildContext context,
  ) async {
    final res = await _postRepository.deletePost(postModel);

    _ref
        .read(userProfileControllerProvider.notifier)
        .updateUserKarma(UserKarma.deletePost);

    res.fold(
      (l) => null,
      (r) => showSnackbar(context, 'Post Deleted Successfully!'),
    );
  }

  void upvote(
    PostModel postModel,
  ) async {
    final uid = _ref.read(userProvider)!.uid;
    _postRepository.upvote(postModel, uid);
  }

  void downvote(
    PostModel postModel,
  ) async {
    final uid = _ref.read(userProvider)!.uid;
    _postRepository.downvote(postModel, uid);
  }

  Stream<PostModel> getPostsById(String postId) {
    return _postRepository.getPostsById(postId);
  }

  void addComment({
    required BuildContext context,
    required String text,
    required PostModel postModel,
  }) async {
    final user = _ref.read(userProvider)!;
    final String commentId = const Uuid().v1();
    CommentModel commentModel = CommentModel(
      id: commentId,
      text: text,
      createdAt: DateTime.now(),
      postId: postModel.id,
      username: user.name,
      profilePic: user.profilePic,
    );

    final res = await _postRepository.addComment(commentModel);

    _ref
        .read(userProfileControllerProvider.notifier)
        .updateUserKarma(UserKarma.comment);

    res.fold((l) => showSnackbar(context, l.message), (r) => null);
  }

  void awardPost({
    required BuildContext context,
    required PostModel postModel,
    required String award,
  }) async {
    final user = _ref.read(userProvider)!;

    final res = await _postRepository.awardPost(postModel, award, user.uid);

    res.fold((l) => showSnackbar(context, l.message), (r) {
      _ref
          .read(userProfileControllerProvider.notifier)
          .updateUserKarma(UserKarma.awardPost);

      _ref.read(userProvider.notifier).update((state) {
        state?.awards.remove(award);
        return state;
      });

      Routemaster.of(context).pop();
    });
  }

  Stream<List<CommentModel>> fetchPostComments(String postId) {
    return _postRepository.getCommentsOfPost(postId);
  }
}
