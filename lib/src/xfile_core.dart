import 'dart:convert';
import 'dart:io';

import 'dart:typed_data';

class XFile {
  Uri _uri;

  String get path => _uri.toString();

  String get scheme => _uri.scheme;

  List<String> get _segments {
    List<String> result = [];
    if (_uri.host != null && _uri.host.isNotEmpty) result.add(_uri.host);
    if (_uri.path != null && _uri.path.isNotEmpty) result.addAll(_uri.pathSegments);
    return result;
  }

  File get file => toFile();

  Directory get directory => toDirectory();

  Uri get uri => toUri();

  // *********************************************************************************************************** constructor

  XFile(String path) {
    path = _simplifyPath(path);
    _uri = Uri.parse(path);
  }

  XFile.fromFile(File file) : this(file.path);

  XFile.fromDirectory(Directory directory) : this(directory.path);

  XFile.fromPath(String path) : this(path);

  XFile.fromUri(Uri uri) : this.fromFile(File.fromUri(uri));

  XFile.fromRawPath(Uint8List rawPath) : this.fromFile(File.fromRawPath(rawPath));

  XFile.fromXFile(XFile xFile) : this(xFile.path);

  /// Concat two any type file
  factory XFile.concat(dynamic parent, dynamic child) {
    XFile parentFile = XFile.parse(parent);
    XFile childFile = XFile.parse(child);
    return XFile("${parentFile.path}/${childFile.path}");
  }

  /// Parse any type to XFile, [fileOrDirectory] only can be a String, File, Directory, Uri, Uint8List or XFile
  factory XFile.parse(dynamic fileOrDirectory) {
    if (fileOrDirectory == null) throw "XFile.parse(null): Invalid argument null";
    if (fileOrDirectory is String) return XFile.fromPath(fileOrDirectory);
    if (fileOrDirectory is File) return XFile.fromFile(fileOrDirectory);
    if (fileOrDirectory is Directory) return XFile.fromDirectory(fileOrDirectory);
    if (fileOrDirectory is Uri) return XFile.fromUri(fileOrDirectory);
    if (fileOrDirectory is Uint8List) return XFile.fromRawPath(fileOrDirectory);
    if (fileOrDirectory is XFile) return fileOrDirectory;
    throw "XFile.parse() can only put String, File, Directory, Uri, Uint8List or XFile";
  }

  // *********************************************************************************************************** method

  String _simplifyPath(String path) {
    return path.replaceAll(RegExp(':[/\\\\]+'), '#').replaceAll(RegExp(r'[\\/]+'), '/').replaceAll('#', '://');
  }

  /// Transform to a [File]
  File toFile() => File(path);

  /// Transform to a [Directory]
  Directory toDirectory() => Directory(path);

  /// Transform to a [Uri]
  Uri toUri() => _uri;

  /// Appends a any type's file
  XFile append(dynamic child) => XFile.concat(this, child);

  /// Appends a any type's file
  XFile operator +(dynamic child) => this.append(child);

  /// <pre>
  /// Get file's name without any extension.
  /// ex:
  ///   note       -> note
  ///   note.txt   -> note
  ///   note.g.txt -> note
  String pureFileName() => fileName(withExtension: true).split(".").first;

  /// <pre>
  /// Get file's name with extension or not.
  /// ex:
  ///   withExtension = true:
  ///     note       -> note
  ///     note.txt   -> note.txt
  ///     note.g.txt -> note.g.txt
  ///   <br>
  ///   withExtension = false:
  ///     note       -> note
  ///     note.txt   -> note
  ///     note.g.txt -> note.g
  ///
  String fileName({bool withExtension = true}) {
    String fullFileName = _segments.last;
    if (withExtension) {
      return fullFileName;
    } else {
      var splits = fullFileName.split(".");
      return splits.length == 1 ? splits.single : splits.reversed.skip(1).toList().reversed.join(".");
    }
  }

  /// Get file's extension
  String extension() {
    var segments = fileName(withExtension: true).split(".");
    return segments.length == 1 ? "" : segments.last;
  }

  /// back in file path
  XFile cdBack([int backDepth = 1]) {
    String newPath = _segments.reversed.skip(backDepth).toList().reversed.join("/");
    String newScheme = scheme.isNotEmpty ? "${scheme}://" : "/";
    return XFile.fromPath(newScheme + newPath);
  }

  @override
  String toString() => toFile().path;

  // ************************************************************************************************ file overrides method

  File get absoluteFile => file.absolute;

  Future<File> copyFile(String newPath) => file.copy(newPath);

  File copyFileSync(String newPath) => file.copySync(newPath);

  Future<File> createFile({bool recursive = false}) => file.create(recursive: recursive);

  void createFileSync({bool recursive = false}) => file.createSync(recursive: recursive);

  Future<FileSystemEntity> deleteFile({bool recursive = false}) => file.delete(recursive: recursive);

  void deleteFileSync({bool recursive = false}) => file.deleteSync(recursive: recursive);

  Future<bool> existsFile() => file.exists();

  bool existsFileSync() => file.existsSync();

  bool get isAbsoluteFile => file.isAbsolute;

  Future<DateTime> fileLastAccessed() => file.lastAccessed();

  DateTime fileLastAccessedSync() => file.lastAccessedSync();

