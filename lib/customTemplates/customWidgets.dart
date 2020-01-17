import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:scheduler/customTemplates/export.dart';

import 'colours.dart';
import 'themes.dart';

import 'package:scheduler/bloc/search/search.dart';

class CircleButton extends MaterialButton {
  final double size;
  const CircleButton({
    Key key,
    @required VoidCallback onPressed,
    VoidCallback onLongPress,
    ValueChanged<bool> onHighlightChanged,
    ButtonTextTheme textTheme,
    Color textColor,
    Color disabledTextColor,
    Color color,
    Color disabledColor,
    Color focusColor,
    Color hoverColor,
    Color highlightColor,
    Color splashColor,
    Brightness colorBrightness,
    EdgeInsetsGeometry padding,
    Clip clipBehavior = Clip.none,
    FocusNode focusNode,
    bool autofocus = false,
    MaterialTapTargetSize materialTapTargetSize,
    @required this.size,
    @required Widget child,
  }) : assert(clipBehavior != null),
       assert(autofocus != null),
       super(
         key: key,
         onPressed: onPressed,
         onLongPress: onLongPress,
         onHighlightChanged: onHighlightChanged,
         textTheme: textTheme,
         textColor: textColor,
         disabledTextColor: disabledTextColor,
         color: color,
         disabledColor: disabledColor,
         focusColor: focusColor,
         hoverColor: hoverColor,
         highlightColor: highlightColor,
         splashColor: splashColor,
         colorBrightness: colorBrightness,
         padding: padding,
         clipBehavior: clipBehavior,
         focusNode: focusNode,
         autofocus: autofocus,
         materialTapTargetSize: materialTapTargetSize,
         child: child,
      );

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ButtonThemeData buttonTheme = ButtonTheme.of(context);

    return Container (
      width: size,
      height: size,
      padding: EdgeInsets.all(size/18),

      decoration: new BoxDecoration(
        border: Border.all(color: buttonTheme.getFillColor(this), width: 2.0),
        shape: BoxShape.circle,
      ),

      child: RawMaterialButton(
        onPressed: onPressed,
        onLongPress: onLongPress,
        onHighlightChanged: onHighlightChanged,

        /* Some bugs in setting localized button theme --- temporary fix, need to fix later */

        fillColor: buttonTheme.getFillColor(this),
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
        shape: new CircleBorder(),
        materialTapTargetSize: buttonTheme.getMaterialTapTargetSize(this),
        animationDuration: buttonTheme.getAnimationDuration(this),
        child: child,  
      ),      
    );
  }
}

class ThemedButton extends StatelessWidget {
  const ThemedButton({Key key, this.text, this.callback, this.icon, @required this.size}) : super(key: key);

  final String text;
  final Icon icon;
  final VoidCallback callback;
  final double size;

  @override
  Widget build(BuildContext context) {
    return CircleButton(
      child: (icon!= null)? icon : Text(text, style: mainTheme.textTheme.body1),
      onPressed: callback,
      color: purple[500],
      size: size,
      disabledColor: purple[200],
      padding: EdgeInsets.all(3.0),
    );
  }
}

Widget backBtn(VoidCallback callback) {
  return IconButton(
    padding: EdgeInsets.all(0),
    icon: Icon(Icons.arrow_left),
    color: Colors.white,
    onPressed: () => callback(),
  );
}

class Tag extends StatelessWidget {
  Tag({
    Key key,
    this.padding,
    this.bgColor,
    double width,
    double height,
    BoxConstraints constraints,
    this.margin,
    this.child,
  }) : assert(margin == null || margin.isNonNegative),
       assert(padding == null || padding.isNonNegative),
       assert(constraints == null || constraints.debugAssertIsValid()),
       constraints =
        (width != null || height != null)
          ? constraints?.tighten(width: width, height: height)
            ?? BoxConstraints.tightFor(width: width, height: height)
          : constraints,
       super(key: key);

