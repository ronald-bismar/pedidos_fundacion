import 'package:pedidos_fundacion/domain/entities/programa.dart';
import 'package:pedidos_fundacion/domain/entities/rango_edad.dart';

abstract class GroupRepository {
  Future<bool> createGroup(Group group);
  Future<Group?> getGroup(String groupId);
  Future<List<Group>> getAllGroups();
  Future<bool> updateGroup(Group group) ;
  Future<bool> deleteGroup(String groupId);
  Future<List<Group>> getGroupsByTutorId(String tutorId);
  Future<bool> updateAgeRange(String groupId, AgeRange newAgeRange);
  Future<Group?> getGroupByAge(int age);
}
