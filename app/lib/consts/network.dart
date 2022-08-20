class NetworkConsts {
  static String serverUrl = "http://paranoidandroid.network";
  static int serverPort = 52042;

  static String apiBasePath = "api/";
  static String signalRBasePath = "appMonitorHub/";
}

class UserApiConsts {
  static String basePath = "Users/";

  static String saveSettings = "${basePath}Save";
  static String connect = "${basePath}Incoming/";
  static String getSettings = "${basePath}Settings/";
}

class UnitApiConsts {
  static String basePath = "Unit/";

  static String unlink = "${basePath}Unlink";
  static String link = "${basePath}Link";
  static String update = "${basePath}Update";
  static String findUnits = "${basePath}Auto";
  static String connect = "${basePath}UnitData";
}