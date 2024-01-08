import 'dart:convert';

class ThumbnailModel {
  final int serieskey;
  final String seriesdesc;
  final String? score;
  final int imagecnt;
  final String path;
  final String fname;
  final Map<String, dynamic> headers;

  ThumbnailModel({
    required this.serieskey,
    required this.seriesdesc,
    this.score,
    required this.imagecnt,
    required this.path,
    required this.fname,
    required this.headers,
  });

  factory ThumbnailModel.fromMap(Map<String, dynamic> res) {
    return ThumbnailModel(
      serieskey: res['SERIESKEY'],
      seriesdesc: res['SERIESDESC'],
      score: res['SCORE'],
      imagecnt: res['IMAGECNT'],
      path: res['PATH'],
      fname: res['FNAME'],
      headers: json.decode(res['HEADERS']),
    );
  }
}