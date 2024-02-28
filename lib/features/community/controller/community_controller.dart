import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:reddit_clone/core/constants/constants.dart';
import 'package:reddit_clone/core/providers/storage_repository_provider.dart';
import 'package:reddit_clone/features/community/repository/community_repository.dart';
import 'package:reddit_clone/features/auth/controller/auth_controller.dart';
import 'package:reddit_clone/models/community_model.dart';
import 'package:routemaster/routemaster.dart';

import '../../../core/failure.dart';
import '../../../core/utils/utilities.dart';

final userCommunitiesProvider = StreamProvider((ref) {
  final communityController = ref.watch(communityControllerProvider.notifier);
  return communityController.getUserCommunities();
});

final communityControllerProvider =
    StateNotifierProvider<CommunityController, bool>((ref) {
  final communityRepository = ref.watch(communityRepositoryProvider);
  final storageRepository = ref.watch(storageRepositoryProvider);
  return CommunityController(
    communityRepository: communityRepository,
    ref: ref,
    storageRepository: storageRepository,
  );
});

final getCommunityByNameProvider = StreamProvider.family((ref, String name) {
  return ref
      .watch(communityControllerProvider.notifier)
      .getCommunityByName(name);
});

final searchCommunityProvider = StreamProvider.family((ref, String query) {
  return ref.watch(communityControllerProvider.notifier).searchCommunity(query);
});

class CommunityController extends StateNotifier<bool> {
  final CommunityRepository _communityRepository;
  final Ref _ref;
  final StorageRepository _storageRepository;

  CommunityController({
    required CommunityRepository communityRepository,
    required Ref ref,
    required StorageRepository storageRepository,
  })  : _communityRepository = communityRepository,
        _ref = ref,
        _storageRepository = storageRepository,
        super(false);

  void createCommunity(String name, BuildContext context) async {
    state = true;
    final uid = _ref.read(userProvider)?.uid ?? '';

    CommunityModel communityModel = CommunityModel(
      id: name,
      name: name,
      banner: Assets.bannerDefault,
      avatar: Assets.avatarDefault,
      members: [uid],
      mods: [uid],
    );

    final res = await _communityRepository.createCommunity(communityModel);
    state = false;
    res.fold((l) => showSnackbar(context, l.message), (r) {
      showSnackbar(context, 'Community created successfully!');
      Routemaster.of(context).push('/');
    });
  }

  void joinCommunity(
    BuildContext context,
    CommunityModel communityModel,
  ) async {
    final user = _ref.read(userProvider)!;
    Either<Failure, void> res;

    if (communityModel.members.contains(user.uid)) {
      res = await _communityRepository.leaveCommunity(
          communityModel.name, user.uid);
    } else {
      res = await _communityRepository.joinCommunity(
          communityModel.name, user.uid);
    }

    return res.fold((l) => showSnackbar(context, l.message), (r) {
      if (communityModel.members.contains(user.uid)) {
        showSnackbar(context, 'Community left successfully!');
      } else {
        showSnackbar(context, 'Community joined successfully!');
      }
    });
  }

  Stream<List<CommunityModel>> getUserCommunities() {
    final uid = _ref.read(userProvider)!.uid;

    return _communityRepository.getUserCommunities(uid);
  }

  Stream<CommunityModel> getCommunityByName(String name) {
    return _communityRepository.getCommunityByName(name);
  }

  void editCommunity({
    required BuildContext context,
    required CommunityModel communityModel,
    required File? profileFile,
    required File? bannerFile,
  }) async {
    state = true;
    if (profileFile != null) {
      final res = await _storageRepository.storeFiles(
        path: 'communities/profile',
        id: communityModel.name,
        file: profileFile,
      );
      res.fold(
        (l) => showSnackbar(context, l.message),
        (r) => communityModel = communityModel.copyWith(avatar: r),
      );
    }
    if (bannerFile != null) {
      final res = await _storageRepository.storeFiles(
        path: 'communities/banner',
        id: communityModel.name,
        file: bannerFile,
      );
      res.fold(
        (l) => showSnackbar(context, l.message),
        (r) => communityModel = communityModel.copyWith(banner: r),
      );
    }

    final res = await _communityRepository.editCommunity(communityModel);
    state = false;
    res.fold(
      (l) => showSnackbar(context, l.message),
      (r) => Routemaster.of(context).pop(),
    );
  }

  Stream<List<CommunityModel>> searchCommunity(String query) {
    return _communityRepository.searchCommunity(query);
  }

  void addMods(
    String communityName,
    List<String> uids,
    BuildContext context,
  ) async {
    final res = await _communityRepository.addMods(communityName, uids);

    res.fold(
      (l) => showSnackbar(context, l.message),
      (r) => Routemaster.of(context).pop(),
    );
  }
}
