import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import './app_constant.dart';
import './iw_one_signal.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String apidata = '';
  Dio dio = Dio();
  static const getURLlink =
      '${AppConstant.webviewUrl}/index.php?option=com_ajax&plugin=onesignalapi&method=url&format=raw';

  @override
  void initState() {
    super.initState();
    // Start fetching the URL from the API as soon as the widget is created
    fetchData();

    // NOTE: no await so that webview can be rendered immediately while one signal get initialized
    IwOneSignal.initPlatformState();
  }

  Future<String> fetchData() async {
    var data = {
      "merchant_key": AppConstant.merchantKey,
      "hash": AppConstant.hash,
    };

    try {
      var res = await dio.get(getURLlink, data: data);
      return res.data.replaceAll('"', ''); // remove quotes from res.data
    } on DioError catch (err) {
      log(err.message ?? "error on dio");
      return ''; // Return an empty string if there was an error
    }
  }

  @override
  Widget build(BuildContext context) {
    return getWebview();
  }

  Widget getWebview() {
    var controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(NavigationDelegate(
        onNavigationRequest: (NavigationRequest request) async {
          var url = request.url;
          if (url.startsWith("https://api.whatsapp.com") ||
              url.startsWith("mailto") ||
              url.startsWith("tel") ||
              url.startsWith("https://www.facebook.com") ||
              url.startsWith("https://t.me")) {
            if (await canLaunchUrl(Uri.parse(url))) {
              await launchUrl(Uri.parse(url),
                  mode: LaunchMode.externalApplication);
              return NavigationDecision.prevent;
            }
          }
          return NavigationDecision.navigate;
        },
        onProgress: (int progress) {},
        onPageStarted: (String url) {},
        onPageFinished: (String url) {},
        onWebResourceError: (WebResourceError error) {},
      ));

    return WillPopScope(
      onWillPop: () async {
        if (await controller.canGoBack()) {
          controller.goBack();
          return false;
        } else {
          return true;
        }
      },
      child: FutureBuilder(
        future: fetchData(),
        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError || snapshot.data!.isEmpty) {
              return Center(
                child: Text('Error fetching URL from API'),
              );
            } else {
              controller.loadRequest(Uri.parse(snapshot.data!));
              return WebViewWidget(controller: controller);
            }
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
