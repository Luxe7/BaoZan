import 'package:flutter/material.dart';

class DeveloperInfoPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('开发者信息'),
      ),
      body: const Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          DeveloperCard(
            name: 'oboard',
            description: '一位热爱创造一切的小透明',
            image: AssetImage('images/oboard.jpg'),
          ),
          DeveloperCard(
            name: 'Luxe7',
            description: '一个普通路过的菠萝李子水蜜桃品鉴大师',
            image: AssetImage('images/Luxe7.jpg'),
          ),
          Spacer(),
          Align(
            alignment: Alignment.bottomCenter,
            child: Text(
              '''联系我们\nLuxe7@foxmail.com\n''',
              style: TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
      // bottomNavigationBar:
    );
  }
}

class DeveloperCard extends StatelessWidget {
  final String name;
  final String description;
  final ImageProvider image;

  const DeveloperCard({
    required this.name,
    required this.description,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      child: Row(
        children: [
          CircleAvatar(
            backgroundImage: image,
            radius: 40,
          ),
          SizedBox(width: 16.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8.0),
                Text(
                  description,
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
