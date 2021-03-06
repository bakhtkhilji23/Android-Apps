import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_understanding/Cat%20Adoption/modal/cat.dart';
import 'package:google_sign_in/google_sign_in.dart';


class CatApi {

  static FirebaseAuth _auth = FirebaseAuth.instance;
  static GoogleSignIn _googleSignIn = new GoogleSignIn();

  FirebaseUser firebaseUser;

  CatApi(FirebaseUser user){
    this.firebaseUser = user;
  }

  static Future<CatApi> signInWithGoogle() async{
    // final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    // final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    final AuthResult authResult = await _auth.signInWithCredential(credential);
    FirebaseUser user = authResult.user;
    assert(user.email != null);
    assert(user.displayName != null);
    assert(user.isAnonymous);
    assert(await user.getIdToken() != null);
    final FirebaseUser currentUser = await _auth.currentUser();
    assert(user.uid == currentUser.uid);
    return new CatApi(user);
  }

  static List<Cat> allCatsFromJson(String jsonData) {
    List<Cat> cats = [];
    json.decode(jsonData)['cats'].forEach((cat) => cats.add(_fromMap(cat)));
    return cats;
  }

  static Cat _fromMap(Map<String, dynamic> map) {
    return new Cat(
      externalId: map['id'],
      name: map['name'],
      description: map['description'],
      avatarUrl: map['image_url'],
      location: map['location'],
      likeCounter: map['like_counter'],
      isAdopted: map['adopted'],
      pictures: new List<String>.from(map['pictures']),
      cattributes: new List<String>.from(map['cattributes']),
    );
  }
}
