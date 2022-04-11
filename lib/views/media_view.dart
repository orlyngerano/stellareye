import 'package:flutter/material.dart';
import 'package:stellareye/models/media.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:stellareye/services/image_service.dart';

class Media extends StatefulWidget {
  static const routeName = '/media';
  final Item item;
  const Media(this.item, {Key? key}) : super(key: key);
  @override
  _MediaState createState() => _MediaState();
}

class _MediaState extends State<Media> {
  final imageService = ImageService();
  String videoLink = '';

  @override
  void initState() {
    super.initState();
    if (widget.item.href != null) {
      final assets = imageService.getAssets(widget.item.href!);
      assets.then((value) =>
          {videoLink = value.firstWhere((element) => element.endsWith('mp4'))});
    }
  }

  String _getValue(String? key, String replaceText) {
    return key != null ? key : replaceText;
  }

  List<Widget> _createInfoWidgets(Item item) {
    final infoTitle = _getValue(item.data![0].title, '');
    final infoCenter = _getValue(item.data![0].center, '');
    final infoLocation = _getValue(item.data![0].location, '');
    final infoPhotographer = _getValue(item.data![0].photographer, '');
    final infoDescription = _getValue(item.data![0].description, '');

    List<Widget> infoWidgets = [];

    if (infoTitle.isNotEmpty) {
      infoWidgets.add(SizedBox(
        height: 8.0,
      ));
      infoWidgets.add(Text(
        infoTitle,
        style: TextStyle(fontWeight: FontWeight.bold),
      ));
    }

    if (infoLocation.isNotEmpty) {
      infoWidgets.add(SizedBox(
        height: 8.0,
      ));
      infoWidgets.add(Row(
        children: [
          Icon(
            Icons.location_pin,
            color: Colors.black,
            size: 16.0,
          ),
          Text(infoLocation),
        ],
      ));
    } else if (infoCenter.isNotEmpty) {
      infoWidgets.add(SizedBox(
        height: 8.0,
      ));
      infoWidgets.add(Row(
        children: [
          Icon(
            Icons.location_pin,
            color: Colors.black,
            size: 16.0,
          ),
          Text(infoCenter),
        ],
      ));
    }

    if (infoPhotographer.isNotEmpty) {
      infoWidgets.add(SizedBox(
        height: 8.0,
      ));
      infoWidgets.add(Row(
        children: [
          Icon(
            Icons.camera_alt,
            color: Colors.black,
            size: 16.0,
          ),
          Text(infoPhotographer),
        ],
      ));
    }

    if (infoDescription.isNotEmpty) {
      infoWidgets.add(SizedBox(
        height: 8.0,
      ));
      infoWidgets.add(Html(data: infoDescription));
    }

    return infoWidgets;
  }

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).padding.bottom;
    final mediaType = widget.item.data![0].media_type;
    final screenTitle = mediaType![0].toUpperCase() + mediaType.substring(1);

    List<Widget> infoWidgets = _createInfoWidgets(widget.item);

    final videoPlayButton = mediaType != 'video'
        ? Container()
        : Align(
            alignment: Alignment.center,
            child: FloatingActionButton(
              heroTag: "media",
              onPressed: () {
                Navigator.pushNamed(context, '/video',
                    arguments: Uri.encodeFull(videoLink));
              },
              child: Icon(Icons.ondemand_video),
            ),
          );

    return Scaffold(
        appBar: AppBar(
          title: Text('$screenTitle Details'),
        ),
        body: Column(
          children: [
            Expanded(
                child: Stack(children: [
              Image.network(widget.item.links![0].href!),
              videoPlayButton
            ])),
            Expanded(
                child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.only(
                    left: 8.0, right: 8.0, top: 8.0, bottom: bottomPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: infoWidgets,
                ),
              ),
            ))
          ],
        ));
  }
}
