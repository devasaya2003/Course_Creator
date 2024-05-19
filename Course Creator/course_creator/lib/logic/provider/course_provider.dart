import 'dart:collection';
import 'package:course_creator/logic/models/data_models.dart';
import 'package:flutter/material.dart';

class CourseProvider extends ChangeNotifier {
  final List<Course> _modules = [
    Course(
      moduleName: 'Trigonometry',
      courseItems: [],
    )
  ];

  UnmodifiableListView<Course> get modules => UnmodifiableListView(_modules);

  //add a module
  void addModule(String moduleName) {
    _modules.add(Course(moduleName: moduleName, courseItems: []));
    notifyListeners();
  }

  //get index of the module
  String getValueAt(int index) {
    return _modules[index].moduleName;
  }

  //edit module name
  void changeModuleName(String newName, int index) {
    _modules[index].moduleName = newName;
    notifyListeners();
  }

  //reorder module with module
  void changeGlobalIndex(int oldIndex, int newIndex) {
    if (newIndex > oldIndex) {
      newIndex -= 1;
    }
    final Course item = _modules.removeAt(oldIndex);
    _modules.insert(newIndex, item);
  }

  //delete module
  void deleteModule(int index) {
    _modules.removeAt(index);
    notifyListeners();
  }

  void addACourseAttribute(int index, dynamic item) {
    _modules[index].courseItems.add(item);
    notifyListeners();
  }

  void deleteACourseAttribute(int index, int itemIndex) {
    _modules[index].courseItems.removeAt(itemIndex);
    notifyListeners();
  }

  int getCourseItemLength(int courseIndex) {
    return _modules[courseIndex].courseItems.length;
  }

  void changeLocalIndex(int courseIndex, int oldIndex, int newIndex) {
    if (newIndex > oldIndex) {
      newIndex -= 1;
    }
    final dynamic item = _modules[courseIndex].courseItems.removeAt(oldIndex);
    _modules[courseIndex].courseItems.insert(newIndex, item);
  }

  String getFileUrl(int courseIndex, int index) {
    if (courseIndex >= 0 && courseIndex < _modules.length) {
      var course = _modules[courseIndex];
      if (index >= 0 && index < course.courseItems.length) {
        var item = course.courseItems[index];
        if (item is CourseFile) {
          return item.downloadUrl;
        } else {
          throw TypeError();
        }
      } else {
        throw RangeError('index out of range');
      }
    } else {
      throw RangeError('courseIndex out of range');
    }
  }

  String getFileName(int courseIndex, int index) {
    if (courseIndex >= 0 && courseIndex < _modules.length) {
      var course = _modules[courseIndex];
      if (index >= 0 && index < course.courseItems.length) {
        var item = course.courseItems[index];
        if (item is CourseFile) {
          return item.name;
        } else {
          throw TypeError();
        }
      } else {
        throw RangeError('index out of range');
      }
    } else {
      throw RangeError('courseIndex out of range');
    }
  }

  String getLinkUrl(int courseIndex, int index) {
    if (courseIndex >= 0 && courseIndex < _modules.length) {
      var course = _modules[courseIndex];
      if (index >= 0 && index < course.courseItems.length) {
        var item = course.courseItems[index];
        if (item is CourseLink) {
          return item.url;
        } else {
          throw TypeError();
        }
      } else {
        throw RangeError('index out of range');
      }
    } else {
      throw RangeError('courseIndex out of range');
    }
  }

  String getLinkName(int courseIndex, int index) {
    if (courseIndex >= 0 && courseIndex < _modules.length) {
      var course = _modules[courseIndex];
      if (index >= 0 && index < course.courseItems.length) {
        var item = course.courseItems[index];
        if (item is CourseLink) {
          return item.name;
        } else {
          throw TypeError();
        }
      } else {
        throw RangeError('index out of range');
      }
    } else {
      throw RangeError('courseIndex out of range');
    }
  }

  void setLinkNameAndUrl(
      int courseIndex, int index, String linkName, String linkUrl) {
    if (courseIndex >= 0 && courseIndex < _modules.length) {
      var course = _modules[courseIndex];
      if (index >= 0 && index < course.courseItems.length) {
        var item = course.courseItems[index];
        if (item is CourseLink) {
          item.name = linkName;
          item.url = linkUrl;
          notifyListeners();
        } else {
          throw TypeError();
        }
      } else {
        throw RangeError('index out of range');
      }
    } else {
      throw RangeError('courseIndex out of range');
    }
  }
}
