import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:reddit_clone/core/constants/firebase_constants.dart';
import 'package:reddit_clone/core/failure.dart';
import 'package:reddit_clone/core/providers/firebase_provider.dart';
import 'package:reddit_clone/models/user_model.dart';

import '../../../core/constants/assets.dart';
import '../../../core/type_defs.dart';

final authRepositoryProvider = Provider((ref) {
  return AuthRepository(
    firebaseFirestore: ref.read(firestoreProvider),
    firebaseAuth: ref.read(authProvider),
    googleSignIn: ref.read(googleSignInProvider),
  );
});

class AuthRepository {
  final FirebaseFirestore _firebaseFirestore;
  final FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;

  AuthRepository({
    required FirebaseFirestore firebaseFirestore,
    required FirebaseAuth firebaseAuth,
    required GoogleSignIn googleSignIn,
  })  : _firebaseFirestore = firebaseFirestore,
        _firebaseAuth = firebaseAuth,
        _googleSignIn = googleSignIn;

  // getter
  CollectionReference get _users =>
      _firebaseFirestore.collection(FirebaseConstants.usersCollection);

  Stream<User?> get authStateChange => _firebaseAuth.authStateChanges();

  FutureEither<UserModel> signInWithGoogle(bool isFromLogin) async {
    try {
      UserCredential userCredential;
      if (kIsWeb) {
        GoogleAuthProvider googleAuthProvider = GoogleAuthProvider();
        googleAuthProvider
            .addScope('https://www.googleapis.com/auth/contacts.readonly');
        userCredential =
            await _firebaseAuth.signInWithPopup(googleAuthProvider);
      } else {
        final GoogleSignInAccount? googleSignInAccount =
            await _googleSignIn.signIn();

        final googleAuth = await googleSignInAccount?.authentication;

        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth?.accessToken,
          idToken: googleAuth?.idToken,
        );

        if (isFromLogin) {
          userCredential = await _firebaseAuth.signInWithCredential(credential);
        } else {
          userCredential =
              await _firebaseAuth.currentUser!.linkWithCredential(credential);
        }

        if (kDebugMode) {
          print(userCredential.user?.email);
        }
      }

      UserModel userModel;

      if (userCredential.additionalUserInfo!.isNewUser) {
        userModel = UserModel(
          uid: userCredential.user!.uid,
          name: userCredential.user!.displayName!,
          profilePic: userCredential.user!.photoURL ?? Assets.avatarDefault,
          banner: Assets.bannerDefault,
          isAuthenticated: true,
          karma: 0,
          awards: [
            'til',
            'gold',
            'rocket',
          ],
        );
        await _users.doc(userCredential.user!.uid).set(userModel.toMap());
      } else {
        userModel = await getUserData(userCredential.user!.uid).first;
      }
      return right(userModel);
    } on FirebaseException catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
      throw e.message!;
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
      return left(Failure(message: e.toString()));
    }
  }

  FutureEither<UserModel> signInAsGuest() async {
    try {
      var userCredential = await _firebaseAuth.signInAnonymously();

      if (kDebugMode) {
        print(userCredential.user?.email);
      }

      UserModel userModel = UserModel(
        uid: userCredential.user!.uid,
        name: 'Guest',
        profilePic: Assets.avatarDefault,
        banner: Assets.bannerDefault,
        isAuthenticated: false,
        karma: 0,
        awards: [],
      );
      await _users.doc(userCredential.user!.uid).set(userModel.toMap());

      return right(userModel);
    } on FirebaseException catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
      throw e.message!;
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
      return left(Failure(message: e.toString()));
    }
  }

  Stream<UserModel> getUserData(
    String uid,
  ) {
    return _users.doc(uid).snapshots().map(
        (event) => UserModel.fromMap(event.data() as Map<String, dynamic>));
  }

  void signOut() async {
    await _googleSignIn.signOut();
    await _firebaseAuth.signOut();
  }
}
