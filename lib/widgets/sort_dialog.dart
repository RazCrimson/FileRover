import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../fs/sorters/enums.dart';
import '../providers/sort_options.dart';

class SortWidget extends StatelessWidget {
  const SortWidget({Key? key}) : super(key: key);

  void handleSortByChange(BuildContext context, SortBy? sortBy) {
    if (sortBy != null) {
      Provider.of<SortOptions>(context, listen: false).sortBy = sortBy;
    }
  }

  void handleSortOrderChange(BuildContext context, SortOrder? sortOrder) {
    if (sortOrder != null) {
      Provider.of<SortOptions>(context, listen: false).sortOrder = sortOrder;
    }
  }

  @override
  Widget build(BuildContext context) {
    const headerStyle = TextStyle(fontSize: 20, fontWeight: FontWeight.bold);
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
                    groupValue: Provider.of<SortOptions>(context).sortBy,
                    onChanged: (SortBy? sortBy) => handleSortByChange(context, sortBy)),
                onTap: () => handleSortByChange(context, SortBy.name)),
            ListTile(
                title: const Text('Modified Time'),
                leading: Radio<SortBy>(
                    value: SortBy.time,
                    groupValue: Provider.of<SortOptions>(context).sortBy,
                    onChanged: (SortBy? sortBy) => handleSortByChange(context, sortBy)),
                onTap: () => handleSortByChange(context, SortBy.time)),
            ListTile(
                title: const Text('File Size'),
                leading: Radio<SortBy>(
                    value: SortBy.size,
                    groupValue: Provider.of<SortOptions>(context).sortBy,
                    onChanged: (SortBy? sortBy) => handleSortByChange(context, sortBy)),
                onTap: () => handleSortByChange(context, SortBy.size)),
            ListTile(
                title: const Text('File Type'),
                leading: Radio<SortBy>(
                    value: SortBy.type,
                    groupValue: Provider.of<SortOptions>(context).sortBy,
                    onChanged: (SortBy? sortBy) => handleSortByChange(context, sortBy)),
                onTap: () => handleSortByChange(context, SortBy.type)),
            const SizedBox(height: 20),
            const Text("Sort Order", style: headerStyle),
            ListTile(
                title: const Text('Ascending'),
                leading: Radio<SortOrder>(
                    value: SortOrder.ascending,
                    groupValue: Provider.of<SortOptions>(context, listen: false).sortOrder,
                    onChanged: (SortOrder? sortOrder) => handleSortOrderChange(context, sortOrder)),
                onTap: () => handleSortOrderChange(context, SortOrder.ascending)),
            ListTile(
                title: const Text('Descending'),
                leading: Radio<SortOrder>(
                    value: SortOrder.descending,
                    groupValue: Provider.of<SortOptions>(context, listen: false).sortOrder,
                    onChanged: (SortOrder? sortOrder) => handleSortOrderChange(context, sortOrder)),
                onTap: () => handleSortOrderChange(context, SortOrder.descending)),
          ],
        ),
      ),
    );
  }
}
