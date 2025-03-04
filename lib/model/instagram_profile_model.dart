import 'package:intl/intl.dart';

class InstagramProfileModel {
  String? _account_type;
  String? _user_id;
  String? _full_name;
  String? _username;
  String? _biography;
  String? _external_url;
  String? _profile_pic_url;
  String? _follower_count;
  String? _following_count;
  String? _media_count;

  InstagramProfileModel.fromJson(Map<String, dynamic> json) {
    _user_id = json['pk']?.toString() ?? '';
    _account_type = json['account_type']?.toString() ?? ''; // null güvenli
    _full_name = json['full_name']?.toString() ?? '';
    _username = json['username']?.toString() ?? '';
    _biography = json['biography']?.toString() ?? '';
    _external_url = json['external_url']?.toString() ?? '';
    _profile_pic_url = json['hd_profile_pic_url_info'] != null
        ? json['hd_profile_pic_url_info']['url']?.toString()
        : '';

    if(json['media_count'] > 9999){
      _media_count = NumberFormat.compactCurrency(
          decimalDigits: 2,
          symbol: ''
      ).format(json['media_count']);
    } else {
      _media_count = json['media_count']?.toString() ?? '';
    }

    if(json['follower_count'] > 9999){
      _follower_count = NumberFormat.compactCurrency(
          decimalDigits: 2,
          symbol: ''
      ).format(json['follower_count']);
    } else {
      _follower_count = json['follower_count']?.toString() ?? '';
    }

    if(json['following_count'] > 9999){
      _following_count = NumberFormat.compactCurrency(
          decimalDigits: 2,
          symbol: ''
      ).format(json['following_count']);
    } else {
      _following_count = json['following_count']?.toString() ?? '';
    }

  }

  String? get account_type => _account_type;
  String? get userId => _user_id;
  String? get full_name => _full_name;
  String? get username => _username;
  String? get biography => _biography;
  String? get external_url => _external_url;
  String? get profile_pic_url => _profile_pic_url;
  String? get follower_count => _follower_count;
  String? get following_count => _following_count;
  String? get media_count => _media_count;
}