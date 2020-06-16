import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart' show DragStartBehavior;
import 'package:flutter_html/flutter_html.dart';
import 'package:fruitpackmobile/packs/packsApi/packsGet.dart';
import '../colors.dart';
import 'package:html/parser.dart';

//here goes the function

String _parseHtmlString(String htmlString) {
  var document = parse(htmlString);

  String parsedString = parse(document.body.text).documentElement.text;

  return parsedString;
}

class PacksView extends StatefulWidget {
  const PacksView({Key key}) : super(key: key);

  @override
  PacksViewState createState() => PacksViewState();
}

class PacksViewState extends State<PacksView> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final searchController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  List _packs;
  bool _isLoadingPacks = true;
  bool get isPacks => _packs != null;

  @override
  void initState() {
    super.initState();

    handleGetPacks();
  }

  void handleGetPacks() async {
    setState(() {
      _isLoadingPacks = true;
    });
    List res = await getPacks();

    print('try RESPONSE $res');

    setState(() {
      _packs = res;
      _isLoadingPacks = false;
    });
  }

  void handleClearImages() {}

  Widget buildSpinner() {
    return Container(
      alignment: Alignment.center,
      child: SizedBox(
        child: CircularProgressIndicator(
          value: null,
          strokeWidth: 3.0,
          valueColor: AlwaysStoppedAnimation<Color>(AppColors.blue),
        ),
        height: 32.0,
        width: 32.0,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Center(
        heightFactor: 1,
        child: Form(
          key: _formKey,
          child: Container(
            margin: EdgeInsets.symmetric(vertical: 0, horizontal: 8),
            child: Scrollbar(
              child: SingleChildScrollView(
                dragStartBehavior: DragStartBehavior.down,
                padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 32),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            onPressed: handleGetPacks,
                            icon: Icon(Icons.arrow_back),
                            iconSize: 20,
                          ),
                          Text(
                            'НАШИ СМУЗИ',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 24),
                          ),
                          IconButton(
                            onPressed: handleGetPacks,
                            icon: Icon(Icons.arrow_forward),
                            iconSize: 20,
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin:
                          EdgeInsets.symmetric(vertical: 8.0, horizontal: 8),
                      height: MediaQuery.of(context).size.height - 16 * 6,
                      width: MediaQuery.of(context).size.width,
                      child: _isLoadingPacks
                          ? buildSpinner()
                          : ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: isPacks ? _packs.length : 1,

                              itemBuilder: (context, i) {
                                final item = _packs[i];
                                final name = item['name'];
                                final cost = item['cost'];
                                final logo = item['logo'];
                                final description = item['description'];

                                return Container(
                                  width: MediaQuery.of(context).size.width -
                                      16 * 2,
                                  margin: EdgeInsets.only(right: 16),
                                  padding: EdgeInsets.symmetric(
                                      vertical: 8.0, horizontal: 8),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      width: 1,
                                      style: BorderStyle.solid,
                                      color: Colors.green,
                                    ),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(8.0)),
                                  ),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        margin: EdgeInsets.symmetric(
                                            vertical: 8.0, horizontal: 8),
                                        height:
                                            MediaQuery.of(context).size.height *
                                                .4,
                                        //width: 100,
                                        child: logo != null
                                            ? CachedNetworkImage(
                                                imageUrl: logo,
                                                imageBuilder:
                                                    (context, imageProvider) =>
                                                        Container(
                                                  decoration: BoxDecoration(
                                                    image: DecorationImage(
                                                      image: imageProvider,
                                                      fit: BoxFit.fitHeight,
                                                    ),
                                                  ),
                                                ),
                                                placeholder: (context, url) =>
                                                    buildSpinner(),
                                                errorWidget:
                                                    (context, url, error) =>
                                                        Icon(Icons.error),
                                              )
                                            : Icon(Icons.error),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 8, vertical: 4),
                                        child: Text('Фитнес'),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 8, vertical: 4),
                                        child: Text(name),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 8, vertical: 4),
                                        child: Text(cost),
                                      ),
                                      Container(
                                        margin: EdgeInsets.symmetric(
                                            horizontal: 4.0, vertical: 16),
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.8,
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 12),
                                        child: Text(
                                          _parseHtmlString(description),
                                          textAlign: TextAlign.justify,
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 3,
                                          softWrap: false,
                                        ),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: <Widget>[
                                          IconButton(
                                            onPressed: handleGetPacks,
                                            icon: Icon(Icons.info_outline),
                                            iconSize: 24,
                                          ),
                                          IconButton(
                                            onPressed: handleGetPacks,
                                            icon: Icon(Icons.add_shopping_cart),
                                            iconSize: 24,
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                );
                              }, //сюда
                            ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
