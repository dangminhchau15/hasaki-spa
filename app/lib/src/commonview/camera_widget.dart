// import 'dart:async';
// import 'dart:io';

// import 'package:app/src/commonview/button_color_normal.dart';
// import 'package:app/src/utils/color_util.dart';
// import 'package:camera/camera.dart';
// import 'package:exif/exif.dart';
// import 'package:firebase_ml_vision/firebase_ml_vision.dart';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:image/image.dart' as img;

// class CameraWidget extends StatefulWidget {
//   @override
//   _CameraWidgetContentState createState() => _CameraWidgetContentState();
// }

// class _CameraWidgetContentState extends State<CameraWidget> {
//   CameraController _controller;
//   List<CameraDescription> cameras;
//   bool _isScanBusy = false;
//   Timer _timer;
//   String _textDetected = "";

//   @override
//   void initState() {
//     initializeCamera();
//     super.initState();
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     _timer.cancel();
//     super.dispose();
//   }

//   void initializeCamera() async {
//     try {
//       WidgetsFlutterBinding.ensureInitialized();
//       // Retrieve the device cameras
//       cameras = await availableCameras();
//     } on CameraException catch (e) {
//       print(e);
//     }
//     _controller = CameraController(cameras[0], ResolutionPreset.medium);
//     _controller.initialize().then((_) {
//       if (!mounted) {
//         return;
//       }

//       setState(() {});
//     });
//   }

//   void initializeVision(File fileOriginal) async {
//     final File imageFile = fileOriginal;
//     final FirebaseVisionImage visionImage =
//         FirebaseVisionImage.fromFile(imageFile);
//     final TextRecognizer textRecognizer =
//         FirebaseVision.instance.textRecognizer();
//     final VisionText visionText =
//         await textRecognizer.processImage(visionImage);

