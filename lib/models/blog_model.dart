import 'package:blogone/models/author_model.dart';
import 'package:blogone/sharedPreference/sharedPref.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'dart:convert';

class Blog {
  String imageUrl;
  String name;
  Author author;
  bool liked;
  String created_at;
  String content;

  Blog(
      {required this.imageUrl,
      required this.name,
      required this.author,
      required this.liked,
      required this.created_at,
      required this.content});
}

final List<Blog> blogs = [
  Blog(
    imageUrl: 'assets/images/blog1.jpg',
    name: '${['title']}',
    author: mike,
    liked: true,
    created_at: "56 min ago",
    content: '${['body']}',
  )
];
