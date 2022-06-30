import 'package:encrypt/encrypt.dart' as encrypt;

void main() {
  List<int> rawListOfIds = [75893, 898490, 7868853, 976593, 976594]; // Liste des ID pour la signature
  var listOfIds = rawListOfIds.join(',');

  // encrypt.Encrypted signatureToDecrypt = ('3jZbYoExjvu8A+9Ctlou3onmNmsxCAXFeQT6hlA2C6StctBNTQyJMC/1nHNNqu5L') as encrypt.Encrypted; // Signature à déchifrer 

  final key = encrypt.Key.fromLength(32); // Mot de passe à définir en ayant un multiple de 32 caractères
  final iv = encrypt.IV.fromLength(16); // Vecteur d'initialisation pour le type de chiffrement

  final encrypter = encrypt.Encrypter(encrypt.AES(key, mode: encrypt.AESMode.cbc, padding: 'PKCS7')); // Type de chiffrement, ici AES ( Advanced Encryption Standart)

  encryptSygnature(listOfIds){
    var encrypted = encrypter.encrypt(listOfIds, iv: iv); // Créer un object chiffré
    return encrypted;
  }

  // decryptSignature64(signatureToDecrypt64){
  //   var decrypted = encrypter.decrypt64(signatureToDecrypt64, iv: iv); // Déchiffre à partir d'un objet chiffré
  //   return decrypted;
  // }

  decryptSignature(signatureToDecrypt){
    var decrypted = encrypter.decrypt(signatureToDecrypt, iv: iv); // Déchiffre à partir d'un objet chiffré
    return decrypted;
  }

  var encrypted = encryptSygnature(listOfIds);
  final decrypted = decryptSignature(encrypted);
  // final decrypted64 = decryptSignature64(signatureToDecrypt);
  final encryptedBase64 = encrypted.base64;

  print(decrypted); // Lorem ipsum dolor sit amet, consectetur adipiscing elit
  print(encryptedBase64); // encryptedBase64
  // print(decrypted64); // base 64 déchiffré
}