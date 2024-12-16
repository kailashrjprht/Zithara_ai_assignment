import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zithara_ai_assignment/screens/bloc/date_format_bloc.dart';
import 'package:zithara_ai_assignment/screens/model/date_format_model.dart';

class DateFormatScreen extends StatefulWidget {
  const DateFormatScreen({super.key});

  @override
  State<DateFormatScreen> createState() => _DateFormatScreenState();
}

class _DateFormatScreenState extends State<DateFormatScreen> {
  final TextEditingController _dateController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<DateFormatBloc>().add(LoadDateFormats());
  }

  @override
  void dispose() {
    _dateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Date Format'),
      ),
      body: BlocBuilder<DateFormatBloc, DateFormatState>(
        builder: (context, state) {
          if (state is DateFormatLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is DateFormatLoaded) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  DropdownButtonFormField<DateFormatModel>(
                    value: state.selectedFormat,
                    items: state.formats.map((format) {
                      return DropdownMenuItem(
                        value: format,
                        child: Text(format.datetype),
                      );
                    }).toList(),
                    onChanged: (format) {
                      if (format != null) {
                        context.read<DateFormatBloc>().add(SelectDateFormat(format));
                      }
                    },
                    decoration: const InputDecoration(
                      labelText: 'Select Date Format',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _dateController,
                    decoration: InputDecoration(
                      labelText: 'Enter Date',
                      border: const OutlineInputBorder(),
                      errorText: context.read<DateFormatBloc>().isDateValid(_dateController.text, state.selectedFormat),
                      hintText: state.selectedFormat.datetype,
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(8),
                    ],
                    onChanged: (value) {
                      String formatted = context.read<DateFormatBloc>().formatDateInput(value, state.selectedFormat);
                      _dateController.value = TextEditingValue(
                        text: formatted,
                        selection: TextSelection.collapsed(offset: formatted.length),
                      );

                      // Update the bloc
                      context.read<DateFormatBloc>().add(UpdateDate(formatted));
                    },
                  ),
                ],
              ),
            );
          }

          return const Center(
            child: Text('Something went wrong'),
          );
        },
      ),
    );
  }
}
