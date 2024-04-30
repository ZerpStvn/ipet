class UsersModel {
  String? vetid;
  String? imageprofile;
  int? role;
  String? nameclinic;
  String? fname;
  String? lname;
  String? pnum;
  String? email;
  String? pass;

  UsersModel({
    this.vetid,
    this.imageprofile,
    this.role,
    this.nameclinic,
    this.fname,
    this.lname,
    this.pnum,
    this.email,
    this.pass,
  });

  factory UsersModel.getdocument(map) {
    return UsersModel(
      vetid: map['vetid'],
      imageprofile: map['imageprofile'],
      role: map['role'],
      nameclinic: map['nameclinic'],
      fname: map['fname'],
      lname: map['lname'],
      pnum: map['pnum'],
      email: map['email'],
      pass: map['pass'],
    );
  }
  Map<String, dynamic> usersModelmap() {
    return {
      'vetid': vetid,
      "imageprofile": imageprofile,
      "role": role,
      "nameclinic": nameclinic,
      "fname": fname,
      "lname": lname,
      "pnum": pnum,
      "email": email,
      "pass": pass,
    };
  }
}
