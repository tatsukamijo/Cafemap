import 'package:http/http.dart' as http;
import 'package:html/parser.dart' show parse;

// main関数。非同期処理(await)を使用するのでasync。
void main() async {
  // 取得先のURLを元にして、Uriオブジェクトを生成する。
  final url = 'https://www.h9v.net/category/%E5%9F%BC%E7%8E%89/';
  final target = Uri.parse(url);

  // 取得する。
  final response = await http.get(target);

  // 下の行のコメントを外すことで、返されたHTMLを出力できる。
  // print(response.body);

  // ステータスコードをチェックする。「200 OK」以外のときはその旨を表示して終了する。
  if (response.statusCode != 200) {
    print('ERROR: ${response.statusCode}');
    return;
  }

  // 取得したHTMLのボディをパースする。
  final document = parse(response.body);

  // 要素を絞り込んで、結果を文字列のリストで得る。
  final result =
  document.querySelectorAll('#post_list2 p').map((v) => v.text).toList();

  //いったんraw data表示させとく
  print(result);

  for (var i = 0; i < result.length; i++) {
    // 各店舗infoでの処理
    var s = result[i].split('スターバックス');
    final s_replace = s[0].replaceAll('が使える店', '：◯　');
    final wifi_info = s_replace.replaceAll('が使えない店', '：×　');
    var u = s[1].split('店');
    final shop_name = u[0] + "店";
    var v = u[1].substring(0, 16);
    final shop_time = v;

    // print(shop_name);
    // print(wifi_info);
    // print(shop_time);

    // print(s[1]);
    // print(shop_name);
  }
}
