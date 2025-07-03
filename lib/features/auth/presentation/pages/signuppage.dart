import 'package:flutter/material.dart';

class Signuppage extends StatefulWidget {
  const Signuppage({super.key});

  @override
  State<Signuppage> createState() => _SignuppageState();}

  class _SignuppageState extends State<Signuppage> {

    bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      appBar: AppBar(backgroundColor: const Color.fromARGB(255, 255, 255, 255)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            const SizedBox(height: 50),
            Text(
              'Sign Up',
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 50),
            const SizedBox(
              width: 300,
              child: TextField(
                decoration: InputDecoration(
                  labelText: '     username',
                  border: null,
                ),
              ),
            ),
            const SizedBox(height: 30),
            const SizedBox(
              width: 300,
              child: TextField(
                decoration: InputDecoration(
                  labelText: '     380 00 00 00 000',
                  border: null,
                ),
              ),
            ),
            const SizedBox(height: 30),
            const SizedBox(
              width: 300,
              child: TextField(
                decoration: InputDecoration(
                  labelText: '     email',
                  border: null,
                ),
              ),
            ),
            const SizedBox(height: 30),
            const SizedBox(
              width: 300,
              child: TextField(
                obscureText: true,
                decoration: InputDecoration(
                  labelText: '     password',
                  border: null,
                ),
              ),
            ),
            const SizedBox(height: 30),
            Container(alignment: Alignment.topCenter,
            child:Row(mainAxisSize: MainAxisSize.min,
              children: [Checkbox(value: isChecked,
          onChanged: (value) {
            setState(() {
              isChecked = value!;});} ),
              const Text('I agree to the terms and conditions', style: TextStyle(fontSize: 16))],
            )),
            Container(
              width: 150,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    const Color.fromARGB(255, 48, 48, 255),
                    const Color.fromARGB(255, 70, 172, 255),
                  ],
                ),
                borderRadius: BorderRadius.circular(30),
              ),
              child: InkWell(
                borderRadius: BorderRadius.circular(30),
                onTap: () {},
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                  child: Center(
                    child: Text(
                      'Sign Up',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          const SizedBox(height: 20),
          const Text(
            'Already have an account? Login',
            style: TextStyle(color: Colors.blue, fontSize: 16),
          ),  
          ],
        ),
      ),
    );
  }
}
