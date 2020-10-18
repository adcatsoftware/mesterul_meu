import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mesterulmeu/Login_SignUp/database.dart';

//Pachetele creat de mine:

import 'package:mesterulmeu/main.dart';
import 'package:mesterulmeu/Login_SignUp/authentificate.dart';
import 'package:mesterulmeu/Login_SignUp/constants.dart';

class signUpPage extends StatefulWidget {
  signUpPage({Key key, this.auth});
  final BaseAuth auth;
  @override
  _signUpPageState createState() => _signUpPageState();
}

class _signUpPageState extends State<signUpPage> {
  final AuthService _firebaseAuth = AuthService();

  final _formKey = GlobalKey<FormState>();
  final firebaseUser = FirebaseAuth.instance.currentUser();
  final firestoreInstance = Firestore.instance;
  String dropdownvalue = 'Judet';
  String error = '';
  bool loading = false;
  String nume;
  String prenume;
  final List<String> categorie = <String>[];
  final List<String> categoriiToate = <String>[
    'Auto',
    'Amenajări interioare',
    'Bucătărie',
    'Curățenie',
    'Construcții',
    'Electrocasnice',
    'Grădinărit',
    'Instalații electrice',
    'Instalații sanitare',
    'Instalații termice',
    'Mobilă'
  ];
  String judet;
  String localitate;
  String telefon;
  String email_input;
  String program;
  String descriere;
  final emailController = TextEditingController();
  String imageURL;

  // text field state
  String email;
  String password;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        iconTheme: IconThemeData(color: Colors.green),
        elevation: 0.1,
        backgroundColor: Colors.white,

