class SearchAddress {
  String? addressName;
  String? addressType;
  String? x;
  String? y;

  SearchAddress({
    this.addressName,
    this.addressType,
    this.x,
    this.y,
  });

  SearchAddress.fromJson(Map<String, dynamic> json) {
    addressName = json['address_name'];
    addressType = json['addressType'];
    x = json['x'];
    y = json['y'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['address_name'] = addressName;
    data['address_type'] = addressType;
    data['x'] = x;
    data['y'] = y;
    return data;
  }

  @override
  String toString() {
    return 'SearchAddress: { addressName: $addressName, addressType: $addressType, x: $x, y: $y }';
  }
}

class SearchAddressList {
  Meta? meta;
  List<SearchAddress>? documents;

  SearchAddressList({this.meta, this.documents});

  SearchAddressList.fromJson(Map<String, dynamic> json) {
    meta = json['meta'] != null ? Meta.fromJson(json['meta']) : null;
    if (json['documents'] != null) {
      documents = <SearchAddress>[];
      json['documents'].forEach((v) {
        documents!.add(SearchAddress.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (meta != null) {
      data['meta'] = meta!.toJson();
    }
    if (documents != null) {
      data['documents'] = documents!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Meta {
  int? totalCount;
  int? pageableCount;
  bool? isEnd;

  Meta({
    this.totalCount,
    this.pageableCount,
    this.isEnd,

  });

  Meta.fromJson(Map<String, dynamic> json) {
    totalCount = json['total_count'];
    pageableCount = json['pageable_count'];
    isEnd = json['is_end'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['total_count'] = totalCount;
    data['pageable_count'] = pageableCount;
    data['total_count'] = totalCount;
    return data;
  }
}