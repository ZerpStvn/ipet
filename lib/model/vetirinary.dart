class VeterinaryModel {
  String? tin;
  String? dti;
  String? bir;
  List? operation;
  List? services;
  List? specialties;
  String? description;
  String? lat;
  String? long;
  int? valid;
  String? dateestablished;

  VeterinaryModel(
      {this.valid,
      this.tin,
      this.dti,
      this.bir,
      this.operation,
      this.services,
      this.specialties,
      this.description,
      this.lat,
      this.long,
      this.dateestablished});

  factory VeterinaryModel.getdocument(map) {
    return VeterinaryModel(
      valid: map['valid'],
      tin: map['tin'],
      dti: map['dti'],
      bir: map['bir'],
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
      "dti": dti,
      "bir": bir,
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
