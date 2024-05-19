import 'package:flutter/material.dart';
import '../models/comment_model.dart';

class KomentarList extends StatelessWidget {
  final List<Comment> komentar;

  const KomentarList({Key? key, required this.komentar}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: komentar.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  spreadRadius: 2,
                  blurRadius: 3,
                  offset: const Offset(0, 2), // changes position of shadow
                ),
              ],
            ),
            child: ListTile(
              title: Text(
                komentar[index].email.split('@')[0],
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: Text(
                  komentar[index].comment,
                  style: const TextStyle(fontSize: 14.0),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
