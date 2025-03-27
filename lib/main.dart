import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:solana_wallet_adapter/solana_wallet_adapter.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: BrowserScreen(),
    );
  }
}

final adapter = SolanaWalletAdapter(
  const AppIdentity(),
  // NOTE: CONNECT THE WALLET APPLICATION
  //       TO THE SAME NETWORK.
  cluster: Cluster.devnet,
);

class BrowserScreen extends StatefulWidget {
  @override
  _BrowserScreenState createState() => _BrowserScreenState();
}

class _BrowserScreenState extends State<BrowserScreen> {
  InAppWebViewController? webViewController;
  String url = 'https://explorer.solana.com/';
  Object? _output;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: [
                Color(0xFF9945FF), // Solana Moru
                Color(0xFF19FB9B), // Solana Yeşili
                Color(0xFF627EEA), // Solana Mavisi
              ],
            ),
          ),
        ),
        title: const Text(
          "Wallet DApp",
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () async {
            if (webViewController != null) {
              bool canGoBack = await webViewController!.canGoBack();
              if (canGoBack) {
                webViewController!.goBack();
              }
            }
          },
        ),
      ),
      endDrawer: _buildDrawer(), // ✅ Drawer (Yan Menü)
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF9945FF),
              Color(0xFF19FB9B),
              Color(0xFF627EEA),
            ],
          ),
        ),
        child: InAppWebView(
          initialUrlRequest: URLRequest(url: WebUri(url)),
          onWebViewCreated: (controller) {
            webViewController = controller;
          },
          onConsoleMessage: (controller, consoleMessage) {
            print(consoleMessage
                .message); // Webview içindeki konsol mesajlarını loglar
          },
          onLoadStart: (controller, url) {
            print("WebView started loading: $url");
          },
          onLoadStop: (controller, url) {
            print("WebView stopped loading: $url");
          },
        ),
      ),
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF9945FF),
              Color(0xFF19FB9B),
              Color(0xFF627EEA),
            ],
          ),
        ),
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.transparent,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.account_balance_wallet,
                      size: 50, color: Colors.white),
                  SizedBox(height: 10),
                  Text(
                    "Wallet Seçin",
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                ],
              ),
            ),
            _drawerItem("Phantom ile Bağlan", "https://phantom.app"),
            _drawerItem("Solflare ile Bağlan", "https://solflare.com"),
            _drawerItem("Sol Pay ile Bağlan", "https://solflare.com"),
          ],
        ),
      ),
    );
  }

  Widget _drawerItem(String text, String link) {
    return ListTile(
      title: Text(
        text,
        style: const TextStyle(fontSize: 18, color: Colors.white),
      ),
      leading: const Icon(Icons.wallet, color: Colors.white),
      onTap: () async {
        Navigator.pop(context); // ✅ Menü kapanıyor
        await adapter
            .authorize()
            .then((result) => setState(() => _output = result.toJson()))
            .catchError((error) => setState(() => _output = error));

        print('objectobjectobjectobjectobject :${_output}');
      },
    );
  }
}
