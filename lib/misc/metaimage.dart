import 'package:firebase_storage/firebase_storage.dart';

void metadataimage(image) {
  SettableMetadata(
      contentType: "image/jpeg",
      customMetadata: {'pick-file-path': image.path});
}
