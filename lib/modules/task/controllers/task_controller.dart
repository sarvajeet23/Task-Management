import 'dart:developer';
import 'package:get/get.dart';
import 'package:taskapp/apis/api_provider.dart';
import 'package:http/http.dart' as http;
import 'package:taskapp/models/task_model.dart';
import 'package:taskapp/routes/route_management.dart';
import 'package:taskapp/sample/data.dart';

enum LoadingStatus { loading, done, error }

class TaskController extends GetxController {
  final _apiProvider = ApiProvider(http.Client());
  var loadingStatus = LoadingStatus.done;

  List<Task> _tasks = [];

  //getters

  List<Task> get tasks => _tasks;

  void _initialize() async {
    _getAllTasks();
  }

  Future<void> _getAllTasks({bool isLoading = true}) async {
    if (isLoading) {
      loadingStatus = LoadingStatus.loading;
      update();
      await Future.delayed(Duration(seconds: 3));
    }
    try {
      final response = await _apiProvider.getAllTask();
      if (response.isSuccessful) {
        List responseList = response.data;
        _tasks.clear();
        log("task response = >${responseList}");
        _tasks = responseList.map((json) => Task.fromJson(json)).toList();
        loadingStatus = LoadingStatus.done;
        update();
        log("_getAllTasks => ${_tasks}");
      }
    } catch (e) {
      loadingStatus = LoadingStatus.error;
      update();
      log("_getAllTasks => $e}");
    }
  }

  void onCheckboxTap(bool? val, int index) {
    log("val $val");

    _tasks[index].status = null;
    if (val == true) {
      _tasks[index].status = "Completed";
      log("Code here.. ");
    } else {
      _tasks[index].status = "Pending";
    }
    update();

    final model = _tasks[index];
    // log(model.status.toString());

    _updateTask(model);
  }

  Future<void> _updateTask(Task model) async {
    try {
      final response = await _apiProvider.updateTask(model.id ?? '', model.toJson());
      if (response.isSuccessful) {
        log("response = >${response.data}");
        _getAllTasks(isLoading: false);
        log("_updateTask => ${_tasks.length}");
      }
    } catch (e) {
      loadingStatus = LoadingStatus.error;
      update();
      log("_updateTask => $e}");
    }
  }

  Future<void> addTask(
    String title,
    String description,
    String status,
    int priority, {
    bool isUpdate = false,
    Task? model,
  }) async {
    try {
      final newTask = Task(
        id: isUpdate ? model?.id : "123",
        title: title,
        description: description,
        status: status,
        priority: priority,
        priorityColorHex: isUpdate ? model?.priorityColorHex : "0XFF3454",
        timestamp: DateTime.now(),
      );

      var body = newTask.toJson();

      log("body = >${newTask.toJson()}");

      final response = isUpdate
          ? await _apiProvider.updateTask(model?.id ?? '', body)
          : await _apiProvider.createTask(body);

      if (response.isSuccessful) {
        log(" New task added: ${response.data}");
        _getAllTasks(isLoading: false);
      }
    } catch (e) {
      loadingStatus = LoadingStatus.error;
      update();
      log("addTask => $e}");
    }
  }

  Future<void> addDemoTask() async {
    try {
      final body = {"tasks": data};

      final response = await _apiProvider.createTasks(body);

      if (response.isSuccessful) {
        log(" Bulk  task added: ${response.data}");
        _getAllTasks(isLoading: true);
      }
    } catch (e) {
      loadingStatus = LoadingStatus.error;
      update();
      log("addTask => $e}");
    }
  }

  @override
  void onReady() {
    _initialize();
    super.onReady();
  }

  Future<void> onRefresh() async => _getAllTasks();

  void onTaskTap(Task model) => RouteManagement.addTaskPage(model: model);
}
