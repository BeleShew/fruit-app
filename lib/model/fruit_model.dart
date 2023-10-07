
class FruitModel{
  FruitModel({this.name,this.description,this.images,this.likeCount,this.location,this.age,this.tags});
  String? name ;
  String? description ;
  List<String>? images;
  int? likeCount;
  String? location;
  int? age;
  List<String>? tags;

  factory FruitModel.fromJson(Map<String, dynamic> json) => FruitModel(
    name: json["name"],
    description: json["description"],
    images:(json['images'] as List<dynamic>?)?.map((e) => e as String).toList(),
    likeCount: json["likeCount"],
    location: json["location"],
    age: json["age"],
    tags:(json['tags'] as List<dynamic>?)?.map((e) => e as String).toList(),
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "description": description,
    "images": images,
    "likeCount": likeCount,
    "location": location,
    "age": age,
    "prices": tags,
    "tags": tags,
  };
}