import 'dart:io';

import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';

class Utility{
  static downloadFileLocally(String mediaURL,Function setStatus, Function setFilePath, {Function? downloadProgress(int total, int count)?}) async {
    String _fileName = mediaURL.split('/').last;

    Dio dio = Dio();
    setStatus(1);
    await getApplicationDocumentsDirectory().then((appDir) async {
      if(!File(appDir.path + '/' + _fileName).existsSync())
      {
        print('Downloading');
        var filePath = await File(appDir.path + '/' + _fileName).create(recursive: true);
        await dio.download(mediaURL, filePath.path, onReceiveProgress: downloadProgress);
        setFilePath(filePath.path, 2);
      }
      else{
        print('Already downloaded');
        setFilePath(File(appDir.path + '/' + _fileName).path, 2);
      }
    });
  }
}