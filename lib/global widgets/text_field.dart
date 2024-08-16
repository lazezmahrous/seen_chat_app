// ignore_for_file: public_member_api_docs, sort_constructors_first, file_names, must_be_immutable
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:seen/constanc.dart';

class TextFieldWidget extends StatefulWidget {
  TextFieldWidget({
    super.key,
    required this.lableName,
    required this.iconName,
    required this.password,
    required this.textinput,
    required this.controller,
    required this.maxLength,
    this.onChanged,
    this.validator,
    this.autofocus = false,
    this.onTap,
    required this.ispassword,
    this.isCountryCode = false,
  });
  final String lableName;
  final String iconName;
  final bool password;
  final bool ispassword;
  bool? isCountryCode;
  bool? autofocus;
  final int maxLength;
  final TextInputType textinput;
  Function(String)? onChanged;
  String? Function(String?)? validator;
  String? Function(String?)? onTap;
  // VoidCallback? onTap;
  final TextEditingController? controller;
  @override
  State<TextFieldWidget> createState() => _TextFieldWidgetState();
}

class _TextFieldWidgetState extends State<TextFieldWidget> {
  bool passwordVisible = true;

  Future<String?>? validate() async {
    if (widget.validator != null) {
      return widget.validator!(widget.controller?.text);
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: TextFormField(
                validator: widget.validator,
                maxLength: widget.maxLength,
                controller: widget.controller,
                onChanged: widget.onChanged,
                onSaved: widget.onTap,
                obscureText: widget.ispassword ? passwordVisible : false,
                textDirection: TextDirection.ltr,
                style: const TextStyle(
                  color: Colors.black,
                ),
                textAlign: TextAlign.end,
                keyboardType: widget.textinput,
                autofocus: widget.autofocus!,
                decoration: InputDecoration(
                    hintText: widget.lableName,
                    hintTextDirection: TextDirection.ltr,
                    prefixIcon: widget.isCountryCode!
                        ? CountryCodePicker(
                            onInit: (code) {
                            },
                            onChanged: (code) {
                            },
                            initialSelection: 'EG',
                            favorite: const ['+20', 'EG'],
                            showCountryOnly: false,
                            showOnlyCountryWhenClosed: false,
                            alignLeft: false,
                            backgroundColor: Colors.amber,
                            boxDecoration: BoxDecoration(
                              color: Constanc.kColorWhite,
                              borderRadius: const BorderRadius.all(
                                Radius.circular(20),
                              ),
                            ),
                            padding: const EdgeInsets.all(10),
                          )
                        : null,
                    suffixIcon: widget.ispassword
                        ? IconButton(
                            onPressed: () {
                              setState(() {
                                passwordVisible = !passwordVisible;
                              });
                            },
                            icon: Icon(
                              passwordVisible
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                            ),
                          )
                        : const SizedBox(
                            width: 0,
                            height: 0,
                          )),
              ),
            ),
          ),
          widget.iconName.isNotEmpty
              ? SvgPicture.asset(
                  'assets/images/${widget.iconName}',
                  width: 25,
                )
              : const SizedBox(),
        ],
      ),
    );
  }
}
