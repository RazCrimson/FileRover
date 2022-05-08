import 'package:file_rover/fs/contracts/entity.dart';
import 'package:file_rover/fs/sorters/enums.dart';

import 'enums.dart';
import 'sorters.dart';

class FsEntitySorterFactory {
  static final _sorterMap = {
    SortBy.name: FsEntityNameSorter(),
    SortBy.size: FsEntitySizeSorter(),
    SortBy.time: FsEntityTimeSorter(),
    SortBy.type: FsEntityTypeSorter(),
  };

  static FsEntitySorter getSorter(SortBy sortBy) {
    return _sorterMap[sortBy] as FsEntitySorter;
  }
}
