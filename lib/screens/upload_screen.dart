import 'dart:async';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'result_screen.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:convert';

class UploadScreen extends StatefulWidget {
  const UploadScreen({super.key});

  @override
  _UploadScreenState createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;
  File? _image;
  List<CameraDescription>? cameras;
  final ImagePicker _picker = ImagePicker();

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
      print('Captured Image Path: ${_image?.path}');
    } catch (e) {
      print('Error taking picture: $e');
    }
  }

  Future<void> _pickImageFromGallery() async {
    try {
      final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        setState(() {
          _image = File(pickedFile.path);
        });
      }
      print('Selected Image Path: ${_image?.path}');
    } catch (e) {
      print('Error picking image: $e');
    }
  }

  Future<void> _submitPicture() async {
    if (_image != null) {
      print('Submitting image...');
      var result = await _submitImageToServer(_image!);
      if (!mounted) return;

      if (result != null) {
        print('Image submitted successfully!');
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ResultScreen(
              success: true, 
              ocrResult: result,
              imageFile: _image!, // Pass the image file
            ),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error uploading image')),
        );
      }
    } else {
      print('No image to submit');
    }
  }

  Future<List<dynamic>?> _submitImageToServer(File image) async {
    try {
      var request =
          http.MultipartRequest('POST', Uri.parse('http://10.0.2.2:5000/ocr'));
      request.files.add(await http.MultipartFile.fromPath('file', image.path));
      var response = await request.send();
      if (response.statusCode == 200) {
        var responseBody = await response.stream.bytesToString();
        return jsonDecode(responseBody);
      } else {
        print('Error in server response: ${response.reasonPhrase}');
        return null;
      }
    } catch (e) {
      print('Error uploading image: $e');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Upload Screen')),
      body: SafeArea(
        child: cameras == null
            ? const Center(child: CircularProgressIndicator())
            : FutureBuilder<void>(
                future: _initializeControllerFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return _image == null
                        ? CameraPreview(_controller)
                        : Column(
                            children: [
                              Flexible(
                                child: Image.file(
                                  _image!,
                                  fit: BoxFit.contain,
                                ),
                              ),
                              const SizedBox(height: 16), // Add space
                              ElevatedButton(
                                onPressed: () {
                                  print('Submit Button Pressed');
                                  _submitPicture();
                                },
                                child: const Text('Submit Image'),
                              ),
                            ],
                          );
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  }
                },
              ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: _takePicture,
            child: const Icon(Icons.camera_alt),
          ),
          const SizedBox(width: 16), // Add space between buttons
          FloatingActionButton(
            onPressed: _pickImageFromGallery,
            child: const Icon(Icons.photo_library), // Gallery icon button
          ),
        ],
      ),
    );
  }
}
