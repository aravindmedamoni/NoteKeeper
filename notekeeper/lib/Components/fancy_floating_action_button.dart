

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class FancyFloatingActionButton extends StatelessWidget {

  final GestureTapCallback onPressed;
  FancyFloatingActionButton({@required this.onPressed});
  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      fillColor: Theme.of(context).primaryColor,
        splashColor: Colors.purple,
        child: Padding(
          padding: const EdgeInsets.only(left: 20.0,right: 20.0,top: 15.0,bottom: 15.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text('Add Note',
              style: TextStyle(color: Colors.white,
              fontSize: 15.0,
              fontWeight: FontWeight.w700),),
              SizedBox(
                width: 2.0,
              ),
              Icon(
                Icons.create,
                color: Colors.white,
                size: 22.0,
              ),
            ],
          ),
        ),
        shape: const StadiumBorder(),
        onPressed: onPressed,
    );
  }
}
