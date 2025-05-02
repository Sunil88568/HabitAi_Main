
import 'package:flutter/cupertino.dart';
import 'package:question_app/utils/extensions/size.dart';
extension OnNumWidget on num{
  SizedBox get height => SizedBox(height: getDouble.sdp,);
  SizedBox get width => SizedBox(width: getDouble.sdp,);
}