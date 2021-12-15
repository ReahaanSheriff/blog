import 'package:flutter/material.dart';

class SearchBlog extends StatefulWidget {
  final String value;
  const SearchBlog({Key? key, required this.value}) : super(key: key);

  @override
  _SearchBlogState createState() => _SearchBlogState();
}

class _SearchBlogState extends State<SearchBlog> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Search"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 15.0, top: 20),
                  child: SizedBox(
                      width: 300,
                      child: TextField(
                        decoration:
                            const InputDecoration(border: OutlineInputBorder()),
                      )),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20.0, left: 5),
                  child: ElevatedButton(
                      onPressed: () {},
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20.0),
                        child: Text("Search"),
                      )),
                ),
              ],
            ),
            Text("data")
          ],
        ),
      ),
    );
  }
}
