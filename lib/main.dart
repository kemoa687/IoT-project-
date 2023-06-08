import 'package:flutter/material.dart';   // to import the syntax of dart language
import 'package:firebase_core/firebase_core.dart'; // to import package of firebase
import 'package:cap_6/show_data.dart'; // navigate to another screen
import 'package:animated_text_kit/animated_text_kit.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
} // initialize everything in the application

class MyApp extends StatelessWidget {
  final Future<FirebaseApp> _fbApp = Firebase.initializeApp();  //import the data from the firebase to the app

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Soil Soldiers',
        home: FutureBuilder(
          future: _fbApp,
          builder: (context, snapshot){
            if (snapshot.hasError){
              print ('You have an error! ${snapshot.error.toString()}');
              return const Text('Something went wrong');
            }else if (snapshot.hasData){
              return const MyHomePage(title: 'Soil Solider');
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        )
      //const
    );
  }
}
class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
            child: Padding(
                padding: const EdgeInsets.all(30),
                child: Column(
                  children: [
                    Image.asset('assets/intro.jpg'),
                    SizedBox(height: 20,),
                    Container(
                        padding: EdgeInsets.all (20),
                        height: 350,
                        width: double.infinity,
                        decoration: BoxDecoration(
                            color: Colors.greenAccent[100],
                            borderRadius: BorderRadius.circular(20)),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: 100,
                              child: DefaultTextStyle(
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                    fontSize: 25, color: Color(0xFF202A44)),
                                child: AnimatedTextKit(
                                  animatedTexts: [
                                    FadeAnimatedText(
                                        'Welcome to Monitoring Climate Change',
                                        textAlign: TextAlign.center),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 50,
                            ),
                            OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                  backgroundColor: const Color(0xFF202A44),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10))),
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                        const showReads()));
                              },
                              child: const Text(
                                'Get Started',
                                style: TextStyle(
                                    fontSize: 40, color: Colors.white),
                              ),
                            ),
                          ],
                        ))
                  ],
                ))));
  }
}
