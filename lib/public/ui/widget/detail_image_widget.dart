import 'package:awesome_flutter/public/widget_state/index.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';


class DetailImageWidgetState extends StatefulWidget {

  final List<String> imageList;
  final int initIndex;

  DetailImageWidgetState(this.imageList, {this.initIndex = 0});

  @override
  _DetailImageWidgetStateState createState() => _DetailImageWidgetStateState();
}

class _DetailImageWidgetStateState extends State<DetailImageWidgetState> with UITools{
  int indexStr=1;

  @override
  Widget build(BuildContext context) {

    return Container(
      width: screenWidth,
      height: screenHeight,
      child: Stack(
        children: <Widget>[
          Container(
            color: Colors.black,
            width: screenWidth,
            height: screenHeight,
            ///可增加滑动退出等功能、具体可以查看插件的文档
            child: ExtendedImageGesturePageView.builder(
              controller: new PageController(initialPage: this.widget.initIndex),
              itemCount: widget.imageList.length,
              itemBuilder: (ctx,index){
                var url = "${widget.imageList[index]}";
                //var url = "http://a0.att.hudong.com/78/52/01200000123847134434529793168.jpg";
                Widget image = ExtendedImage.network(
                  url,fit: BoxFit.contain,mode: ExtendedImageMode.gesture,
                  initGestureConfigHandler: (state){
                    return GestureConfig(
                        inPageView: widget.imageList.length>1
                    );
                  },
                );
                return image;
              },
              onPageChanged: (int index) {
                setState(() {
                  indexStr=index+1;
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}





















