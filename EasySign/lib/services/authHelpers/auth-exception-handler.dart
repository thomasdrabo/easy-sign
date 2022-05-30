import 'auth-status-enum.dart';

class AuthExceptionHandler {
  static handleException(e) {
    print('LA');
    print(e.code);
    var status;
    switch (e.code) {
      case "invalid-email":
        status = AuthResultStatus.invalidEmail;
        break;
      case "missing-email":
        status = AuthResultStatus.missingEmail;
        break;
      case "weak-password":
        status = AuthResultStatus.weakPassword;
        break;
      case "wrong-password":
        status = AuthResultStatus.wrongPassword;
        break;
      case "user-not-found":
        status = AuthResultStatus.userNotFound;
        break;
      case "user-disabled":
        status = AuthResultStatus.userDisabled;
        break;
      case "roo-many-requests":
        status = AuthResultStatus.tooManyRequests;
        break;
      case "operation-not-allowed":
        status = AuthResultStatus.operationNotAllowed;
        break;
      case "email-already-in-use":
        status = AuthResultStatus.emailAlreadyExists;
        break;
      default:
        status = AuthResultStatus.undefined;
    }
    return status;
  }

  ///
  /// Accepts AuthExceptionHandler.errorType
  ///
  static generateExceptionMessage(exceptionCode) {
    String errorMessage;
    print("ICI");
    print(exceptionCode);
    switch (exceptionCode) {
      case AuthResultStatus.invalidEmail:
        errorMessage = "Merci d'entrer une adresse email valide.";
        break;
      case AuthResultStatus.missingEmail:
        errorMessage = "Merci d'entrer une adresse email.";
        break;
      case AuthResultStatus.weakPassword:
        errorMessage = "Le mot de passe doit contenir au moins 6 caractères";
        break;
      case AuthResultStatus.wrongPassword:
        errorMessage = "Les indentifiants de connections ne sont pas correct.";
        break;
      case AuthResultStatus.userNotFound:
        errorMessage = "Les indentifiants de connections ne sont pas correct.";
        break;
      case AuthResultStatus.userDisabled:
        errorMessage = "L'utilisateur lié a cette adresse email a été désactivé";
        break;
      case AuthResultStatus.tooManyRequests:
        errorMessage = "Trop de requetes effectué. Réessayer plus tard.";
        break;
      case AuthResultStatus.operationNotAllowed:
        errorMessage = "Signing in with Email and Password is not enabled.";
        break;
      case AuthResultStatus.emailAlreadyExists:
        errorMessage = "Un compte est déjà lié a cette adresse email.";
        break;
      default:
        errorMessage = "Une erreur est survenue.";
    }

    return errorMessage;
  }
}