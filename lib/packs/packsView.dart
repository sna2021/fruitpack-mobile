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
  List<String> _packs;
  bool _isLoadingPacks = false;
  bool get isPacks => _packs != null;

  void handleGetPacks() async {
    setState(() {
      _isLoadingPacks = true;
    });
    List<String> res = await getPacks();

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
          child: Form(
            key: _formKey,
            child: Container(
              margin: EdgeInsets.symmetric(vertical: 20.0, horizontal: 16),
              decoration: BoxDecoration(
                  border: Border.all(color: AppColors.gray, width: 1.5)),
              child: Scrollbar(
                child: SingleChildScrollView(
                  dragStartBehavior: DragStartBehavior.down,
                  padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                                width: 1,
                                style: BorderStyle.solid,
                                color: AppColors.gray),
                          ),
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 24, vertical: 16),
                          child: RaisedButton(
                            onPressed: handleGetPacks,
                            child: Text('PACKS'),
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 10.0),
                        height: 230.0,
                        child: _isLoadingPacks
                            ? buildSpinner()
                            : !isPacks
                                ? Center(
                                    child: Text('Nothing. Need search word.'))
                                : ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: isPacks ? _packs.length : 1,
                                    itemBuilder: (context, i) => Container(
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                            width: 1.5,
                                            style: BorderStyle.solid,
                                            color: AppColors.gray),
                                      ),
                                      margin:
                                          EdgeInsets.symmetric(horizontal: 8.0),
                                      width: 150.0,
                                      child: Padding(
                                        padding: EdgeInsets.all(3),
                                        child: CachedNetworkImage(
                                          imageUrl: _packs[i],
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
                                          errorWidget: (context, url, error) =>
                                              Icon(Icons.error),
                                        ),
                                      ),
                                    ),
                                  ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ));
  }
}
