class VeterinaryModel {
  String? tin;
  String? dti;
  String? bir;
  List<dynamic>? operation;
  List<dynamic>? services;
  List<dynamic>? specialties;
  String? description;
  String? lat;
  String? long;
  int? valid;
  String? clinicname;
  String? imageprofile;
  String? dateestablished;

  VeterinaryModel(
      {this.valid,
      this.tin,
      this.dti,
      this.bir,
      this.operation,
      this.services,
      this.imageprofile,
      this.specialties,
      this.description,
      this.lat,
      this.long,
      this.clinicname,
      this.dateestablished});

  factory VeterinaryModel.getdocument(map) {
    return VeterinaryModel(
      valid: map['valid'],
      tin: map['tin'],
      dti: map['dti'],
      bir: map['bir'],
      imageprofile: map['imageprofile'],
      clinicname: map['clinicname'],
      operation: map['operation'],
      services: map['services'],
      specialties: map['specialties'],
      description: map['description'],
      lat: map['lat'],
      long: map['long'],
      dateestablished: map['dateestablished'],
    );
  }

  Map<String, dynamic> veterinarymap() {
    return {
      'valid': 0,
      "tin": tin,
      "clinicname": clinicname,
      "dti": dti,
      "bir": bir,
      "imageprofile": imageprofile,
      "operation": operation,
      "services": services,
      "specialties": specialties,
      "description": description,
      "lat": lat,
      "long": long,
      "dateestablished": dateestablished,
    };
  }
}
