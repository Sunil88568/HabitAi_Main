import 'package:flutter/material.dart';

@immutable
class UiTheme extends ThemeExtension<UiTheme> {
  final Color appBarColor;
  final Color appBarSecondaryColor;
  final Color appBarDataColor;
  final Color appBarSecondaryDataColor;
  final Color backGroundColor;
  final Color backGroundSecondaryColor;
  final Color splashColor;
  final Color editTextField;
  final Color forgetText;
  final Color cardColor;
  final Color btnColor;
  final Color grey;
  final Color transp;
  final Color colorF5;
  final Color cardBaground;
  final Color cardbagroundColor;
  final Color red;
  final Color yellow;
  final Color exploreColorColor;
  final Color bgcolor;
  final Color green;
  final Color termandcondation;
  final Color orange;
  final Color primaryBlue;
  final Color greyHint;
  final Color retake;
  final Color border;
  final Color divider;
  final Color greynew;
  final Color greySetting;
  final Color Grey;
  final Color contcolor;
  final Color greenlight;
  final Color newgrey;
  final Color resultcolor;
  final Color txtfieldtext;
  final Color blackText;
  final Color white;

  const UiTheme({
    required this.appBarColor,
    required this.appBarSecondaryColor,
    required this.appBarDataColor,
    required this.appBarSecondaryDataColor,
    required this.backGroundColor,
    required this.backGroundSecondaryColor,
    required this.splashColor,
    required this.editTextField,
    required this.forgetText,
    required this.cardColor,
    required this.btnColor,
    required this.grey,
    required this.transp,
    required this.colorF5,
    required this.cardBaground,
    required this.cardbagroundColor,
    required this.red,
    required this.yellow,
    required this.exploreColorColor,
    required this.bgcolor,
    required this.green,
    required this.termandcondation,
    required this.orange,
    required this.primaryBlue,
    required this.greyHint,
    required this.retake,
    required this.border,
    required this.divider,
    required this.greynew,
    required this.greySetting,
    required this.Grey,
    required this.contcolor,
    required this.greenlight,
    required this.newgrey,
    required this.resultcolor,
    required this.txtfieldtext,
    required this.blackText,
    required this.white,
  });

  @override
  UiTheme copyWith({
    Color? appBarColor,
    Color? appBarSecondaryColor,
    Color? appBarDataColor,
    Color? appBarSecondaryDataColor,
    Color? backGroundColor,
    Color? backGroundSecondaryColor,
    Color? splashColor,
    Color? editTextField,
    Color? forgetText,
    Color? cardColor,
    Color? btnColor,
    Color? grey,
    Color? transp,
    Color? colorF5,
    Color? cardBaground,
    Color? cardbagroundColor,
    Color? red,
    Color? yellow,
    Color? exploreColorColor,
    Color? bgcolor,
    Color? green,
    Color? termandcondation,
    Color? orange,
    Color? primaryBlue,
    Color? greyHint,
    Color? retake,
    Color? border,
    Color? divider,
    Color? greynew,
    Color? greySetting,
    Color? Grey,
    Color? contcolor,
    Color? greenlight,
    Color? newgrey,
    Color? resultcolor,
    Color? txtfieldtext,
    Color? blackText,
    Color? white,
  }) {
    return UiTheme(
      appBarColor: appBarColor ?? this.appBarColor,
      appBarSecondaryColor: appBarSecondaryColor ?? this.appBarSecondaryColor,
      appBarDataColor: appBarDataColor ?? this.appBarDataColor,
      appBarSecondaryDataColor: appBarSecondaryDataColor ?? this.appBarSecondaryDataColor,
      backGroundColor: backGroundColor ?? this.backGroundColor,
      backGroundSecondaryColor: backGroundSecondaryColor ?? this.backGroundSecondaryColor,
      splashColor: splashColor ?? this.splashColor,
      editTextField: editTextField ?? this.editTextField,
      forgetText: forgetText ?? this.forgetText,
      cardColor: cardColor ?? this.cardColor,
      btnColor: btnColor ?? this.btnColor,
      grey: grey ?? this.grey,
      transp: transp ?? this.transp,
      colorF5: colorF5 ?? this.colorF5,
      cardBaground: cardBaground ?? this.cardBaground,
      cardbagroundColor: cardbagroundColor ?? this.cardbagroundColor,
      red: red ?? this.red,
      yellow: yellow ?? this.yellow,
      exploreColorColor: exploreColorColor ?? this.exploreColorColor,
      bgcolor: bgcolor ?? this.bgcolor,
      green: green ?? this.green,
      termandcondation: termandcondation ?? this.termandcondation,
      orange: orange ?? this.orange,
      primaryBlue: primaryBlue ?? this.primaryBlue,
      greyHint: greyHint ?? this.greyHint,
      retake: retake ?? this.retake,
      border: border ?? this.border,
      divider: divider ?? this.divider,
      greynew: greynew ?? this.greynew,
      greySetting: greySetting ?? this.greySetting,
      Grey: Grey ?? this.Grey,
      contcolor: contcolor ?? this.contcolor,
      greenlight: greenlight ?? this.greenlight,
      newgrey: newgrey ?? this.newgrey,
      resultcolor: resultcolor ?? this.resultcolor,
      txtfieldtext: txtfieldtext ?? this.txtfieldtext,
      blackText: blackText ?? this.blackText,
      white: white ?? this.white,
    );
  }

