import 'package:json_annotation/json_annotation.dart';
import 'package:uniud_timetable_app/utilities/profiles.dart';

part 'profile_models.g.dart';

@JsonSerializable(explicitToJson: true)
class ProfilesWrapper {
  final Set<Profile> profiles;

  ProfilesWrapper(this.profiles);

  factory ProfilesWrapper.fromJson(Map<String, dynamic> json) => _$ProfilesWrapperFromJson(json);

  Map<String, dynamic> toJson() => _$ProfilesWrapperToJson(this);
}

@JsonSerializable(explicitToJson: true)
class Profile {
  final String name;
  final String departmentName;
  final String degreeTypeName;
  final String degreeName;
  final String periodName;
  final Set<Course> courses;

  Profile(this.name, this.departmentName, this.degreeTypeName, this.degreeName,
      this.periodName, this.courses);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is Profile &&
              runtimeType == other.runtimeType &&
              name == other.name;

  @override
  int get hashCode => name.hashCode;

  factory Profile.fromJson(Map<String, dynamic> json) => _$ProfileFromJson(json);

  Map<String, dynamic> toJson() => _$ProfileToJson(this);
}

@JsonSerializable(explicitToJson: true)
class Course {
  final String name;
  final String credits;
  final Professor professor;
  final List<CourseLesson> lessons;

  Course(this.name, this.credits, this.professor, this.lessons);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is Course &&
              runtimeType == other.runtimeType &&
              name == other.name &&
              credits == other.credits &&
              professor == other.professor;

  @override
  int get hashCode => name.hashCode ^ credits.hashCode ^ professor.hashCode;

  factory Course.fromJson(Map<String, dynamic> json) => _$CourseFromJson(json);

  Map<String, dynamic> toJson() => _$CourseToJson(this);
}

@JsonSerializable(explicitToJson: true)
class CourseLesson {
  /// The parent [course] reference.
  /// This is guaranteed to be non-null if this object has been retrieved
  /// through the [Profiles] class.
  @JsonKey(ignore: true) // Ignore to avoid circular reference
  Course? course;
  final DateTime startDateTime;
  final DateTime endDateTime;
  final String building;
  final String room;

  CourseLesson(this.startDateTime, this.endDateTime, this.building, this.room);

  factory CourseLesson.fromJson(Map<String, dynamic> json) => _$CourseLessonFromJson(json);

  Map<String, dynamic> toJson() => _$CourseLessonToJson(this);
}

@JsonSerializable(explicitToJson: true)
class Professor {
  final String name;
  final String surname;
  String? email;
  String? phone;

  Professor(this.name, this.surname);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Professor &&
          runtimeType == other.runtimeType &&
          name == other.name &&
          surname == other.surname &&
          email == other.email &&
          phone == other.phone;

  @override
  int get hashCode =>
      name.hashCode ^ surname.hashCode ^ email.hashCode ^ phone.hashCode;

  factory Professor.fromJson(Map<String, dynamic> json) => _$ProfessorFromJson(json);

  Map<String, dynamic> toJson() => _$ProfessorToJson(this);
}
