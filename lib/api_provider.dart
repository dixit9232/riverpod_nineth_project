import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_nineth_project/post_model.dart';
import 'package:http/http.dart' as http;

final url = "https://jsonplaceholder.typicode.com/posts";
final apiProvider = FutureProvider<List<PostModel>>((ref) async {
  try {
    final http.Response response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final List<PostModel> postModel = postModelFromJson(response.body);
      return postModel;
    } else {
      throw "Something went wrong";
    }
  } on SocketException {
    throw "No Internet";
  } catch (e) {
    rethrow;
  }
});
