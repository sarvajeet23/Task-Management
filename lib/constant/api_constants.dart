abstract class APIConstants {
  static const creatTaskUri = "/tasks/";
  static const creatTasksUri = "/tasks/bulk";
  static const getAllTaskUri = "/tasks/";
  static updateTaskUri(String taskID) => "/tasks/$taskID";
  static deletTaskUri(String taskID) => "/tasks/$taskID";
}
