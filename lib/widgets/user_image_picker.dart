import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UserImagePickerWidget extends StatefulWidget {
  final void Function(File pickImage) imagePickFn;
  UserImagePickerWidget(this.imagePickFn);
  @override
  _UserImagePickerWidgetState createState() => _UserImagePickerWidgetState();
}

class _UserImagePickerWidgetState extends State<UserImagePickerWidget> {
  File imageFile;
  final picker = ImagePicker();
  void pickImage() async {
    final file =
        await picker.getImage(source: ImageSource.gallery, imageQuality: 50);
    if (file != null) {
      setState(() {
        imageFile = File(file.path);
      });
      widget.imagePickFn(File(file.path));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      CircleAvatar(
        radius: 40,
        backgroundImage: imageFile != null ? FileImage(imageFile) : null,
      ),
      FlatButton(child: Icon(Icons.camera_alt), onPressed: () => pickImage()),
    ]);
  }
}
