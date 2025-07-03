import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Loginpage extends StatelessWidget {
  const Loginpage({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      appBar: AppBar(backgroundColor: const Color.fromARGB(255, 255, 255, 255)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            const SizedBox(height: 100),
            Text(
              'Login',
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 70),
            const SizedBox(
              width: 300,
              child: TextField(
                decoration: InputDecoration(
                  labelText: '     Email',
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
                  labelText: '     Password',
                  border: null,
                ),
              ),
            ),
            const SizedBox(height: 70),
            Container(
              width: 150,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [const Color.fromARGB(255, 48, 48, 255), const Color.fromARGB(255, 70, 172, 255)],
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
                      'LOG IN',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
