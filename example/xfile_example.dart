import 'dart:io';

import 'package:xfile/xfile.dart';

main() {
  var path1 = "/root/fruit/apple/big-apple.png";

  XFile xFile;

  // many ways to get instance of XFile
  xFile = XFile(path1);
  xFile = XFile.fromPath(path1);
  xFile = XFile.fromDirectory(Directory("/root/animal"));
  xFile = XFile.fromUri(Uri.file(path1));
  xFile = XFile.fromFile(File(path1));
  xFile = XFile.parse(path1);
  xFile = XFile.concat("/root/animal", "fish/sushi.png");

  // many ways to append child
  xFile = XFile("/root"); // /root/
  xFile = xFile.append("animal"); // /root/animal/
  xFile = xFile + File("fish"); // /root/animal/fish/
  xFile = xFile + Directory("aaa"); // /root/animal/fish/aaa/
  xFile = xFile + "sushi.png"; // /root/animal/fish/aaa/sushi.png

  // cd back
  xFile = XFile.parse("/root/fruit/apple/big-apple.png");
  xFile.cdBack(); // /root/fruit/apple/
  xFile.cdBack(2); // /root/fruit/

  // transforms
  File file = xFile.toFile();
  file = xFile.file;
  Directory directory = xFile.toDirectory();
  directory = xFile.directory;
  Uri uri = xFile.toUri();
  uri = xFile.uri;

  var path2 = "C:/root/animal/fish/sushi.g.png";

  // get file information
  xFile = XFile(path2);
  xFile.scheme; // c
  xFile.fileName(); // sushi.g.png
  xFile.fileName(withExtension: false); // sushi.g
  xFile.pureFileName(); // sushi
  xFile.extension(); // png

  // XFile also implements all "File" and "Directory" methods,
  // all method name prefix or suffix "File" or "Directory" like this:
  xFile.existsFile();
  xFile.existsDirectory();

  xFile.renameFile("");
  xFile.renameDirectory("");

  xFile.deleteFile();
  xFile.deleteDirectory();

  xFile.fileParent;
  xFile.directoryParent;
}
