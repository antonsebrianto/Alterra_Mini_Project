import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _secureText = true;

  showHide() {
    setState(() {
      _secureText = !_secureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: ListView(
          children: <Widget>[
            Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.all(10),
              margin: const EdgeInsets.only(top: 40),
              child: Image.asset(
                "assets/images/logo_blogapp.png",
                height: 170,
                width: 170,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Column(
              children: [
                Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 22, vertical: 14),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      // border: Border.all(color: Colors.black),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.25),
                          blurRadius: 4,
                          offset: const Offset(0, 4), // Shadow position
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        const SizedBox(
                          width: 20,
                          height: 20,
                          child: Icon(Icons.account_circle_outlined,
                              color: Colors.black),
                        ),
                        const SizedBox(
                          width: 15,
                        ),
                        Expanded(
                          child: TextFormField(
                            autofocus: false,
                            controller: _emailController,
                            style: const TextStyle(color: Colors.black),
                            decoration: const InputDecoration.collapsed(
                                hintStyle: TextStyle(
                                  color: Colors.black,
                                ),

                                // border: OutlineInputBorder(
                                //     borderRadius: BorderRadius.circular(20)),
                                hintText: "Email"),
                            // validator: (emailValue) {
                            //   if (emailValue == null) {
                            //     return 'Please enter your username';
                            //   }
                            //   email = emailValue;
                            //   return null;
                            // }
                          ),
                        ),
                      ],
                    )
                    // ),
                    ),
                const SizedBox(
                  height: 22,
                ),
                Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 22, vertical: 0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      // border: Border.all(color: Colors.black),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.25),
                          blurRadius: 4,
                          offset: const Offset(0, 4), // Shadow position
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.key,
                          color: Colors.black,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: TextFormField(
                            controller: _passwordController,
                            style: const TextStyle(color: Colors.black),
                            // keyboardType: TextInputType.text,
                            obscureText: _secureText,
                            decoration: const InputDecoration.collapsed(
                                hintStyle: TextStyle(
                                  color: Colors.black,
                                ),
                                // prefixIcon: Icon(Icons.key),
                                //
                                // suffixIcon:
                                // border: OutlineInputBorder(
                                //     borderRadius: BorderRadius.circular(20)),
                                hintText: "Password"),
                            // validator: (passwordValue) {
                            //   if (passwordValue == null) {
                            //     return 'Please enter your password';
                            //   }
                            //   password = passwordValue;
                            //   return null;
                            // }
                          ),
                        ),
                        IconButton(
                          hoverColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          iconSize: 20,
                          onPressed: showHide,
                          icon: Icon(
                            _secureText
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    )
                    // ),
                    ),
                const SizedBox(height: 10),
                ElevatedButton(
                  child: const Text(
                    "SIGN IN",
                    style: TextStyle(fontSize: 16),
                  ),
                  onPressed: () {
                    // UserProvider userProvider = Provider.of(context)
                    //     .login('athal@gmail.com', '12345678');
                    // print("object");
                    // if (userProvider == true) {
                    //   Navigator.pushNamed(context, '/home');
                    // } else {
                    //   print("ktnl");
                    // }
                    // ApiLogin(_loginAuth));
                    // _loginAuth;
                    // child:
                    // auth.loggedInStatus == Status.Authenticating
                    //     ? loading
                    //     : AuthProvider().login("athal@gmail.com", "12345678");
                    // Navigator.pushNamed(context, '/home');
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
