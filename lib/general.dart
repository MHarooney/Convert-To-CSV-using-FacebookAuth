class General {
static  getDate(){
  String finalDate = '';
  var date = new DateTime.now().toString();

  var dateParse = DateTime.parse(date);

  var formattedDate = "${dateParse.day}-${dateParse.month}-${dateParse.year}";



    finalDate = formattedDate.toString() ;

  }
}