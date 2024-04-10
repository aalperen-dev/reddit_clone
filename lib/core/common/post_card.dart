import 'package:any_link_preview/any_link_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone/core/common/error_text.dart';
import 'package:reddit_clone/core/common/loader.dart';
import 'package:reddit_clone/core/constants/constants.dart';
import 'package:reddit_clone/features/auth/controller/auth_controller.dart';
import 'package:reddit_clone/features/community/controller/community_controller.dart';
import 'package:reddit_clone/features/post/controller/post_controller.dart';

import 'package:reddit_clone/models/post_model.dart';
import 'package:routemaster/routemaster.dart';

import '../../theme/pallete.dart';

class PostCard extends ConsumerWidget {
  final PostModel postModel;
  const PostCard({
    super.key,
    required this.postModel,
  });

  void deletePost(WidgetRef ref, BuildContext context) async {
    ref.read(postControllerProvider.notifier).deletePost(
          postModel,
          context,
        );
  }

  void upvotePost(
    WidgetRef ref,
  ) async {
    ref.read(postControllerProvider.notifier).upvote(
          postModel,
        );
  }

  void downvotePost(
    WidgetRef ref,
  ) async {
    ref.read(postControllerProvider.notifier).downvote(
          postModel,
        );
  }

  void navigateToUser(BuildContext context) {
    Routemaster.of(context).push('/u/${postModel.uid}');
  }

  void navigateToCommunity(BuildContext context) {
    Routemaster.of(context).push('/r/${postModel.communityName}');
  }

  void navigateToComments(BuildContext context) {
    Routemaster.of(context).push('/post/${postModel.id}/comments');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isTypeImage = postModel.type == 'image';
    final isTypeText = postModel.type == 'text';
    final isTypeLink = postModel.type == 'link';

    final currentTheme = ref.watch(themeNotifierProvider);
    final user = ref.watch(userProvider);

    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: currentTheme.drawerTheme.backgroundColor,
          ),
          padding: const EdgeInsets.symmetric(
            vertical: 10,
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 4,
                        horizontal: 16,
                      ).copyWith(right: 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  //
                                  GestureDetector(
                                    onTap: () => navigateToCommunity(context),
                                    child: CircleAvatar(
                                      backgroundImage: NetworkImage(
                                          postModel.communityProfilePic),
                                      radius: 16,
                                    ),
                                  ),
                                  //
                                  Padding(
                                    padding: const EdgeInsets.only(left: 8),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        //
                                        Text(
                                          'r/${postModel.communityName}',
                                          style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        //
                                        GestureDetector(
                                          onTap: () => navigateToUser(context),
                                          child: Text(
                                            'u/${postModel.username}',
                                            style: const TextStyle(
                                              fontSize: 12,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              if (postModel.uid == user!.uid)
                                IconButton(
                                  onPressed: () => deletePost(
                                    ref,
                                    context,
                                  ),
                                  icon: Icon(
                                    Icons.delete,
                                    color: Pallete.redColor,
                                  ),
                                ),
                            ],
                          ),
                          //
                          Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: Text(
                              postModel.title,
                              style: const TextStyle(
                                fontSize: 19,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          if (isTypeImage)
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.35,
                              width: double.infinity,
                              child: Image.network(
                                postModel.link!,
                                fit: BoxFit.cover,
                              ),
                            ),
                          if (isTypeLink)
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 18),
                              child: AnyLinkPreview(
                                link: postModel.link!,
                                displayDirection:
                                    UIDirection.uiDirectionHorizontal,
                              ),
                            ),
                          if (isTypeText)
                            Container(
                              alignment: Alignment.bottomLeft,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 15),
                              child: Text(
                                postModel.description!,
                                style: const TextStyle(color: Colors.grey),
                              ),
                            ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  IconButton(
                                    onPressed: () => upvotePost(ref),
                                    icon: Icon(
                                      Assets.up,
                                      size: 30,
                                      color:
                                          postModel.upvotes.contains(user.uid)
                                              ? Pallete.redColor
                                              : null,
                                    ),
                                  ),
                                  //
                                  Text(
                                    '${postModel.upvotes.length - postModel.downvotes.length == 0 ? 'Vote' : postModel.upvotes.length - postModel.downvotes.length}',
                                    style: const TextStyle(fontSize: 17),
                                  ),
                                  //
                                  IconButton(
                                    onPressed: () => downvotePost(ref),
                                    icon: Icon(
                                      Assets.down,
                                      size: 30,
                                      color:
                                          postModel.downvotes.contains(user.uid)
                                              ? Pallete.blueColor
                                              : null,
                                    ),
                                  ),
                                ],
                              ),
                              //
                              Row(
                                children: [
                                  IconButton(
                                    onPressed: () =>
                                        navigateToComments(context),
                                    icon: Icon(
                                      Icons.comment,
                                      size: 30,
                                      color:
                                          postModel.upvotes.contains(user.uid)
                                              ? Pallete.redColor
                                              : null,
                                    ),
                                  ),
                                  //
                                  Text(
                                    '${postModel.commentCount == 0 ? 'Comment' : postModel.commentCount}',
                                    style: const TextStyle(fontSize: 17),
                                  ),
                                ],
                              ),
                              // mod tools buton
                              ref
                                  .watch(getCommunityByNameProvider(
                                      postModel.communityName))
                                  .when(
                                    data: (data) {
                                      if (data.mods.contains(user.uid)) {
                                        return IconButton(
                                          onPressed: () =>
                                              deletePost(ref, context),
                                          icon: const Icon(
                                            Icons.admin_panel_settings,
                                          ),
                                        );
                                      }
                                      return const SizedBox();
                                    },
                                    error: (error, stackTrace) => ErrorText(
                                      error: error.toString(),
                                    ),
                                    loading: () => const Loader(),
                                  ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}
