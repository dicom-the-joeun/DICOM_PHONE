class HomePageTableData{
  final int studyKey;
  final String pId;
  final String pName;
  final String modallity;
  final String? studyDescription;
  final int studyDate;
  final int reportStatus;
  final int seriesCount;
  final int imageCount;
  final int examStatus; 

  HomePageTableData(
    {
      required this.studyKey,
      required this.pId,
      required this.pName,
      required this.modallity,
      required this.studyDescription,
      required this.studyDate,
      required this.reportStatus,
      required this.seriesCount,
      required this.imageCount,
      required this.examStatus
    }
  );

  HomePageTableData.fromMap(Map<String, dynamic> hpData) 
  : 
  studyKey = hpData['STUDYKEY'],
  pId = hpData['PID'],
  pName = hpData['PNAME'],
  modallity = hpData['MODALITY'],
  studyDescription = hpData['STUDYDESC'],
  studyDate = hpData['STUDYDATE'],
  reportStatus = hpData['REPORTSTATUS'],
  seriesCount = hpData['SERIESCNT'],
  imageCount = hpData['IMAGECNT'],
  examStatus = hpData['EXAMSTATUS'];
}