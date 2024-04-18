import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../greyscalemode/grayscale_settings.dart';
import '../limit/limit_settings.dart';

const methodChannel = MethodChannel('ekagrata_app');

class FocusPage extends StatefulWidget {
  const FocusPage({super.key});

  @override
  State<FocusPage> createState() => _FocusPageState();
}

class _FocusPageState extends State<FocusPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFffbe0b).withOpacity(0.7),
      appBar: AppBar(
        centerTitle: true,
        title: Text("Focus Mode"),
      ),
      body: Center(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  decoration: BoxDecoration(
                      color: Colors.yellow,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(width: 1)),
                  width: MediaQuery.of(context).size.width / 2.1,
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(20),
                      // border: BoxBorder[]
                    ),
                    child: Column(
                      children: [
                        Text(
                          "Block Gaming Apps",
                          style: TextStyle(fontSize: 16),
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            var result = 'approved';
                            if (Platform.isAndroid) {
                              result = await methodChannel
                                  .invokeMethod('checkPermission') as String;
                            }
                            debugPrint('[DEBUG]result: $result');
                            if (result == 'approved') {
                              await methodChannel.invokeMethod('blockApp');
                            } else {
                              debugPrint('[DEBUG]Permission not granted');
                              await methodChannel
                                  .invokeMethod('requestAuthorization');
                            }
                          },
                          child: const Text('blockApp'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            methodChannel.invokeMethod('unblockApp');
                          },
                          child: const Text('unblockApp'),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  decoration: BoxDecoration(
                      color: Colors.yellow,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(width: 1)),
                  width: MediaQuery.of(context).size.width / 2.1,
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(20),
                      // border: BoxBorder[]
                    ),
                    child: Column(
                      children: [
                        Text(
                          "Set Apps Limit",
                          style: TextStyle(fontSize: 16),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LimitSettings()),
                            );
                          },
                          child: const Text('Set Limits'),
                        ),
                      ],
                    ),
                  ),
                ),
                // Container(
                //   padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                //   decoration: BoxDecoration(
                //       color: Colors.yellow,
                //       borderRadius: BorderRadius.circular(20),
                //       border: Border.all(width: 1)),
                //   width: MediaQuery.of(context).size.width / 2.1,
                //   child: Container(
                //     padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                //     decoration: BoxDecoration(
                //       color: Colors.red,
                //       borderRadius: BorderRadius.circular(20),
                //       // border: BoxBorder[]
                //     ),
                //     child: Column(
                //       children: [
                //         Text(
                //           "Block Gaming Apps",
                //           style: TextStyle(fontSize: 16),
                //         ),
                //         ElevatedButton(
                //           onPressed: () async {
                //             // var result = 'approved';
                //             // if (Platform.isAndroid) {
                //             //   result = await methodChannel
                //             //       .invokeMethod('checkPermission') as String;
                //             // }
                //             // debugPrint('[DEBUG]result: $result');
                //             // if (result == 'approved') {
                //             //   await methodChannel.invokeMethod('blockApp');
                //             // } else {
                //             //   debugPrint('[DEBUG]Permission not granted');
                //             //   await methodChannel
                //             //       .invokeMethod('requestAuthorization');
                //             // }
                //           },
                //           child: const Text('blockApp'),
                //         ),
                //         ElevatedButton(
                //           onPressed: () {
                //             // methodChannel.invokeMethod('unblockApp');
                //           },
                //           child: const Text('unblockApp'),
                //         ),
                //       ],
                //     ),
                //   ),
                // ),
              ],
            ),
            Row(
              children: [],
            ),
            // ElevatedButton(
            //   onPressed: () {
            //     Navigator.push(
            //       context,
            //       MaterialPageRoute(builder: (context) => GrayscaleSettings()),
            //     );
            //   },
            //   child: const Text('Grayscale Settings'),
            // ),
          ],
        ),
      ),
    );
  }
}
