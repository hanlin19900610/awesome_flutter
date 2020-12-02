import 'package:extended_text/extended_text.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class ExpandableText extends StatefulWidget {
  const ExpandableText(
    this.text, {
    Key key,
    this.expandText,
    this.collapseText,
    this.expandColor,
    this.collapseColor,
    this.expandView,
    this.collapseView,
    this.expandImage,
    this.collapseImage,
    this.imageHeight,
    this.imageWidth,
    this.expanded = false,
    this.style,
    this.textDirection,
    this.textAlign,
    this.textScaleFactor,
    this.maxLines = 2,
    this.semanticsLabel,
    this.keywords,
    this.keywordColor,
  })  : assert(text != null),
        assert((expandText != null &&
                collapseText != null &&
                expandColor != null &&
                collapseColor != null) ||
            (expandView != null && collapseView != null)),
        assert(expanded != null),
        assert(maxLines != null && maxLines > 0),
        assert(expandImage == null ||
            collapseImage == null ||
            (expandImage != null &&
                collapseImage != null &&
                imageHeight != null &&
                imageWidth != null)),
        super(key: key);

  /// 文本内容
  final String text;

  /// 展开文字
  final String expandText;

  /// 收起文字
  final String collapseText;

  /// 是否展开
  final bool expanded;

  /// 展开文字颜色
  final Color expandColor;

  /// 收起文字颜色
  final Color collapseColor;

  /// 展开图片路径
  final String expandImage;

  /// 收起图片路径
  final String collapseImage;

  /// 图片高度
  final double imageHeight;

  /// 图片宽度
  final double imageWidth;

  /// 文字样式
  final TextStyle style;

  final TextDirection textDirection;
  final TextAlign textAlign;
  final double textScaleFactor;

  /// 最大行数
  final int maxLines;

  /// 扩展View
  final Widget expandView;
  final Widget collapseView;
  final String semanticsLabel;

  /// 改变颜色文本的集合
  final List<String> keywords;

  /// 改变后的颜色
  final Color keywordColor;

  @override
  ExpandableTextState createState() => ExpandableTextState();
}

class ExpandableTextState extends State<ExpandableText> {
  bool _expanded = false;
  bool hasImage = false;
  bool hasExpandedView = false;
  TapGestureRecognizer _tapGestureRecognizer;

  @override
  void initState() {
    super.initState();
    _expanded = widget.expanded;
    _tapGestureRecognizer = TapGestureRecognizer()..onTap = _toggleExpanded;
  }

  @override
  void dispose() {
    _tapGestureRecognizer.dispose();
    super.dispose();
  }

  void _toggleExpanded() {
    setState(() => _expanded = !_expanded);
  }

