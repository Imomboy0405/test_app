import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:test_app/Data/Models/group_model.dart';
import 'package:test_app/Data/Models/user_model.dart';

class FirestoreService {
  static final FirebaseFirestore _db = FirebaseFirestore.instance;
  static final CollectionReference _usersCollection = FirebaseFirestore.instance.collection('user');

  static Future<void> createUser(UserModel user) async => await _usersCollection.doc(user.uid).set(user.toJson());

  static Future<void> updateUser(UserModel user) async => await _usersCollection.doc(user.uid).update(user.toJson());

  static Future<void> deleteUser(String userId) async => await _usersCollection.doc(userId).delete();

  static Future<UserModel?> loadUser(String userId) async {
    final documentSnapshot = await _usersCollection.doc(userId).get();
    if (documentSnapshot.exists) {
      return UserModel.fromJson(documentSnapshot.data() as Map<dynamic, dynamic>);
    } else {
      return null;
    }
  }

  static Future<List<Map<String, dynamic>>> loadSeed(String uid) async {
    List<Map<String, dynamic>> list = List.filled(5, {});
    list[0] = await _getDataFromFirestore('currentIllness/$uid');
    list[1] = await _getDataFromFirestore('generalPhysical/$uid');
    list[2] = await _getDataFromFirestore('heredity/$uid');
    list[3] = await _getDataFromFirestore('medicines/$uid');
    list[4] = await _getDataFromFirestore('surgicalInterventions/$uid');
    return list;
  }

  static Future<void> updateSeed(List<Map<String, dynamic>> values, String uid) async {
    if (values[0].isNotEmpty) await _db.doc('currentIllness/$uid').set(values[0], SetOptions(merge: true));
    if (values[1].isNotEmpty) await _db.doc('generalPhysical/$uid').set(values[1], SetOptions(merge: true));
    if (values[2].isNotEmpty) await _db.doc('heredity/$uid').set(values[2], SetOptions(merge: true));
    if (values[3].isNotEmpty) await _db.doc('medicines/$uid').set(values[3], SetOptions(merge: true));
    if (values[4].isNotEmpty) await _db.doc('surgicalInterventions/$uid').set(values[4], SetOptions(merge: true));
  }

  static Future<Map<String, dynamic>> _getDataFromFirestore(String collectionPath) async {
    final map = <String, dynamic>{};
    DocumentSnapshot<Map<String, dynamic>>? snapshot = await _db.doc(collectionPath).get();
    if (snapshot.exists) {
      map.addAll(Map<String, dynamic>.from(snapshot.data() as Map));
    }
    return map;
  }

  static Future<List<GroupModel>> loadEmptyGroups() async {
    final query = _db.collection('group').where('membersCount', isEqualTo: 1);
    final snapshot = await query.get();
    List<GroupModel> groups = [];
    for (var group in snapshot.docs) {
      if (group.exists) {
        groups.add(GroupModel.fromJson(Map<String, dynamic>.from(group.data() as Map)));
      }
    }
    return groups;
  }

  static Future<List<GroupModel>> loadDoctorGroups(String doctorId) async {
    final query = _db.collection('group').where('members', arrayContains: doctorId);
    final snapshot = await query.get();
    List<GroupModel> groups = [];
    for (var group in snapshot.docs) {
      if (group.exists) {
        groups.add(GroupModel.fromJson(Map<String, dynamic>.from(group.data() as Map)));
      }
    }
    return groups;
  }
  
  static Future<void> updateGroup(GroupModel group) async {
    await _db.collection('group').doc(group.id).update(group.toJson());
  }
}