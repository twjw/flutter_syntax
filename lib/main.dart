import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MyHomePage(),
    );
  }
}

final dio = Dio();

class AvatarModel {
  const AvatarModel({required this.src});

  final String src;

  static AvatarModel fromJson(Map<String, dynamic> json) {
    return AvatarModel(src: json['src']);
  }
}

final avatarProvider = FutureProvider<AvatarModel>((ref) async {
  final response = await dio.get(
      'https://api.thecatapi.com/v1/images/search?size=med&mime_types=jpg&format=json&has_breeds=true&order=RANDOM&page=0&limit=1',
      options: Options(
        headers: {
          Headers.contentTypeHeader: "application/json",
          'x-api-key': 'DEMO-API-KEY',
        },
        followRedirects: true,
      ));
  if (response.statusCode == 200) {
    return AvatarModel.fromJson({'src': response.data[0]['url']});
  } else {
    throw Exception('Failed to fetch data');
  }
});

class Avatar extends ConsumerWidget {
  const Avatar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final avatar = ref.watch(avatarProvider);

    return avatar.when(
      // data: (data) => Image.network(data.src),
      data: (data) => ClipOval(
        child: Image.asset(
          'assets/images/avatar.png',
          width: 78,
          height: 78,
          fit: BoxFit.cover,
        ),
      ),
      error: (error, stack) => const Text('error'),
      loading: () => const SizedBox.shrink(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  void initState() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Casa',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle_rounded),
            label: 'Conta',
          ),
        ],
      ),
      appBar: AppBar(
        flexibleSpace: PreferredSize(
          preferredSize: Size.fromHeight(100.0), // 设置AppBar的高度为100像素
          child: Container(
            color: Color.fromRGBO(33, 33, 33, 1),
          ),
        ),
        shadowColor: Colors.transparent,
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Center(
              child: Text(
                "Conta",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Spacer(),
        ],
      ),
      body: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Color.fromRGBO(255, 130, 22, 1),
            ),
            child: const Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Nome de Usuário',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                              ),
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            Row(
                              children: [
                                Text(
                                  '0981010689',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(
                                  width: 8,
                                ),
                                const Image(
                                  image: AssetImage(
                                      'assets/images/my_btn_edit.webp'),
                                  width: 24,
                                  height: 24,
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                      Spacer(),
                      Avatar(),
                    ],
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
