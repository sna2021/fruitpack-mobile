import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart' show DragStartBehavior;
import 'package:fruitpackmobile/packs/packsApi/packsGet.dart';
import '../colors.dart';

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
            margin: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
            child: Scrollbar(
              child: SingleChildScrollView(
                dragStartBehavior: DragStartBehavior.down,
                padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      child: Padding(
                        padding: EdgeInsets.only(top: 32),
                        child: Text(
                          'НАШИ СМУЗИ',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 24),
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 8.0),
                      height: 560,
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
                                  margin: EdgeInsets.symmetric(
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
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Container(
                                        margin: EdgeInsets.symmetric(
                                            vertical: 16.0, horizontal: 8),
                                        height: 240,
                                        width: 220,
                                        child: logo != null
                                            ? CachedNetworkImage(
                                                imageUrl: logo,
                                                imageBuilder:
                                                    (context, imageProvider) =>
                                                        Container(
                                                  decoration: BoxDecoration(
                                                    image: DecorationImage(
                                                      image: imageProvider,
                                                      fit: BoxFit.cover,
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
                                        margin: EdgeInsets.all(4.0),
                                        width: 200.0,
                                        child: Text(description),
                                      ),
                                      Container(
                                        child: RaisedButton(
                                          onPressed: handleGetPacks,
                                          child: Text('Добавить в корзину'),
                                        ),
                                      ),
                                      Container(
                                        child: RaisedButton(
                                          onPressed: handleGetPacks,
                                          child: Text('Подробнее'),
                                        ),
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
