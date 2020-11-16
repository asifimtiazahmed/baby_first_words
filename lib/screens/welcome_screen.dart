import 'package:flutter/material.dart';
import 'package:flutter_first_words/screens/slideshow_screen.dart';
import '../widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_first_words/progress_indicator.dart';
import 'dart:typed_data';
import 'dart:io';
import 'package:http/http.dart' as http;
import  'package:path_provider/path_provider.dart';
import 'package:archive/archive.dart';


class LobbyScreen extends StatefulWidget {
  @override
  _LobbyScreenState createState() => _LobbyScreenState();
}


class _LobbyScreenState extends State<LobbyScreen> {

  bool needToDownload = false;
  double totalMB = 0;
  double currentMB = 0;
  String nameOfFilesInsideZip;
  int zipTotal;
  int zipCurrent;
  File currentAssetFolder;



  @override
  void initState() {
    downloadAssets();
    print('start download called');
    getLocalImageDir();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: SafeArea(
        child: Container(
          color: Color(0xFFF1F8E9),
          child: Stack(
            children: [
              (needToDownload) ? LoadAssets( progress: progress, totalMB: totalMB, currentMB: currentMB, zipCurrent: zipCurrent, zipTotal: zipTotal, zipFileName: nameOfFilesInsideZip,) : GridView.count(
                crossAxisCount: 2,
                childAspectRatio: 1,
                scrollDirection: Axis.vertical,
                crossAxisSpacing: 20,
                mainAxisSpacing: 20,
                children: [
                  Center(
                      child: Text(
                        'Baby First ',
                        style: GoogleFonts.spicyRice(
                          textStyle: TextStyle(
                              color: Colors.redAccent,
                              fontSize: 50,
                              fontWeight: FontWeight.w400,
                              textBaseline: TextBaseline.ideographic),
                        ),
                        textAlign: TextAlign.end,
                      )),
                  Center(
                    child: Text('Words',
                        style: GoogleFonts.spicyRice(
                          textStyle: TextStyle(
                              color: Colors.redAccent,
                              fontSize: 50,
                              fontWeight: FontWeight.w400),
                        ),
                        textAlign: TextAlign.start),
                  ),
                  BigButton(
                    useAssetImage: true, //this is telling the button to use the assets folder to load the images, it will use imageAsset widget otherwise it will use Imge.file widget
                    fileImagePath: 'assets/images/ABC.png',
                    onPress: () {
                      Navigator.push(context, MaterialPageRoute(
                        builder: (context) => SlideshowScreen(libraryName: 'alphabets', assetPathFile: currentAssetFolder,),
                      ),);
                      //slide.nameOfList = 'letters';
                    },
                    darkShadowColor: Colors.blue,
                    lightShadowColor: Colors.yellow,
                    splashColor: Colors.orangeAccent,
                  ),
                  BigButton(
                    useAssetImage: true,
                    fileImagePath: 'assets/images/animals.png',
                    onPress: () {
                      Navigator.push(context, MaterialPageRoute(
                        builder: (context) => SlideshowScreen(libraryName: 'animals', assetPathFile: currentAssetFolder),
                      ),);
                      //slide.nameOfList = 'letters';
                    },
                    darkShadowColor: Colors.blue,
                    lightShadowColor: Colors.yellow,
                    splashColor: Colors.deepOrange,
                  ),
                  BigButton(
                    useAssetImage: true,
                    fileImagePath: 'assets/images/obj.png',
                    onPress: () {
                      Navigator.push(context, MaterialPageRoute(
                        builder: (context) => SlideshowScreen(libraryName: 'objects', assetPathFile: currentAssetFolder),
                      ),);
                      //slide.nameOfList = 'letters';
                    },
                    darkShadowColor: Colors.blue,
                    lightShadowColor: Colors.yellow,
                    splashColor: Colors.lightBlue,
                  ),
                  BigButton(
                    useAssetImage: true,
                    fileImagePath: 'assets/images/123.png',
                    onPress: () {
                      Navigator.push(context, MaterialPageRoute(
                        builder: (context) => SlideshowScreen(libraryName: 'numbers', assetPathFile: currentAssetFolder),
                      ),);
                      //slide.nameOfList = 'letters';
                    },
                    darkShadowColor: Colors.blue,
                    lightShadowColor: Colors.yellow,
                    splashColor: Colors.green,
                  ),

                ],
                padding: EdgeInsets.only(top: 90, left: 20, right: 20),
              ),
            ],
          ),
        ),
      ),
    );
  }

  double progress=0;
  int downloaded;
  int contLength;

  static const String assetDownloadUrl = "https://www.iamasif.ca/resources/first_words_assets/assets.zip";
  String _dir;
  String name = 'assets.zip';
  File assetFileDirectory;
  List<int> bytes = [];


  Future<void> downloadAssets() async { //Getting the directory name
    print('download assets called');
    if (_dir == null) {
      _dir = (await getApplicationDocumentsDirectory()).path;
      assetFileDirectory =  File(_dir);
      print(_dir);
    }

    if (!await hasToDownloadAssets(name, _dir)) {
      print('assets already downloaded');
      needToDownload = false;
      return; //exits the method
    }
    needToDownload = true; //if the above did not return then it will start to download
    print('calling time zipped file to download');
    File zippedFile = await downloadFile(assetDownloadUrl, filename: name);
    // print('zip files received, proceeding to unzip');
    //
    // var bytes = zippedFile.readAsBytesSync();
    //   var archive = ZipDecoder().decodeBytes(bytes);
    //   print('UNZIPPING FILE NOW');
    //   zipCurrent=0;
    //   zipTotal = archive.length;
    //
    //   for (var file in archive) {
    //     var filename = '$_dir/${file.name}';
    //     print('filename = $filename');
    //     if (file.isFile) {
    //       var outFile = File(filename);
    //       outFile = await outFile.create(recursive: true);
    //       await outFile.writeAsBytes(file.content);
    //       setState(() {
    //         zipCurrent++;
    //         zipFileName = '$filename';
    //       });
    //     }
    // }
    // setState(() {
    //   needToDownload = true;
    // });
  }


  Future<bool> hasToDownloadAssets(String name, String dir) async {
    print('hasToDownloadAssets called');
    var file = File('$dir/$name');
    return !(await file.exists());
  }





  Future<File> downloadFile (String url, {String filename}) async {
    File fileR;
    var httpClient = http.Client();
    var request = http.Request('GET', Uri.parse(url));
    var response = httpClient.send(request);
    String dir = (await getApplicationDocumentsDirectory()).path;

    List<List<int>> chunks = List();
    downloaded = 0;

    response.asStream().listen((http.StreamedResponse r) {
      r.stream.listen((List<int> chunk) {
        //Display percentage of completion
        contLength = r.contentLength;
        //print('download Percentage: ${downloaded / r.contentLength * 100}');
        setState(() {
          progress = downloaded / r.contentLength;
          currentMB = (downloaded / 1000000.0);
          totalMB = r.contentLength / 1000000.0;
        });

        chunks.add(chunk);
        downloaded += chunk.length;
      },
          onDone: () async {
            //Display percentage of completion
            print('download Percentage: ${downloaded / r.contentLength *
                100} from onDONE');
            progress = downloaded / r.contentLength;
            //Save the file
            File file = File('$dir/$filename');
            final Uint8List bytes = Uint8List(r.contentLength);
            int offset = 0;
            for (List<int> chunk in chunks) {
              bytes.setRange(offset, offset + chunk.length, chunk);
              offset += chunk.length;
            }
            await file.writeAsBytes(bytes);
            fileR = file;
            print('file returned');

            var bytesN = file.readAsBytesSync();
            var archive = ZipDecoder().decodeBytes(bytesN);
            print('UNZIPPING FILE NOW');
            zipCurrent=0;
            zipTotal = archive.length;

            for (var file in archive) {
              var filename = '$_dir/${file.name}';
              //print('filename = $filename');
              if (file.isFile) {
                var outFile = File(filename);
                outFile = await outFile.create(recursive: true);
                await outFile.writeAsBytes(file.content);
                setState(() {
                  zipCurrent++;
                  nameOfFilesInsideZip = '${file.name}';
                });
              }
            }
            setState(() {
              needToDownload = false;
            });


            return file;


          });
    });
    print('fileR returned');
    return fileR;
  }
  getLocalImageDir() async {
    print('getLocalImageFile called');
    String dir = (await getApplicationDocumentsDirectory()).path;
    dir += '/assets';
    //print('$dir/$name');
    currentAssetFolder = File(dir);
    print(File(dir));
  }






}