  @override
  UiTheme lerp(ThemeExtension<UiTheme>? other, double t) {
    if (other is! UiTheme) return this;
    return UiTheme(
      appBarColor: Color.lerp(appBarColor, other.appBarColor, t)!,
      appBarSecondaryColor: Color.lerp(appBarSecondaryColor, other.appBarSecondaryColor, t)!,
      appBarDataColor: Color.lerp(appBarDataColor, other.appBarDataColor, t)!,
      appBarSecondaryDataColor: Color.lerp(appBarSecondaryDataColor, other.appBarSecondaryDataColor, t)!,
      backGroundColor: Color.lerp(backGroundColor, other.backGroundColor, t)!,
      backGroundSecondaryColor: Color.lerp(backGroundSecondaryColor, other.backGroundSecondaryColor, t)!,
      splashColor: Color.lerp(splashColor, other.splashColor, t)!,
      editTextField: Color.lerp(editTextField, other.editTextField, t)!,
      forgetText: Color.lerp(forgetText, other.forgetText, t)!,
      cardColor: Color.lerp(cardColor, other.cardColor, t)!,
      btnColor: Color.lerp(btnColor, other.btnColor, t)!,
      grey: Color.lerp(grey, other.grey, t)!,
      transp: Color.lerp(transp, other.transp, t)!,
      colorF5: Color.lerp(colorF5, other.colorF5, t)!,
      cardBaground: Color.lerp(cardBaground, other.cardBaground, t)!,
      cardbagroundColor: Color.lerp(cardbagroundColor, other.cardbagroundColor, t)!,
      red: Color.lerp(red, other.red, t)!,
      yellow: Color.lerp(yellow, other.yellow, t)!,
      exploreColorColor: Color.lerp(exploreColorColor, other.exploreColorColor, t)!,
      bgcolor: Color.lerp(bgcolor, other.bgcolor, t)!,
      green: Color.lerp(green, other.green, t)!,
      termandcondation: Color.lerp(termandcondation, other.termandcondation, t)!,
      orange: Color.lerp(orange, other.orange, t)!,
      primaryBlue: Color.lerp(primaryBlue, other.primaryBlue, t)!,
      greyHint: Color.lerp(greyHint, other.greyHint, t)!,
      retake: Color.lerp(retake, other.retake, t)!,
      border: Color.lerp(border, other.border, t)!,
      divider: Color.lerp(divider, other.divider, t)!,
      greynew: Color.lerp(greynew, other.greynew, t)!,
      greySetting: Color.lerp(greySetting, other.greySetting, t)!,
      Grey: Color.lerp(Grey, other.Grey, t)!,
      contcolor: Color.lerp(contcolor, other.contcolor, t)!,
      greenlight: Color.lerp(greenlight, other.greenlight, t)!,
      newgrey: Color.lerp(newgrey, other.newgrey, t)!,
      resultcolor: Color.lerp(resultcolor, other.resultcolor, t)!,
      txtfieldtext: Color.lerp(txtfieldtext, other.txtfieldtext, t)!,
      blackText: Color.lerp(blackText, other.blackText, t)!,
      white: Color.lerp(white, other.white, t)!,
    );
  }
}

