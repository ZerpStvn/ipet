import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

final usercred = FirebaseFirestore.instance.collection('usercred');
final userAuth = FirebaseAuth.instance;
final usercredstorage = FirebaseStorage.instance;
