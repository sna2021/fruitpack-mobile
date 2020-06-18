class Pack {
  var data;

  Pack(this.data);

  String get id {
    return data['id'];
  }

  String get name {
    return data['name'];
  }

  String get nameRu {
    return data['name_ru'];
  }

  String get shortDescription {
    return data['short_description'];
  }

  String get logo {
    return data['logo'];
  }

  String get description {
    return data['description'];
  }

  String get color {
    return data['accent_color'];
  }

  String get cost {
    return data['cost'];
  }
}
