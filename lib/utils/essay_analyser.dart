// 2023.7.9
// Created lib/utils/essay_analyzer.dart
// by oboard

import 'package:dio/dio.dart';
import 'package:wechat/models/essay.dart';
// 1. 导入html库
import 'package:html/parser.dart' as parser;

class EssayAnalyzer {
  static Future<Essay> linkToEssay(String? link) async {
    Essay essay = Essay();
    // 解析微信公众号文章链接，使用Dio请求文章内容
    Response response = await Dio()
        .get(link ?? 'https://mp.weixin.qq.com/s/FIsVtcA_I-JiMhTtcZbK5A');
    // 解析返回的HTML结构为
    // <html>
    //   <head>
    // <meta property="og:title" content="招新丨请查收石碣大学生成长交流中心邀请信">
    // <meta property="og:image" content="https://mmbiz.qpic.cn/sz_mmbiz_jpg/3X4BUia0prA2HoSyQzRRsv2PRpib6TEbYG0t6BayIoH07vUO0pJLGztdMRtzZKeDZYy10eCKMHLib1Gm4oicrZfVLQ/0?wx_fmt=jpeg">
    // <meta property="og:description" content="点燃希望同交流\x0d\x0a社会实践展风采">
    //   </head>
    //   <body>
    //   </body>
    // </html>

    // 解析HTML中meta封面、标题、描述
    // 使用html库
    // https://pub.dev/packages/html
    //
    // 2. 使用parse方法解析HTML
    var document = parser.parse(response.data);
    // 3. 使用querySelector方法获取meta标签
    var titleMeta = document.querySelector('meta[property="og:title"]'),
        descriptionMeta =
            document.querySelector('meta[property="og:description"]'),
        coverMeta = document.querySelector('meta[property="og:image"]');
    // 4. 使用attributes获取meta标签的属性
    var title = titleMeta?.attributes['content'],
        description = descriptionMeta?.attributes['content'],
        cover = coverMeta?.attributes['content'];
    // 5. 将属性值赋值给Essay对象
    essay
      ..title = title
      ..description = description
      ..cover = cover
      ..link = link;
    // 6. 返回Essay对象
    return essay;
  }
}
