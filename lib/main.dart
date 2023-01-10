import 'package:flutter/material.dart';
import 'package:moviepedia/utils/text.dart';
import 'package:moviepedia/widgets/toprated.dart';
import 'package:moviepedia/widgets/trending.dart';
import 'package:moviepedia/widgets/tv.dart';
import 'package:tmdb_api/tmdb_api.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Home(),
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.green,
      ),
    );
  }
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List trendingMovies = [];
  List topRatedMovies = [];
  List popularTVShows = [];
  final String apiKey = '042a1fde8fdc6870e4754204510d0d76';
  final String readAccessToken =
      'eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiIwNDJhMWZkZThmZGM2ODcwZTQ3NTQyMDQ1MTBkMGQ3NiIsInN1YiI6IjYzYjljMDJiNmQ2NzVhMDA3YzVlMWMwOCIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.an8JxnY_zWuGHTAqtHUZAUNZldNnlHw2Xw_fmzo4bxE';

  @override
  void initState() {
    loadMovies();
    super.initState();
  }

  loadMovies() async {
    TMDB tmdbWithCustomLogs = TMDB(ApiKeys(apiKey, readAccessToken),
        logConfig: ConfigLogger(showLogs: true, showErrorLogs: true));

    Map trendingResult = await tmdbWithCustomLogs.v3.trending.getTrending();
    Map topRatedResult = await tmdbWithCustomLogs.v3.movies.getTopRated();
    Map tvResult = await tmdbWithCustomLogs.v3.tv.getPopular();

    setState(() {
      trendingMovies = trendingResult['results'];
      topRatedMovies = topRatedResult['results'];
      popularTVShows = tvResult['results'];
    });

    print(trendingMovies);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: modified_text(
          text: 'MoviePedia',
          color: Colors.white,
          size: 25,
        ),
      ),
      body: ListView(
        children: [
          TV(tv: popularTVShows),
          TopRated(toprated: topRatedMovies),
          TrendingMovies(trending: trendingMovies)],
      ),
    );
  }
}
