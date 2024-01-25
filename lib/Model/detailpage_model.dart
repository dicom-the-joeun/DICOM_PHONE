class DetailModel {
  final int studydate;
  final int studytime;
  final String manufacturer;
  final String? seriesdescription;
  final String ManufacturersModelName;
  final String PatientsName;
  final String PatientID;
  final int PatientsBirthDate;
  final int SeriesNumber;
  final int Rows;
  final int Columns;
  final int WindowCenter;
  final int WindowWidth;
  final int NumberofFrames;
  final int pixelarrayshape;
  final ResultModel result;

  DetailModel(
      {required this.studydate,
      required this.studytime,
      required this.manufacturer,
      this.seriesdescription,
      required this.ManufacturersModelName,
      required this.PatientsName,
      required this.PatientID,
      required this.PatientsBirthDate,
      required this.SeriesNumber,
      required this.Rows,
      required this.Columns,
      required this.WindowCenter,
      required this.WindowWidth,
      required this.NumberofFrames,
      required this.pixelarrayshape,
      required this.result});
  
   DetailModel.fromMap(Map<String, dynamic> res)
  : studydate = res['studydate'] ?? 0,
    studytime = res['studytime'] ?? 0,
    manufacturer = res['manufacturer'] ?? '',
    seriesdescription = res['seriesdescription'] ?? '',
    ManufacturersModelName = res['ManufacturersModelName'] ?? '',
    PatientsName = res['PatientsName'] ?? '',
    PatientID = res['PatientID'] ?? '',
    PatientsBirthDate = res['PatientsBirthDate'] is int ? res['PatientsBirthDate'] : 0,
    SeriesNumber = res['SeriesNumber'] ?? 0,
    Rows = res['Rows'] ?? 0,
    Columns = res['Columns'] ?? 0,
    WindowCenter = res['WindowCenter'] ?? 0,
    WindowWidth = res['WindowWidth'] ?? 0,
    NumberofFrames = res['NumberofFrames'] ?? 0,
    pixelarrayshape = res['pixelarrayshape'] ?? 0,
    result = ResultModel(
      IMAGEKEY: res['imagekey'] is int ? res['imagekey'] : 0,
      PATH: res['path'] ?? '',
      FNAME: res['fname'] ?? '');

       

}

class ResultModel {
  final int IMAGEKEY;
  final String PATH;
  final String FNAME;

  ResultModel(
      {required this.IMAGEKEY, required this.PATH, required this.FNAME});
}
