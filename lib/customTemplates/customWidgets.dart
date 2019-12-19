import 'package:flutter/material.dart';
import 'colours.dart';

class CircleButton extends MaterialButton {
  const CircleButton({
    Key key,
    @required VoidCallback onPressed,
    @required Widget child,
  }) : super(
         key: key,
         onPressed: onPressed,
         child: child,
      );


  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ButtonThemeData buttonTheme = theme.buttonTheme.copyWith(
        padding: EdgeInsets.all(0),
        shape: new CircleBorder(),
    );

    return Container (
      width: 85.0,
      height: 85.0,
      padding: EdgeInsets.all(5.0),

      decoration: new BoxDecoration(
        border: Border.all(color: purple[500], width: 2.0),
        shape: BoxShape.circle,
      ),

      child: RawMaterialButton(
        onPressed: onPressed,
        onLongPress: onLongPress,
        onHighlightChanged: onHighlightChanged,

        /* Some bugs in setting localized button theme --- temporary fix, need to fix later */

        fillColor: purple[500],
        textStyle: theme.textTheme.button,
        focusColor: buttonTheme.getFocusColor(this),
        hoverColor: buttonTheme.getHoverColor(this),
        highlightColor: buttonTheme.getHighlightColor(this),
        splashColor: buttonTheme.getSplashColor(this),
        elevation: buttonTheme.getElevation(this),
        focusElevation: buttonTheme.getFocusElevation(this),
        hoverElevation: buttonTheme.getHoverElevation(this),
        highlightElevation: buttonTheme.getHighlightElevation(this),
        disabledElevation: buttonTheme.getDisabledElevation(this),

        padding: buttonTheme.getPadding(this),
        constraints: buttonTheme.getConstraints(this),
        shape: buttonTheme.getShape(this),
        materialTapTargetSize: buttonTheme.getMaterialTapTargetSize(this),
        animationDuration: buttonTheme.getAnimationDuration(this),
        child: child,  
      ),      
    );
  }
}