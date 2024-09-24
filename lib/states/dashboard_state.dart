import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:comments_app/models/comment.dart';
import 'package:comments_app/models/current_user.dart';
import 'package:comments_app/utils/app_helper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:http/http.dart' as http;

part 'dashboard_state.g.dart';

class DashboardStateModel {
  final AsyncValue<CurrentUser?> currentUser;
  final AsyncValue<List<Comment>> comments;

  DashboardStateModel({
    this.currentUser = const AsyncData(null),
    this.comments = const AsyncData([]),
  });

  // copyWith method
  DashboardStateModel copyWith({
    AsyncValue<CurrentUser?>? currentUser,
    AsyncValue<List<Comment>>? comments,
  }) {
    return DashboardStateModel(
      currentUser: currentUser ?? this.currentUser,
      comments: comments ?? this.comments,
    );
  }
}

@riverpod
class DashboardState extends _$DashboardState {
  @override
  DashboardStateModel build() {
    return DashboardStateModel();
  }

  void getComments() async {
    state = state.copyWith(comments: const AsyncLoading());
    try {
      var url = Uri.parse(
        'https://jsonplaceholder.typicode.com/comments',
      );
      final response = await http.get(
        url,
      );
      if (response.statusCode == 200) {
        // If the server returns a 200 OK response, decode the JSON data
        List<dynamic> jsonList = json.decode(response.body);

        // Map the decoded JSON list to a list of Comment objects
        List<Comment> comments =
            jsonList.map((json) => Comment.fromJson(json)).toList();

        state = state.copyWith(comments: AsyncData(comments));
      } else {
        // If the server returns an error, throw an exception
        throw Exception('Failed to load comments');
      }
    } catch (e) {
      state = state.copyWith(
          comments: AsyncError("Failed to load comments", StackTrace.current));
      AppHelper.showAlert(message: e.toString());
    }
  }

  void getUserName() async {
    state = state.copyWith(currentUser: const AsyncLoading());
    FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .get()
        .then((value) {
      state = state.copyWith(
          currentUser: AsyncData(CurrentUser(
              email: value.data()?['email'].toString(),
              userName: value.data()?['name'].toString())));
    }).catchError((error) {
      state = state.copyWith(currentUser: const AsyncData(null));
      AppHelper.showAlert(message: "Failed to get current user data");
    });
  }
}
