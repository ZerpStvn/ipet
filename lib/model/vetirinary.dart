class VeterinaryModel {
  String? vetid;
  String? imageprofile;
  int? role;
  String? nameclinic;
  String? fname;
  String? lname;
  String? pnum;
  String? email;
  String? pass;
  String? tin;
  String? dti;
  String? bir;
  List? operation;
  List? services;
  List? specialties;
  String? description;
  String? lat;
  String? long;

  VeterinaryModel(
      {this.vetid,
      this.imageprofile,
      this.role,
      this.nameclinic,
      this.fname,
      this.lname,
      this.pnum,
      this.email,
      this.pass,
      this.tin,
      this.dti,
      this.bir,
      this.operation,
      this.services,
      this.specialties,
      this.description,
      this.lat,
      this.long});

  factory VeterinaryModel.getdocument(map) {
    return VeterinaryModel(
      vetid: map['vetid'],
      imageprofile: map['imageprofile'],
      role: map['role'],
      nameclinic: map['nameclinic'],
      fname: map['fname'],
      lname: map['lname'],
      pnum: map['pnum'],
      email: map['email'],
      pass: map['pass'],
      tin: map['tin'],
      dti: map['dti'],
      bir: map['bir'],
      operation: map['operation'],
      services: map['services'],
      specialties: map['specialties'],
      description: map['description'],
      lat: map['lat'],
      long: map['long'],
    );
  }

  Map<String, dynamic> veterinarymap() {
    return {
      'vetid': 'vetid',
      "imageprofile": imageprofile,
      "role": role,
      "nameclinic": nameclinic,
      "fname": fname,
      "lname": lname,
      "pnum": pnum,
      "email": email,
      "pass": pass,
      "tin": tin,
      "dti": dti,
      "bir": bir,
      "operation": operation,
      "services": services,
      "specialties": specialties,
      "description": description,
      "lat": lat,
      "long": long,
    };
  }
}
