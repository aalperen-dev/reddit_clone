import 'package:flutter/material.dart';
import 'package:reddit_clone/features/feed/screens/feed_screen.dart';
import 'package:reddit_clone/features/post/screens/add_post_screen.dart';

class Assets {
  Assets._();

  static const String myFlutterAppFont = "assets/fonts/MyFlutterApp.ttf";

  static const String awardsAwesomeAnswer =
      "assets/images/awards/awesomeanswer.png";

  static const String awardsGold = "assets/images/awards/gold.png";

  static const String awardsHelpful = "assets/images/awards/helpful.png";

  static const String awardsPlatinum = "assets/images/awards/platinum.png";

  static const String awardsPlusone = "assets/images/awards/plusone.png";

  static const String awardsRocket = "assets/images/awards/rocket.png";

  static const String awardsThankyou = "assets/images/awards/thankyou.png";

  static const String awardsTil = "assets/images/awards/til.png";

  static const String google = "assets/images/google.png";

  static const String loginEmote = "assets/images/loginEmote.png";

  static const String logo = "assets/images/logo.png";

  static const bannerDefault =
      'https://thumbs.dreamstime.com/b/abstract-stained-pattern-rectangle-background-blue-sky-over-fiery-red-orange-color-modern-painting-art-watercolor-effe-texture-123047399.jpg';
  static const avatarDefault =
      'https://external-preview.redd.it/5kh5OreeLd85QsqYO1Xz_4XSLYwZntfjqou-8fyBFoE.png?auto=webp&s=dbdabd04c399ce9c761ff899f5d38656d1de87c2';

  static IconData up =
      const IconData(0xe800, fontFamily: 'MyFlutterApp', fontPackage: null);
  static IconData down =
      const IconData(0xe801, fontFamily: 'MyFlutterApp', fontPackage: null);

  static const awardsPath = 'assets/images/awards';

  static const awards = {
    'awesomeAns': '${Assets.awardsPath}/awesomeanswer.png',
    'gold': '${Assets.awardsPath}/gold.png',
    'platinum': '${Assets.awardsPath}/platinum.png',
    'helpful': '${Assets.awardsPath}/helpful.png',
    'plusone': '${Assets.awardsPath}/plusone.png',
    'rocket': '${Assets.awardsPath}/rocket.png',
    'thankyou': '${Assets.awardsPath}/thankyou.png',
    'til': '${Assets.awardsPath}/til.png',
  };

  static const tabWidgets = [
    FeedScreen(),
    AddPostScreen(),
  ];
}
