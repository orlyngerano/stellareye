import 'package:flutter/material.dart';

class MediaListItem extends StatelessWidget {
  final String name;
  final String author;
  final String imageURL;
  const MediaListItem(
      {Key? key,
      required this.name,
      required this.author,
      required this.imageURL})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.only(bottom: 8.0),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(8.0)),
              image: DecorationImage(
                  image: NetworkImage(imageURL), fit: BoxFit.cover)),
          height: 200,
        ),
        Row(
          children: [
            Expanded(
                child:
                    Text(name, style: TextStyle(fontWeight: FontWeight.bold))),
            Expanded(child: Text(author, textAlign: TextAlign.right)),
          ],
        )
      ],
    );
  }
}
