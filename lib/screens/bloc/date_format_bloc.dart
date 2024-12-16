import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zithara_ai_assignment/screens/model/date_format_model.dart';

abstract class DateFormatEvent {}

class LoadDateFormats extends DateFormatEvent {}

class SelectDateFormat extends DateFormatEvent {
  final DateFormatModel format;
  SelectDateFormat(this.format);
}

class UpdateDate extends DateFormatEvent {
  final String date;
  UpdateDate(this.date);
}

// States
abstract class DateFormatState {}

class DateFormatInitial extends DateFormatState {}

class DateFormatLoading extends DateFormatState {}

class DateFormatLoaded extends DateFormatState {
  final List<DateFormatModel> formats;
  final DateFormatModel selectedFormat;
  final String? date;
  final String? error;

  DateFormatLoaded({
    required this.formats,
    required this.selectedFormat,
    this.date,
    this.error,
  });
}

class DateFormatError extends DateFormatState {
  final String message;
  DateFormatError(this.message);
}

// BLoC
class DateFormatBloc extends Bloc<DateFormatEvent, DateFormatState> {
  DateFormatBloc() : super(DateFormatInitial()) {
    on<LoadDateFormats>(_onLoadDateFormats);
    on<SelectDateFormat>(_onSelectDateFormat);
    on<UpdateDate>(_onUpdateDate);
  }

  void _onLoadDateFormats(LoadDateFormats event, Emitter<DateFormatState> emit) {
    try {
      final formats = _getDateFormats();
      final defaultFormat = formats.firstWhere((format) => format.enabled);
      emit(DateFormatLoaded(formats: formats, selectedFormat: defaultFormat));
    } catch (e) {
      emit(DateFormatError('Failed to load date formats'));
    }
  }

  void _onSelectDateFormat(SelectDateFormat event, Emitter<DateFormatState> emit) {
    if (state is DateFormatLoaded) {
      final currentState = state as DateFormatLoaded;
      emit(DateFormatLoaded(
        formats: currentState.formats,
        selectedFormat: event.format,
        date: currentState.date,
      ));
    }
  }

  List<DateFormatModel> _getDateFormats() {
    final jsonData = [
      {"id": 1, "datetype": "dd-mm-yyyy", "enabled": true},
      {"id": 2, "datetype": "mm-dd-yyyy", "enabled": false},
      {"id": 3, "datetype": "yyyy-dd-mm", "enabled": false},
      {"id": 4, "datetype": "yyyy-mm-dd", "enabled": false},
      {"id": 5, "datetype": "dd/mm/yyyy", "enabled": false},
      {"id": 6, "datetype": "mm/dd/yyyy", "enabled": false},
      {"id": 7, "datetype": "yyyy/mm/dd", "enabled": false},
      {"id": 8, "datetype": "yyyy/dd/mm", "enabled": false}
    ];

    return jsonData.map((json) => DateFormatModel.fromJson(json)).toList();
  }

  bool _isLeapYear(int year) {
    return year % 4 == 0 && (year % 100 != 0 || year % 400 == 0);
  }

  int _getMaxDaysInMonth(int month, int year) {
    switch (month) {
      case 2: // February
        return _isLeapYear(year) ? 29 : 28;
      case 4: // April
      case 6: // June
      case 9: // September
      case 11: // November
        return 30;
      default:
        return 31;
    }
  }

//
  String? _validateDate(String date, String format) {
    // Removing separators to get just numbers
    final numbers = date.replaceAll(RegExp(r'[-/]'), '');
    try {
      int day, month, year;

      // Parse values based on format
      switch (format) {
        case 'dd-mm-yyyy':
        case 'dd/mm/yyyy':
          day = int.parse(numbers.substring(0, 2));
          month = int.parse(numbers.substring(2, 4));
          year = int.parse(numbers.substring(4));
          break;

        case 'mm-dd-yyyy':
        case 'mm/dd/yyyy':
          month = int.parse(numbers.substring(0, 2));
          day = int.parse(numbers.substring(2, 4));
          year = int.parse(numbers.substring(4));
          break;

        case 'yyyy-mm-dd':
        case 'yyyy/mm/dd':
          year = int.parse(numbers.substring(0, 4));
          month = int.parse(numbers.substring(4, 6));
          day = int.parse(numbers.substring(6));
          break;

        case 'yyyy-dd-mm':
        case 'yyyy/dd/mm':
          year = int.parse(numbers.substring(0, 4));
          day = int.parse(numbers.substring(4, 6));
          month = int.parse(numbers.substring(6));
          break;

        default:
          return 'Invalid date format';
      }

      // Validate year
      final currentYear = DateTime.now().year;
      if (year > currentYear) {
        return 'Year cannot exceed the current year';
      }

      // Validate month
      if (month <= 0 || month > 12) {
        return 'Invalid month. Please enter a value between 1 and 12';
      }

      // Validate day
      if (day <= 0) {
        return 'Date cannot be 0 or negative';
      }

      final maxDays = _getMaxDaysInMonth(month, year);
      if (day > maxDays) {
        if (month == 2 && day == 29) {
          return 'Invalid date for February in a non-leap year';
        }
        return 'Date exceeds maximum days for the selected month';
      }
      return null;
    } catch (e) {
      return 'Invalid date format';
    }
  }

//

