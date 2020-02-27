import 'package:brew_crew/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:brew_crew/models/brew.dart';

class DatabaseService {
  final CollectionReference brewCollection =
      Firestore.instance.collection("brews");
  final String uid;

  DatabaseService({this.uid});

  Future updateUserData(String sugars, String name, int strength) async {
    return await brewCollection.document(uid).setData({
      "sugars": sugars,
      "name": name,
      "strength": strength,
    });
  }

  List<Brew> _brewListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.documents.map((doc) {
      return Brew(
          name: doc.data['name'] ?? '',
          strength: doc.data['strength'] ?? 0,
          sugars: doc.data['sugars'] ?? '0'
          );
    }).toList();
  }

  UserData _userDateFromSnapshot(DocumentSnapshot snapshot){
    return UserData(
      uid: uid,
      sugars: snapshot.data['sugars'],
      name: snapshot.data['name'],
      strength: snapshot.data['strength']
    );
  }

  Stream<List<Brew>> get brews {
    return brewCollection.snapshots()
    .map(_brewListFromSnapshot);
  }

  Stream<UserData> get userData {
    return brewCollection.document(uid).snapshots()
    .map(_userDateFromSnapshot);
  }
}
