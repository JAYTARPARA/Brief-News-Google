import 'dart:async';
import 'dart:io';

// import 'package:cached_network_image/cached_network_image.dart';
import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_news/src/bloc/home/home_bloc.dart';
import 'package:google_news/src/model/category/category.dart';
import 'package:google_news/src/model/topheadlinesnews/response_top_headlines_news.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:firebase_admob/firebase_admob.dart';

final GlobalKey<ScaffoldState> scaffoldState = GlobalKey<ScaffoldState>();

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    FirebaseAdMob.instance
        .initialize(appId: 'ca-app-pub-4800441463353851~6558594714')
        .then((response) {
      Timer.periodic(new Duration(seconds: 60), (timer) {
        myBanner
          ..load()
          ..show(
            // Banner Position
            anchorType: AnchorType.bottom,
          );
      });
    });

    FirebaseAdMob.instance
        .initialize(appId: 'ca-app-pub-4800441463353851~6558594714')
        .then((response) {
      Timer.periodic(new Duration(seconds: 600), (timer) {
        myInterstitial
          ..load()
          ..show();
      });
    });

    FirebaseAdMob.instance
        .initialize(appId: 'ca-app-pub-4800441463353851~6558594714')
        .then((response) {
      Timer.periodic(new Duration(seconds: 900), (timer) {
        myInterstitial
          ..load()
          ..show();
      });
    });

    var strToday = getStrToday();
    var mediaQuery = MediaQuery.of(context);
    double paddingTop = mediaQuery.padding.top;

    return Scaffold(
      key: scaffoldState,
      body: DoubleBackToCloseApp(
        snackBar: const SnackBar(
          content: Text('Press again to exit'),
        ),
        child: BlocProvider<HomeBloc>(
          create: (context) => HomeBloc(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                  color: Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                  ),
                ),
                padding: EdgeInsets.only(
                  top: paddingTop + 16.0,
                  bottom: 16.0,
                ),
                child: Column(
                  children: <Widget>[
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        WidgetTitle(strToday),
                      ],
                    ),
                    SizedBox(
                      height: 12.0,
                    ),
                    WidgetCategory(),
                  ],
                ),
              ),
              SizedBox(
                height: 16.0,
              ),
              _buildWidgetLabelLatestNews(context),
              _buildWidgetSubtitleLatestNews(context),
              Expanded(
                child: WidgetLatestNews(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWidgetSubtitleLatestNews(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 16.0,
        vertical: 5,
      ),
      child: Text(
        'Top headlines at the moment',
        style: Theme.of(context).textTheme.caption.merge(
              TextStyle(
                fontSize: 18.0,
                // color: Color(0xFF325384).withOpacity(0.5),
                color: Colors.white.withOpacity(0.5),
              ),
            ),
      ),
    );
  }

  Widget _buildWidgetLabelLatestNews(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      child: Text(
        'Latest News',
        style: Theme.of(context).textTheme.subtitle.merge(
              TextStyle(
                fontSize: 18.0,
                // color: Color(0xFF325384).withOpacity(0.8),
                color: Colors.white.withOpacity(0.8),
              ),
            ),
      ),
    );
  }

  String getStrToday() {
    var today = DateFormat().add_yMMMMd().format(DateTime.now());
    var strDay = today.split(' ')[1].replaceFirst(',', '');

    if (strDay == '1' || strDay == '21' || strDay == '31') {
      strDay = strDay + 'st';
    } else if (strDay == '2' || strDay == '22') {
      strDay = strDay + 'nd';
    } else if (strDay == '3' || strDay == '23') {
      strDay = strDay + 'rd';
    } else {
      strDay = strDay + 'th';
    }

    var strMonth = today.split(' ')[0];
    var strYear = today.split(' ')[2];

    return '$strDay $strMonth $strYear';
  }
}

class WidgetTitle extends StatelessWidget {
  final String strToday;

