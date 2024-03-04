import 'package:any_link_preview/any_link_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone/features/auth/controller/auth_controller.dart';

import 'package:reddit_clone/models/post_model.dart';

import '../../theme/pallete.dart';

class PostCard extends ConsumerWidget {
  final PostModel postModel;
  const PostCard({
    super.key,
    required this.postModel,
  });
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
                                  CircleAvatar(
                                    backgroundImage: NetworkImage(
                                        postModel.communityProfilePic),
                                    radius: 16,
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
                                        Text(
                                          'u/${postModel.username}',
                                          style: const TextStyle(
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              if (postModel.uid == user!.uid)
                                IconButton(
                                  onPressed: () {},
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
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.35,
                              width: double.infinity,
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
                        ],
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        )
      ],
    );
  }
}
