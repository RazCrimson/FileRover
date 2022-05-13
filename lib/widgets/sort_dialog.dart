import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../fs/sorters/enums.dart';
import '../providers/browser.dart';

class SortWidget extends StatelessWidget {
  const SortWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final browserProvider = Provider.of<BrowserProvider>(context);
    const headerStyle = TextStyle(fontSize: 20, fontWeight: FontWeight.bold);

    return Dialog(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const Text("Sort By", style: headerStyle),
            ListTile(
              title: const Text('Name'),
              leading: Radio<SortBy>(
                  value: SortBy.name,
                  groupValue: browserProvider.sortBy,
                  onChanged: (SortBy? sortBy) => browserProvider.sortBy = sortBy ?? browserProvider.sortBy),
            ),
            ListTile(
              title: const Text('Modified Time'),
              leading: Radio<SortBy>(
                  value: SortBy.time,
                  groupValue: browserProvider.sortBy,
                  onChanged: (SortBy? sortBy) => browserProvider.sortBy = sortBy ?? browserProvider.sortBy),
            ),
            ListTile(
              title: const Text('File Size'),
              leading: Radio<SortBy>(
                  value: SortBy.size,
                  groupValue: browserProvider.sortBy,
                  onChanged: (SortBy? sortBy) => browserProvider.sortBy = sortBy ?? browserProvider.sortBy),
            ),
            ListTile(
              title: const Text('File Type'),
              leading: Radio<SortBy>(
                  value: SortBy.type,
                  groupValue: browserProvider.sortBy,
                  onChanged: (SortBy? sortBy) => browserProvider.sortBy = sortBy ?? browserProvider.sortBy),
            ),
            const SizedBox(height: 20),
            const Text("Sort Order", style: headerStyle),
            ListTile(
              title: const Text('Ascending'),
              leading: Radio<SortOrder>(
                  value: SortOrder.ascending,
                  groupValue: browserProvider.sortOrder,
                  onChanged: (SortOrder? sortOrder) =>
                      browserProvider.sortOrder = sortOrder ?? browserProvider.sortOrder),
            ),
            ListTile(
              title: const Text('Descending'),
              leading: Radio<SortOrder>(
                  value: SortOrder.descending,
                  groupValue: browserProvider.sortOrder,
                  onChanged: (SortOrder? sortOrder) =>
                      browserProvider.sortOrder = sortOrder ?? browserProvider.sortOrder),
            ),
          ],
        ),
      ),
    );
  }
}