  @override
  Widget build(BuildContext context) {
    /// 是否显示扩展图片
    hasImage = widget.collapseImage != null && widget.collapseImage != null;

    /// 是否使用换行组件
    hasExpandedView = widget.expandView != null && widget.collapseView != null;
    final DefaultTextStyle defaultTextStyle = DefaultTextStyle.of(context);
    TextStyle effectiveTextStyle = widget.style;
    if (widget.style == null || widget.style.inherit) {
      effectiveTextStyle = defaultTextStyle.style.merge(widget.style);
    }

    final textAlign =
        widget.textAlign ?? defaultTextStyle.textAlign ?? TextAlign.start;
    final textDirection = widget.textDirection ?? Directionality.of(context);
    final textScaleFactor =
        widget.textScaleFactor ?? MediaQuery.textScaleFactorOf(context);
    final locale = Localizations.localeOf(context, nullOk: true);

    /// 展开 隐藏的文本
    final linkText =
        _expanded ? ' ${widget.collapseText}' : '${widget.expandText}';

    // 展开 隐藏的文本颜色
    final linkColor = _expanded ? widget.collapseColor : widget.expandColor;

    final link = TextSpan(
      text: linkText,
      style: effectiveTextStyle.copyWith(
        color: linkColor,
      ),
      recognizer: _tapGestureRecognizer,
    );

    // 展开和隐藏的图标
    final images = hasImage
        ? ImageSpan(
            _expanded
                ? AssetImage(widget.collapseImage)
                : AssetImage(widget.expandImage),
            imageWidth: widget.imageWidth,
            imageHeight: widget.imageHeight)
        : TextSpan();

    /// 三个点
    final moreSpan = TextSpan(
      text: '...',
      style: effectiveTextStyle,
    );

    /// 尾部扩展
    final endSpan = hasExpandedView
        ? TextSpan()
        : TextSpan(
            style: effectiveTextStyle,
            children: [link, images],
          );

    final text = TextSpan(
      text: widget.text,
      style: effectiveTextStyle,
    );

    Widget result = LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        assert(constraints.hasBoundedWidth);
        final double maxWidth = constraints.maxWidth;

        TextPainter textPainter = TextPainter(
          text: link,
          textAlign: textAlign,
          textDirection: textDirection,
          textScaleFactor: textScaleFactor,
          maxLines: widget.maxLines,
          locale: locale,
        );
        textPainter.layout(minWidth: constraints.minWidth, maxWidth: maxWidth);
        final linkSize = textPainter.size;

        /// 获取三个点的宽度
        textPainter.text = moreSpan;
        textPainter.layout(minWidth: constraints.minWidth, maxWidth: maxWidth);
        final moreSize = textPainter.size;

        textPainter.text = text;
        textPainter.layout(minWidth: constraints.minWidth, maxWidth: maxWidth);
        final textSize = textPainter.size;

        final position = hasExpandedView
            ? textPainter.getPositionForOffset(Offset(
                textSize.width - moreSize.width,
                textSize.height,
              ))
            : textPainter.getPositionForOffset(Offset(
                textSize.width -
                        moreSize.width -
                        linkSize.width -
                        widget.imageWidth ??
                    0,
                textSize.height,
              ));
        final endOffset = textPainter.getOffsetBefore(position.offset);

        TextSpan textSpan;

        /// 判断原始文字在指定最大行数的时候是否超出
        bool hasMore = textPainter.didExceedMaxLines;
        if(widget.keywords == null || widget.keywords.length == 0) {
          if (hasMore) {
            textSpan = TextSpan(
              style: effectiveTextStyle,
              text: _expanded
                  ? widget.text
                  : '${widget.text.substring(
                  0, hasImage ? endOffset : endOffset)}...',
              children: [endSpan],
            );
          } else {
            textSpan = text;
          }
        }else{
          if (hasMore) {
            String content = _expanded
                ? widget.text
                : '${widget.text.substring(
                0, hasImage ? endOffset : endOffset)}...';
            List<TextSpan> ts = splitTextSpan1(content, widget.keywords, 0,effectiveTextStyle);
            ts.add(endSpan);
            textSpan = TextSpan(
              children: ts,
            );
          } else {
            textSpan = TextSpan(
              children: splitTextSpan1(widget.text, widget.keywords,0,effectiveTextStyle),
            );
          }
        }

        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RichText(
              text: textSpan,
              softWrap: true,
              textDirection: textDirection,
              textAlign: textAlign,
              textScaleFactor: textScaleFactor,
              overflow: TextOverflow.clip,
            ),
            widget.expandView != null && widget.collapseView != null
                ? InkWell(
                    onTap: () {
                      _toggleExpanded();
                    },
                    child: _expanded ? widget.collapseView : widget.expandView,
                  )
                : Container(),
          ],
        );
      },
    );
    if (widget.semanticsLabel != null) {
      result = Semantics(
        textDirection: widget.textDirection,
        label: widget.semanticsLabel,
        child: ExcludeSemantics(
          child: result,
        ),
      );
    }

    return result;
  }

  List<TextSpan> splitTextSpan1(String content, List<String> keywords, int index, TextStyle style) {
    List<TextSpan> spans = [];
    List<String> strS = content.split(keywords[index]);
    for (int i = 0; i < strS.length; i++) {
      if(keywords.length == 1 ||index == keywords.length - 1){
        spans.add(TextSpan(text: strS[i], style: style));
      }else {
        spans.addAll(splitTextSpan1(strS[i], keywords, index + 1, style));
      }
      if (i < strS.length - 1) {
        spans.add(TextSpan(
            text: keywords[index],
            style: style.copyWith(color: widget.keywordColor)));
      }
    }
    return spans;
  }
}
