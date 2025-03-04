import 'package:flutter/material.dart';

final ThemeData theme = ThemeData(
  // Uygulama Başlık Teması
  appBarTheme: const AppBarTheme(
    color: Color(0xFF272727),
    titleTextStyle: TextStyle(
      color: Color(0xFFD4AF37),
      fontWeight: FontWeight.bold,
      fontSize: 22,
      fontFamily: 'Montserrat',
    ),
    iconTheme: IconThemeData(
      color: Color(0xFFD4AF37), // Geri butonunun ve tüm ikonların rengi
    ),
    actionsIconTheme: IconThemeData(
      color: Color(0xFFD4AF37), // End drawer butonunun (sağdaki menü) rengi
    ),
  ),

  cardTheme: CardTheme(
    color: Color(0xFF3A3A3A),
    elevation: 5,
    margin: EdgeInsets.all(10)
  ),
  scaffoldBackgroundColor: Color(0xFF434343), // Koyu Gri/Antrasit


  textTheme: const TextTheme(
    bodyLarge: TextStyle(color: Color(0xFFF5F5F5), fontFamily: 'Roboto', fontSize: 16),
    bodyMedium: TextStyle(color: Color(0xFFF5F5F5), fontFamily: 'Roboto', fontSize: 14),
    bodySmall: TextStyle(color: Color(0xFFF5F5F5), fontFamily: 'Roboto', fontSize: 12),
    labelLarge: TextStyle(color: Color(0xFFF5F5F5)),
    labelMedium: TextStyle(color: Color(0xFFF5F5F5)),
    labelSmall: TextStyle(color: Color(0xFFF5F5F5)),
    titleLarge: TextStyle(color: Color(0xFFF5F5F5)),
    titleMedium: TextStyle(color: Color(0xFFF5F5F5)),
    titleSmall: TextStyle(color: Color(0xFFF5F5F5)),
    headlineLarge: TextStyle(color: Color(0xFFF5F5F5)),
    headlineMedium: TextStyle(color: Color(0xFFF5F5F5)),
    headlineSmall: TextStyle(color: Color(0xFFF5F5F5)),
    displayLarge: TextStyle(color: Color(0xFFF5F5F5)),
    displayMedium: TextStyle(color: Color(0xFFF5F5F5)),
    displaySmall: TextStyle(color: Color(0xFFF5F5F5)),
  ),


  inputDecorationTheme: const InputDecorationTheme(
    labelStyle: TextStyle(
      color: Color(0xFFD4AF37),
      fontFamily: 'Roboto',
      fontWeight: FontWeight.w500,
    ),
    focusColor: Color(0xFFD4AF37),
    fillColor: Color(0xFFD4AF37),
    hoverColor: Color(0xFFD4AF37),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Color(0xFFD4AF37), width: 1.5),
      borderRadius: BorderRadius.all(Radius.circular(8)),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Color(0xFFD4AF37), width: 2),
      borderRadius: BorderRadius.all(Radius.circular(8)),
    ),
    iconColor: Colors.white
  ),


  iconTheme: const IconThemeData(
    color: Color(0xFFD4AF37), // Altın Sarısı
    size: 30, // İkon boyutunu değiştirebilirsiniz
  ),

  buttonTheme: ButtonThemeData(
    buttonColor: Color(0xFF50C878),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
    padding: EdgeInsets.symmetric(vertical: 14, horizontal: 20),
  ),
  
  outlinedButtonTheme: OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      side: BorderSide(
        color: Color(0xFFD4AF37)
      ),
      textStyle: TextStyle(color: Color(0xFFD4AF37))
    )
  ),

  tabBarTheme: TabBarTheme(
    labelColor: Color(0xFFD4AF37),
    unselectedLabelColor: Color(0xFF9B5DE5),
    indicatorColor: Color(0xFFD4AF37),
  ),
);
