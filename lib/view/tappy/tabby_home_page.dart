import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:perfume_store_mobile_app/mock.dart';
import 'package:perfume_store_mobile_app/services/tabby_flutter_inapp_sdk.dart';
import 'package:perfume_store_mobile_app/view/tappy/chechout_page.dart';


class TabbyHomePage extends StatefulWidget {
  const TabbyHomePage({Key? key}) : super(key: key);

  @override
  State<TabbyHomePage> createState() => _TabbyHomePageState();
}

class _TabbyHomePageState extends State<TabbyHomePage> {
  String _status = 'idle';
  TabbySession? session;
  late Lang lang;

  void _setStatus(String newStatus) {
    setState(() {
      _status = newStatus;
    });
  }

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) => getCurrentLang());
  }

  void getCurrentLang() {
    final myLocale = Localizations.localeOf(context);
    setState(() {
      lang = myLocale.languageCode == 'ar' ? Lang.ar : Lang.en;
    });
  }

  Future<void> createSession() async {
    try {
      _setStatus('pending');

      final s = await TabbySDK().createSession(TabbyCheckoutPayload(
        merchantCode: 'sa',
        lang: lang,
        payment: mockPayload,
      ));

      print('Session id:  ${s.sessionId}');

      setState(() {
        session = s;
      });
      _setStatus('created');
    } catch (e, s) {
      printError(e, s);
      _setStatus('error');
    }
  }

  void openCheckOutPage() {
    Navigator.pushNamed(
      context,
      '/checkout',
      arguments: TabbyCheckoutNavParams(
        selectedProduct: session!.availableProducts.installments!,
      ),
    );
  }

  void openInAppBrowser() {
    TabbyWebView.showWebView(
      context: context,
      webUrl: session!.availableProducts.installments!.webUrl,
      onResult: (WebViewResult resultCode) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(resultCode.name),
          ),
        );
        Navigator.pop(context);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tabby Flutter SDK demo'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              '${mockPayload.amount} ${mockPayload.currency.name}',
              style: Theme.of(context).textTheme.headline6,
              textAlign: TextAlign.center,
            ),
            Text(
              mockPayload.buyer?.email ?? '',
              style: Theme.of(context).textTheme.headline6,
              textAlign: TextAlign.center,
            ),
            Text(
              mockPayload.buyer?.phone ?? '',
              style: Theme.of(context).textTheme.headline6,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            Text(
              _status,
              style: Theme.of(context).textTheme.headline4,
            ),
            const SizedBox(height: 24),
            if (session == null) ...[
              ElevatedButton(
                onPressed: _status == 'pending' ? null : createSession,
                child: const Text('Create Session'),
              ),
            ],
            if (session != null) ...[
              ElevatedButton(
                onPressed: openCheckOutPage,
                child: const Text('Open checkout page'),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: openInAppBrowser,
                child: const Text('Open checkout in-app browser'),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: TabbyPresentationSnippet(
                  price: mockPayload.amount,
                  currency: mockPayload.currency,
                  lang: lang,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
