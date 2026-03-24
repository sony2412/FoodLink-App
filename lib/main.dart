import 'package:flutter/material.dart';
import 'app.dart';

void main() {
  runApp(const FoodLink());
}

// class FoodlinkHome extends StatelessWidget {
//   const FoodlinkHome({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       themeMode: ThemeMode.system, //default theme
//       home: Splash(),
//       theme: AppTheme.lightTheme, //light theme
//       darkTheme: AppTheme.darkTheme,  //dark theme
//     );
//   }
// }
//
// class LoginScreen extends StatelessWidget {
//     const LoginScreen({super.key});
//
//     @override
//     Widget build(BuildContext context) {
//       return Scaffold(
//     backgroundColor: Colors.white,
//     body:Container(
//     child: Column(
//     children: <Widget> [
//     Container(
//     height: 400,
//     decoration: BoxDecoration(
//     image: DecorationImage(
//     image: AssetImage("assets/images/background.jpg"),
//     fit: BoxFit.fitWidth,
//     )
//     ),
//     child: Stack(
//     children: <Widget>[
//     Positioned(
//     child: Container(
//     margin: EdgeInsets.only(top: 300),
//     child: Center(
//     child : Text(
//     "Login", style: TextStyle(color: Colors.deepOrangeAccent, fontSize: 40, fontWeight: .bold),
//                       )
//                     )
//                     )
//             )
//               ],
//             )
//           ),
//           Padding(
//               padding: EdgeInsets.all(30),
//               child: Column(
//                 children: <Widget>[
//                   Container(
//                     padding: EdgeInsets.all(5),
//                     decoration: BoxDecoration(
//                       color: Colors.white,
//                       borderRadius: BorderRadius.circular(10),
//                       boxShadow: [
//                         BoxShadow(
//                           color: Colors.grey,
//                           blurRadius: 20,
//                           offset: Offset(0,10)
//                         )
//                       ]
//                     ),
//                     child: Column(
//                       children: <Widget> [
//                         Container(
//                           padding: EdgeInsets.all(8),
//                           decoration: BoxDecoration(
//                           border: Border(bottom: BorderSide(color: Colors.grey)),
//                           ),
//                           child: TextField(
//                             style: TextStyle(
//                               color: Colors.black,
//                             ),
//                             decoration: InputDecoration(
//                               border: InputBorder.none,
//                               hintText: "Email or Phone number",
//                               hintStyle: TextStyle(color: Colors.black54, fontStyle: .italic),
//                             ),
//                           )
//                         ),
//                         SizedBox(height: 15),
//                         Container(
//                             padding: EdgeInsets.all(8),
//                             child: TextField(
//                               obscureText: true,
//                               decoration: InputDecoration(
//                                 suffixIcon: Icon(Icons.lock,),
//                                 border: InputBorder.none,
//                                 hintText: "Password",
//                                 hintStyle: TextStyle(color: Colors.black54, fontStyle: .italic),
//                               ),
//                             )
//                         ),
//                       ],
//                     )
//                   ),
//                   SizedBox(height: 10,),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.end,
//                     children:[
//                       TextButton(
//                         onPressed: () {},
//                         child: Text("Forgot Password?", style: TextStyle(color: Color.fromRGBO(255, 130, 130, 1)),textAlign: TextAlign.left, ),
//                       ),
//                   ]
//                   ),
//                   SizedBox(height: 20,),
//                   Container(
//                     height: 50,
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(10),
//                       gradient: LinearGradient(
//                           colors: [
//                             Color.fromRGBO(255, 82, 82, 1),
//                             Color.fromRGBO(255, 82, 82, .8)
//                           ]
//                       ),
//                     ),
//                     child: Center(
//                       child: Text("Login", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),)
//                     ),
//                   ),
//                   SizedBox(height: 40,),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                       children:[
//                         Text("Don't have an account?", style: TextStyle(color: Colors.black, ),),
//                         TextButton(
//                           onPressed: () {},
//                           child: Text("Register", style: TextStyle(color: Color.fromRGBO(255, 130, 130, 1)),),
//                         ),
//                       ]
//                   )
//                 ],
//               )
//           )
//         ]
//       )
//       )
//     );
//   }
// }
//
// class LoginScreen extends StatelessWidget {
//   const LoginScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SingleChildScrollView(
//         child: Padding(
//             padding: EdgeInsets.all(
//               top: TSizes.
//             )),
//       )
//     );
//   }
// }
//