//     if (this.mounted) {
//       setState(() {
//         _textDetected = visionText?.text;
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (_controller != null && !_controller.value.isInitialized) {
//       return Container();
//     }
//     return SingleChildScrollView(
//       child: Column(children: [
//         Container(
//             width: MediaQuery.of(context).size.width,
//             height: 400,
//             child: Container(child: _cameraPreviewWidget())),
//         Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
//           Expanded(
//             child: Center(
//               child: Text(
//                 _textDetected,
//                 style: TextStyle(fontStyle: FontStyle.italic, fontSize: 24),
//               ),
//             ),
//           )
//         ]),
//         Container(
//           child: Column(children: <Widget>[
//             ButtonColorNormal(
//               width: 150,
//               height: 50,
//               onPressed: () async {
//                 _timer =
//                     Timer.periodic(Duration(seconds: 1), (currentTimer) async {
//                   await _controller
//                       .startImageStream((CameraImage availableImage) async {
//                     if (_isScanBusy) {
//                       print("1.5 -------- isScanBusy, skipping...");
//                       return;
//                     }

//                     print("1 -------- isScanBusy = true");
//                     _isScanBusy = true;

//                     scanText(availableImage).then((textVision) {
//                       setState(() {
//                         _textDetected = textVision ?? "";
//                       });

//                       _isScanBusy = false;
//                     }).catchError((error) {
//                       _isScanBusy = false;
//                     });
//                   });
//                 });
//               },
//               colorData: ColorData.primaryColor,
//               content: Text("Bắt đầu scan",
//                   style: TextStyle(color: ColorData.colorsWhite)),
//             ),
//             SizedBox(height: 10),
//             ButtonColorNormal(
//               width: 150,
//               height: 50,
//               onPressed: () async {
//                 await _controller.stopImageStream();
//                 _timer.cancel();
//               },
//               colorData: ColorData.backgroundDarkGray,
//               content: Text(
//                 "Ngừng scan",
//                 style: TextStyle(color: ColorData.colorsWhite),
//               ),
//             )
//           ]),
//         ),
//       ]),
//     );
//   }

//   _detectText(String path) async {
//     final File imageFile = File(path);
//     final result = await FlutterImageCompress.compressAndGetFile(
//       imageFile.absolute.path,
//       path,
//       quality: 88,
//       rotate: 90,
//     );
//     FirebaseVisionImage visionImage = FirebaseVisionImage.fromFile(result);
//     TextRecognizer textRecognizer = FirebaseVision.instance.textRecognizer();
//     VisionText visionText = await textRecognizer.processImage(visionImage);

//     if (this.mounted) {
//       setState(() {
//         _textDetected = visionText?.text;
//       });
//     }
//   }

//   Future<String> scanText(CameraImage availableImage) async {
//     /*
//      * https://firebase.google.com/docs/ml-kit/android/recognize-text
//      * .setWidth(480)   // 480x360 is typically sufficient for
//      * .setHeight(360)  // image recognition
//      */

//     final FirebaseVisionImageMetadata metadata = FirebaseVisionImageMetadata(
//         rawFormat: availableImage.format.raw,
//         size: Size(
//             availableImage.width.toDouble(), availableImage.height.toDouble()),
//         planeData: availableImage.planes
//             .map((currentPlane) => FirebaseVisionImagePlaneMetadata(
//                 bytesPerRow: currentPlane.bytesPerRow,
//                 height: currentPlane.height,
//                 width: currentPlane.width))
//             .toList(),
//         rotation: ImageRotation.rotation90);

//     final FirebaseVisionImage visionImage =
//         FirebaseVisionImage.fromBytes(availableImage.planes[0].bytes, metadata);
//     final TextRecognizer textRecognizer =
//         FirebaseVision.instance.textRecognizer();
//     final VisionText visionText =
//         await textRecognizer.processImage(visionImage);

//     return visionText?.text;
//   }

//   Future<String> _takePicture() async {
//     // Checking whether the controller is initialized
//     if (!_controller.value.isInitialized) {
//       print("Controller is not initialized");
//       return null;
//     }

//     // Formatting Date and Time
//     String dateTime = DateFormat.yMMMd()
//         .addPattern('-')
//         .add_Hms()
//         .format(DateTime.now())
//         .toString();

//     String formattedDateTime = dateTime.replaceAll(' ', '');

//     // Retrieving the path for saving an image
//     final Directory appDocDir = await getApplicationDocumentsDirectory();
//     final String visionDir = '${appDocDir.path}/hasaki/images';
//     await Directory(visionDir).create(recursive: true);
//     final String imagePath = '$visionDir/image_$formattedDateTime.jpg';

//     // Checking whether the picture is being taken
//     // to prevent execution of the function again
//     // if previous execution has not ended
//     if (_controller.value.isTakingPicture) {
//       print("Processing is in progress...");
//       return null;
//     }

//     try {
//       // Captures the image and saves it to the
//       // provided path
//       await _controller.takePicture(imagePath);
//     } on CameraException catch (e) {
//       print("Camera Exception: $e");
//       return null;
//     }

//     return imagePath;
//   }

//   Future<File> _fixExifRotation(String imagePath) async {
//     final originalFile = File(imagePath);
//     List<int> imageBytes = await originalFile.readAsBytes();

//     final originalImage = img.decodeImage(imageBytes);

//     final height = originalImage.height;
//     final width = originalImage.width;

//     // Let's check for the image size
//     if (height >= width) {
//       // I'm interested in portrait photos so
//       // I'll just return here
//       return originalFile;
//     }

//     // We'll use the exif package to read exif data
//     // This is map of several exif properties
//     // Let's check 'Image Orientation'
//     final exifData = await readExifFromBytes(imageBytes);

//     img.Image fixedImage;

//     if (height < width) {
//       // rotate
//       if (exifData['Image Orientation'].printable.contains('Horizontal')) {
//         fixedImage = img.copyRotate(originalImage, 90);
//       } else if (exifData['Image Orientation'].printable.contains('180')) {
//         fixedImage = img.copyRotate(originalImage, -90);
//       } else {
//         fixedImage = img.copyRotate(originalImage, 0);
//       }
//     }

//     // Here you can select whether you'd like to save it as png
//     // or jpg with some compression
//     // I choose jpg with 100% quality
//     final fixedFile =
//         await originalFile.writeAsBytes(img.encodeJpg(fixedImage));

//     return fixedFile;
//   }

//   Widget _cameraPreviewWidget() {
//     if (_controller == null || !_controller.value.isInitialized) {
//       return const Text(
//         'Tap a camera',
//         style: TextStyle(
//           color: Colors.white,
//           fontSize: 24.0,
//           fontWeight: FontWeight.w900,
//         ),
//       );
//     } else {
//       return AspectRatio(
//           aspectRatio: _controller.value.aspectRatio,
//           child: CameraPreview(_controller));
//     }
//   }
// }
