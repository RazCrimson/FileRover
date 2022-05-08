import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../fs/sorters/enums.dart';
import '../providers/sort_options.dart';

class SortWidget extends StatelessWidget {
  const SortWidget({Key? key}) : super(key: key);

 @override
  Widget build(BuildContext context) {
    const headerStyle = TextStyle(fontSize: 20, fontWeight: FontWeight.bold);
    final sortOptions = Provider.of<SortOptions>(context);
    return Dialog(
      child: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const Text("Sort By", style: headerStyle),
            ListTile(
              title: const Text('Name'),
              leading: Radio<SortBy>(
                  value: SortBy.name,
                  groupValue: sortOptions.sortBy,
                  onChanged: (SortBy? sortBy) => sortOptions.sortBy = sortBy ?? sortOptions.sortBy),
            ),
            ListTile(
              title: const Text('Modified Time'),
              leading: Radio<SortBy>(
                  value: SortBy.time,
                  groupValue: sortOptions.sortBy,
                  onChanged: (SortBy? sortBy) => sortOptions.sortBy = sortBy ?? sortOptions.sortBy),
            ),
            ListTile(
              title: const Text('File Size'),
              leading: Radio<SortBy>(
                  value: SortBy.size,
                  groupValue: sortOptions.sortBy,
                  onChanged: (SortBy? sortBy) => sortOptions.sortBy = sortBy ?? sortOptions.sortBy),
            ),
            ListTile(
              title: const Text('File Type'),
              leading: Radio<SortBy>(
                  value: SortBy.type,
                  groupValue: sortOptions.sortBy,
                  onChanged: (SortBy? sortBy) => sortOptions.sortBy = sortBy ?? sortOptions.sortBy),
            ),
            const SizedBox(height: 20),
            const Text("Sort Order", style: headerStyle),
            ListTile(
              title: const Text('Ascending'),
              leading: Radio<SortOrder>(
                  value: SortOrder.ascending,
                  groupValue: sortOptions.sortOrder,
                  onChanged: (SortOrder? sortOrder) => sortOptions.sortOrder = sortOrder ?? sortOptions.sortOrder),
            ),
            ListTile(
              title: const Text('Descending'),
              leading: Radio<SortOrder>(
                  value: SortOrder.descending,
                  groupValue: sortOptions.sortOrder,
                  onChanged: (SortOrder? sortOrder) => sortOptions.sortOrder = sortOrder ?? sortOptions.sortOrder),
            ),
          ],
        ),
      ),
    );
  }
}
