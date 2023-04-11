
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin{
  double progess=0;
  late WebViewController controller;
   bool isLoading = true;
  @override
  void initState() {
    super.initState();
    isLoading = true;
    progess=0;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.white
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                  LinearProgressIndicator(
                      color: Colors.white,
                      backgroundColor: Colors.blueGrey,
                      value: progess,
                    ),
                    Expanded(
                      child: WebView(javascriptMode:JavascriptMode.unrestricted,
                        initialUrl: 'https://www.mothersbdsoft.com/',
                        onWebViewCreated: (controller){
                          this.controller=controller;
                        },
                        onPageFinished: (con) async{
                          print("--------------");
                          String? s  = await controller.currentUrl();
                          setState(() {
                            isLoading =false;
                          });
                          print(s) ;
                          print("--------------");
                        },

                          onProgress: (progess) => setState(() => this.progess = progess/100),

                      ),
                    ),
                  ],
                ),

                isLoading == true ?    Container(
                    height:400,
                    width: 400,
                    decoration:  const BoxDecoration(
                      color: Colors.white,
                        shape: BoxShape.circle,
                        image:  DecorationImage(
                            fit: BoxFit.fill,
                            image: AssetImage("assets/my_icon.png")
                        )
                    )) : const SizedBox()

              ],
            ),
          ),),
      ),
    );
  }


  Future<bool>  _onBackPressed() async {
    if(await controller.canGoBack()){
      controller.goBack();
      return false;
    }
    return await showDialog(context: context,     builder: (context) {
      return AlertDialog(
        title: const Text('Confirm'),
        content: const Text('Do you want to exit the App'),
        actions: <Widget>[
          TextButton(
            child: const Text('No',style: TextStyle(color: Colors.teal),),
            onPressed: () {
              Navigator.of(context).pop(false); //Will not exit the App
            },
          ),
          TextButton(
            child: const Text('Yes',style: TextStyle(color: Colors.red)),
            onPressed: () {
              Navigator.of(context).pop(true); //Will exit the App
            },
          )
        ],
      );
    },
    ) ?? false ;
  }
}