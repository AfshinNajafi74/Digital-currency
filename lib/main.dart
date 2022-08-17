import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:fp/model/currency.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'package:intl/intl.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: const [
        GlobalCupertinoLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate
      ],
      supportedLocales: const [Locale('fa', '')],
      theme: ThemeData(
          fontFamily: 'dana',
          textTheme: const TextTheme(
              headline1: TextStyle(
                  fontFamily: 'dana',
                  fontSize: 16,
                  fontWeight: FontWeight.w700),
              bodyText1: TextStyle(
                  fontFamily: 'dana',
                  fontSize: 13,
                  fontWeight: FontWeight.w300),
              headline2: TextStyle(
                  fontFamily: 'dana',
                  fontSize: 14,
                  color: Colors.white,
                  fontWeight: FontWeight.w300),
              headline3: TextStyle(
                  fontFamily: 'dana',
                  fontSize: 14,
                  color: Colors.red,
                  fontWeight: FontWeight.w700),
              headline4: TextStyle(
                  fontFamily: 'dana',
                  fontSize: 14,
                  color: Colors.green,
                  fontWeight: FontWeight.w700))),
      debugShowCheckedModeBanner: false,
      home: const Home(),
    );
  }
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Currency> currency = [];

  @override
  void initState() {
    getResponse(context);
    super.initState();
  }

  Future getResponse(BuildContext context) async {
    String url =
        "https://sasansafari.com/flutter/api.php?access_key=flutter123456";
    var value = await http.get(Uri.parse(url));
    if (currency.isEmpty) {
      if (value.statusCode == 200) {
        _showSnackBar(context,'اطلاعات با موفقیت انجام شد .');
        List jsonList = convert.jsonDecode(value.body);
        if (jsonList.isNotEmpty) {
          for (int i = 0; i < jsonList.length; i++) {
            setState(() {
              currency.add(Currency(
                  id: jsonList[i]['id'],
                  title: jsonList[i]['title'],
                  price: jsonList[i]['price'],
                  changes: jsonList[i]['changes'],
                  status: jsonList[i]['status']));
            });
          }
        }
      }
    }
    return value;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 243, 243, 243),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          const SizedBox(
            width: 8,
          ),
          Image.asset('assets/images/icon.png'),
          Align(
              alignment: Alignment.centerRight,
              child: Text(
                'قیمت به روز ارز',
                style: Theme.of(context).textTheme.headline1,
              )),
          Expanded(
              child: Align(
                  alignment: Alignment.centerLeft,
                  child: Image.asset('assets/images/menu.png'))),
          const SizedBox(
            width: 16,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(28.0),
          child: Column(
            children: [
              Row(
                children: [
                  Image.asset('assets/images/question.png'),
                  const SizedBox(
                    width: 8,
                  ),
                  Text(
                    'نرخ ارز آزاد چیست؟',
                    style: Theme.of(context).textTheme.headline1,
                  ),
                ],
              ),
              const SizedBox(
                height: 12.0,
              ),
              Text(
                ' نرخ ارزها در معاملات نقدی و رایج روزانه است معاملات نقدی معاملاتی هستند که خریدار و فروشنده به محض انجام معامله، ارز و ریال را با هم تبادل می نمایند.',
                style: Theme.of(context).textTheme.bodyText1,

              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 24, 0, 0),
                child: Container(
                  height: 35,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                      color: Color.fromARGB(255, 130, 130, 130),
                      borderRadius: BorderRadius.all(Radius.circular(1000))),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(
                        'نام آزاد ارز',
                        style: Theme.of(context).textTheme.headline2,
                      ),
                      Text(
                        'قیمت',
                        style: Theme.of(context).textTheme.headline2,
                      ),
                      Text(
                        'تغییر',
                        style: Theme.of(context).textTheme.headline2,
                      ),
                    ],
                  ),
                ),
              ),
              // List
              SizedBox(
                height: MediaQuery.of(context).size.height/2,
                width: double.infinity,
                child: listFutureBuilder(context),
              ),
              // Update Button
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Container(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height/16,
                  decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 232, 232, 232),
                      borderRadius: BorderRadius.circular(1000)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // update btn
                      SizedBox(
                        height: MediaQuery.of(context).size.height/16,
                        child: TextButton.icon(
                          onPressed: () {
                            currency.clear();
                              listFutureBuilder(context);
                          },
                          icon: const Icon(
                            CupertinoIcons.refresh_bold,
                            color: Colors.black,
                          ),
                          label: Padding(
                            padding: const EdgeInsets.only(left: 8),
                            child: Text(
                              'بروز رسانی',
                              style: Theme.of(context).textTheme.headline1,
                            ),
                          ),
                          style: ButtonStyle(
                              shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(1000))),
                              backgroundColor: MaterialStateProperty.all(
                                const Color.fromARGB(255, 202, 193, 255),
                              )),
                        ),
                      ),
                      Text(" آخرین بروز رسانی ${_getTime()}"),
                      const SizedBox(
                        width: 6.0,
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget listFutureBuilder(BuildContext context) {
    return FutureBuilder(
      future: getResponse(context),
      builder: (context, snapshot) {
        return snapshot.hasData ? _listItems() : _loading();
      },
    );
  }

  Widget _loading() => const Center(
        child: CircularProgressIndicator(),
      );

  Widget _listItems() {
    return ListView.separated(
      physics: const BouncingScrollPhysics(),
      itemCount: currency.length,
      itemBuilder: (BuildContext context, int position) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
          child: MyItem(position, currency),
        );
      },
      separatorBuilder: (BuildContext context, int index) {
        if (index % 8 == 0) {
          return const Padding(
            padding: EdgeInsets.fromLTRB(0, 8, 0, 0),
            child: Add(),
          );
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }

  String _getTime() {
    DateTime now = DateTime.now();
    return DateFormat('kk:mm:ss').format(now);
  }
}

class MyItem extends StatelessWidget {
  final int position;
  final List<Currency> currency;

  const MyItem(this.position, this.currency, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 50,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(1000),
          boxShadow: const [BoxShadow(blurRadius: 1.0, color: Colors.grey)]),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text(
            currency[position].title!,
            style: Theme.of(context).textTheme.bodyText1,
          ),
          Text(
            currency[position].price.toString(),
            style: Theme.of(context).textTheme.bodyText1,
          ),
          Text(
            currency[position].changes!,
            style: currency[position].status == 'p'
                ? Theme.of(context).textTheme.headline4
                : Theme.of(context).textTheme.headline3,
          ),
        ],
      ),
    );
  }
}

class Add extends StatelessWidget {
  const Add({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 50,
      decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(1000),
          boxShadow: const [BoxShadow(blurRadius: 1.0, color: Colors.white)]),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text(
            'تبلغات',
            style: Theme.of(context).textTheme.headline2,
          ),
        ],
      ),
    );
  }
}

void _showSnackBar(BuildContext context, String msg) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text(
      msg,
      style: Theme.of(context).textTheme.headline1,
    ),
    backgroundColor: Colors.green,
  ));
}

// String getFarsiNumber(String number){
//   const fa =['1','2','3','4','5','6','7','8','9'];
//   const en =['1','2','3','4','5','6','7','8','9'];
//   en.forEach((element) {
//     number.replaceAll(element, fa[en.indexOf(element)]);
//   });
//   return number;
// }
