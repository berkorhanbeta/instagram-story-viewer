class InstagramStoryModel {

  String? imageUrl;
  String? videoUrl;
  bool? hasAudio;
  String? takenAt;

  InstagramStoryModel.fromJson(Map<String, dynamic> json){
    if(json['image_versions2'] != null && json['image_versions2']['candidates'].isNotEmpty) {
      imageUrl = json['image_versions2']['candidates'][0]['url']?.toString() ?? '';
    }
    if(json['video_versions'] != null && json['video_versions'].isNotEmpty){
      videoUrl = json['video_versions'][0]['url']?.toString() ?? '';
    }
    hasAudio = json['has_audio'] ?? false;
    int taken_at = json['taken_at'];
    DateTime postDate = DateTime.fromMillisecondsSinceEpoch(taken_at * 1000);
    DateTime now = DateTime.now();
    Duration difference = now.difference(postDate);
    takenAt = _getTimeAgo(difference);
  }

  String _getTimeAgo(Duration difference) {
    if (difference.inDays > 365) {
      int years = (difference.inDays / 365).floor();
      return '$years year${years > 1 ? 's' : ''} ago';
    } else if (difference.inDays > 30) {
      int months = (difference.inDays / 30).floor();
      return '$months month${months > 1 ? 's' : ''} ago';
    } else if (difference.inDays > 0) {
      return '${difference.inDays} day${difference.inDays > 1 ? 's' : ''} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hour${difference.inHours > 1 ? 's' : ''} ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minute${difference.inMinutes > 1 ? 's' : ''} ago';
    } else if (difference.inSeconds > 0) {
      return '${difference.inSeconds} second${difference.inSeconds > 1 ? 's' : ''} ago';
    } else {
      return 'just now';
    }
  }

}