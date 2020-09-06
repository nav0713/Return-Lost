import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class NoContent extends StatelessWidget {
  final String text;

  NoContent(this.text);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            height: 150.0,
            width: 150.0,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("images/empty.png"),
              )
            ),
          ),
          SizedBox(height: 25,),
          Text(text,textAlign: TextAlign.justify,style: TextStyle(fontSize: 16,color: Colors.black45,wordSpacing: 2),

          ),   ],
      ),
    );
  }
}
