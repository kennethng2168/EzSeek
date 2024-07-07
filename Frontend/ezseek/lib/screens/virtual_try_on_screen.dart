import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';

class TryOnScreen extends StatefulWidget {
  @override
  _TryOnScreenState createState() => _TryOnScreenState();
}

class _TryOnScreenState extends State<TryOnScreen> {
  File? _humanImage;
  File? _garmentImage;
  File? _resultImage;
  bool _loading = false;

  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage(ImageSource source, bool isHumanImage) async {
    final pickedFile = await _picker.pickImage(source: source);
    setState(() {
      if (isHumanImage) {
        _humanImage = pickedFile != null ? File(pickedFile.path) : null;
      } else {
        _garmentImage = pickedFile != null ? File(pickedFile.path) : null;
      }
    });
  }

  Future<void> _virtualTryOn() async {
    if (_humanImage == null || _garmentImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Both images are required for virtual try-on.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _loading = true;
    });

    try {
      final request = http.MultipartRequest(
          'POST',
          Uri.parse(
              'https://5b9b-14-192-242-19.ngrok-free.app/virtual-try-on'));
      request.files
          .add(await http.MultipartFile.fromPath('imgs', _humanImage!.path));
      request.files.add(
          await http.MultipartFile.fromPath('garm_img', _garmentImage!.path));

      request.fields['garment_des'] = 'Your garment description';
      request.fields['is_checked'] = true.toString();
      request.fields['is_checked_crop'] = false.toString();
      request.fields['denoise_steps'] = '30';
      request.fields['seed'] = '42';

      final response = await request.send();

      if (response.statusCode == 200) {
        final responseData = await response.stream.toBytes();
        // Save the image to a file
        final tempDir = await getTemporaryDirectory();
        final resultFile = File('${tempDir.path}/result_image.png');
        await resultFile.writeAsBytes(responseData);

        setState(() {
          _resultImage = resultFile;
          _loading = false;
        });
      } else {
        setState(() {
          _loading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content:
              Text('Error: ${response.statusCode} - ${response.reasonPhrase}'),
        ));
      }
    } catch (e) {
      setState(() {
        _loading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Request error: $e'),
      ));
    }
  }

  Future<void> _saveToGallery() async {
    if (_resultImage == null) return;

    // Check for storage permissions
    final result = await ImageGallerySaver.saveFile(_resultImage!.path);
    if (result["isSuccess"]) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.green,
        content: Text('Image saved to gallery'),
      ));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.red,
        content: Text('Failed to save image to gallery'),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Container(
          color: Colors.white,
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                    border: Border(bottom: BorderSide(color: Colors.black12))),
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Icon(Icons.add_card),
                    Text(
                      "Try Your Outfit",
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                    Icon(Icons.more_horiz)
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        _imageContainer(_humanImage,
                            () => _pickImage(ImageSource.gallery, true)),
                        SizedBox(width: 10),
                        _imageContainer(_garmentImage,
                            () => _pickImage(ImageSource.gallery, false)),
                      ],
                    ),
                    SizedBox(height: 10),
                    _loading
                        ? CircularProgressIndicator()
                        : ElevatedButton(
                            onPressed: _virtualTryOn,
                            style: ElevatedButton.styleFrom(
                              shadowColor: Colors.black,
                              elevation: 10,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: Text(
                              'Virtual Try On',
                              style: TextStyle(
                                color: Colors.black,
                              ),
                            ),
                          ),
                    if (_resultImage != null) ...[
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                        height: 350,
                        child: Image.file(_resultImage!),
                      ),
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                _humanImage = null;
                                _garmentImage = null;
                                _resultImage = null;
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              shadowColor: Colors.black,
                              elevation: 10,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: Text(
                              'Reset',
                              style: TextStyle(
                                color: Colors.black,
                              ),
                            ),
                          ),
                          SizedBox(width: 10),
                          ElevatedButton(
                            onPressed: _saveToGallery,
                            style: ElevatedButton.styleFrom(
                              shadowColor: Colors.black,
                              elevation: 10,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: Text(
                              'Save to Gallery',
                              style: TextStyle(
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _imageContainer(File? image, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 200,
        height: 200,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
        ),
        child: image == null
            ? Icon(
                Icons.add_a_photo,
                color: Colors.black,
              )
            : Image.file(image, fit: BoxFit.cover),
      ),
    );
  }
}
