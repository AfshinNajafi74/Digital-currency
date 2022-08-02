import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:fp/model/currency.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: const [
        GlobalCupertinoLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate
      ],
      supportedLocales:const [
        Locale('fa','')
      ],
      theme: ThemeData(
        fontFamily: 'dana',
        textTheme: const TextTheme(
          headline1: TextStyle(
            fontFamily: 'dana',
            fontSize: 16,
            fontWeight: FontWeight.w700
          ),
          bodyText1: TextStyle(
            fontFamily: 'dana',
            fontSize: 13,
            fontWeight: FontWeight.w300
          ),
          headline2: TextStyle(
            fontFamily: 'dana',
            fontSize: 14,
            color: Colors.white,
            fontWeight: FontWeight.w300
          ),
          headline3: TextStyle(
            fontFamily: 'dana',
            fontSize: 14,
            color: Colors.red,
            fontWeight: FontWeight.w700
          ),
          headline4: TextStyle(
            fontFamily: 'dana',
            fontSize: 14,
            color: Colors.green,
            fontWeight: FontWeight.w700
          )
        )
      ),
      debugShowCheckedModeBanner: false,
      home: Home(),
    );
  }

}

class Home extends StatefulWidget{
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  getResponse(){
    String url = 'https://sasansafari.com/flutter/api.php?access_key=flutter123456';
    http.get(Uri.parse(url)).then((value) {
      if(currency.isEmpty){
        if(value.statusCode == 200){
          List jsonList = convert.jsonDecode(value.body);
          if(jsonList.isNotEmpty){
            for(int i=0; i<jsonList.length; i++){
              setState((){
                currency.add(Currency(
                    id: jsonList[i]['id'],
                    title: jsonList[i]['title'],
                    price: jsonList[i]['price'],
                    changes: jsonList[i]['changes'],
                    status: jsonList[i]['status']
                )
                );
              });
            }
          }
        }

      }
    });
  }

  List<Currency>  currency =[];

  @override
  Widget build(BuildContext context) {
    getResponse();
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 243, 243, 243),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          const SizedBox(width: 8,),
          Image.asset('assets/images/icon.png'),
          Align(alignment: Alignment.centerRight,child: Text('قیمت به روز ارز',style: Theme.of(context).textTheme.headline1,)),
          Expanded(child: Align(alignment: Alignment.centerLeft,child: Image.asset('assets/images/menu.png'))),
          const SizedBox(width: 16,),
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
                  const SizedBox(width: 8,),
                  Text('نرخ ارز آزاد چیست؟',style: Theme.of(context).textTheme.headline1,),
                ],
              ),
              const SizedBox(height: 12.0,),
              Text(' نرخ ارزها در معاملات نقدی و رایج روزانه است معاملات نقدی معاملاتی هستند که خریدار و فروشنده به محض انجام معامله، ارز و ریال را با هم تبادل می نمایند.'
                ,style: Theme.of(context).textTheme.bodyText1,
                textDirection: TextDirection.rtl,
              ),
              Padding(
                padding: const  EdgeInsets.fromLTRB(0,24,0,0),
                child: Container(
                  height: 35,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 130, 130, 130),
                    borderRadius: BorderRadius.all(Radius.circular(1000))
                  ),
                  child:  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text('نام آزاد ارز',style: Theme.of(context).textTheme.headline2,),
                      Text('قیمت',style: Theme.of(context).textTheme.headline2,),
                      Text('تغییر',style: Theme.of(context).textTheme.headline2,),
                    ],
                  ),
                ),
              ),
              // List
              SizedBox(
                height: 350,
                width: double.infinity,
                child: ListView.separated(
                  physics: const BouncingScrollPhysics(),
                  itemCount: currency.length,
                    itemBuilder: (BuildContext context,int position){
                      return Padding(
                        padding: const EdgeInsets.fromLTRB(0,8,0,0),
                        child: MyItem(position,currency),
                      );
                    }, separatorBuilder: (BuildContext context, int index) {
                    if(index % 8 == 0){
                      return Padding(
                        padding: const EdgeInsets.fromLTRB(0,8,0,0),
                        child: Add(),
                      );
                    }else{
                      return SizedBox.shrink();
                    }
                },
                ),
              ),
              // Update Button
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child:  Container(
                  width: double.infinity,
                  height: 50,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 232, 232, 232),
                    borderRadius: BorderRadius.circular(1000)
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // update btn
                      SizedBox(
                        height: 50,
                        child: TextButton.icon(
                            onPressed: (){
                              _showSnackBar(context,'بروز رسانی با موفقیت انجام شد');
                            },
                            icon: const Icon(CupertinoIcons.refresh_bold,color: Colors.black,),
                            label: Padding(
                              padding: const EdgeInsets.only(left:8),
                              child: Text('بروز رسانی',style: Theme.of(context).textTheme.headline1,),
                            ),
                          style: ButtonStyle(
                            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(1000)
                              )
                            ),
                            backgroundColor: MaterialStateProperty.all(Color.fromARGB(255, 202, 193, 255),

                          )
                          ),
                        ),
                      ),
                      Text(" آخرین بروز رسانی ${_getTime()}"),
                      const SizedBox(width: 6.0,)
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

  String _getTime(){
    return '20:45';
  }
}

class MyItem extends StatelessWidget{
  int position;
  List<Currency> currency;

  MyItem(this.position, this.currency);


  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 50,
      decoration:  BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(1000),
          boxShadow: const [
            BoxShadow(
                blurRadius: 1.0,
                color: Colors.grey
            )
          ]
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text(currency[position].title!,style: Theme.of(context).textTheme.bodyText1,),
          Text(currency[position].price!,style: Theme.of(context).textTheme.bodyText1,),
          Text(currency[position].changes!,
            style: currency[position].status == 'p' ? Theme.of(context).textTheme.headline4 : Theme.of(context).textTheme.headline3,
          ),
        ],
      ),
    );
  }

}
class Add extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 50,
      decoration:  BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(1000),
          boxShadow: const [
            BoxShadow(
                blurRadius: 1.0,
                color: Colors.white
            )
          ]
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text('تبلغات',style: Theme.of(context).textTheme.headline2,),
        ],
      ),
    );
  }

}

void _showSnackBar(BuildContext context,String msg){
  ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg,style: Theme.of(context).textTheme.headline1,),
        backgroundColor: Colors.green,
      )
  );
}

