import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';

final userNameValidator = MultiValidator([
  RequiredValidator(errorText: "Username is Required"),
  MinLengthValidator(5,
      errorText: "Username must be at least 5 characters long")
]);
final passwordValidators = MultiValidator([
  RequiredValidator(errorText: "Password is required"),
  MinLengthValidator(6,
      errorText: "Password must be at least 6 characters long")
]);

final phoneNumberValidator = MultiValidator([
  RequiredValidator(errorText: "Phone Number is Required"),
  MinLengthValidator(10, errorText: "Enter the 10 digit number only"),
]);
