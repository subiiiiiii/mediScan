import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'result_screen.dart';

class UploadScreen extends StatefulWidget {
  @override
  _UploadScreenState createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;
  File? _image;
  List<CameraDescription>? cameras;

  @override
  void initState() {
    super.initState();
    _initializeCameras();
  }

  Future<void> _initializeCameras() async {
    cameras = await availableCameras();
    if (cameras != null && cameras!.isNotEmpty) {
      _controller = CameraController(cameras!.first, ResolutionPreset.medium);
      _initializeControllerFuture = _controller.initialize();
      setState(() {});
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _takePicture() async {
    try {
      await _initializeControllerFuture;
      final image = await _controller.takePicture();
      setState(() {
        _image = File(image.path);
      });
    } catch (e) {
      print(e);
    }
  }

  Future<void> _submitPicture() async {
    bool success = await _submitImageToServer(_image);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ResultScreen(success: success),
      ),
    );
  }

  Future<bool> _submitImageToServer(File? image) async {
    await Future.delayed(Duration(seconds: 2));
    return image != null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Upload Screen')),
      body: cameras == null
          ? Center(child: CircularProgressIndicator())
          : FutureBuilder<void>(
              future: _initializeControllerFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return _image == null
                      ? CameraPreview(_controller)
                      : Column(
                          children: [
                            Image.file(_image!),
                            ElevatedButton(
                              onPressed: _submitPicture,
                              child: const Text('Submit Image'),
                            ),
                          ],
                        );
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _takePicture,
        child: const Icon(Icons.camera_alt),
      ),
    );
  }
}