  WidgetTitle(this.strToday);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: 'News Today\n',
                style: Theme.of(context).textTheme.title.merge(
                      TextStyle(
                        color: Color(0xFF325384),
                      ),
                    ),
              ),
              TextSpan(
                text: strToday,
                style: Theme.of(context).textTheme.caption.merge(
                      TextStyle(
                        color: Color(0xFF325384).withOpacity(0.8),
                        fontSize: 10.0,
                      ),
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class WidgetCategory extends StatefulWidget {
  @override
  _WidgetCategoryState createState() => _WidgetCategoryState();
}

class _WidgetCategoryState extends State<WidgetCategory> {
  final listCategories = [
    Category('', 'All'),
    Category('assets/images/img_business.png', 'Business'),
    Category('assets/images/img_entertainment.png', 'Entertainment'),
    Category('assets/images/img_health.png', 'Health'),
    Category('assets/images/img_science.png', 'Science'),
    Category('assets/images/img_sport.png', 'Sport'),
    Category('assets/images/img_technology.png', 'Technology'),
  ];
  int indexSelectedCategory = 0;

  @override
  void initState() {
    final homeBloc = BlocProvider.of<HomeBloc>(context);
    homeBloc.add(DataEvent(listCategories[indexSelectedCategory].title));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final homeBloc = BlocProvider.of<HomeBloc>(context);
    return Container(
      height: 74.0,
      child: ListView.builder(
        shrinkWrap: false,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          Category itemCategory = listCategories[index];
          return Padding(
            padding: EdgeInsets.only(
              left: 16.0,
              right: index == listCategories.length - 1 ? 16.0 : 0.0,
            ),
            child: Column(
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                    setState(() {
                      indexSelectedCategory = index;
                      homeBloc.add(DataEvent(
                          listCategories[indexSelectedCategory].title));
                    });
                  },
                  child: index == 0
                      ? Container(
                          width: 48.0,
                          height: 48.0,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color(0xFFBDCDDE),
                            border: indexSelectedCategory == index
                                ? Border.all(
                                    color: Colors.white,
                                    width: 5.0,
                                  )
                                : null,
                          ),
                          child: Icon(
                            Icons.apps,
                            color: Colors.white,
                          ),
                        )
                      : Container(
                          width: 48.0,
                          height: 48.0,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              image: AssetImage(itemCategory.image),
                              fit: BoxFit.cover,
                            ),
                            border: indexSelectedCategory == index
                                ? Border.all(
                                    color: Colors.white,
                                    width: 5.0,
                                  )
                                : null,
                          ),
                        ),
                ),
                SizedBox(
                  height: 8.0,
                ),
                Text(
                  itemCategory.title,
                  style: TextStyle(
                    fontSize: 14.0,
                    color: Color(0xFF325384),
                    fontWeight: indexSelectedCategory == index
                        ? FontWeight.bold
                        : FontWeight.normal,
                  ),
                )
              ],
            ),
          );
        },
        itemCount: listCategories.length,
      ),
    );
  }
}

class WidgetLatestNews extends StatefulWidget {
  @override
  _WidgetLatestNewsState createState() => _WidgetLatestNewsState();
}

class _WidgetLatestNewsState extends State<WidgetLatestNews> {
  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQuery = MediaQuery.of(context);
    final HomeBloc homeBloc = BlocProvider.of<HomeBloc>(context);

