import 'dart:io';

import 'package:dio/dio.dart';
import 'package:external_path/external_path.dart';
import 'package:flowdetect/screens/hii_video_upload.dart';
import 'package:flutter/material.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:video_player/video_player.dart';

String? videoPath;

class VideoPage extends StatefulWidget {
  final String filePath;

  const VideoPage({Key? key, required this.filePath}) : super(key: key);

  @override
  _VideoPageState createState() => _VideoPageState();
}

class _VideoPageState extends State<VideoPage> {
  late VideoPlayerController _videoPlayerController;
  String? pathStorage;

  @override
  void dispose() {
    super.dispose();
    print('##13july dispost Work');
    _videoPlayerController.dispose();
  }

  // @override
  // void dispose() {
  //   print('##13july dispost Work');
  //   _videoPlayerController.dispose();
  //   super.dispose();
  // }

  Future _initVideoPlayer() async {
    videoPath = widget.filePath;
    _videoPlayerController = VideoPlayerController.file(File(widget.filePath));
    await _videoPlayerController.initialize();
    await _videoPlayerController.setLooping(true);
    await _videoPlayerController.play();

    findPathStorage();
  }

  Future<void> findPathStorage() async {
    pathStorage = await ExternalPath.getExternalStoragePublicDirectory(
        ExternalPath.DIRECTORY_MOVIES);
    print('##13july  pathStroage ===> $pathStorage');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '321 สถานีโทรมาตรวัดระดับน้ำ สสน.',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        elevation: 0,
        backgroundColor: Colors.blue.shade500,
        //actions: [IconButton(icon: const Icon(Icons.check), onPressed: () {})]
      ),
      //extendBodyBehindAppBar: true,
      body: Container(
        color: Colors.black,
        child: FutureBuilder(
          future: _initVideoPlayer(),
          builder: (context, state) {
            if (state.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else {
              return Center(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    AspectRatio(
                      child: VideoPlayer(_videoPlayerController),
                      aspectRatio: _videoPlayerController.value.aspectRatio,
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Video Path:' + videoPath.toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10.0,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Align(
                          alignment: Alignment.bottomLeft,
                          child: FloatingActionButton.extended(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: const Icon(Icons.undo),
                            label: const Text('Undo'),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: FloatingActionButton.extended(
                            onPressed: () async {
                              print('##13july save Video at $videoPath');
                              await GallerySaver.saveVideo(videoPath.toString())
                                  .then((value) {
                                print(
                                    '##13july ===> value gallerySaver ===> ${value.toString()}');
                                dispose();
                              });
                              File(videoPath.toString()).deleteSync();
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => VideoUpload(
                                      videoPath: videoPath,
                                      pathStorage: pathStorage,
                                    ),
                                  ));
                            },
                            icon: const Icon(Icons.save),
                            label: const Text('Save'),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: FloatingActionButton.extended(
                            onPressed: () async {
                              _videoPlayerController.pause();

                              File file = File(widget.filePath);

                              var strings = file.path.split('/');
                              String nameImage = strings.last;
                              print('##13july ==> $nameImage');

                              Map<String, dynamic> map = {};
                              map['file'] = await MultipartFile.fromFile(
                                file.path,
                                filename: nameImage,
                              );
                              map['particle_diamiter'] = 1;

                              print(
                                  '##13july You Click Cloud file.path ==> ${file.path}');
                              print('##13july map at cloud ==>> $map');

                              FormData formData = FormData.fromMap(map);
                              String path =
                                  'http://113.53.253.55:5001/upload_file_api3';
                              await Dio()
                                  .post(
                                path,
                                data: formData,
                              )
                                  .then((value) {
                                print('##13july value from api ==> $value');
                              }).catchError((error) {
                                print('##13july error from api ==> $error');
                              });
                            },
                            icon: const Icon(Icons.cloud),
                            label: const Text('Cloud'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
