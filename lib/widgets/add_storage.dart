import 'package:file_rover/models/credential.dart';
import 'package:file_rover/providers/session.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class AddConnectionWidget extends StatefulWidget {
  const AddConnectionWidget({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _AddConnectionWidget();
}

class _AddConnectionWidget extends State<AddConnectionWidget> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final sessionProvider = Provider.of<SessionProvider>(context, listen: false);

    final usernameFieldController = TextEditingController();
    final passwordFieldController = TextEditingController();
    final hostFieldController = TextEditingController();
    final portFieldController = TextEditingController(text: "22");

    return Dialog(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
            key: _formKey,
            child: Column(
              children: [
                Center(child: Text("Add Remote Storage", style: Theme.of(context).textTheme.headline6)),
                TextFormField(
                  controller: usernameFieldController,
                  decoration: const InputDecoration(icon: Icon(Icons.person_sharp), labelText: 'Username'),
                  validator: (val) =>
                      (val == null || val.isEmpty || val.contains('@')) ? 'Not a valid username!' : null,
                ),
                TextFormField(
                  controller: passwordFieldController,
                  obscureText: true,
                  autocorrect: false,
                  enableSuggestions: false,
                  decoration: const InputDecoration(icon: Icon(Icons.password_sharp), labelText: 'Password'),
                ),
                TextFormField(
                  controller: hostFieldController,
                  decoration: const InputDecoration(icon: Icon(Icons.location_city_sharp), labelText: 'Host'),
                  validator: (val) => (val == null || val.isEmpty) ? 'Not a valid host address!' : null,
                ),
                TextFormField(
                  controller: portFieldController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(
                        r'^([1-9][0-9]{0,3}|[1-5][0-9]{4}|6[0-4][0-9]{3}|65[0-4][0-9]{2}|655[0-2][0-9]|6553[0-5])$'))
                  ],
                  decoration: const InputDecoration(icon: Icon(Icons.numbers_sharp), labelText: 'Host'),
                  validator: (val) => (val == null || val.isEmpty) ? 'Not a valid port number!' : null,
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      final credential = Credential(
                        username: usernameFieldController.text,
                        password: passwordFieldController.text,
                        host: hostFieldController.text,
                        port: int.parse(portFieldController.text),
                      );
                      await sessionProvider.addCredential(credential);
                      Navigator.pop(context);
                    }
                  },
                  child: const Text('Submit'),
                ),
              ],
            )),
      ),
    );
  }
}