    return Padding(
      padding: EdgeInsets.only(
        left: 16.0,
        top: 8.0,
        right: 16.0,
        bottom: mediaQuery.padding.bottom + 16.0,
      ),
      child: BlocListener<HomeBloc, DataState>(
        listener: (context, state) {
          if (state is DataFailed) {
            Scaffold.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage),
              ),
            );
          }
        },
        child: BlocBuilder(
          bloc: homeBloc,
          builder: (context, state) {
            return _buildWidgetContentLatestNews(state, mediaQuery);
          },
        ),
      ),
    );
  }

  Widget _buildWidgetContentLatestNews(
    DataState state,
    MediaQueryData mediaQuery,
  ) {
    if (state is DataLoading) {
      return Center(
        child: Platform.isAndroid
            ? CircularProgressIndicator()
            : CupertinoActivityIndicator(),
      );
    } else if (state is DataSuccess) {
      ResponseTopHeadlinesNews data = state.data;
      return ListView.separated(
        padding: EdgeInsets.zero,
        itemBuilder: (context, index) {
          Article itemArticle = data.articles[index];
          if (itemArticle.urlToImage == null) {
            itemArticle.urlToImage =
                'https://i.ibb.co/9NNWWcq/img-not-found.jpg';
          }
          if (index == 0 || (index % 6) == 0) {
            return Stack(
              children: <Widget>[
                ClipRRect(
                  child: Image.network(
                    itemArticle.urlToImage,
                    height: 192.0,
                    width: mediaQuery.size.width,
                    fit: BoxFit.cover,
                  ),
                  borderRadius: BorderRadius.all(
                    Radius.circular(8.0),
                  ),
                ),
                GestureDetector(
                  onTap: () async {
                    if (await canLaunch(itemArticle.url)) {
                      await launch(
                        itemArticle.url,
                        forceSafariVC: true,
                        forceWebView: true,
                      );
                    } else {
                      scaffoldState.currentState.showSnackBar(
                        SnackBar(
                          content: Text('Could not launch news'),
                        ),
                      );
                    }
                  },
                  child: Container(
                    width: mediaQuery.size.width,
                    height: 192.0,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(
                        Radius.circular(8.0),
                      ),
                      gradient: LinearGradient(
                        colors: [
                          Colors.black.withOpacity(0.8),
                          Colors.black.withOpacity(0.0),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        stops: [
                          0.0,
                          0.7,
                        ],
                      ),
                    ),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 12.0,
                        top: 12.0,
                        right: 12.0,
                      ),
                      child: Text(
                        itemArticle.title,
                        style: TextStyle(
                          color: Colors.white,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 12.0,
                        top: 4.0,
                        right: 12.0,
                      ),
                      child: Wrap(
                        children: <Widget>[
                          Icon(
                            Icons.launch,
                            color: Colors.white.withOpacity(0.8),
                            size: 12.0,
                          ),
                          SizedBox(
                            width: 4.0,
                          ),
                          Text(
                            '${itemArticle.source.name}',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.8),
                              fontSize: 11.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            );
          } else {
            return GestureDetector(
              onTap: () async {
                if (await canLaunch(itemArticle.url)) {
                  await launch(
                    itemArticle.url,
                    forceSafariVC: true,
                    forceWebView: true,
                  );
                }
              },
              child: Container(
                width: mediaQuery.size.width,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                      child: SizedBox(
                        height: 72.0,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              itemArticle.title,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 3,
                              style: TextStyle(
                                fontSize: 16.0,
                                // color: Color(0xFF325384),
                                color: Colors.white,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            Wrap(
                              crossAxisAlignment: WrapCrossAlignment.center,
                              children: <Widget>[
                                Icon(
                                  Icons.launch,
                                  size: 12.0,
                                  // color: Color(0xFF325384).withOpacity(0.5),
                                  color: Colors.white.withOpacity(0.5),
                                ),
                                SizedBox(
                                  width: 4.0,
                                ),
                                Text(
                                  itemArticle.source.name,
                                  style: TextStyle(
                                    // color: Color(0xFF325384).withOpacity(0.5),
                                    color: Colors.white.withOpacity(0.5),
                                    fontSize: 12.0,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 16.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.all(
                          Radius.circular(4.0),
                        ),
                        child: Image.network(
                          itemArticle.urlToImage,
                          width: 72.0,
                          height: 72.0,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
        },
        separatorBuilder: (context, index) {
          return Divider();
        },
        itemCount: data.articles.length,
      );
    }
  }
}

MobileAdTargetingInfo targetingInfo = MobileAdTargetingInfo(
  keywords: <String>['games', 'cricket'],
  contentUrl: 'https://flutter.io',
  childDirected: false,
  testDevices: <String>[], // Android emulators are considered test devices
);

InterstitialAd myInterstitial = InterstitialAd(
  // Replace the testAdUnitId with an ad unit id from the AdMob dash.
  // https://developers.google.com/admob/android/test-ads
  // https://developers.google.com/admob/ios/test-ads
  // adUnitId: InterstitialAd.testAdUnitId,
  adUnitId: 'ca-app-pub-4800441463353851/8993186368',
  // targetingInfo: targetingInfo,
  listener: (MobileAdEvent event) {
    print("InterstitialAd event is $event");
  },
);

BannerAd myBanner = BannerAd(
  // Replace the testAdUnitId with an ad unit id from the AdMob dash.
  // https://developers.google.com/admob/android/test-ads
  // https://developers.google.com/admob/ios/test-ads
  // adUnitId: BannerAd.testAdUnitId,
  adUnitId: 'ca-app-pub-4800441463353851/6951446578',
  size: AdSize.smartBanner,
  // targetingInfo: targetingInfo,
  listener: (MobileAdEvent event) {
    print("BannerAd event is $event");
  },
);
