// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ipet/model/users.dart';
import 'package:ipet/model/vetirinary.dart';
import 'package:ipet/utils/firebasehook.dart';

class AuthProviderClass extends ChangeNotifier {
  Navigator navigator = const Navigator();
  UsersModel? _userModel;
  VeterinaryModel? _veterinaryModel;

  UsersModel? get userModel => _userModel;
  VeterinaryModel? get veterinarymovel => _veterinaryModel;

  Future<void> loginWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user!.uid)
          .get();
      Map<String, dynamic>? userData =
          userSnapshot.data() as Map<String, dynamic>?;

      if (userData != null &&
          userData.isNotEmpty &&
          userData.containsKey("role")) {
        _userModel = UsersModel.getdocument(userData);

        int role = userData["role"];

        if (role == 1) {
          DocumentSnapshot veterinarydata = await usercred
              .doc(userCredential.user!.uid)
              .collection("vertirenary")
              .doc(userCredential.user!.uid)
              .get();

          Map<String, dynamic>? vetdata =
              veterinarydata.data() as Map<String, dynamic>?;

          _veterinaryModel = VeterinaryModel.getdocument(vetdata);

          debugPrint(" Vetirenary");
        } else {
          debugPrint("Vet = Not Vetirenary");
        }

        notifyListeners();
      }
    } catch (error) {
      // Throw FirebaseAuthException
      throw FirebaseAuthException(
        message: error.toString(),
        code: 'auth-error',
      );
    }
  }
}