        //Culoare bara de sus AppBar
        title: Center(
          child: GestureDetector(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => new HomePage()));
            },
            child: Image.asset(
              'images/logo_size.jpg',
              fit: BoxFit.cover,
            ),
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 30.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                SizedBox(height: 20.0),
                TextFormField(
                  focusNode: FocusNode(canRequestFocus: false),
                  decoration: textInputDecoration.copyWith(
                      hintText: 'Introduceți adresa de email'),
                  validator: (val) =>
                      val.isEmpty ? 'Introduceți adresa de email' : null,
                  onChanged: (val) {
                    setState(() => email = val);
                  },
                ),
                SizedBox(height: 20.0),
                TextFormField(
                  focusNode: FocusNode(canRequestFocus: false),
                  decoration: textInputDecoration.copyWith(
                      hintText: 'Introduceți parola '),
                  obscureText: true,
                  validator: (val) => val.length < 6
                      ? 'Parola trebuie să aibe mai mult de 6 caractere!'
                      : null,
                  onChanged: (val) {
                    setState(() => password = val);
                  },
                ),
                SizedBox(
                  height: 20.0,
                ),
                TextFormField(
                  focusNode: FocusNode(canRequestFocus: false),
                  decoration: textInputDecoration.copyWith(
                      hintText: 'Introduceți link către poza dvs.(Opțional!)'),
                  onChanged: (val) {
                    setState(() => imageURL = val);
                  },
                ),
                SizedBox(height: 20.0),
                TextFormField(
                  focusNode: FocusNode(canRequestFocus: false),
                  decoration: textInputDecoration.copyWith(
                      hintText: 'Programul dvs. Exemplu: L-V 8:00-16:00'),
                  onChanged: (val) {
                    this.program = val;
                    print(program);
                  },
                ),
                SizedBox(height: 20.0),
                TextFormField(
                  focusNode: FocusNode(canRequestFocus: false),
                  decoration: textInputDecoration.copyWith(
                      hintText: 'Numele dvs. Exemplu: "Popescu"'),
                  onChanged: (val) {
                    this.nume = val;
                    print(nume);
                  },
                  validator: (val) => val.isEmpty
                      ? 'Introduceți numele dvs. Câmp obligatoriu!'
                      : null,
                ),
                SizedBox(height: 20.0),
                TextFormField(
                  focusNode: FocusNode(canRequestFocus: false),
                  decoration: textInputDecoration.copyWith(
                      hintText: 'Prenumele dvs. Exemplu: "Ion"'),
                  onChanged: (val) {
                    this.prenume = val;
                    print(prenume);
                  },
                  validator: (val) => val.isEmpty
                      ? 'Introduceți prenumele dvs. Câmp obligatoriu!'
                      : null,
                ),
                SizedBox(height: 20.0),
                TextFormField(
                  focusNode: FocusNode(canRequestFocus: false),
                  keyboardType: TextInputType.number,
                  decoration: textInputDecoration.copyWith(
                      hintText: 'Numărul dvs. de telefon"'),
                  onChanged: (val) {
                    this.telefon = val;
                    print(telefon);
                  },
                  validator: (val) => val.isEmpty
                      ? 'Introduceți numărul dvs. de telefon! Câmp obligatoriu!'
                      : null,
                ),
                SizedBox(height: 20.0),
                TextFormField(
                  focusNode: FocusNode(canRequestFocus: false),
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  decoration: textInputDecoration.copyWith(
                      hintText: 'Descrierea dvs.',
                      contentPadding:
                          const EdgeInsets.symmetric(vertical: 20.0)),
                  onChanged: (val) {
                    this.descriere = val;
                    print(descriere);
                  },
                ),
                SizedBox(height: 20.0),
                DropdownButtonFormField<String>(
                  isExpanded: true,
                  value: categorie.isEmpty ? null : categorie.last,
                  hint: Text("Categorie Meșter: "),
                  onChanged: (newCategorie) {
                    setState(() {
                      if (categorie.contains(newCategorie))
                        categorie.remove(newCategorie);
                      else
                        categorie.add(newCategorie);
                    });

                    print(categorie);
                  },
                  validator: (value) => value == null
                      ? 'Selectați cel puțin o categorie ! Câmp obligatoriu!'
                      : null,
                  items: categoriiToate
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Icon(
                            Icons.check,
                            color: categorie.contains(value)
                                ? null
                                : Colors.transparent,
                          ),
                          SizedBox(width: 30),
                          Text(
                            '$value',
                            overflow: TextOverflow.ellipsis,
                            softWrap: true,
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
                Text(
                  'Categorii Selectate: ',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                  textScaleFactor: 1.2,
                ),
                Wrap(
                  direction: Axis.horizontal,
                  alignment: WrapAlignment.start,
                  children: categorie
                      .map((categorie) => Text(
                            categorie + "; ",
                            softWrap: false,
                            overflow: TextOverflow.fade,
                            textScaleFactor: 1.1,
                          ))
                      .toList(),
                ),
                DropdownButtonFormField<String>(
                  value: judet,
                  hint: Text("Județ "),
                  onChanged: (judet) {
                    setState(() {});
                    this.judet = judet;
                    print(judet);
                  },
                  validator: (value) => value == null
                      ? 'Selectați județul! Câmp obligatoriu!'
                      : null,
                  items: <String>[
                    'Alba',
                    'Arad',
                    'Argeș',
                    'Bacău',
                    'Bihor',
                    'Bistrița-Năsăud',
                    'Botoșani',
                    'Brașov',
                    'Brăila',
                    'București',
                    'Buzău',
                    'Caraș-Severin',
                    'Călărași',
                    'Cluj',
                    'Constanța',
                    'Covasna',
                    'Dâmbovița',
                    'Dolj',
                    'Galați',
                    'Giurgiu',
                    'Gorj',
                    'Harghita',
                    'Hunedoara',
                    'Ialomița',
                    'Iași',
                    'Ilfov',
                    'Maramureș',
                    'Mehedinți',
                    'Mureș',
                    'Neamț',
                    'Olt',
                    'Prahova',
                    'Satu Mare',
                    'Sălaj',
                    'Sibiu',
                    'Suceava',
                    'Teleorman',
                    'Timiș',
                    'Tulcea',
                    'Vaslui',
                    'Vâlcea',
                    'Vrancea',
                  ].map((String value) {
                    return new DropdownMenuItem<String>(
                      value: value,
                      child: new Text(value),
                    );
                  }).toList(),
                ),
                SizedBox(height: 5.0),
                RaisedButton(
                    color: Colors.green,
                    child: Text(
                      'Înregistrare',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    onPressed: () async {
                      if (_formKey.currentState.validate()) {
                        print(email);
                        setState(() => loading = true);

                        dynamic result =
                            await _firebaseAuth.createUserWithEmailAndPassword(
                                email,
                                password,
                                nume,
                                telefon,
                                prenume,
                                judet,
                                imageURL);

                        Firestore.instance
                            .collection('mesteri')
                            .document(email)
                            .setData({
                          'email': email,
                          'program': program,
                          'judet': judet,
                          'descriere': descriere,
                          'telefon': telefon,
                          'nume': nume,
                          'prenume': prenume,
                          'categorie': categorie,
                          'imageURL': imageURL,
                        });

                        if (result != null) {
                          setState(() {
                            loading = true;
                            error = 'Mulțumesc pentru înregistrare!';
                            Text(error);
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => new HomePage()));
                          });
                        } else {
                          setState(() {
                            loading = false;
                            error = 'Eroare înregistrare!';
                            Text(error);
                          });
                        }
                      }
                    }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

abstract class BaseAuth {
  Future<String> signIn(String email, String password);
  Future<String> signUp(String email, String password);
  Future<FirebaseUser> getCurrentUser();
  Future<void> signOut();
  Future<void> resetPassword(String email);
}

class Auth implements BaseAuth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  Future<String> signIn(String email, String password) async {
    FirebaseUser user = (await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password)) as FirebaseUser;
    if (user.isEmailVerified) {
      return user.uid;
    } else {
      Fluttertoast.showToast(
          msg:
              'Verificați-vă emailul pentru și accesați linkul pentru a valida contul');
    }
  }

  Future<String> signUp(String email, String password) async {
    FirebaseUser user = (await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password)) as FirebaseUser;
    await user.sendEmailVerification();
    return user.uid;
  }

  Future<FirebaseUser> getCurrentUser() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    return user;
  }

  Future<void> signOut() async {
    return _firebaseAuth.signOut();
  }

  Future<void> resetPassword(String email) async {
    return _firebaseAuth.sendPasswordResetEmail(email: email);
  }
}
