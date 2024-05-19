class Course {
  String moduleName;

  List<dynamic> courseItems;

  Course({
    required this.moduleName,
    required this.courseItems,
  });
}

class CourseAttributes {
  List<CourseLink> links;
  List<CourseFile> files;

  CourseAttributes({required this.links, required this.files});
}

class CourseLink {
  String name;
  String url;

  CourseLink({required this.url, required this.name});
}

class CourseFile {
  String downloadUrl;
  String name;

  CourseFile({required this.downloadUrl, required this.name});
}
