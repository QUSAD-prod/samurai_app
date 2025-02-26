import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

class SamuraiTextField extends StatelessWidget {
  const SamuraiTextField({
    super.key,
    required this.screeenHeight,
    required this.screeenWidth,
    this.hint,
    this.buttonWithTimerEnabled = false,
    this.timerValue,
    this.onTapTimerButton,
    this.controller,
    this.initialValue,
    this.focusNode,
    this.keyboardType,
    this.textCapitalization = TextCapitalization.none,
    this.textInputAction,
    this.autofocus = false,
    this.readOnly = false,
    this.obscureText = false,
    this.autocorrect = true,
    this.maxLengthEnforcement,
    this.maxLines = 1,
    this.minLines,
    this.expands = false,
    this.maxLength,
    this.onChanged,
    this.onTap,
    this.onTapOutside,
    this.onEditingComplete,
    this.onFieldSubmitted,
    this.inputFormatters,
    this.enabled,
    this.keyboardAppearance,
    this.enableInteractiveSelection,
    this.selectionControls,
    this.autofillHints,
    this.scrollController,
  });

  final double screeenHeight;
  final double screeenWidth;
  final String? hint;
  final bool buttonWithTimerEnabled;
  final int? timerValue;
  final VoidCallback? onTapTimerButton;

  final TextEditingController? controller;
  final String? initialValue;
  final FocusNode? focusNode;
  final TextInputType? keyboardType;
  final TextCapitalization textCapitalization;
  final TextInputAction? textInputAction;
  final bool autofocus;
  final bool readOnly;
  final bool obscureText;
  final bool autocorrect;
  final MaxLengthEnforcement? maxLengthEnforcement;
  final int? maxLines;
  final int? minLines;
  final bool expands;
  final int? maxLength;
  final ValueChanged<String>? onChanged;
  final GestureTapCallback? onTap;
  final TapRegionCallback? onTapOutside;
  final VoidCallback? onEditingComplete;
  final ValueChanged<String>? onFieldSubmitted;
  final List<TextInputFormatter>? inputFormatters;
  final bool? enabled;
  final Brightness? keyboardAppearance;
  final bool? enableInteractiveSelection;
  final TextSelectionControls? selectionControls;
  final Iterable<String>? autofillHints;
  final ScrollController? scrollController;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SvgPicture.asset(
          'assets/text_field_border.svg',
          width: screeenWidth - screeenWidth * 0.14,
          height: (screeenWidth - screeenWidth * 0.14) * 0.21,
        ),
        SizedBox(
          width: screeenWidth - screeenWidth * 0.14,
          height: (screeenWidth - screeenWidth * 0.14) * 0.21,
          child: Row(
            children: [
              const Spacer(
                flex: 30,
              ),
              Expanded(
                flex: buttonWithTimerEnabled ? 225 : 292,
                child: TextFormField(
                  controller: controller,
                  initialValue: initialValue,
                  focusNode: focusNode,
                  autofocus: autofocus,
                  autocorrect: autocorrect,
                  autofillHints: autofillHints,
                  enabled: enabled,
                  expands: expands,
                  enableInteractiveSelection: enableInteractiveSelection,
                  readOnly: readOnly,
                  inputFormatters: inputFormatters,
                  obscureText: obscureText,
                  onChanged: onChanged,
                  onEditingComplete: onEditingComplete,
                  onFieldSubmitted: onFieldSubmitted,
                  onTap: onTap,
                  onTapOutside: onTapOutside,
                  scrollController: scrollController,
                  selectionControls: selectionControls,
                  keyboardAppearance: keyboardAppearance,
                  keyboardType: keyboardType,
                  maxLength: maxLength,
                  maxLines: maxLines,
                  maxLengthEnforcement: maxLengthEnforcement,
                  minLines: minLines,
                  decoration: InputDecoration.collapsed(
                    hintText: hint,
                    hintStyle: GoogleFonts.spaceMono(
                      fontSize: screeenHeight * 0.02,
                      fontWeight: FontWeight.w400,
                      height: 1.5,
                      color: Colors.white.withOpacity(0.5),
                    ),
                  ),
                  style: GoogleFonts.spaceMono(
                    fontSize: screeenHeight * 0.02,
                    fontWeight: FontWeight.w400,
                    height: 1.5,
                    color: Colors.white,
                  ),
                  cursorColor: const Color(0xFF00FFFF),
                  cursorRadius: const Radius.circular(5),
                ),
              ),
              const Spacer(
                flex: 12,
              ),
              buttonWithTimerEnabled
                  ? Expanded(
                      flex: 67,
                      child: Column(
                        children: [
                          Spacer(
                            flex: timerValue == null ? 1 : 2,
                          ),
                          timerValue == null
                              ? InkWell(
                                  onTap: onTapTimerButton,
                                  child: SvgPicture.asset(
                                    'assets/text_field_send_button.svg',
                                    width: (screeenWidth - screeenWidth * 0.14) * 0.2,
                                  ),
                                )
                              : Text(
                                  timerValue!.toString(),
                                  style: TextStyle(
                                    fontFamily: 'AmazObitaemOstrovItalic',
                                    fontSize: screeenHeight * 0.03,
                                    height: 1.5,
                                    color: Colors.white,
                                  ),
                                ),
                          Spacer(
                            flex: timerValue == null ? 2 : 3,
                          ),
                        ],
                      ),
                    )
                  : Container(),
              const Spacer(
                flex: 4,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
