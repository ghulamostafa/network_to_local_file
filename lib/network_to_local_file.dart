library network_to_local_file;
import 'dart:io';
import 'package:flutter/material.dart';
import './resources/utility.dart';
import './common_widgets/local_audio_player.dart';
import './common_widgets/local_video_player.dart';

class NetworkToLocal extends StatefulWidget {

  final String mediaURL;
  final String mediaType;

  @override
  _NetworkToLocalState createState() => _NetworkToLocalState();

  NetworkToLocal({required this.mediaURL, required this.mediaType});
}

class _NetworkToLocalState extends State<NetworkToLocal> {
  int _status = 0;
  String _filePath = '';
  double _downloadPercentage = 0;

  setStatus(int status){
    setState(() {
      _status = status;
    });
  }

  setFilePath(String filePath, int status){
    setState(() {
      _filePath = filePath;
      _status = status;
    });
  }

  Function? downloadProgress(int count, int total){
    setState(() {
      _downloadPercentage = count / total;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Utility.downloadFileLocally(widget.mediaURL, setStatus, setFilePath, downloadProgress: downloadProgress);
  }

  @override
  Widget build(BuildContext context) {
    if(_status == 0){
      return ElevatedButton(
          onPressed: (){
            print('download file');
            Utility.downloadFileLocally(widget.mediaURL, setStatus, setFilePath);
          },
          child: Text('Download')
      );
    } else if(_status == 1){
      return Column(
        children: [
          CircularProgressIndicator(value: _downloadPercentage,)
        ],
      );
    } else {
      if(widget.mediaType == 'image'){
        return Image.file(File(_filePath));
      }
      else if(widget.mediaType == 'audio'){
        return LocalAudioPlayer(filePath: _filePath);
      }
      else if(widget.mediaType == 'video'){
        return LocalVideoPlayer(filePath: _filePath);
      }
      else{
        return CircularProgressIndicator(value: _downloadPercentage,);
      }
    }
  }
}
