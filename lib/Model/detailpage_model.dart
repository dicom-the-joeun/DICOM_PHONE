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
      : studydate = res['studydate'],
        studytime = res['studytime'],
        manufacturer = res['manufacturer'],
        seriesdescription = res['seriesdescription'],
        ManufacturersModelName = res['ManufacturersModelName'],
        PatientsName = res['PatientsName'],
        PatientID = res['PatientID'],
        PatientsBirthDate = res['PatientsBirthDate'],
        SeriesNumber = res['SeriesNumber'],
        Rows = res['Rows'],
        Columns = res['Columns'],
        WindowCenter = res['WindowCenter'],
        WindowWidth = res['WindowWidth'],
        NumberofFrames = res['NumberofFrames'],
        pixelarrayshape = res['pixelarrayshape'],
        result = ResultModel(
          IMAGEKEY: res['IMAGEKEY'], 
          PATH: res['PATH'],
          FNAME: res['FNAME']);
       

}

class ResultModel {
  final int IMAGEKEY;
  final String PATH;
  final String FNAME;

  ResultModel(
      {required this.IMAGEKEY, required this.PATH, required this.FNAME});
}
