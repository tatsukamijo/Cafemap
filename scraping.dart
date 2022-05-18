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
  final result = document.querySelectorAll('h2').map((v) => v.text).toList();

  // 結果を出力する。
  print(result);
}