import 'dart:convert';
import '../data_providers/matching_data_provider.dart';
import '../models/other_user.dart';
import '../models/match.dart';

class MatchingRepository {
  MatchingDataProvider matchingDataProvider;
  MatchingRepository(this.matchingDataProvider);

  Future<List<OtherUser>> getSuggestions() async {
    var response = await matchingDataProvider.getSuggestions();
    List<dynamic> suggestions = jsonDecode(response.body);

    List<OtherUser> users = suggestions.map((suggested) {
      var mapifized = suggested as Map<String, dynamic>;
      return OtherUser.fromMap(mapifized);
    }).toList();
    return users;
  }

  Future<bool> like(String likedId) async {
    var response = await matchingDataProvider.like(likedId);
    return response.statusCode == 200;
  }

  Future<bool> dislike(String dislikedId) async {
    var response = await matchingDataProvider.like(dislikedId);
    return response.statusCode == 200;
  }

  Future<List<Match>> getMatches() async {
    var response = await matchingDataProvider.getMatches();
    List<dynamic> matchResults = jsonDecode(response.body);

    List<Match> matches = matchResults.map((matchResult) {
      var mapifized = matchResult as Map<String, dynamic>;
      return Match.fromMap(mapifized);
    }).toList();
    return matches;
  }

  Future<bool> createAppointment(String chatId, String appointment) async {
    var response =
        await matchingDataProvider.createAppointment(chatId, appointment);
    return response.statusCode == 200;
  }

  Future<bool> deleteAppointment(String chatId, String appointment) async {
    var response = await matchingDataProvider.deleteAppointment(chatId);
    return response.statusCode == 200;
  }

  Future<bool> editAppointment(String chatId, String appointment) async {
    var response =
        await matchingDataProvider.editAppointment(chatId, appointment);
    return response.statusCode == 200;
  }

  Function(String) enterChat(
      {required String chatId, required void Function(String) onMessage}) {
    var wsChannel = matchingDataProvider.getWebSocketChannel(chatId);
    var stream = wsChannel.stream;
    stream.listen((data) => onMessage(data as String));

    return (String message) => wsChannel.sink.add(message);
  }
}