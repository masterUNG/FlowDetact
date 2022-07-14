import 'package:camera/camera.dart';
import 'package:flowdetect/screens/camera_page.dart';
import 'package:flowdetect/utility/dialog.dart';
import 'package:flutter/material.dart';

class ParticleSizeSelect extends StatefulWidget {
  const ParticleSizeSelect({Key? key}) : super(key: key);

  @override
  State<ParticleSizeSelect> createState() => _ParticleSizeSelectState();
}

class _ParticleSizeSelectState extends State<ParticleSizeSelect> {
  late double screenWidth;
  late double screenHigh;

  String? name;
  String? date;
  String? time;
  double? water;
  double? left_bank;
  double? right_bank;
  double? ground_level;
  double? lat;
  double? lng;
  dynamic stationCode;

  bool particleSelect = false;
  double particleSize = 0.0;

  var clicks = <bool>[
    false,
    false,
    false,
  ];
  Color colorClick = const Color.fromARGB(255, 7, 72, 125);

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHigh = MediaQuery.of(context).size.height;

    final routeData =
        ModalRoute.of(context)?.settings.arguments as Map<dynamic, dynamic>;
    stationCode = routeData['stationCode'];

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'สถานีโทรมาตรวัดระดับน้ำ สสน.',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.blue.shade500,
        elevation: 0.0,
      ),
      body: Stack(
        children: [
          ClipPath(
            clipper: CustomClipPath(),
            child: Container(
              color: Colors.blue.shade500,
              child: const ClipPath(),
              height: screenHigh,
              width: screenWidth,
            ),
          ),
          Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'กรุณาเลือกขนาดของวัตถุที่ใช้ลอย',
                    style: TextStyle(
                      fontSize: 20.0,
                      color: Color(0xff0064b7),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Particle Image
                  Column(
                    children: [
                      particle100(),
                      const SizedBox(height: 10),
                      particle50(),
                      const SizedBox(height: 10),
                      particle20(),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'ขนาด Particle ที่เลือก = ' + particleSize.toString(),
                    style: const TextStyle(
                      fontSize: 20.0,
                      color: Color(0xff0064b7),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 15),
                  nextButton(),
                  const SizedBox(height: 10),
                  const Text('* เลือกขนาดตามความกว้างของลำน้ำ'),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  void changeColor({required int index}) {
    for (var i = 0; i < clicks.length; i++) {
      clicks[i] = false;
    }
    clicks[index] = true;
    setState(() {});
  }

  Widget particle100() {
    return ElevatedButton(
      child: const Text(
        '100 cm',
        style: TextStyle(fontSize: 15),
      ),
      onPressed: () {
        changeColor(index: 0);
        setState(() {
          particleSelect = true;
          particleSize = 100.0;
        });
      },
      style: ElevatedButton.styleFrom(
        primary:
            clicks[0] ? colorClick : const Color.fromARGB(255, 92, 170, 234),
        fixedSize: const Size(120, 120),
        shape: const CircleBorder(),
      ),
    );
  }

  Widget particle50() {
    return ElevatedButton(
      child: const Text(
        '50 cm',
        style: TextStyle(fontSize: 15),
      ),
      onPressed: () {
        changeColor(index: 1);
        setState(() {
          particleSelect = true;
          particleSize = 50.0;
        });
      },
      style: ElevatedButton.styleFrom(
        primary:
            clicks[1] ? colorClick : const Color.fromARGB(255, 87, 151, 204),
        fixedSize: const Size(100, 100),
        shape: const CircleBorder(),
       
      ),
    );
  }

  Widget particle20() {
    return ElevatedButton(
      child: const Text(
        '20 cm',
        style: TextStyle(fontSize: 15),
      ),
      onPressed: () {
        changeColor(index: 2);
        setState(() {
          particleSelect = true;
          particleSize = 20.0;
        });
      },
      style: ElevatedButton.styleFrom(primary: clicks[2] ? colorClick : Color.fromARGB(255, 71, 163, 239) ,
        fixedSize: const Size(80, 80),
        shape: const CircleBorder(),
       
      ),
    );
  }

  Widget particleSize100() {
    //bool setColor = false;
    return ClipOval(
      child: Material(
        //color: setColor == true ? Colors.blue.shade800 : Colors.blue.shade200,
        color: Colors.blue.shade200,
        child: InkWell(
          splashColor: Colors.red,
          onTap: () {
            color:
            Colors.blue.shade800;
          },
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: FittedBox(
              fit: BoxFit.contain,
              child: Container(
                color: Colors.blue.shade200,
                width: 100.0,
                height: 100.0,
                child: const Center(
                  child: Text(
                    '100 cm',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10.0,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget particleSize50() {
    bool setColor = false;
    return ClipOval(
      child: Material(
        color: setColor == true ? Colors.blue.shade800 : Colors.blue.shade200,
        child: InkWell(
          onTap: () {
            setState(() {
              setColor = true;
            });
          },
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: FittedBox(
                fit: BoxFit.contain,
                child: Container(
                  color: setColor == true
                      ? Colors.blue.shade800
                      : Colors.blue.shade200,
                  width: 60.0,
                  height: 60.0,
                  child: const Center(
                    child: Text(
                      '50 cm',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10.0,
                      ),
                    ),
                  ),
                )),
          ),
        ),
      ),
    );
  }

  Widget particleSize20() {
    bool setColor = false;
    return ClipOval(
      child: Material(
        color: setColor == true ? Colors.blue.shade800 : Colors.blue.shade200,
        child: InkWell(
          onTap: () {
            setState(() {
              setColor = true;
            });
          },
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: FittedBox(
                fit: BoxFit.contain,
                child: Container(
                  color: setColor == true
                      ? Colors.blue.shade800
                      : Colors.blue.shade200,
                  width: 30.0,
                  height: 30.0,
                  child: const Center(
                    child: Text(
                      '20 cm',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10.0,
                      ),
                    ),
                  ),
                )),
          ),
        ),
      ),
    );
  }

  Widget nextButton() {
    return ElevatedButton(
      onPressed: () async {
        if (particleSize == 0.0) {
          normalDialog(
              context, "ยังไม่ได้เลือกขนาดวัตถุ", "กรุณาเลือกเลือกขนาดวัตถุ");
        } else {
          await availableCameras().then((value) => Navigator.push(context,
              MaterialPageRoute(builder: (_) => CameraPage(cameras: value))));
        }
      },
      child: const Text("ต่อไป"),
      style: ElevatedButton.styleFrom(
          fixedSize: const Size(250, 50),
          shadowColor: Colors.black,
          elevation: 10,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
          primary: const Color.fromRGBO(41, 168, 223, 1),
          textStyle: const TextStyle(
            fontStyle: FontStyle.normal,
            fontSize: 20.0,
            fontFamily: "Orbitron",
          )),
    );
  }
}

class CustomClipPath extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    // TOP
    final Path path0 = Path();
    path0.moveTo(0, 0);
    path0.lineTo(0, size.height * 0.2017986);
    path0.quadraticBezierTo(size.width * 0.0516667, size.height * 0.1122302,
        size.width * 0.2188889, size.height * 0.1003597);
    path0.cubicTo(
        size.width * 0.3405556,
        size.height * 0.0974820,
        size.width * 0.6283333,
        size.height * 0.1330935,
        size.width * 0.7777778,
        size.height * 0.1320144);
    path0.quadraticBezierTo(size.width * 0.9111111, size.height * 0.1301295,
        size.width, size.height * 0.0848921);
    path0.lineTo(size.width, 0);

    return path0;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}
