import 'dart:io';

import 'package:flutter/material.dart';

import 'package:image_picker/image_picker.dart';

class ImageInput extends StatefulWidget {
  final Function updateImage;

  ImageInput({this.updateImage});

  @override
  State<StatefulWidget> createState() {
    return _ImageInputState();
  }
}

class _ImageInputState extends State<ImageInput> {
  File _imageFile;

  void _getImage(BuildContext context, ImageSource source) {
    ImagePicker.pickImage(source: source, maxWidth: 400.0).then((File image) {
      setState(() {
        _imageFile = image;
      });
      widget.updateImage(image);
      Navigator.pop(context);
    });
  }

  void _openImagePicker(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Container(
            decoration: BoxDecoration(color: Theme.of(context).secondaryHeaderColor),
            height: 90.0,
            padding: EdgeInsets.all(10.0),
            child: Column(children: [
              FlatButton(
                textColor: Theme.of(context).primaryColor,
                child: Text(
                  'GALLERY',
                  style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontSize: 20,
                      letterSpacing: 5),
                ),
                onPressed: () {
                  _getImage(context, ImageSource.gallery);
                },
              )
            ]),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        _imageFile == null
            ? Container(
                width: width * 0.2,
                height: height * 0.1,
                child: OutlineButton(
                  color: Color.fromRGBO(131, 129, 129, 1),
                  borderSide: BorderSide(
                    color: Color.fromRGBO(131, 129, 129, 1),
                    width: 0.5,
                  ),
                  onPressed: () {
                    _openImagePicker(context);
                  },
                  child: Center(
                    child: Icon(
                      Icons.add,
                      color: Color.fromRGBO(131, 129, 129, 1),
                      size: 30,
                    ),
                  ),
                ),
              )
            : Container(
                width: width * 0.2,
                height: height * 0.04,
                decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor),
                child: Center(
                  child: Icon(
                    Icons.check,
                    color: Theme.of(context).secondaryHeaderColor,
                    size: 30,
                  ),
                ),
              ),
      ],
    );
  }
}
