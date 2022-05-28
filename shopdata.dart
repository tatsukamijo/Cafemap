final String tableShop = 'shop_data';

class Shopfields {
  static final List<String> values = [
    id, shopname, shoplatlng, wifiinfo, eigyojikan
  ];

  static final String id = 'id';
  static final String shopname = 'shopname';
  static final String shoplatlng = 'shoplatlng';
  static final String wifiinfo = 'wifiinfo';
  static final String eigyojikan = 'eigyojikan';
}

class Shopdata {
  final int? id;
  final String shopname;
  final String shoplatlng;
  final String wifiinfo;
  final String eigyojikan;

  const Shopdata({
    this.id,
    required this.shopname,
    required this.shoplatlng,
    required this.wifiinfo,
    required this.eigyojikan,
  });

  Shopdata copy({
    int? id,
    String? shopname,
    String? shoplatlng,
    String? wifiinfo,
    String? eigyojikan,
  }) =>
      Shopdata(
        id: id ?? this.id,
        shopname: shopname ?? this.shopname,
        shoplatlng: shoplatlng ?? this.shoplatlng,
        wifiinfo: wifiinfo ?? this.wifiinfo,
        eigyojikan: eigyojikan ?? this.eigyojikan,
      );

  static Shopdata fromJson(Map<String, Object?> json) => Shopdata(
    id: json[Shopfields.id] as int?,
    shopname: json[Shopfields.shopname] as String,
    shoplatlng: json[Shopfields.shoplatlng] as String,
    wifiinfo: json[Shopfields.wifiinfo] as String,
    eigyojikan: json[Shopfields.eigyojikan] as String,
  );

  Map<String, Object?> toJson() => {
    Shopfields.id: id,
    Shopfields.shopname: shopname,
    Shopfields.shoplatlng: shoplatlng,
    Shopfields.wifiinfo: wifiinfo,
    Shopfields.eigyojikan: eigyojikan,
  };

}
