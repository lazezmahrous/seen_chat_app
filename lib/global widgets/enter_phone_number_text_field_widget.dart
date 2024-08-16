import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:seen/constanc.dart';

class EnterPhoneNumberTextFieldWidget extends StatefulWidget {
  const EnterPhoneNumberTextFieldWidget({
    super.key,
    required this.controller,
  });

  final TextEditingController? controller;

  @override
  State<EnterPhoneNumberTextFieldWidget> createState() =>
      _EnterPhoneNumberTextFieldWidgetState();
}

class _EnterPhoneNumberTextFieldWidgetState
    extends State<EnterPhoneNumberTextFieldWidget> {
  String countryCode = '';

  bool _isEmoji(String text) {
    return RegExp(
            r'(\u00a9|\u00ae|[\u2000-\u3300]|\ud83c[\ud000-\udfff]|\ud83d[\ud000-\udfff]|\ud83e[\ud000-\udfff])')
        .hasMatch(text);
  }

  bool _isNumberWithoutLetters(String text) {
    return RegExp(r'[a-zA-Z\u0600-\u06FF]').hasMatch(text);
  }

  String punctuation = r"[!\" "#\$%&'()*+,-.:;<=>?@[\\]^_`{|}~]";
  bool _containsPunctuation(String text) {
    return RegExp(punctuation).hasMatch(text);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: TextFormField(
                validator: (data) {
                  if (data!.isEmpty) {
                    return 'يرجي إدخال رقم الهاتف';
                  } else if (data.length < 10) {
                    return 'رقم الهاتف قصير';
                  } else if (_isEmoji(data) ||
                      _containsPunctuation(data) ||
                      _isNumberWithoutLetters(data)) {
                    return 'رقم الهاتف يجب ان يحتوي علي أرقام فقط';
                  } else {}
                  return null;
                },
                maxLength: 11,
                controller: widget.controller,
                // textDirection: TextDirection.ltr,
                style: const TextStyle(
                  color: Colors.black,
                ),
                // textAlign: TextAlign.end,
                keyboardType: TextInputType.phone,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: 'رقم الهاتف',
                  prefixIcon: CountryCodePicker(
                    onInit: (code) {
                      countryCode = code!.dialCode!;
                    },
                    onChanged: (code) {
                      countryCode = code.dialCode!;
                    },
                    initialSelection: 'EG',
                    favorite: const ['+20', 'EG'],
                    showCountryOnly: false,
                    showOnlyCountryWhenClosed: false,
                    alignLeft: false,
                    boxDecoration: BoxDecoration(
                      color: Constanc.kColorWhite,
                      borderRadius: const BorderRadius.all(
                        Radius.circular(20),
                      ),
                    ),
                    padding: const EdgeInsets.all(10),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
