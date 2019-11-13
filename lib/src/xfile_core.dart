import 'dart:io';

import 'dart:typed_data';

class XFile {
  File _file;

  File get file => _file;

  Directory get directory => Directory(file.path);

  String _simplifyPath(String path) {
    return path.replaceAll(RegExp(':[/\\\\]+'), '#').replaceAll(RegExp(r'[\\/]+'), '/').replaceAll('#', '://');
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
    var segments = fileName(withExtension: true).split(".");
    return segments.length == 1 ? "" : segments.last;
  }

  XFile operator +(String child) {
    return append(child);
  }

  XFile cdBack() {
    List<String> segments = [];
    Uri uri = Uri.parse(file.path);
    if (uri.host != null && uri.host.isNotEmpty) segments.add(uri.host);
    if (uri.pathSegments != null && uri.pathSegments.isNotEmpty) {
      segments.addAll(uri.pathSegments.where((o) => o.isNotEmpty).toList());
    }
    String cdPath = (uri.scheme.isNotEmpty ? "${uri.scheme}://" : "/") + segments.reversed.skip(1).toList().reversed.join("/");
    return XFile.fromPath(cdPath);
  }

  @override
  String toString() {
    return file.toString();
  }
}
