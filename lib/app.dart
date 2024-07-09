import 'package:flutter/material.dart';
import 'package:rest_api_flutter/profuct_list_screen.dart';

class CRUDApp extends StatelessWidget {
   const CRUDApp({super.key});

   @override
   Widget build(BuildContext context) {
     return MaterialApp(
       home: const ProductListScreen(),
       theme: ThemeData(
         inputDecorationTheme: const InputDecorationTheme(
           enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.black)),
           border: OutlineInputBorder(borderSide: BorderSide(color: Colors.black)),
           disabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
           focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.black)),
           errorBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.red)),
         ),
       ),
     );
   }
 }
