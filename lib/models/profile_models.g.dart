// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Profile _$ProfileFromJson(Map<String, dynamic> json) => Profile(
      json['name'] as String,
      json['departmentName'] as String,
      json['degreeTypeName'] as String,
      json['degreeName'] as String,
      json['periodName'] as String,
      (json['courses'] as List<dynamic>)
          .map((e) => Course.fromJson(e as Map<String, dynamic>))
          .toSet(),
    );

Map<String, dynamic> _$ProfileToJson(Profile instance) => <String, dynamic>{
      'name': instance.name,
      'departmentName': instance.departmentName,
      'degreeTypeName': instance.degreeTypeName,
      'degreeName': instance.degreeName,
      'periodName': instance.periodName,
      'courses': instance.courses.map((e) => e.toJson()).toList(),
    };

Course _$CourseFromJson(Map<String, dynamic> json) => Course(
      json['name'] as String,
      json['credits'] as String,
      Professor.fromJson(json['professor'] as Map<String, dynamic>),
      (json['lessons'] as List<dynamic>)
          .map((e) => CourseLesson.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$CourseToJson(Course instance) => <String, dynamic>{
      'name': instance.name,
      'credits': instance.credits,
      'professor': instance.professor.toJson(),
      'lessons': instance.lessons.map((e) => e.toJson()).toList(),
    };

CourseLesson _$CourseLessonFromJson(Map<String, dynamic> json) => CourseLesson(
      Course.fromJson(json['course'] as Map<String, dynamic>),
      DateTime.parse(json['startDateTime'] as String),
      DateTime.parse(json['endDateTime'] as String),
      json['building'] as String,
      json['room'] as String,
    );

Map<String, dynamic> _$CourseLessonToJson(CourseLesson instance) =>
    <String, dynamic>{
      'course': instance.course.toJson(),
      'startDateTime': instance.startDateTime.toIso8601String(),
      'endDateTime': instance.endDateTime.toIso8601String(),
      'building': instance.building,
      'room': instance.room,
    };

Professor _$ProfessorFromJson(Map<String, dynamic> json) => Professor(
      json['name'] as String,
      json['surname'] as String,
    )
      ..email = json['email'] as String?
      ..phone = json['phone'] as String?;

Map<String, dynamic> _$ProfessorToJson(Professor instance) => <String, dynamic>{
      'name': instance.name,
      'surname': instance.surname,
      'email': instance.email,
      'phone': instance.phone,
    };
