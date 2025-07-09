import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class LocaleEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class ToggleLocale extends LocaleEvent {}

class SetLocale extends LocaleEvent {
  final Locale locale;

  SetLocale(this.locale);

  @override
  List<Object?> get props => [locale];
}
