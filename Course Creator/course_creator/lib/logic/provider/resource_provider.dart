import 'dart:collection';

import 'package:course_creator/logic/models/data_models.dart';
import 'package:flutter/material.dart';

class ResourceProvider extends ChangeNotifier {
  final List<dynamic> _resources = [];

  UnmodifiableListView<dynamic> get resources =>
      UnmodifiableListView(_resources);

  void addLinkResourceThroughText(String url, String name) {
    _resources.add(CourseLink(url: url, name: name));
    notifyListeners();
  }

  String getLinkName(int index) {
    if (index >= 0 && index < _resources.length) {
      var resource = _resources[index];
      if (resource is CourseLink) {
        return resource.name;
      } else {
        throw TypeError();
      }
    } else {
      throw RangeError('index out of range');
    }
  }

  String getLinkUrl(int index) {
    if (index >= 0 && index < _resources.length) {
      var resource = _resources[index];
      if (resource is CourseLink) {
        return resource.url;
      } else {
        throw TypeError();
      }
    } else {
      throw RangeError('index out of range');
    }
  }

  String getFileUrl(int index) {
    if (index >= 0 && index < _resources.length) {
      var resource = _resources[index];
      if (resource is CourseFile) {
        return resource.downloadUrl;
      } else {
        throw TypeError();
      }
    } else {
      throw RangeError('index out of range');
    }
  }

  String getFileName(int index) {
    if (index >= 0 && index < _resources.length) {
      var resource = _resources[index];
      if (resource is CourseFile) {
        return resource.name;
      } else {
        throw TypeError();
      }
    } else {
      throw RangeError('index out of range');
    }
  }

  void addLinkResource(CourseLink link) {
    _resources.add(link);
    notifyListeners();
  }

  void addFileResource(CourseFile file) {
    _resources.add(file);
    notifyListeners();
  }

  void removeItem(int index) {
    _resources.removeAt(index);
    notifyListeners();
  }

  void editResource(int index, String newName, String newUrlOrPath) {
    var resource = _resources[index];
    if (resource is CourseLink) {
      resource.name = newName;
      resource.url = newUrlOrPath;
    } else if (resource is CourseFile) {
      resource.name = newName;
      resource.downloadUrl = newUrlOrPath;
    }
    notifyListeners();
  }

  void changeIndex(int oldIndex, int newIndex) {
    if (newIndex > oldIndex) {
      newIndex -= 1;
    }
    final dynamic item = _resources.removeAt(oldIndex);
    _resources.insert(newIndex, item);
  }
}
