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
      // print(_imageFile);
      // _updateImage(_imageFile);
      Navigator.pop(context);
    });
  }

  void _updateImage(File image) {
    // widget.updateImage(AssetImage(image.toString()));
  }

  void _openImagePicker(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Container(
            height: 150.0,
            padding: EdgeInsets.all(10.0),
            child: Column(children: [
              FlatButton(
                textColor: Theme.of(context).primaryColor,
                child: Text('Use Camera'),
                onPressed: () {
                  _getImage(context, ImageSource.camera);
                },
              ),
              FlatButton(
                textColor: Theme.of(context).primaryColor,
                child: Text('Use Gallery'),
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
    final buttonColor = Theme.of(context).primaryColor;
    return Column(
      children: <Widget>[
        _imageFile == null
            ? OutlineButton(
                borderSide: BorderSide(
                  color: buttonColor,
                  width: 2.0,
                ),
                onPressed: () {
                  _openImagePicker(context);
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      Icons.camera_alt,
                      color: buttonColor,
                    ),
                    SizedBox(
                      width: 5.0,
                    ),
                    Text(
                      'Add Image',
                      style: TextStyle(color: buttonColor),
                    )
                  ],
                ),
              )
            : Container(
                width: 150,
                margin: EdgeInsets.only(top: 10),
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.green, width: 2.0)),
                child: Icon(Icons.check, color: Colors.green))
      ],
    );
  }
}
