import 'package:flutter/material.dart';

InputDecoration cityInputDecoration() => InputDecoration(
    filled: true,
    fillColor: Colors.white,
    icon: const Icon(
      Icons.location_city,
    ),
    focusedBorder: textFieldInputBorder(),
    border: textFieldInputBorder());

InputBorder textFieldInputBorder() => OutlineInputBorder(
      borderRadius: BorderRadius.circular(20),
      borderSide: const BorderSide(color: Colors.white),
    );
