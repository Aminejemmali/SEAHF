import 'dart:convert';

class Gallery {
  late int id;
  late String photo;
  late String titleGallery;
  late int conferenceOfPhoto;
  Gallery(int id,String fields){
    var data2 =json.decode(fields);
    this.id=id;
    this.photo=data2['photo'];
    this.titleGallery=data2['titleGallery'];
    this.conferenceOfPhoto=data2['conferenceOfPhoto'];
  }
  toJson() => {
    'id':id,
    'photo': photo,
    'titleGallery': titleGallery,
    'conferenceOfPhoto':conferenceOfPhoto,
  };

  @override
  String toString() {
    String text =json.encode(this.toJson());
    return text;
  }




}