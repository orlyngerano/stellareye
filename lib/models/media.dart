dynamic getValue<T>(dynamic data, T nullValue) {
  return data != null ? data : nullValue;
}

class ItemLink {
  String? href;
  String? rel;
  String? render;
  ItemLink.fromJson(Map<String, dynamic> json) {
    href = getValue<String>(json['href'], '');
    rel = getValue<String>(json['rel'], '');
    render = getValue<String>(json['render'], '');
  }
}

class Data {
  String? center;
  String? title;
  String? photographer;
  String? location;
  List<String>? keywords;
  String? nasa_id;
  DateTime? date_created;
  String? media_type;
  String? description;
  Data.fromJson(Map<String, dynamic> json) {
    center = json.putIfAbsent('center', () => '') as String;
    title = json.putIfAbsent('title', () => '') as String;
    photographer = json.putIfAbsent('photographer', () => '') as String;
    location = json.putIfAbsent('location', () => '') as String;
    nasa_id = json.putIfAbsent('nasa_id', () => '') as String;
    keywords = (json.putIfAbsent('keywords', () => []) as List<dynamic>)
        .map((e) => e.toString())
        .toList();
    date_created = DateTime.parse(json.putIfAbsent('date_created', () => ''));
    center = json.putIfAbsent('center', () => '') as String;
    media_type = json.putIfAbsent('media_type', () => '') as String;
    description = json.putIfAbsent('description', () => '') as String;
  }
}

class Item {
  String? href;
  List<Data>? data;
  List<ItemLink>? links;
  Item.fromJson(Map<String, dynamic> json) {
    href = json.putIfAbsent('href', () => '') as String;
    links = (json.putIfAbsent('links', () => []) as List<dynamic>)
        .map((e) => ItemLink.fromJson(e))
        .toList();

    data = (json.putIfAbsent('data', () => []) as List<dynamic>)
        .map((e) => Data.fromJson(e))
        .toList();
  }
}

class CollectionLink {
  String? rel;
  String? prompt;
  String? href;
  CollectionLink.fromJson(Map<String, dynamic> json) {
    rel = json.putIfAbsent('rel', () => '') as String;
    prompt = json.putIfAbsent('prompt', () => '') as String;
    href = json.putIfAbsent('href', () => '') as String;
  }
}

class Metadata {
  int? total_hits;
  Metadata.fromJson(Map<String, dynamic> json) {
    total_hits = json.putIfAbsent('total_hits', () => 0) as int;
  }
}

class Collection {
  String? version;
  String? href;
  List<Item>? items;
  Metadata? metadata;
  List<CollectionLink>? links;

  Collection.fromJson(Map<String, dynamic> json) {
    version = json.putIfAbsent('version', () => '') as String;
    href = json.putIfAbsent('href', () => '') as String;

    items = ((json.putIfAbsent('items', () => [])) as List<dynamic>)
        .map((e) => Item.fromJson(e))
        .toList();

    metadata = Metadata.fromJson(json['metadata']);

    links = ((json.putIfAbsent('links', () => [])) as List<dynamic>)
        .map((e) => CollectionLink.fromJson(e))
        .toList();
  }
}
