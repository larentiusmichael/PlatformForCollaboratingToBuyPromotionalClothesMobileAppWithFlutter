//Programmer Name: Laurentius Michael
//Program Name: Platform for Collaborating to Buy Promotional Clothes

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loading extends StatelessWidget {
  const Loading({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[100],
      child: Center(
        child: SpinKitCircle(
          color: Colors.black,
          size: 50.0,
        ),
      ),
    );
  }
}