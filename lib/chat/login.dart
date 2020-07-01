import 'package:bdcoe/chat/authorize.dart';
import 'package:bdcoe/chat/chat.dart';
import 'package:bdcoe/chat/forgot.dart';
import 'package:bdcoe/chat/preference.dart';
import 'package:bdcoe/chat/register.dart';
import 'package:bdcoe/navigation/navigation.dart';
import 'package:bdcoe/notifiers/dark.dart';
import 'package:bdcoe/views/contact.dart';
import 'package:circular_reveal_animation/circular_reveal_animation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

GlobalKey<FormState> validatekey = GlobalKey<FormState>();
final _scaffoldKey = GlobalKey<ScaffoldState>();

class _LoginState extends State<Login> with TickerProviderStateMixin {
  AuthMethods authService = new AuthMethods();

  bool validateAndSave() {
    final FormState form = validatekey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  signMeIn(String email, String pass) async {
    if (validatekey.currentState.validate()) {
      setState(() {
        isLoading = true;
      });

      await authService
          .signInwithEmailAndPassword(email, pass)
          .then((value) async {
        if (value != null) {
          setState(() {
            isLoading = true;
          });

          HelperFunctions.saveUserLoggedInSharedPreference(true);

          HelperFunctions.saveUserEmailSharedPreference(email);
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => Chatting()),
              (Route<dynamic> route) => false);
          setState(() {
            isLoading = false;
          });
        } else{
            Alert(
            context: context,
            
            type: AlertType.error,
            title: "ERROR",
            style:AlertStyle(
              backgroundColor: Theme.of(context).cardColor,
      animationType: AnimationType.fromTop,
      isCloseButton: false,
      isOverlayTapDismiss: false,
      descStyle: TextStyle(fontSize: 18),
      animationDuration: Duration(milliseconds: 400),
      alertBorder: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(0.0),
        side: BorderSide(
         // color: Colors.grey,
        ),
      ),
      titleStyle: TextStyle(
        fontWeight: FontWeight.bold,
       color: Theme.of(context).textSelectionColor
      ),
    ),
            desc: "Check your details!",
            buttons: [
              DialogButton(
                color: Color(0xff3972CF),
                child: Text(
                  "OK",
                  style: TextStyle(fontSize: 20,color: Colors.white),
                ),
                onPressed: () => Navigator.of(context).pop()
              )
            ],
          ).show();
          print('error');
        setState(() {
          isLoading = false;
        });
        }
      });
    }
  }

  bool isLoading = false;
  String email;
  String password;
  bool passwordVisible = true;
  AnimationController animationController;

  Animation<double> animation;
  bool cirAn = false;
  @override
  void initState() {
    super.initState();

    animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );
    animation = CurvedAnimation(
      parent: animationController,
      curve: Curves.easeIn,
    );
    animationController.forward();
    setState(() {
      cirAn = true;
    });

    if (animationController.status == AnimationStatus.forward ||
        animationController.status == AnimationStatus.completed) {
      animationController.reset();
      animationController.forward();
    } else {
      animationController.forward();
    }
  }

  @override
  dispose() {
    animationController.dispose(); // you need this
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<DarkThemeProvider>(context);

    var size = MediaQuery.of(context).size;
    return cirAn
        ? CircularRevealAnimation(
            center: Offset(size.height / 15, size.width / 3.5),
            animation: animation,
            child: homeBody(
              themeProvider,
            ),
          )
        : homeBody(themeProvider);
  }

  Future<bool> MoveToLastScreen() {
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => BottomNavBar()),
        (Route<dynamic> route) => false);
  }

  Widget homeBody(DarkThemeProvider themeProvider) {
    return isLoading
        ? Container(
          color: themeProvider.darkTheme?Colors.black:Colors.white,
            child: Center(
              child: SpinKitChasingDots(
                      itemBuilder: (BuildContext context, int index) {
                        return DecoratedBox(
                          decoration: BoxDecoration(
                            color: themeProvider.darkTheme
                                ? Colors.white
                                : Colors.black,
                          ),
                        );
                      },
                    ),
            ),
          )
        : WillPopScope(
            onWillPop: MoveToLastScreen,
            child: Container(
              color: Theme.of(context).primaryColor,
              child: SafeArea(
                child: Scaffold(
                  resizeToAvoidBottomInset:false,
                  key: _scaffoldKey,
                  body: Stack(
                    children: <Widget>[
                      new Positioned(
                        left: MediaQuery.of(context).size.width / 1.15, //230.0,
                        bottom: MediaQuery.of(context).size.width / 1,

                        child: new Container(
                          height: MediaQuery.of(context).size.height / 8,
                          width: MediaQuery.of(context).size.height / 5,
                          decoration: new BoxDecoration(
                            shape: BoxShape.circle,
                            color: Theme.of(context).indicatorColor,
                          ),
                        ),
                      ),
                      new Positioned(
                        right: MediaQuery.of(context).size.width / 1.2, //230.0,
                        bottom: MediaQuery.of(context).size.width / 0.69, //40
                        child: new Container(
                          height: MediaQuery.of(context).size.height / 8,
                          width: MediaQuery.of(context).size.height / 5,
                          decoration: new BoxDecoration(
                            shape: BoxShape.circle,
                            color: Theme.of(context).hintColor,
                          ),
                        ),
                      ),
                      new Positioned(
                        left: MediaQuery.of(context).size.width / 1.1, //230.0,
                        top: MediaQuery.of(context).size.width / 0.8, //40.0,
                        child: new Container(
                          height: MediaQuery.of(context).size.height / 4,
                          width: MediaQuery.of(context).size.height / 4,
                          decoration: new BoxDecoration(
                            shape: BoxShape.circle,
                            color: Theme.of(context).highlightColor,
                          ),
                        ),
                      ),
                      new Positioned(
                        right:
                            MediaQuery.of(context).size.width / 1.05, //230.0,
                        bottom: MediaQuery.of(context).size.width / 1.3, //40.0,
                        child: new Container(
                          height: MediaQuery.of(context).size.height / 8,
                          width: MediaQuery.of(context).size.height / 8,
                          decoration: new BoxDecoration(
                            shape: BoxShape.circle,
                            color: Theme.of(context).focusColor,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: Container(
                              decoration: new BoxDecoration(
                                shape: BoxShape.circle,
                                color: Theme.of(context).backgroundColor,
                              ),
                            ),
                          ),
                        ),
                      ),
                      new Positioned(
                        left: MediaQuery.of(context).size.width / 1.1, //230.0,
                        bottom: MediaQuery.of(context).size.width / 0.7, //40.0,
                        child: new Container(
                          height: MediaQuery.of(context).size.height / 8,
                          width: MediaQuery.of(context).size.height / 8,
                          decoration: new BoxDecoration(
                            shape: BoxShape.circle,
                            color: Theme.of(context).hintColor,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: Container(
                              decoration: new BoxDecoration(
                                shape: BoxShape.circle,
                                color: Theme.of(context).backgroundColor,
                              ),
                            ),
                          ),
                        ),
                      ),
                      new Positioned(
                        right: MediaQuery.of(context).size.width / 1.2, //230.0,
                        top: MediaQuery.of(context).size.width / 2.5, //40.0,
                        child: new Container(
                          height: MediaQuery.of(context).size.height / 12,
                          width: MediaQuery.of(context).size.height / 12,
                          decoration: new BoxDecoration(
                            shape: BoxShape.circle,
                            color: Theme.of(context).indicatorColor,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: Container(
                              decoration: new BoxDecoration(
                                shape: BoxShape.circle,
                                color: Theme.of(context).backgroundColor,
                              ),
                            ),
                          ),
                        ),
                      ),
                      new Positioned(
                        right: MediaQuery.of(context).size.width / 1.2, //230.0,
                        top: MediaQuery.of(context).size.width / 0.69, //40
                        child: new Container(
                          height: MediaQuery.of(context).size.height / 8,
                          width: MediaQuery.of(context).size.height / 5,
                          decoration: new BoxDecoration(
                            shape: BoxShape.circle,
                            color: Theme.of(context).indicatorColor,
                          ),
                        ),
                      ),
                      new Column(
                        children: <Widget>[
                          Flexible(
                              flex: 12,
                              child: _description(
                                context,
                                themeProvider,
                              )),
                        ],
                      ),
                    ],
                  ),
                  backgroundColor: Theme.of(context).backgroundColor,
                ),
              ),
            ),
          );
  }

  Widget _description(context, DarkThemeProvider themeProvider) {
    _displaySnackBar(BuildContext context, String a) {
      final snackBar = SnackBar(
        content: Text(a,
            style: TextStyle(
                color: themeProvider.darkTheme ? Colors.black : Colors.white,
                fontWeight: FontWeight.bold),
            textAlign: TextAlign.center),
        backgroundColor: themeProvider.darkTheme ? Colors.white : Colors.black,
      );
      _scaffoldKey.currentState.showSnackBar(snackBar);
    }

    var size = MediaQuery.of(context).size;

    return Container(
      child: Padding(
        padding: const EdgeInsets.only(left: 15, right: 15),
        child: Container(
          height: size.height / 1,
          width: size.width / 1.1,
          child: Center(
              child: Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: Padding(
              padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
              child: Form(
                key: validatekey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      child: Container(
                        margin: EdgeInsets.all(8),
                        height: size.height / 8,
                        width: size.width / 2,
                        child: themeProvider.darkTheme
                            ? Align(
                                child: Text(
                                  'LOGIN',
                                  style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold),
                                ),
                                alignment: Alignment.center,
                              )
                            : Align(
                                child: Text(
                                  'LOGIN',
                                  style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold),
                                ),
                                alignment: Alignment.center,
                              ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: TextFormField(
                        style: TextStyle(
                            //  color: Colors.white,
                            ),
                        validator: (value) {
                          if (value == null) {
                            return "Enter Username";
                          } else
                            return null;
                        },
                        //
                        cursorColor: themeProvider.darkTheme
                            ? Colors.white
                            : Colors.black,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          // fillColor: Color(0xffefb168),
                          hintText: "Email",
                          alignLabelWithHint: true,
                          labelText: "Email",
                          hintStyle: TextStyle(
                              color: themeProvider.darkTheme
                                  ? Colors.white
                                  : Colors.black,
                              fontWeight: FontWeight.bold),
                          labelStyle: TextStyle(
                              color: themeProvider.darkTheme
                                  ? Color(0xff3972CF)
                                  : Color(0xff3972CF),
                              fontWeight: FontWeight.bold),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: themeProvider.darkTheme
                                    ? Colors.white
                                    : Colors.black,
                                style: BorderStyle.solid,
                                width: 2),
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: themeProvider.darkTheme
                                    ? Colors.white
                                    : Colors.black,
                                style: BorderStyle.solid,
                                width: 2),
                            borderRadius: BorderRadius.circular(25.0),
                          ),
                        ),
                        onSaved: (value) {
                          email = value;
                        },
                      ),
                    ),
                    SizedBox(height: 15.0),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: TextFormField(
                        style: TextStyle(
                            //color: Colors.white,
                            ),
                        validator: (value) {
                          if (value == null) {
                            return "Enter Password";
                          } else
                            return null;
                        },
                        keyboardType: TextInputType.text,
                        cursorColor: themeProvider.darkTheme
                            ? Colors.white
                            : Colors.black,
                        obscureText: passwordVisible,
                        decoration: InputDecoration(
                          // fillColor: Color(0xffefb168),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: themeProvider.darkTheme
                                    ? Colors.white
                                    : Colors.black,
                                style: BorderStyle.solid,
                                width: 2),
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          hintText: "Password",
                          alignLabelWithHint: true,
                          labelText: "Password",
                          hintStyle: TextStyle(
                              color: themeProvider.darkTheme
                                  ? Colors.white
                                  : Colors.black,
                              fontWeight: FontWeight.bold),
                          labelStyle: TextStyle(
                              color: themeProvider.darkTheme
                                  ? Color(0xff3972CF)
                                  : Color(0xff3972CF),
                              fontWeight: FontWeight.bold),
                          //     hintStyle: GoogleFonts.aBeeZee(color:Colors.grey),
                          suffixIcon: IconButton(
                            icon: Icon(
                              // Based on passwordVisible state choose the icon

                              passwordVisible
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: themeProvider.darkTheme
                                  ? Colors.white
                                  : Colors.black,
                            ),
                            onPressed: () {
                              // Update the state i.e. toogle the state of passwordVisible variable
                              setState(() {
                                passwordVisible = !passwordVisible;
                              });
                            },
                          ),
                          //labelStyle: TextStyle(color:Colors.white),

                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: themeProvider.darkTheme
                                    ? Colors.white
                                    : Colors.black,
                                style: BorderStyle.solid,
                                width: 2),
                            borderRadius: BorderRadius.circular(25.0),
                          ),
                        ),
                        onSaved: (value) {
                          password = value;
                        },
                      ),
                    ),
                    GestureDetector(
                        onTap: () {
                          Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(builder: (context) => Forgot()),
                              (Route<dynamic> route) => false);
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Align(
                            alignment: Alignment.bottomRight,
                            child: Text('Forgot Password?',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                          ),
                        )),
                    SizedBox(
                      height: 10,
                    ),
                    GestureDetector(
                      onTap: () {
                        print(email);
                        validatekey.currentState.save();
                        if (email?.isEmpty ?? true) {
                          _displaySnackBar(context, "Please enter your Email");
                        } else if (!RegExp(
                                r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                            .hasMatch(email))
                          _displaySnackBar(context, "Please Fill valid Email");
                        else if (password?.isEmpty ?? true)
                          _displaySnackBar(
                              context, "Please enter your Password");
                        else {
                          signMeIn(email, password);
                        }
                      },
                      child: Card(
                          color: themeProvider.darkTheme
                              ? Colors.blue[900]
                              : Colors.blue[900],
                          clipBehavior: Clip.antiAlias,
                          child: Container(
                              width: MediaQuery.of(context).size.width / 1.5,
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Icon(
                                      Icons.person,
                                      color: Colors.white,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        "Login",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ],
                                ),
                              ))),
                    ),
                    /*RaisedButton(
                                                onPressed: () {
                                                  loginFunction();
                                                },
                                                child: Text("Login"),
                                              )*/

                    SizedBox(height: 5),

//  Navigator.of(context).pushAndRemoveUntil(
//         MaterialPageRoute(builder: (context) => Forgot()),
//         (Route<dynamic> route) => false);
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(top: 8, bottom: 8),
                          child: Align(
                            alignment: Alignment.bottomRight,
                            child: Text('Don\'t have an account?',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(
                                    builder: (context) => Register()),
                                (Route<dynamic> route) => false);
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(top: 8, bottom: 8),
                            child: Align(
                              alignment: Alignment.bottomRight,
                              child: Text(' Click Here',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xff3972CF))),
                            ),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
          )),
        ),
      ),
    );
  }
}
