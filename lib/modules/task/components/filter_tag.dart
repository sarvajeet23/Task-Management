import 'package:flutter/material.dart';
import 'package:taskapp/utils/app_style.dart';

class FilterTag extends StatelessWidget {
  final Color? bgColor;
  final Color? textColour;
  final String? title;
  final bool isLeftPad;

  const FilterTag({
    super.key,
    this.bgColor,
    this.textColour,
    this.title,
    this.isLeftPad = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: isLeftPad ? 10 : 0, right: 10, top: 5, bottom: 5),
      alignment: Alignment.center,
      child: Text(
        title ?? '',
        style: AppStyles.style14Normal
            .copyWith(fontWeight: FontWeight.w500, color: textColour),
      ),
      decoration:
          ShapeDecoration(shape: StadiumBorder(), color: bgColor?.withOpacity(0.15)),
    );
  }
}
