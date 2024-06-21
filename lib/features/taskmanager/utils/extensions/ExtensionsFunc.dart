
import 'package:flutter/material.dart';

extension ContextExtensions on BuildContext{
  getTheme()=> Theme.of(this);
  TextTheme getTextTheme()=> Theme.of(this).textTheme;

  getKeyboardInsets()=>MediaQuery.of(this).viewInsets.bottom;

}