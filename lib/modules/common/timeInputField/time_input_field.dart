import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../i18n/strings.g.dart';

class TimeInputField extends StatefulWidget {
  final TextEditingController controller;

  const TimeInputField({
    super.key,
    required this.controller,
  });

  @override
  TimeInputFieldState createState() => TimeInputFieldState();
}

class TimeInputFieldState extends State<TimeInputField> {

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      keyboardType: const TextInputType.numberWithOptions(decimal: false),
      decoration: InputDecoration(
        labelText: t.meetings.meeting.time,
      ),
      inputFormatters: <TextInputFormatter>[
        TimeTextInputFormatter(),
      ],
      validator: (value) {
        if (value == null || value.isEmpty) {
          return t.meetings.meeting.time_hint;
        }
        return null;
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}

class TimeTextInputFormatter extends TextInputFormatter {
  final RegExp _hourMinuteRegExp = RegExp(r'^[0-9:]+$');

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    // Permettre de vider complètement le champ
    if (newValue.text.isEmpty) {
      return newValue;
    }

    // Si le nouveau texte ne correspond pas au format attendu, on garde l'ancienne valeur
    if (!_hourMinuteRegExp.hasMatch(newValue.text)) {
      return oldValue;
    }

    // On ne garde que les chiffres
    final String digitsOnly = newValue.text.replaceAll(':', '');

    // Limite à 4 chiffres maximum
    if (digitsOnly.length > 4) {
      return oldValue;
    }

    // Construction du texte formaté
    String formatted = '';

    if (digitsOnly.length == 1) {
      // Un seul chiffre - on le laisse tel quel
      formatted = digitsOnly;
    } else if (digitsOnly.length == 2) {
      // Deux chiffres - si > 23, on ajoute le 0 devant
      int hours = int.tryParse(digitsOnly) ?? 0;
      if (hours > 23) {
        formatted = '0${digitsOnly[0]}:${digitsOnly[1]}';
      } else {
        formatted = digitsOnly;
      }
    } else if (digitsOnly.length == 3) {
      // Trois chiffres - on essaie d'abord de l'interpréter comme HMM
      int firstDigit = int.tryParse(digitsOnly[0]) ?? 0;
      int lastTwoDigits = int.tryParse(digitsOnly.substring(1)) ?? 0;

      if (firstDigit < 3 && lastTwoDigits < 60) {
        // Si c'est une heure valide (0-2) et minutes valides, on le traite comme HMM
        formatted = '$firstDigit${lastTwoDigits < 10 ? "0" : ""}$lastTwoDigits';
      } else {
        // Sinon on ajoute un 0 devant
        formatted = '0${digitsOnly[0]}:${digitsOnly.substring(1)}';
      }
    } else if (digitsOnly.length == 4) {
      // Quatre chiffres - format complet HH:MM
      String hours = digitsOnly.substring(0, 2);
      String minutes = digitsOnly.substring(2);

      int hoursInt = int.tryParse(hours) ?? 0;
      int minutesInt = int.tryParse(minutes) ?? 0;

      if (hoursInt > 23 || minutesInt > 59) {
        return oldValue;
      }

      formatted = '$hours:$minutes';
    }

    // Ajout automatique des deux points pour 2 chiffres ou plus
    if (formatted.length == 2 && !formatted.contains(':')) {
      formatted += ':';
    } else if (formatted.length == 3 && !formatted.contains(':')) {
      formatted = '${formatted.substring(0, 2)}:${formatted.substring(2)}';
    } else if (formatted.length == 4 && !formatted.contains(':')) {
      formatted = '${formatted.substring(0, 2)}:${formatted.substring(2)}';
    }

    // Calcul de la nouvelle position du curseur
    final int newCursorPosition = formatted.length;

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: newCursorPosition),
      composing: TextRange.empty,
    );
  }
}