  String formatDateInput(String value, DateFormatModel format) {
    // Remove any non-digit characters
    String digitsOnly = value.replaceAll(RegExp(r'[^\d]'), '');

    // Get separator from format
    String separator = format.datetype.contains('-') ? '-' : '/';

    // Handle different date formats
    switch (format.datetype.toLowerCase()) {
      case 'dd-mm-yyyy':
      case 'dd/mm/yyyy':
        return _formatDDMMYYYY(digitsOnly, separator);
      case 'mm-dd-yyyy':
      case 'mm/dd/yyyy':
        return _formatMMDDYYYY(digitsOnly, separator);
      case 'yyyy-mm-dd':
      case 'yyyy/mm/dd':
        return _formatYYYYMMDD(digitsOnly, separator);
      case 'yyyy-dd-mm':
      case 'yyyy/dd/mm':
        return _formatYYYYDDMM(digitsOnly, separator);
      default:
        return digitsOnly;
    }
  }

  String _formatDDMMYYYY(String digits, String separator) {
    StringBuffer formatted = StringBuffer();
    for (int i = 0; i < digits.length && i < 8; i++) {
      if (i == 2 || i == 4) formatted.write(separator);
      formatted.write(digits[i]);
    }
    return formatted.toString();
  }

  String _formatMMDDYYYY(String digits, String separator) {
    StringBuffer formatted = StringBuffer();
    for (int i = 0; i < digits.length && i < 8; i++) {
      if (i == 2 || i == 4) formatted.write(separator);
      formatted.write(digits[i]);
    }
    return formatted.toString();
  }

  String _formatYYYYMMDD(String digits, String separator) {
    StringBuffer formatted = StringBuffer();
    for (int i = 0; i < digits.length && i < 8; i++) {
      if (i == 4 || i == 6) formatted.write(separator);
      formatted.write(digits[i]);
    }
    return formatted.toString();
  }

  String _formatYYYYDDMM(String digits, String separator) {
    StringBuffer formatted = StringBuffer();
    for (int i = 0; i < digits.length && i < 8; i++) {
      if (i == 4 || i == 6) formatted.write(separator);
      formatted.write(digits[i]);
    }
    return formatted.toString();
  }

  String? isDateValid(String value, DateFormatModel format) {
    if (value.isEmpty) return null;

    String digitsOnly = value.replaceAll(RegExp(r'[^\d]'), '');
    if (digitsOnly.length != 8) return "Please enter a complete date";

    int day, month, year;

    try {
      switch (format.datetype.toLowerCase()) {
        case 'dd-mm-yyyy':
        case 'dd/mm/yyyy':
          day = int.parse(digitsOnly.substring(0, 2));
          month = int.parse(digitsOnly.substring(2, 4));
          year = int.parse(digitsOnly.substring(4));
          break;
        case 'mm-dd-yyyy':
        case 'mm/dd/yyyy':
          month = int.parse(digitsOnly.substring(0, 2));
          day = int.parse(digitsOnly.substring(2, 4));
          year = int.parse(digitsOnly.substring(4));
          break;
        case 'yyyy-mm-dd':
        case 'yyyy/mm/dd':
          year = int.parse(digitsOnly.substring(0, 4));
          month = int.parse(digitsOnly.substring(4, 6));
          day = int.parse(digitsOnly.substring(6));
          break;
        case 'yyyy-dd-mm':
        case 'yyyy/dd/mm':
          year = int.parse(digitsOnly.substring(0, 4));
          day = int.parse(digitsOnly.substring(4, 6));
          month = int.parse(digitsOnly.substring(6));
          break;
        default:
          return "Invalid date format";
      }
    } catch (e) {
      return "Invalid date format";
    }
    // Year validation
    final currentYear = DateTime.now().year;
    debugPrint("Current Year is $currentYear");
    if (year > currentYear) {
      return "Year cannot be more than one year in the future.";
    }

    // Month validation
    if (month < 1 || month > 12) {
      return "Invalid month. Please enter a value between 1 and 12.";
    }

    // Check days in month
    bool isLeapYear = (year % 4 == 0 && year % 100 != 0) || (year % 400 == 0);
    int maxDays;

    if (month == 2) {
      maxDays = isLeapYear ? 29 : 28;

      if (!isLeapYear && day == 29) {
        return "Invalid date for February in a non-leap year.";
      }
      if (day > maxDays) {
        return "Date exceeds maximum days for February.";
      }
    } else {
      maxDays = [4, 6, 9, 11].contains(month) ? 30 : 31;
      if (day > maxDays) {
        return "Date exceeds maximum days for the selected month.";
      }
    }

    if (day < 1) {
      return "Day cannot be less than 1.";
    }

    // validations passed
    return null;
  }

  void _onUpdateDate(UpdateDate event, Emitter<DateFormatState> emit) {
    if (state is DateFormatLoaded) {
      final currentState = state as DateFormatLoaded;
      final error = _validateDate(event.date, currentState.selectedFormat.datetype);

      emit(DateFormatLoaded(
        formats: currentState.formats,
        selectedFormat: currentState.selectedFormat,
        date: event.date,
        error: error,
      ));
    }
  }
}
