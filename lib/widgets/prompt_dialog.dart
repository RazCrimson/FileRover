import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/browser.dart';

class InputPromptWidget extends StatefulWidget {
  final String actionText;
  final Function action;

  const InputPromptWidget({Key? key, required this.actionText, required this.action}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _PromptDialogWidget();
}

class _PromptDialogWidget extends State<InputPromptWidget> {
  @override
  Widget build(BuildContext context) {
    final TextEditingController folderEditorController = TextEditingController();

    return Dialog(
        child: Container(
            padding: const EdgeInsets.all(20),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              ListTile(title: TextField(controller: folderEditorController)),
              Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  TextButton(
                    onPressed: () async {
                      final folderName = folderEditorController.text;
                      try {
                        // Create Folder
                        await widget.action(folderName);
                      } catch (e) {
                        print(e);
                      }
                      Navigator.pop(context);
                      Provider.of<BrowserProvider>(context, listen: false).manualRebuild();
                    },
                    child: const Text('Create Folder'),
                  )
                ],
              ),
            ])));
  }
}
