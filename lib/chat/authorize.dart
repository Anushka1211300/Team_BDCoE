
import 'package:bdcoe/modals/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
 
class AuthMethods{
final FirebaseAuth _auth= FirebaseAuth.instance;
User _userFromFirebaseUser(FirebaseUser user){
return user != null ? User(userId: user.uid): null;
}

Future signInwithEmailAndPassword(String email, String pass) async{

    AuthResult result= await _auth.signInWithEmailAndPassword(email: email, password: pass);
    FirebaseUser firebaseUser= result.user;
    return _userFromFirebaseUser(firebaseUser);

 

}
Future signUpwithEmailAndPassword(String email, String pass)async{

       AuthResult result= await _auth.createUserWithEmailAndPassword(email: email, password: pass);
       FirebaseUser firebaseUser = result.user;
       return _userFromFirebaseUser(firebaseUser);
       

}
Future resetPass(String email) async{
 

  return await _auth.sendPasswordResetEmail(email: email);



}
Future signOut()async{
  try{
     return await _auth.signOut();
  }catch(e){
       print(e.toString());
  }
}
}