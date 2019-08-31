import 'dart:io';

import 'dart:typed_data';

class XFile {
  File _file;

  File get file => _file;

  Directory get directory => Directory(file.path);

  String _simplifyPath(String path) {
    return path.replaceAll(RegExp(r'((?<!:)(\\|/)+)|((?<=:)(\\|/)+)'), '/');
  }

  XFile.fromFile(File file) {
    _file = File(_simplifyPath(file.path));
  }

  XFile(String path) : this.fromFile(File(path));

  XFile.fromPath(String path) : this(path);

  XFile.fromUri(Uri uri) : this.fromFile(File.fromUri(uri));

  XFile.fromRawPath(Uint8List rawPath) : this.fromFile(File.fromRawPath(rawPath));

  XFile.combine(String parent, String child) : this.fromFile(File('$parent/$child'));

  XFile.combineDir(Directory parent, String child) : this.combine(parent.path, child);

  XFile.combineFile(File parent, String child) : this.combine(parent.path, child);

  XFile append(String child) {
    File file = XFile.combineFile(_file, child).file;
    return XFile.fromFile(file);
  }

  String fileName({bool withExtension = true}) {
    String nameWithExtension = _file.path.split('/').last;
    if (withExtension) {
      return nameWithExtension;
    } else {
      return nameWithExtension.split('.').reversed.skip(1).toList().reversed.join('.');
    }
  }

  String extension() {
    return fileName(withExtension: true).split('.').reversed.toList().take(1).first;
  }

  XFile operator +(String child) {
    return append(child);
  }
}
