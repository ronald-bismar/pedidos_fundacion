import 'package:pedidos_fundacion/domain/entities/programa.dart';
import 'package:pedidos_fundacion/domain/entities/rango_edad.dart';

class Grupo {
  // Método para crear los grupos de ejemplo con rangos de edad apropiados
  static List<Group> values() {
    return [
      Group(
        id: 'group_001',
        idTutor: 'tutor_001',
        groupName: 'Base Hogar',
        ageRange: AgeRange(0, 1), // Bebés y niños pequeños
      ),

      Group(
        id: 'group_002',
        idTutor: 'tutor_002',
        groupName: 'Base Centro - Descubridores',
        ageRange: AgeRange(2, 5), // Preescolar general
      ),

      Group(
        id: 'group_003',
        idTutor: 'tutor_003',
        groupName: 'Base Centro - Triunfadores I',
        ageRange: AgeRange(6, 8), // Primaria temprana
      ),

      Group(
        id: 'group_004',
        idTutor: 'tutor_004',
        groupName: 'Base Centro - Triunfadores II',
        ageRange: AgeRange(9, 11), // Primaria media/tardía
      ),

      Group(
        id: 'group_005',
        idTutor: 'tutor_005',
        groupName: 'Base Centro - Restauradores',
        ageRange: AgeRange(12, 15), // Adolescencia temprana
      ),

      Group(
        id: 'group_006',
        idTutor: 'tutor_006',
        groupName: 'Base Centro - Pre GAP',
        ageRange: AgeRange(16, 18), // Adolescencia tardía/jóvenes
      ),
    ];
  }
}