  final Color bgColor;
  final Widget child;
  final EdgeInsetsGeometry padding;

  final BoxConstraints constraints;
  final EdgeInsetsGeometry margin;

  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      padding: padding,
      decoration: BoxDecoration(
        color: bgColor == null ? purple[700] : bgColor,
        borderRadius: BorderRadius.all(Radius.circular(7.0)),
      ),

      child: child,
    );
  }
}

class SearchContent extends StatelessWidget {
  /// Returns a widget for a full screen search page
  /// 
  /// `title` : text for header
  /// 
  /// `list` : list of objects defined by user able to be searched
  /// 
  /// `extractString` : (object) => string, returns string to check for add new
  /// 
  /// `newCallback` : (string, context, bloc) => void, onpressed function of add new item
  /// 
  /// `tileContent` : (object) => widget, object information display format in list tile
  SearchContent({
    Key key,
    this.title,
    @required this.list,
    @required this.extractString,
    @required this.newString,
    @required this.newCallback,
    @required this.tileContent,
  }) : super(key: key);

  final String title;
  final List<Object> list;
  final Function newString;
  final Function newCallback;
  final Function extractString;
  final Function tileContent;

  @override
  Widget build(BuildContext context) {
    // print(context);
    return Provider(
      child: _content(context),
    );
  }
  
  Widget _content(BuildContext context) {
    return Builder(
      builder: (context) {
        final bloc = Provider.of(context);

        return Container(
          child: Column(
            children: <Widget>[
              _headerNav(context),
              _searchBar(bloc),
              _dataSource(bloc),
            ],
          ),
        );
      },
    );
  }

  Widget _headerNav(BuildContext context) {
    return Stack(
      alignment: Alignment.centerLeft,
      children: [
        backBtn(() => Navigator.pop(context, null)),
        Center(
          child: Text(
            'Select $title',
            style: mainTheme.textTheme.subtitle,
          ),
        ),
      ],
    );
  }

  Widget _searchBar(Bloc bloc) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 30.0),
      child: StreamBuilder(
        stream: bloc.search,
        builder: (context, snapshot) {
          return TextField(
            keyboardType: TextInputType.text,
            style: mainTheme.textTheme.body1,
            onChanged: bloc.updateSearch,
            
            decoration: searchFieldStyle('SEARCH'),
          );
        },
      ),
    );
  }

  Widget _dataSource(Bloc bloc) {
    return Expanded(
      child: _listView(bloc),
    );
  }

  ListView _listView(Bloc bloc) {
    return ListView.builder(
      padding: EdgeInsets.symmetric(vertical: 20.0),

      itemCount: list.length + 1,
      itemBuilder: (context, index) {
        return StreamBuilder(
          stream: bloc.search,
          builder: (context, snapshot) {
            return index >= list.length ? _addNew(bloc) : listRow(bloc, list[index], context);
          },
        );
      },
    );
  }

  Widget listRow(Bloc bloc, Object item, BuildContext context) {
    return Visibility(
      visible: bloc.doesContain(extractString(item), bloc.curSearch().toLowerCase()),
      child: ListTile(
        title: tileContent(item),
        onTap: () => {
          // print('${cat.name}, ${cat.id}'),
          Navigator.pop(context, item),
        },
      ),
    );
  }

  Widget _addNew(Bloc bloc) {
    return StreamBuilder(
      stream: bloc.search,
      builder: (context, snapshot) {
        /* TODO: check for blank search and spaces only searches */
        /* TODO: display some alert / visual for no search results */
        return bloc.getHidden() && bloc.curSearch().length > 0 ? _addNewCat(bloc, bloc.curSearch(), context) : Container(height: 0, width: 0,);
      },
    );
  }

  Widget _addNewCat(Bloc bloc, String string, BuildContext context) {
    return FlatButton(
      child: Text(
        newString(string),
        style: mainTheme.textTheme.body1,
      ),
      onPressed: () => newCallback(string, context, bloc),
    );
  }
}