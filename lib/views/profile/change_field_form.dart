import 'package:firechat/common/extensions/context_extensions.dart';
import 'package:firechat/domain/blocs/simple_state.dart';
import 'package:firechat/models/response.dart';
import 'package:firechat/views/common/theme/colors.dart';
import 'package:firechat/views/common/theme/styles.dart';
import 'package:firechat/views/common/widgets/error_panel.dart';
import 'package:firechat/views/common/widgets/primary_button.dart';
import 'package:flutter/material.dart';

class ChangeFieldForm extends StatefulWidget {
  final Widget child;
  final Future<Response> Function() onValidate;
  final String title;
  final String message;

  ChangeFieldForm(
      {Key key,
      @required this.child,
      @required this.title,
      @required this.onValidate,
      this.message})
      : assert(onValidate != null),
        assert(child != null),
        assert(title != null),
        super(key: key);

  @override
  _ChangeFieldFormState createState() => _ChangeFieldFormState();
}

class _ChangeFieldFormState extends State<ChangeFieldForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  SimpleState state = SimpleState.idle();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: themeBackgroundColor,
        appBar: AppBar(
          title: Text(widget.title),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
            child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: _createForm(context),
        )));
  }

  Widget _createForm(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // MESSAGE
          Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: Text(widget.message, style: themeFieldContentTextStyle),
          ),

          // CHILD FIELDS
          Padding(
              padding: const EdgeInsets.symmetric(vertical: 30.0),
              child: widget.child),

          // ERROR PANEL
          (state.errorCode != null)
              ? Center(child: ErrorCodePanel(errorCode: state.errorCode))
              : SizedBox(height: 50,),

          // VALIDATE BUTTON
          Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: (state.loading) ? _loadingButton : _validateButton(context))
        ],
      ),
    );
  }

  Widget _validateButton(BuildContext context) => PrimaryButton(
      label: context.strings.validate, onClick: _onValidateButton);

  Widget get _loadingButton => PrimaryButton(
      onClick: (context) {}, // Do nothing on click
      child: CircularProgressIndicator(
        strokeWidth: 3,
        valueColor: AlwaysStoppedAnimation(themeTextColor),
      ));

  _onValidateButton(BuildContext context) async {
    if (_formKey.currentState.validate()) {
      setState(() {
        state = SimpleState.loading();
      });

      final result = await widget.onValidate();

      if(result.hasError) {
        setState(() {
          state = result.toSimpleState();
        });
      } else {
        Navigator.of(context).pop();
      }
    }
  }
}
