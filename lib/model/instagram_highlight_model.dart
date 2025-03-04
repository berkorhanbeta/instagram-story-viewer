class InstagramHighlightModel {

  String? _title;
  String? _highlight_id;
  String? _cover_media;

  InstagramHighlightModel.fromJson(Map<String, dynamic> json){
    _title = json['title']?.toString() ?? '';
    _highlight_id = json['id']?.toString() ?? '';
    _cover_media = json['cover_media']['cropped_image_version']['url']?.toString() ?? '';
  }

  String? get title => _title;
  String? get highlightId => _highlight_id;
  String? get coverMedia => _cover_media;
}