  Future<DateTime> fileLastModified() => file.lastModified();

  DateTime fileLastModifiedSync() => file.lastModifiedSync();

  Future<int> fileLength() => file.length();

  int fileLengthSync() => file.lengthSync();

  Future<RandomAccessFile> openFile({FileMode mode = FileMode.read}) => file.open(mode: mode);

  Stream<List<int>> openReadFile([int start, int end]) => file.openRead(start, end);

  RandomAccessFile openFileSync({FileMode mode = FileMode.read}) => file.openSync(mode: mode);

  IOSink openWriteFile({FileMode mode = FileMode.write, Encoding encoding = utf8}) =>
      file.openWrite(mode: mode, encoding: encoding);

  Directory get fileParent => file.parent;

  String get filePath => file.path;

  Future<Uint8List> readFileAsBytes() => file.readAsBytes();

  Uint8List readFileAsBytesSync() => file.readAsBytesSync();

  Future<List<String>> readFileAsLines({Encoding encoding = utf8}) => file.readAsLines(encoding: encoding);

  List<String> readFileAsLinesSync({Encoding encoding = utf8}) => file.readAsLinesSync(encoding: encoding);

  Future<String> readFileAsString({Encoding encoding = utf8}) => file.readAsString(encoding: encoding);

  String readFileAsStringSync({Encoding encoding = utf8}) => file.readAsStringSync(encoding: encoding);

  Future<File> renameFile(String newPath) => file.rename(newPath);

  File renameFileSync(String newPath) => file.renameSync(newPath);

  Future<String> fileResolveSymbolicLinks() => file.resolveSymbolicLinks();

  String fileResolveSymbolicLinksSync() => file.resolveSymbolicLinksSync();

  Future setFileLastAccessed(DateTime time) => file.setLastAccessed(time);

  void setFileLastAccessedSync(DateTime time) => file.setLastAccessedSync(time);

  Future setFileLastModified(DateTime time) => file.setLastModified(time);

  void setFileLastModifiedSync(DateTime time) => file.setLastModifiedSync(time);

  Future<FileStat> fileStat() => file.stat();

  FileStat fileStatSync() => file.statSync();

  Uri get fileUri => file.uri;

  Stream<FileSystemEvent> watchFile({int events = FileSystemEvent.all, bool recursive = false}) {
    return file.watch(events: events, recursive: recursive);
  }

  Future<File> writeFileAsBytes(List<int> bytes, {FileMode mode = FileMode.write, bool flush = false}) {
    return file.writeAsBytes(bytes, mode: mode, flush: flush);
  }

  void writeFileAsBytesSync(List<int> bytes, {FileMode mode = FileMode.write, bool flush = false}) {
    file.writeAsBytesSync(bytes, mode: mode, flush: flush);
  }

  Future<File> writeFileAsString(String contents,
      {FileMode mode = FileMode.write, Encoding encoding = utf8, bool flush = false}) {
    return file.writeAsString(contents, mode: mode, encoding: encoding, flush: flush);
  }

  void writeFileAsStringSync(String contents, {FileMode mode = FileMode.write, Encoding encoding = utf8, bool flush = false}) {
    file.writeAsStringSync(contents, mode: mode, encoding: encoding, flush: flush);
  }

  // ************************************************************************************************ file overrides method

  Directory get absoluteDirectory => directory.absolute;

  Future<Directory> createDirectory({bool recursive = false}) => directory.create(recursive: recursive);

  void createDirectorySync({bool recursive = false}) => directory.createSync(recursive: recursive);

  Future<Directory> createTempDirectory([String prefix]) => directory.createTemp(prefix);

  Directory createTempDirectorySync([String prefix]) => directory.createTempSync(prefix);

  Future<FileSystemEntity> deleteDirectory({bool recursive = false}) => directory.delete(recursive: recursive);

  void deleteDirectorySync({bool recursive = false}) => directory.deleteSync(recursive: recursive);

  Future<bool> existsDirectory() => directory.exists();

  bool existsDirectorySync() => directory.existsSync();

  bool get isAbsoluteDirectory => directory.isAbsolute;

  Stream<FileSystemEntity> directoryList({bool recursive = false, bool followLinks = true}) {
    return directory.list(recursive: recursive, followLinks: followLinks);
  }

  List<FileSystemEntity> directoryListSync({bool recursive = false, bool followLinks = true}) {
    return directory.listSync(recursive: recursive, followLinks: followLinks);
  }

  Directory get directoryParent => directory.parent;

  String get directoryPath => directory.path;

  Future<Directory> renameDirectory(String newPath) => directory.rename(newPath);

  Directory renameDirectorySync(String newPath) => directory.renameSync(newPath);

  Future<String> resolveDirectorySymbolicLinks() => directory.resolveSymbolicLinks();

  String resolveDirectorySymbolicLinksSync() => directory.resolveSymbolicLinksSync();

  Future<FileStat> directoryStat() => directory.stat();

  FileStat directoryStatSync() => directory.statSync();

  Uri get directoryUri => directory.uri;

  Stream<FileSystemEvent> watchDirectory({int events = FileSystemEvent.all, bool recursive = false}) {
    return directory.watch(events: events, recursive: recursive);
  }
}
