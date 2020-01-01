import 'package:google_news/src/api/api_provider.dart';
import 'package:google_news/src/model/topheadlinesnews/response_top_headlines_news.dart';

class ApiRepository {
  final ApiProvider _apiProvider = ApiProvider();

  Future<ResponseTopHeadlinesNews> fetchTopHeadlinesNews() => _apiProvider.getTopHeadlinesNews();
  
  Future<ResponseTopHeadlinesNews> fetchTopBusinsessHeadlinesNews() => _apiProvider.getTopBusinsessHeadlinesNews();
  
  Future<ResponseTopHeadlinesNews> fetchTopEntertainmentHeadlinesNews() => _apiProvider.getTopEntertainmentHeadlinesNews();
  
  Future<ResponseTopHeadlinesNews> fetchTopHealthHeadlinesNews() => _apiProvider.getTopHealthHeadlinesNews();
  
  Future<ResponseTopHeadlinesNews> fetchTopScienceHeadlinesNews() => _apiProvider.getTopScienceHeadlinesNews();
  
  Future<ResponseTopHeadlinesNews> fetchTopSportHeadlinesNews() => _apiProvider.getTopSportHeadlinesNews();
  
  Future<ResponseTopHeadlinesNews> fetchTopTechnologyHeadlinesNews() => _apiProvider.getTopTechnologyHeadlinesNews();
}