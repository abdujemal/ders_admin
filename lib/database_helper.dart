// import 'dart:io';

// import 'package:ders_admin/constants.dart';
// import 'package:ders_admin/course.dart';
// import 'package:ders_admin/faq.dart';
// import 'package:flutter/foundation.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:sqflite/sqflite.dart';

// // import 'constants.dart';

// class DatabaseHelper {
//   static DatabaseHelper? _databaseHelper;
//   static Database? _database;

//   DatabaseHelper._createInstance();
//   factory DatabaseHelper() {
//     _databaseHelper ??= DatabaseHelper._createInstance();
//     return _databaseHelper!;
//   }

//   closeDb() async {
//     await _database!.close();
//   }

//   Future<void> deleteDb(String table) async {
//     final db = await database;
//     await db!.delete(table);
//   }

//   Future<Database> initializeDatabase() async {
//     PermissionStatus status = await Permission.storage.request();
//     if (status.isGranted) {
//       // Get the downloads directory path
//       Directory directory = (await getDownloadsDirectory())!;

//       String path = '${directory.path}$dbPath';

//       // if (await File(path).exists()) {
//       //   await File(path).delete();
//       //   print("db deleted");
//       // }

//       var notesDatabase = await openDatabase(path,
//           version: 1, onCreate: _createDb, readOnly: false);
//       if (kDebugMode) {
//         print("db is ready");
//       }
//       return notesDatabase;
//     }
   
//     throw Exception("Permission pls");
//   }

//   Future<Database?> get database async {
//     _database ??= await initializeDatabase();
//     return _database;
//   }

//   //creating database
//   void _createDb(Database db, int newVersion) async {
//     await db.execute('CREATE TABLE ${DatabaseConst.savedCourses}('
//         'id INTEGER PRIMARY KEY AUTOINCREMENT,'
//         'courseId TEXT,'
//         'author TEXT,'
//         'category TEXT,'
//         'courseIds TEXT,'
//         'noOfRecord INTEGER,'
//         'pdfId TEXT,'
//         'title TEXT,'
//         'ustaz TEXT,'
//         'image TEXT,'
//         'lastViewed TEXT,'
//         'isFav INTEGER,'
//         'isStarted INTEGER,'
//         'isFinished INTEGER,'
//         'pausedAtAudioNum INTEGER,'
//         'pausedAtAudioSec INTEGER,'
//         "scheduleDates TEXT,"
//         "scheduleTime TEXT,"
//         'isScheduleOn INTEGER,'
//         'pdfPage DOUBLE,'
//         'pdfNum DOUBLE,'
//         'totalDuration INTEGER,'
//         'audioSizes TEXT,'
//         'isCompleted INTEGER,'
//         'isBeginner INTEGER,'
//         'dateTime TEXT'
//         ')');

//     await db.execute('CREATE TABLE ${DatabaseConst.category}('
//         'id INTEGER PRIMARY KEY AUTOINCREMENT,'
//         'name TEXT'
//         ')');

//     await db.execute('CREATE TABLE ${DatabaseConst.content}('
//         'id INTEGER PRIMARY KEY AUTOINCREMENT,'
//         'name TEXT'
//         ')');

//     await db.execute('CREATE TABLE ${DatabaseConst.ustaz}('
//         'id INTEGER PRIMARY KEY AUTOINCREMENT,'
//         'name TEXT'
//         ')');

//     await db.execute('CREATE TABLE ${DatabaseConst.faq}('
//         'id INTEGER PRIMARY KEY AUTOINCREMENT,'
//         'question TEXT,'
//         'answer TEXT'
//         ')');
//   }

//   //check
//   Future<bool> isCourseAvailable(String courseId) async {
//     Database? db = await database;
//     try {
//       var result = await db!.query(DatabaseConst.savedCourses,
//           where: 'courseId = ?', whereArgs: [courseId]);
//       return result.isNotEmpty;
//     } catch (e) {
//       return false;
//     }
//   }

//   //geting data
//   Future<List<Course>> getCourseHistories() async {
//     Database? db = await database;

//     var result = await db!.query(
//       DatabaseConst.savedCourses,
//       orderBy: 'lastViewed DESC',
//       // limit: 10,
//     );
//     List<Course> courses = [];
//     for (var courseDb in result) {
//       courses.add(Course.fromMap(courseDb, courseDb['courseId'] as String));
//     }
//     return courses;
//   }

//   Future<List<Course>> getSavedCourses() async {
//     Database? db = await database;

//     var result =
//         await db!.query(DatabaseConst.savedCourses, orderBy: 'lastViewed DESC');
//     List<Course> courses = [];
//     for (var courseDb in result) {
//       courses.add(Course.fromMap(courseDb, courseDb['courseId'] as String));
//     }
//     return courses;
//   }

//   Future<Course?> getSingleCourse(String courseId) async {
//     Database? db = await database;

//     var result = await db!.query(DatabaseConst.savedCourses,
//         where: 'courseId = ?', whereArgs: [courseId]);
//     List<Course> courses = [];
//     for (var courseDb in result) {
//       courses.add(Course.fromMap(courseDb, courseDb['courseId'] as String));
//     }
//     return courses.isEmpty ? null : courses.first;
//   }

//   Future<List<Course>> getStartedCourses() async {
//     Database? db = await database;

//     var result = await db!.query(DatabaseConst.savedCourses,
//         orderBy: 'lastViewed DESC', where: 'isStarted = ?', whereArgs: [1]);
//     List<Course> courses = [];
//     for (var courseDb in result) {
//       courses.add(Course.fromMap(courseDb, courseDb['courseId'] as String));
//     }
//     // courses.sort((a, b) => b.lastViewed.compareTo(a.lastViewed));
//     return courses;
//   }

//   Future<List<Course>> getFavCourses() async {
//     Database? db = await database;

//     var result = await db!.query(DatabaseConst.savedCourses,
//         orderBy: 'lastViewed ASC', where: 'isFav = ?', whereArgs: [1]);

//     List<Course> tasks = [];
//     for (var taskDb in result) {
//       tasks.add(Course.fromMap(taskDb, taskDb['courseId'] as String));
//     }
//     return tasks;
//   }

//   //inserting data
//   Future<int> insertCourse(Course course) async {
//     Database? db = await database;
//     var result = await db!.insert(DatabaseConst.savedCourses, course.toMap());

//     return result;
//   }

//   Future<int> insertCategory(String category) async {
//     Database? db = await database;
//     var result = await db!.insert(DatabaseConst.category, {'name': category});

//     return result;
//   }

//   Future<int> insertContent(String content) async {
//     Database? db = await database;
//     var result = await db!.insert(DatabaseConst.content, {'name': content});

//     return result;
//   }

//   Future<int> insertUstaz(String ustaz) async {
//     Database? db = await database;
//     var result = await db!.insert(DatabaseConst.ustaz, {'name': ustaz});

//     return result;
//   }

//   Future<int> insertFaq(Faq faq) async {
//     final db = await database;
//     var result = await db!.insert(DatabaseConst.faq, faq.toMap());

//     return result;
//   }

//   //update data
//   Future<int> updateCourse(Course course) async {
//     var db = await database;
//     var result = await db!.update(DatabaseConst.savedCourses, course.toMap(),
//         where: 'id = ?', whereArgs: [course.id]);

//     return result;
//   }

//   //deleta data
//   Future<int> deleteCourse(int id) async {
//     var db = await database;
//     var result = await db!
//         .rawDelete('DELETE FROM ${DatabaseConst.savedCourses} WHERE id = $id');

//     return result;
//   }
// }