final lightUiTheme = UiTheme(
  appBarColor: Colors.white,
  appBarSecondaryColor: Colors.white,
  appBarDataColor: Colors.black,
  appBarSecondaryDataColor: Colors.black,
  backGroundColor: Colors.white,
  backGroundSecondaryColor: Colors.grey[100]!,

  splashColor: Color(0xffA259FF),
  editTextField: Color(0xffF0F5FA),
  forgetText: Color(0xffFDC04F),
  cardColor: Color(0xffB5DCEE),
  btnColor: Color(0xFF30AFFC),
  grey: Color(0xFF858585),
  transp: Color(0xFFD9D9D9E5),
  colorF5: Color(0xFFF5F5F5),
  cardBaground: Color(0xFFF6F8FA),
  cardbagroundColor: Color(0xFFFBFBFB),
  red: Color(0xFFF14336),
  yellow: Color(0xFFFBBB00),
  exploreColorColor: Color(0xFFFDC04F),
  bgcolor: Color(0xFFC4C4C4),
  green: Color(0xFF00C48C),
  termandcondation: Color(0xFFBC9C22),
  orange: Colors.orange,
  primaryBlue: Color(0xFF1976D2),
  greyHint: Color(0xFF959595),
  retake: Color(0xFFE1DFDF),
  border: Color(0xFF8D99AE),
  divider: Color(0xFFF1F1F1),
  greynew: Color(0xFFC0C0C0),
  greySetting: Color(0xFFF7F7F7),
  Grey: Color(0xFFD9D9D9),
  contcolor: Color(0xFFf0ecec),
  greenlight: Color(0xFF0CD03D),
  newgrey: Color(0xFFF7F7F7),
  resultcolor: Color(0xFF88ec9c),
  txtfieldtext: Color(0xFF697585),
  blackText: Color(0xFF1F1F1F),
  white: Color(0xFFFFFFFF),
);

final darkUiTheme = UiTheme(
  appBarColor: Colors.black,
  appBarSecondaryColor: Color(0xFF1C1C1C),
  appBarDataColor: Colors.white,
  appBarSecondaryDataColor: Colors.white70,
  backGroundColor: Color(0xFF121212),
  backGroundSecondaryColor: Color(0xFF1E1E1E),

  splashColor: Color(0xffA259FF),
  editTextField: Color(0xFF2A2A2A),
  forgetText: Color(0xffFDC04F),
  cardColor: Color(0xff3B3B3B),
  btnColor: Color(0xFF30AFFC),
  grey: Color(0xFFB0B0B0),
  transp: Color(0xFF1E1E1E),
  colorF5: Color(0xFF2C2C2C),
  cardBaground: Color(0xFF1E1E1E),
  cardbagroundColor: Color(0xFF2C2C2C),
  red: Color(0xFFE57373),
  yellow: Color(0xFFFFD54F),
  exploreColorColor: Color(0xFFFDC04F),
  bgcolor: Color(0xFF2E2E2E),
  green: Color(0xFF00C48C),
  termandcondation: Color(0xFFE0C558),
  orange: Colors.deepOrangeAccent,
  primaryBlue: Color(0xFF42A5F5),
  greyHint: Color(0xFF8E8E8E),
  retake: Color(0xFF424242),
  border: Color(0xFF5A5A5A),
  divider: Color(0xFF383838),
  greynew: Color(0xFF606060),
  greySetting: Color(0xFF3C3C3C),
  Grey: Color(0xFF757575),
  contcolor: Color(0xFF2D2D2D),
  greenlight: Color(0xFF00E676),
  newgrey: Color(0xFFBDBDBD),
  resultcolor: Color(0xFF64DD17),
  txtfieldtext: Colors.white70,
  blackText: Colors.black,
  white: Color(0xFFFFFFFF),
);

