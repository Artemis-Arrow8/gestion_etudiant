import '../models/course.dart';

class CourseService {
  static final List<Course> courses = const [
    Course(title: 'Développement mobile avancé', code: 'MOB301', instructor: 'Mme Traoré'),
    Course(title: 'Génie logiciel et UML', code: 'GEN302', instructor: 'M. Diallo'),
    Course(title: 'Bases de données relationnelles', code: 'BDD303', instructor: 'Dr Coulibaly'),
    Course(title: 'Réseaux informatiques', code: 'RES304', instructor: 'M. Sidibé'),
    Course(title: 'Systèmes d\'exploitation', code: 'SYST305', instructor: 'Mme Guindo'),
  ];
}