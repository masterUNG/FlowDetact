// ignore_for_file: public_member_api_docs, sort_constructors_first, avoid_print, prefer_const_constructors
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flowdetect/screens/show_video_player.dart';
import 'package:flutter/material.dart';

import 'package:flowdetect/models/sqlite_model.dart';
import 'package:flowdetect/utility/main_style.dart';
import 'package:flowdetect/utility/sqlite_helper.dart';

late String videoPath;
//List<Measurement> measurements = getInfo();

class Measurement {
  late final String user;
}

// Future<List<Measurement>> getInfo() async {
//   const data = [
//     {
//       "user": "amornpan@gmail.com",
//       "code": "MUN017",
//       "name": "เมืองอุบลราชธานี",
//       "lat": "15.3276864",
//       "lng": "104.6817984",
//       "left_bank": 114.758,
//       "right_bank": 118.692,
//       "ground_level": 105.73,
//       "date": "2021-09-12",
//       "time": "00:00:00",
//       "water": 110.94,
//       "video_path": "",
//       "surface_velocity": 0.0,
//     },
//     {
//       "user": "amornpan@gmail.com",
//       "code": "SKM001",
//       "name": "อากาศอำนวย",
//       "lat": "17.7775936",
//       "lng": "104.0150464",
//       "left_bank": 142.857,
//       "right_bank": 144.219,
//       "ground_level": 131.865,
//       "date": "2021-09-12",
//       "time": "00:00:00",
//       "water": 141.93,
//       "video_path": "",
//       "surface_velocity": 0.0,
//     }
//   ];
//   return null;
//   //return data.map(<Meaturement>(Meaturement.fromJson)).toList();
// }

class VideoUpload extends StatefulWidget {
  final String? videoPath;
  final String? pathStorage;

  const VideoUpload({
    Key? key,
    this.videoPath,
    this.pathStorage,
  }) : super(key: key);

  @override
  State<VideoUpload> createState() => _VideoUploadState();
}

class _VideoUploadState extends State<VideoUpload> {
  String? pathRecordVideo;
  bool load = true;
  var sqliteModels = <SQLiteModel>[];

  String? videoPath, pathStroage;

  @override
  void initState() {
    super.initState();
    videoPath = widget.videoPath;
    pathStroage = widget.pathStorage;
    var strings = videoPath!.split('/');
    pathRecordVideo = '$pathStroage/${strings.last}';
    processSaveSqlite();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () async {
              await SQLiteHelper().deleteAll().then((value) {
                processSaveSqlite();
              });
            },
            icon: const Icon(Icons.delete_forever),
          ),
        ],
        title: const Text('Video Upload'),
      ),
      body: load
          ? MainStyle().showProgressBar()
          : ListView(
              children: [
                Container(
                  decoration: BoxDecoration(color: Colors.blue),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      // ignore: prefer_const_literals_to_create_immutables
                      children: [
                        Expanded(
                          flex: 1,
                          child: Text(
                            'No.',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: Text(
                            'DateTime',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: Text(
                            'Chanel',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const ScrollPhysics(),
                  itemCount: sqliteModels.length,
                  itemBuilder: (context, index) => Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: Text(
                              sqliteModels[index].id.toString(),
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child: Text(sqliteModels[index].recordDataTime),
                          ),
                          Expanded(
                            flex: 1,
                            child: Text(sqliteModels[index].chanel),
                          ),
                          Expanded(
                            flex: 1,
                            child: IconButton(
                              onPressed: () async {
                                String pathVideoUpload =
                                    sqliteModels[index].pathStorage;

                                print(
                                    '##13july pathVideoUpload ===> $pathVideoUpload');

                                File file = File(pathVideoUpload);
                                var strings = file.path.split('/');
                                String nameImage = strings.last;

                                Map<String, dynamic> map = {};
                                map['file'] = await MultipartFile.fromFile(
                                  file.path,
                                  filename: nameImage,
                                );
                                map['particle_diamiter'] = 1;

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
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ShowVideoPlayer(
                                            urlVideo: value.toString()),
                                      ));
                                }).catchError((error) {
                                  print('##13july error from api ==> $error');
                                });
                              },
                              icon: const Icon(Icons.cloud_upload),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: IconButton(
                              onPressed: () async {
                                await SQLiteHelper()
                                    .deleteWhereId(
                                        idDelete: sqliteModels[index].id!)
                                    .then((value) {
                                  processReadAllData();
                                });
                              },
                              icon: const Icon(Icons.delete_forever),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  Future<void> processSaveSqlite() async {
    DateTime dateTime = DateTime.now();

    SQLiteModel sqLiteModel = SQLiteModel(
        recordDataTime: dateTime.toString(),
        chanel: 'chanel',
        pathStorage: pathRecordVideo!);

    await SQLiteHelper().insertData(sqLiteModel: sqLiteModel).then((value) {
      print('##13july processSaveSqlite Success');
      processReadAllData();
    });
  }

  Future<void> processReadAllData() async {
    if (sqliteModels.isNotEmpty) {
      sqliteModels.clear();
    }

    await SQLiteHelper().readAllData().then((value) {
      sqliteModels = value;
      load = false;
      setState(() {});
    });
  }
}
