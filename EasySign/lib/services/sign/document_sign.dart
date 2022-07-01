import 'package:encrypt/encrypt.dart' as encrypt;

void main() {

/* On récupère la liste des ID ou la signature une fois chiffrée */
  List<int> rawListOfIds = [75893, 898490, 7868853, 976593, 976594]; // Liste des ID pour la signature
  var listOfIds = rawListOfIds.join(',');
  encrypt.Encrypted signatureToDecrypt = ('3jZbYoExjvu8A+9Ctlou3onmNmsxCAXFeQT6hlA2C6StctBNTQyJMC/1nHNNqu5L') as encrypt.Encrypted; // Signature à déchifrer


/* On créer le clé de chiffrement en 32 charactères puis le vecteur d'initialisation lors du chiffrement */
  final key = encrypt.Key.fromLength(32); 
  final iv = encrypt.IV.fromLength(16); 


/* Type de chiffrement, ici AES ( Advanced Encryption Standart) */
  final encrypter = encrypt.Encrypter(encrypt.AES(key, mode: encrypt.AESMode.cbc, padding: 'PKCS7')); 


/* Différentes fonctions de chiffrement et déchiffrement */
  encryptSygnature(listOfIds){ //Permet de chiffrer une liste donnée
    var encrypted = encrypter.encrypt(listOfIds, iv: iv); 
    return encrypted;
  }
  decryptSignature(signatureToDecrypt){ //Permet de déchiffrer un object chiffré 
    var decrypted = encrypter.decrypt(signatureToDecrypt, iv: iv); // Déchiffre à partir d'un objet chiffré
    return decrypted;
  }
  decryptSignature64(signatureToDecrypt64){ //Permet de permet de déchiffrer une signature
    var decrypted = encrypter.decrypt64(signatureToDecrypt64, iv: iv); // Déchiffre à partir d'un objet chiffré
    return decrypted;
  }


  final encrypted = encryptSygnature(listOfIds);
  final decrypted = decryptSignature(encrypted);
  final decrypted64 = decryptSignature64(signatureToDecrypt);
  final encryptedBase64 = encrypted.base64;

  print(decrypted); 
  print(encryptedBase64);
  print(decrypted64);
}