// lib/features/groups/data/datasources/group_remote_datasource.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart'; 
import '../../domain/entities/group_entity.dart';
import '../models/group_model.dart';
import '../../domain/entities/age_range.dart';

class GroupRemoteDataSource {
  final _groupsCollection = FirebaseFirestore.instance.collection('groups');

  Future<int> getHighestGroupIdNumber() async {
    try {
      final querySnapshot = await _groupsCollection.get();
      int highestNumber = 0;

      for (var doc in querySnapshot.docs) {
        final docId = doc.id;
        if (docId.startsWith('group_')) {
          final numberPart = docId.split('group_')[1];
          final number = int.tryParse(numberPart);
          if (number != null && number > highestNumber) {
            highestNumber = number;
          }
        }
      }
      return highestNumber;
    } catch (e) {
      debugPrint('Error getting highest group ID number: $e');
      return 0;
    }
  }

  Future<void> addGroup(GroupEntity group) async {
    final now = Timestamp.fromDate(DateTime.now());
    final groupData = GroupModel.fromEntity(group).toFirestore()
      ..['registration_date'] = now
      ..['last_modified_date'] = now;
    
    await _groupsCollection.doc(group.id).set(groupData);
  }

  Future<void> updateGroup(GroupEntity group) async {
    final now = Timestamp.fromDate(DateTime.now());
    final groupData = GroupModel.fromEntity(group).toFirestore()
      ..['last_modified_date'] = now;
    
    await _groupsCollection.doc(group.id).update(groupData);
  }

  Future<void> deleteGroup(String id) async {
    final now = Timestamp.fromDate(DateTime.now());
    await _groupsCollection.doc(id).update({
      'state': 0,
      'delete_date': now,
      'last_modified_date': now,
    });
  }

  Future<void> blockGroup(String id) async {
    final now = Timestamp.fromDate(DateTime.now());
    await _groupsCollection.doc(id).update({
      'state': 2,
      'block_date': now,
      'last_modified_date': now,
    });
  }

  Future<void> restoreGroup(String id) async {
    final now = Timestamp.fromDate(DateTime.now());
    await _groupsCollection.doc(id).update({
      'state': 1,
      'delete_date': null,
      'restore_date': now,
      'last_modified_date': now,
    });
  }

  Stream<List<GroupEntity>> getGroups() {
    return _groupsCollection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => GroupModel.fromFirestore(doc)).toList();
    });
  }
  
  
  Stream<List<GroupEntity>> getGroupsByPlaceId(String placeId) {
  
    return _groupsCollection
        .where('placeIds', arrayContains: placeId) 
        .snapshots()
        .map((snapshot) {
          return snapshot.docs
              .map((doc) => GroupModel.fromFirestore(doc))
              .toList();
        });
  }
  

  Future<GroupModel?> getGroup(String groupId) async {
    final docSnapshot = await _groupsCollection.doc(groupId).get();
    if (docSnapshot.exists) {
      return GroupModel.fromFirestore(docSnapshot);
    }
    return null;
  }

  Stream<List<GroupModel>> getGroupsByTutorId(String tutorId) {
    return _groupsCollection
        .where('idTutor', isEqualTo: tutorId)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) => GroupModel.fromFirestore(doc)).toList();
        });
  }

  Future<void> updateAgeRange(String groupId, AgeRange newAgeRange) async {
    await _groupsCollection.doc(groupId).update({
      'minAge': newAgeRange.minAge,
      'maxAge': newAgeRange.maxAge,
    });
  }

  Future<GroupModel?> getGroupByAge(int age) async {
    final querySnapshot = await _groupsCollection
        .where('minAge', isLessThanOrEqualTo: age)
        .where('maxAge', isGreaterThanOrEqualTo: age)
        .limit(1)
        .get();
    if (querySnapshot.docs.isNotEmpty) {
      return GroupModel.fromFirestore(querySnapshot.docs.first);
    }
    return null;
  }
}