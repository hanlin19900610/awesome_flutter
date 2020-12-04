import 'package:awesome_flutter/public/index.dart';
import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with UITools {
  TextEditingController _controller = TextEditingController();

  List<String> keywords = [];
  @override
  Widget build(BuildContext context) {
    setDesignWHD(375, 812);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Awesome Flutter Demo',
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10.w),
              child: Row(
                children: [
                  Expanded(
                      child: TextField(
                    controller: _controller,
                        decoration: InputDecoration(
                          hintText: '请输入要标红的文字, 多个请用 ","逗号 分割',
                          hintStyle: TextStyle(color: Colors.grey, fontSize: 12.sp)
                        ),
                  )),
                  TextButton(onPressed: () {
                    String content = _controller.text;
                    keywords = content.split(',');
                    setState(() {

                    });
                  }, child: Text('文字标红'))
                ],
              ),
            ),
            Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15.h),
                  color: Colors.white),
              margin: EdgeInsets.all(10),
              padding: EdgeInsets.all(5),
              child: ExpandableText(
                "飞行力学是研究飞行器在空中飞行时所受到的力和运动轨迹的学问，通俗的讲就是研究飞机在飞行时的受力情况，以及如何保持需要的飞行姿态，如何调整飞行状态和飞行轨迹的学问。飞行力学是在空气动力学的基础上对飞机飞行控制领域进行非常专业的研究和深入的运用。从狭义上来说，传统飞行力学主要采用力学原理研究飞行器的运动规律和特性，是力学学科的分支。但从广义上来说，由于飞行器运动特性与飞行器所受的空气动力、发动机推力及飞行器结构弹性变形、飞机控制等密切相关，直接决定了飞行器的总体特征、任务能力和使用需求，已成为飞行器设计的出发点和归宿点，为此，飞行力学正逐步发展为一门飞行器设计领域的系统、综合性学科。",
                expandText: '展开',
                collapseText: '隐藏',
                maxLines: 4,
                expandColor: Color(0xFFF22C2C),
                collapseColor: Color(0xff3970FB),
                expandImage: 'assets/image/down.png',
                collapseImage: 'assets/image/up.png',
                imageHeight: 15,
                imageWidth: 15,
                keywordColor: Colors.red,
                keywords: keywords,
              ),
            ),
            Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15.h),
                  color: Colors.white),
              margin: EdgeInsets.all(10),
              padding: EdgeInsets.all(5),
              child: ExpandableText(
                "飞行力学是研究飞行器在空中飞行时所受到的力和运动轨迹的学问，通俗的讲就是研究飞机在飞行时的受力情况，以及如何保持需要的飞行姿态，如何调整飞行状态和飞行轨迹的学问。飞行力学是在空气动力学的基础上对飞机飞行控制领域进行非常专业的研究和深入的运用。从狭义上来说，传统飞行力学主要采用力学原理研究飞行器的运动规律和特性，是力学学科的分支。但从广义上来说，由于飞行器运动特性与飞行器所受的空气动力、发动机推力及飞行器结构弹性变形、飞机控制等密切相关，直接决定了飞行器的总体特征、任务能力和使用需求，已成为飞行器设计的出发点和归宿点，为此，飞行力学正逐步发展为一门飞行器设计领域的系统、综合性学科。",
                maxLines: 4,
                expandColor: Color(0xFFF22C2C),
                collapseColor: Color(0xff3970FB),
                expandView: Center(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [Text('展开', style: TextStyle(color: Color(0xFFF22C2C)),), Image.asset('assets/image/down.png', width: 15, height: 15,)],
                  ),
                ),
                collapseView: Center(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [Text('隐藏', style: TextStyle(color: Color(0xff3970FB)),), Image.asset('assets/image/up.png', width: 15, height: 15,)],
                  ),
                ),
                imageHeight: 15,
                imageWidth: 15,
                keywordColor: Colors.red,
                keywords: keywords,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
