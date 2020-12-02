import 'package:flutter/material.dart';

/// 自定义复选框
class CustomerCheckbox extends StatefulWidget {
  CustomerCheckbox(
      {Key key,
      @required this.value,
      this.onChanged,
      this.height,
      this.width,
      @required this.checkedImage,
      @required this.uncheckedImage})
      : super(key: key);

  final bool value;
  final ValueChanged<bool> onChanged;
  final double height;
  final double width;
  final Widget checkedImage;
  final Widget uncheckedImage;

  @override
  _CustomerCheckboxState createState() => _CustomerCheckboxState();
}

class _CustomerCheckboxState extends State<CustomerCheckbox>
    with TickerProviderStateMixin {
  bool _value;

  @override
  void initState() {
    super.initState();
    _value = widget.value;
  }

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasMaterial(context));
    return Container(
        child: InkWell(
      child: _value ? widget.checkedImage : widget.uncheckedImage,
      borderRadius: BorderRadius.all(Radius.circular(30)),
      onTap: () {
        setState(() {
          _value = !_value;
          widget.onChanged(_value);
        });
      },
    ));
  }
}
