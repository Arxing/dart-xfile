A library used like java class 'File'.

## Usage

A simple usage example:

```dart
import 'dart:io';

import 'package:xfile/xfile.dart';

main() {
  XFile('/path/path/path/file.txt');
  XFile.fromPath('/path/path/path/file.txt');
  XFile.fromFile(File('/path/path/path/file.txt'));
  XFile.fromUri(Uri.parse('/path/path/path/file.txt'));

  XFile.combine('/path/path/path', 'file.txt');
  XFile.combineDir(Directory('/path/path/path'), 'file.txt');
  XFile.combineFile(File('/path/path/path'), 'file.txt');

  XFile dir = XFile.fromPath('/path/path/path');
  XFile file1 = dir.append('file.txt');
  XFile file2 = dir + 'file.txt';

  Directory toDir = dir.directory;
  File toFile = file1.file;
}
```
