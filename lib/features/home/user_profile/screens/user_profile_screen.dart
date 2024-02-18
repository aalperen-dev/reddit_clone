import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone/features/auth/controller/auth_controller.dart';

import '../../../../core/common/error_text.dart';
import '../../../../core/common/loader.dart';

class UserProfileScreen extends ConsumerWidget {
  final String uid;
  const UserProfileScreen({
    super.key,
    required this.uid,
  });
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: ref.watch(getUserDataProvider(uid)).when(
            data: (user) => NestedScrollView(
              headerSliverBuilder: (context, innerBoxIsScrolled) {
                return [
                  //
                  SliverAppBar(
                    floating: true,
                    snap: true,
                    expandedHeight: 250,
                    flexibleSpace: Stack(
                      children: [
                        Positioned.fill(
                          child: Image.network(
                            user.banner,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Container(
                          padding:
                              const EdgeInsets.all(20).copyWith(bottom: 70),
                          alignment: Alignment.bottomLeft,
                          child: CircleAvatar(
                            radius: 45,
                            backgroundImage: NetworkImage(
                              user.profilePic,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(20),
                          alignment: Alignment.bottomLeft,
                          child: OutlinedButton(
                            onPressed: () {},
                            style: OutlinedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            child: const Text('Edit Profile'),
                          ),
                        )
                      ],
                    ),
                  ),
                  //
                  SliverPadding(
                    padding: const EdgeInsets.all(16),
                    sliver: SliverList(
                      delegate: SliverChildListDelegate(
                        [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'u/${user.name}',
                                style: const TextStyle(
                                  fontSize: 19,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              //
                            ],
                          ),
                          //
                          Padding(
                            padding: const EdgeInsets.only(
                              top: 10,
                            ),
                            child: Text('${user.karma} karma'),
                          ),
                          const SizedBox(height: 10),
                          const Divider(
                            thickness: 2,
                          ),
                        ],
                      ),
                    ),
                  ),
                ];
              },
              body: Container(),
            ),
            error: (error, stackTrace) => ErrorText(error: error.toString()),
            loading: () => const Loader(),
          ),
    );
  }
}
