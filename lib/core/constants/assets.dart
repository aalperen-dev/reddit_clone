import 'package:flutter/material.dart';

import '../../features/feed/screens/feed_screen.dart';
import '../../features/post/screens/add_post_screen.dart';

class Assets {
  Assets._();

  static const String fontsMyFlutterApp = "assets/fonts/MyFlutterApp.ttf";

  static const String imagesAwardsAwesomeanswer =
      "assets/images/awards/awesomeanswer.png";

  static const String imagesAwardsGold = "assets/images/awards/gold.png";

  static const String imagesAwardsHelpful = "assets/images/awards/helpful.png";

  static const String imagesAwardsPlatinum =
      "assets/images/awards/platinum.png";

  static const String imagesAwardsPlusone = "assets/images/awards/plusone.png";

  static const String imagesAwardsRocket = "assets/images/awards/rocket.png";

  static const String imagesAwardsThankyou =
      "assets/images/awards/thankyou.png";

  static const String imagesAwardsTil = "assets/images/awards/til.png";

  static const String imagesGoogle = "assets/images/google.png";

  static const String imagesLoginEmote = "assets/images/loginEmote.png";

  static const String imagesLogo = "assets/images/logo.png";

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
