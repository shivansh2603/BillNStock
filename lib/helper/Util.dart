import 'package:bill_n_stock/helper/content_exts.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

Route smoothRoute(Widget page) {
  return PageRouteBuilder(
    transitionDuration: const Duration(milliseconds: 400),
    pageBuilder: (_, animation, __) => page,
    transitionsBuilder: (_, animation, __, child) {
      final slide = Tween<Offset>(
        begin: const Offset(0.0, 0.08),
        end: Offset.zero,
      ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOutCubic));

      final fade = Tween<double>(begin: 0.0, end: 1.0).animate(animation);

      return FadeTransition(
        opacity: fade,
        child: SlideTransition(position: slide, child: child),
      );
    },
  );
}

class Util {
  static void showError(BuildContext context, String errorMessage) async {
    // final customTheme = Theme.of(context).extension<CustomThemeData>();
    if (errorMessage.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            errorMessage,
            style: TextStyle(
              fontSize: context.getFontSize(14),

              color: Colors.white,
            ),
          ),
          action: SnackBarAction(
            textColor: Colors.white,
            label: "Dismiss",
            onPressed: ScaffoldMessenger.of(context).hideCurrentSnackBar,
          ),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  bool ActiveConnection = false;
  String T = "";
  // Future<bool> isNetworkConnected() async {
  //   var connectivityResult = await Connectivity().checkConnectivity();

  //   return !(connectivityResult.isEmpty ||
  //       connectivityResult.contains(ConnectivityResult.none));
  //   // try {
  //   //   final result = await InternetAddress.lookup('google.com');
  //   //   if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
  //   //     ActiveConnection = true;
  //   //     T = "Turn off the data and repress again";
  //   //   }
  //   // } on SocketException catch (_) {
  //   //   ActiveConnection = false;
  //   //   T = "Turn On the data and repress again";
  //   // }
  //   // return ActiveConnection;
  // }
  Future<bool> isNetworkConnected() async {
    final result = await Connectivity().checkConnectivity();
    return result != ConnectivityResult.none;
  }

  static navigatorPop(BuildContext context) {
    Navigator.pop(context);
  }

  static String formatGramToKg(double gram) {
    final kg = gram / 1000;
    return "${kg.toStringAsFixed(2)} kg";
  }

  // static String parseHtmlString(String htmlString) {
  //   final document = html_parser.parse(htmlString);
  //   return document.body?.text ?? '';
  // }

  static String separateDigits(String mobileNumber) {
    return mobileNumber.split('').join(', ');
  }

  static void snackBarNew(String message) {
    Fluttertoast.showToast(
      msg: message,
      gravity: ToastGravity.BOTTOM,
      toastLength: Toast.LENGTH_SHORT,
    );
  }

  static void snackBar(BuildContext context, String content) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          content,
          style: TextStyle(fontSize: context.getFontSize(14)),
        ),
      ),
    );
  }

  static bool isContextValid(BuildContext context) {
    try {
      // This will throw if context is invalid
      return context.owner != null;
    } catch (_) {
      return false;
    }
  }

  static Future<String> fileToBase64String(File file) async {
    Uint8List bytes = await file.readAsBytes();

    return base64.encode(bytes);
  }

  // static Future<String> xFileToBase64String(XFile file) async {
  //   Uint8List bytes = await file.readAsBytes();
  //   return base64Encode(bytes);
  // }

  // static Future<bool> checkCameraPermission(BuildContext context) async {
  //   if (Platform.isIOS) {
  //     var status = await Permission.camera.status;
  //     if (status.isPermanentlyDenied) {
  //       showCustomDialog(context,
  //           title: "Camera services disabled",
  //           message:
  //               "Please enable camera services in settings to capture photo for profile picture or siganature photo or farm photo for survey.",
  //           okBtnText: "Go to Settings",
  //           cancelBtnText: "Cancel", okBtnFunction: (flag) {
  //         if (flag) {
  //           openAppSettings();
  //         }
  //       });
  //       return false;
  //     }
  //   }
  //   return true;
  // }

  // static String removeInlineStyles(String html) {
  //   final document = htmlParser.parse(html);
  //   document.querySelectorAll('[style]').forEach((element) {
  //     element.attributes.remove('style');
  //   });
  //   return document.body?.innerHtml ?? "";
  // }

  static void showCustomDialog(
    BuildContext context, {
    required String title,
    required String message,
    String okBtnText = "Ok",
    String cancelBtnText = "Cancel",
    required Function okBtnFunction,
  }) {
    // final customTheme = Theme.of(context).extension<CustomThemeData>();
    showDialog(
      barrierColor: (Colors.black).withOpacity(0.3),
      context: context,
      builder: (_) {
        return AlertDialog(
          title: Text(
            title,
            style: TextStyle(fontSize: context.getFontSize(14)),
          ),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [Text(message)],
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                okBtnText,
                style: TextStyle(fontSize: context.getFontSize(12)),
              ),
              onPressed: () {
                okBtnFunction(true);
                Navigator.pop(context);
              },
            ),
            TextButton(
              child: Text(
                cancelBtnText,
                style: TextStyle(fontSize: context.getFontSize(12)),
              ),
              onPressed: () {
                okBtnFunction(false);
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  static void scrollToFirstInvalidate(
    BuildContext context,
    Map<String, GlobalKey<FormFieldState>> fieldKeys,
    ScrollController scrollController,
  ) async {
    for (int i = 0; i < fieldKeys.length; i++) {
      var key = fieldKeys.keys.toList()[i];
      var currentFieldKey = fieldKeys[key];
      var currentState = fieldKeys[key]!.currentState;
      if (currentState != null) {
        if (!currentState.validate()) {
          RenderBox renderBox =
              currentFieldKey!.currentContext!.findRenderObject() as RenderBox;

          // Convert local coordinates to global coordinates
          Offset widgetOffset = renderBox.localToGlobal(Offset.zero);

          // Get the screen height
          double screenHeight = MediaQuery.of(context).size.height;

          // Compare widget's y-coordinate with screen bounds
          if (widgetOffset.dy < 100 || widgetOffset.dy > screenHeight) {
            Scrollable.ensureVisible(
              currentFieldKey.currentContext!,
              duration: const Duration(seconds: 1),
            );
            await Future.delayed(const Duration(seconds: 1));
            if (scrollController.hasClients) {
              scrollController.animateTo(
                scrollController.offset - 40,
                duration: const Duration(milliseconds: 1000),
                curve: Curves.ease,
              );
            }
            break;
          }
        }
      }
    }
  }

  // static Future<bool> checkGalleryPermission(BuildContext context) async {
  //   if (Platform.isIOS) {
  //     var status = await Permission.camera.status;
  //     if (status.isPermanentlyDenied) {
  //       showCustomDialog(context,
  //           title: "Photos services disabled",
  //           message:
  //               "Please enable photos services in settings to select photos for profile picture or siganature photo or farm photo for survey.",
  //           okBtnText: "Go to Settings",
  //           cancelBtnText: "Cancel", okBtnFunction: (flag) {
  //         if (flag) {
  //           openAppSettings();
  //         }
  //       });
  //       return false;
  //     }
  //   }
  //   return true;
  // }

  // static Future<void> openUrl(
  //     String url, BuildContext context, String title) async {
  //   if (url.isNotEmpty) {
  //       if (await Util().isNetworkConnected()) {
  //         Navigator.pushNamed(context, documentViewRoute,arguments:ScreenArguments(title, "$imageUrl$url"));
  //         debugPrint("document: https://smart-ms-cboapi.smart-mh.org/CBOAttachments/$url");
  //         debugPrint("isvalid");
  //       } else {
  //         Util.showError(
  //             context, AppLocalizations.of(context)?.no_internet_connection ?? "");
  //       }
  //   }
  // }

  // static Future<void> openDocumentUrl(
  //     String url, BuildContext context, String title) async {
  //   if (url.isNotEmpty) {
  //     bool validURL = Uri.parse(url).isAbsolute;
  //     if (validURL) {
  //       if (await Util().isNetworkConnected()) {
  //         Navigator.pushNamed(context, documentViewRoute,arguments:ScreenArguments(title, url));
  //         debugPrint("Document: $url");
  //       } else {
  //         Util.showError(
  //             context, AppLocalizations.of(context)?.no_internet_connection ?? "");
  //       }
  //     } else {
  //       Navigator.pushNamed(context, fullImageViewRoute,arguments:ScreenArguments(title, url));
  //       debugPrint("image : $url");
  //     }
  //   }
  // }

  // static CachedNetworkImage setRemoteImg(String url) {
  //   return CachedNetworkImage(
  //     imageUrl: url,
  //     placeholder: (context, url) => Container(),
  //     errorWidget: (context, url, error) => Container(),
  //     fit: BoxFit.fitWidth,
  //     // memCacheHeight: 100,
  //     // memCacheWidth: 100,
  //     width: double.infinity,
  //     height: double.infinity,
  //   );

  //   //   CachedNetworkImage(
  //   //   placeholder: (context, url) => const CircularProgressIndicator(),
  //   //   color: Color.fromARGB(0, 0, 0, 0),
  //   //   imageUrl: url,
  //   //   errorWidget:(context, url, error) => Icon(Icons.error),
  //   // );
  // }

  // static Future<String?> findLocalPath() async {
  //   String? dirloc;
  //   if (Platform.isAndroid) {
  //     dirloc = "/sdcard/download/";
  //   } else {
  //     var dir = await getApplicationDocumentsDirectory();
  //     dirloc = dir.path; //(await getTemporaryDirectory()).path;
  //   }
  //   return dirloc;
  // }

  // static Future<String> saveDoc(
  //     String docurl, BuildContext context, String fileName) async {
  //   if (await checkPermission()) {
  //     var url = docurl;

  //     var localPath = await findLocalPath();
  //     if (localPath == null) {
  //       Util.snackBar(context,
  //           "Could not access local storage for download. Please try again.");
  //       return "";
  //     }

  //     return await downloadFile(context, url, basename(url), localPath);
  //   } else {
  //     return "";
  //   }
  // }

  static Future<String> downloadFile(
    BuildContext context,
    String url,
    String fileName,
    String dir,
  ) async {
    HttpClient httpClient = new HttpClient();
    File file;
    String filePath = '';

    try {
      var request = await httpClient.getUrl(Uri.parse(url));
      var response = await request.close();
      if (response.statusCode == 200) {
        var bytes = await consolidateHttpClientResponseBytes(response);
        filePath = '$dir/$fileName';
        file = File(filePath);
        await file.writeAsBytes(bytes);
      } else
        filePath = 'Error code: ' + response.statusCode.toString();
    } catch (ex) {
      filePath = 'Can not fetch url';
    }

    return filePath;
  }

  // static Future<bool> checkPermission() async {
  //   if (Platform.isAndroid) {
  //     PermissionStatus status;
  //     // final status = await Permission.storage.status;
  //     final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
  //     final AndroidDeviceInfo info = await deviceInfoPlugin.androidInfo;

  //     if ((info.version.sdkInt) >= 33) {
  //       status = await Permission.manageExternalStorage.request();
  //     } else {
  //       status = await Permission.storage.request();
  //     }

  //     if (status != PermissionStatus.granted) {
  //       final result = await Permission.storage.request();
  //       if (result == PermissionStatus.granted) {
  //         return true;
  //       }
  //     } else {
  //       return true;
  //     }
  //   } else {
  //     var status = await Permission.storage.status;
  //     if (!status.isGranted) {
  //       // If not we will ask for permission first
  //       await Permission.storage.request();
  //     }
  //     return true;
  //     // var permission = Permission.photos;
  //     // if (await permission.isGranted) {
  //     //   return true;
  //     // } else {
  //     //   var result = await permission.request();
  //     //   if (result == PermissionStatus.pe) {
  //     //     return true;
  //     //   }else{
  //     //   await openAppSettings();
  //     //   }
  //     // }
  //   }
  //   return false;
  // }

  // static String pointsToWKT(List<LatLng> points) {
  //   final latLngBuffer = StringBuffer();
  //   for (int index = 0; index < points.length; index++) {
  //     latLngBuffer
  //         .write('${points[index].longitude} ${points[index].latitude}');

  //     latLngBuffer.write(', ');
  //   }
  //   if (points.isNotEmpty) {
  //     latLngBuffer.write('${points.first.longitude} ${points.first.latitude}');
  //   }
  //   return "POLYGON(($latLngBuffer))";
  // }

  // static List<List<LatLng>> toListOfLatLngsList(String wkt) {
  //   if (wkt == "" || wkt == "null") {
  //     return [];
  //   }
  //   if (wkt.contains("MULTIPOLYGON")) {
  //     var newString =
  //         wkt.replaceAll("MULTIPOLYGON(((", "").replaceAll(")))", "");

  //     var points = newString.split(")),");
  //     List<List<LatLng>> latLong = points.map((e) {
  //       var polygonPoints = e.split(",");

  //       List<LatLng> latLongs = polygonPoints.map((e1) {
  //         var tempArr = e1.replaceAll("((", "").trim().split(" ");

  //         if (tempArr.length == 2) {
  //           return LatLng(
  //               double.parse(tempArr.last), double.parse(tempArr.first));
  //         } else {
  //           return const LatLng(0, 0);
  //         }
  //       }).toList();
  //       return latLongs;
  //     }).toList();

  //     return latLong;
  //   } else {
  //     return [wktToPoints(wkt)];
  //   }
  // }

  // static List<LatLng> wktToPoints(String wkt) {
  //   if (wkt.isEmpty) {
  //     return [];
  //   }
  //   var newString = wkt.replaceAll("POLYGON((", "").replaceAll("))", "");

  //   var points = newString.split(",");
  //   List<LatLng> latLong = points.map((e) {
  //     var tempArr = e.trim().split(" ");
  //     if (tempArr.length == 2) {
  //       return LatLng(double.parse(tempArr.last), double.parse(tempArr.first));
  //     } else {
  //       return const LatLng(0, 0);
  //     }
  //   }).toList();
  //   return latLong;
  // }

  // static void openPhoneApp(String phoneNumber) async {
  //   final phoneUrl = Uri.parse("tel://+91$phoneNumber");
  //   try {
  //     if (await canLaunchUrl(phoneUrl)) {
  //       await launchUrl(phoneUrl);
  //     } else {
  //       final intent = AndroidIntent(
  //         action: 'android.intent.action.DIAL',
  //         data: 'tel:+91$phoneNumber',
  //       );

  //       await intent.launch();
  //       // throw 'Could not launch $phoneNumber';
  //     }
  //   } catch (error) {
  //     // log(error.toString());
  //   }
  //   // final res = await FlutterPhoneDirectCaller.callNumber(phoneNumber);
  // }

  // (int, double)? getMostContainMatchText(
  //     List<String> array, String searchText) {
  //   var searchWords = searchText.split(RegExp(r'\s+')).toSet();

  //   double maxMatchCount = 0;
  //   int? maxMatchIndex;
  //   String mostContainMatchText = '';
  //   int mostContainMatchIndex = 0;

  //   // Iterate through each element in the array.
  //   for (int i = 0; i < array.length; i++) {
  //     double currentDistance =
  //         (StringSimilarity.compareTwoStrings(searchText, array[i]));

  //     // If the current element has more matches than any previous element, update the maximum.
  //     if (currentDistance > maxMatchCount) {
  //       maxMatchCount = currentDistance;
  //       maxMatchIndex = i;
  //       mostContainMatchText = array[i];
  //       mostContainMatchIndex = i;
  //     }
  //   }

  //   debugPrint(
  //       'Most contain match text: "$mostContainMatchText" at index: $maxMatchIndex lowest : $maxMatchCount');
  //   if (maxMatchCount != 0) {
  //     return (mostContainMatchIndex, maxMatchCount);
  //   } else {
  //     return null;
  //   }
  // }

  // static void showLanguageNotInstalledDialog() async {
  //   showDialog(
  //     // barrierColor: (customTheme?.black ?? Colors.black).withOpacity(0.3),
  //     context: rootNavigatorKey.currentContext!,
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         title: Text("Language Not Installed"),
  //         content: Text(
  //             "The selected language is not installed. Please install it from the settings."),
  //         actions: <Widget>[
  //           TextButton(
  //             child: Text("Go to Settings"),
  //             onPressed: () async {
  //               Navigator.of(context).pop();

  //               if (Platform.isAndroid) {
  //                 try {
  //                   AndroidIntent intent = AndroidIntent(
  //                     action: 'com.android.settings.TTS_SETTINGS',
  //                   );
  //                   await intent.launch();
  //                 } catch (error) {
  //                   // log(error.toString());
  //                 }
  //               }
  //             },
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }

  // static void showIntroVideoDialog(BuildContext context) {
  //   final customTheme = Theme.of(context).extension<CustomThemeData>();
  //   showGeneralDialog(
  //     barrierLabel: "Label",
  //     barrierDismissible: true,
  //     barrierColor: (customTheme?.black ?? Colors.black)
  //         .withOpacity(0.3), // Colors.black.withOpacity(0.5),
  //     transitionDuration: Duration(milliseconds: 700),
  //     context: context,
  //     pageBuilder: (context, anim1, anim2) {
  //       return Align(
  //         alignment: Alignment.bottomCenter,
  //         child: Container(
  //           child: VideoBottomSheet(),
  //         ),
  //       );
  //     },
  //     transitionBuilder: (context, anim1, anim2, child) {
  //       return SlideTransition(
  //         position:
  //             Tween(begin: Offset(0, 1), end: Offset(0, 0)).animate(anim1),
  //         child: child,
  //       );
  //     },
  //   );
  // }

  // static List<LatLng> wktToPointsNew(String wkt) {
  //   if (wkt.isEmpty) {
  //     return [];
  //   }
  //   /*if (wkt.contains("MULTIPOLYGON")) {
  //     var newString =
  //     wkt.replaceAll("MULTIPOLYGON(((","").replaceAll(")))", "");

  //     var points = newString.split(")),");
  //     List<List<LatLng>> latLong = points.map((e) {
  //       var polygonPoints = e.split(",");

  //       List<LatLng> latLongs = polygonPoints.map((e1) {
  //         var tempArr = e1.replaceAll("((","").trim().split(" ");

  //         if (tempArr.length == 2) {
  //           return LatLng(
  //               double.parse(tempArr.last), double.parse(tempArr.first));
  //         } else {
  //           return const LatLng(0, 0);
  //         }
  //       }).toList();
  //       return latLongs;
  //     }).toList();

  //     return latLong.firstOrNull ?? [];
  //   } */
  //   if (wkt.contains("MULTIPOLYGON")) {
  //     final newString =
  //         wkt.replaceAll("MULTIPOLYGON(((", "").replaceAll(")))", "").trim();

  //     final points = newString.split(")),");
  //     List<List<LatLng>> latLong = points.map((poly) {
  //       final polygonPoints = poly.split(",");

  //       List<LatLng> latLngs = polygonPoints.map((rawPoint) {
  //         final cleaned =
  //             rawPoint.replaceAll("(", "").replaceAll(")", "").trim();
  //         final tempArr = cleaned.split(RegExp(r'\s+'));

  //         if (tempArr.length == 2) {
  //           final lon = double.tryParse(tempArr[0]);
  //           final lat = double.tryParse(tempArr[1]);

  //           if (lat != null && lon != null) {
  //             return LatLng(lat, lon);
  //           }
  //         }

  //         // If parse fails or input is bad
  //         return const LatLng(0, 0);
  //       }).toList();

  //       return latLngs;
  //     }).toList();

  //     return latLong.firstOrNull ?? [];
  //   } else {
  //     var newString = wkt.replaceAll("POLYGON ((", "").replaceAll("))", "");

  //     var points = newString.split(",");
  //     List<LatLng> latLong = points.map((e) {
  //       var tempArr = e.trim().split(" ");
  //       if (tempArr.length == 2) {
  //         return LatLng(
  //             double.parse(tempArr.last), double.parse(tempArr.first));
  //       } else {
  //         return const LatLng(0, 0);
  //       }
  //     }).toList();
  //     return latLong;
  //   }
  // }

  // static LatLng calculateCentroid(List<LatLng> points) {
  //   double lat = 0;
  //   double lng = 0;
  //   for (var point in points) {
  //     lat += point.latitude;
  //     lng += point.longitude;
  //   }
  //   lat /= points.length;
  //   lng /= points.length;

  //   return LatLng(lat, lng);
  // }

  // static Future<LatLng?> findNearestPointOnPolygon(
  //     List<LatLng> polygon, LatLng currentLocation) async {
  //   double minDistance = double.infinity;
  //   LatLng? nearestPoint;

  //   for (int i = 0; i < polygon.length; i++) {
  //     LatLng start = polygon[i];
  //     LatLng end = polygon[(i + 1) % polygon.length];
  //     LatLng closestPoint =
  //     getClosestPointOnSegment(start, end, currentLocation);
  //     double distance = calculateDistance(currentLocation, closestPoint);
  //     if (distance < minDistance) {
  //       minDistance = distance;
  //       nearestPoint = closestPoint;
  //     }
  //   }

  //   return nearestPoint;
  // }

  // static LatLng getClosestPointOnSegment(LatLng start, LatLng end, LatLng point) {
  //   double dx = end.latitude - start.latitude;
  //   double dy = end.longitude - start.longitude;

  //   if (dx == 0 && dy == 0) {
  //     return start;
  //   }

  //   double t = ((point.latitude - start.latitude) * dx +
  //       (point.longitude - start.longitude) * dy) /
  //       (dx * dx + dy * dy);

  //   if (t < 0) {
  //     return start;
  //   } else if (t > 1) {
  //     return end;
  //   }

  //   return LatLng(start.latitude + t * dx, start.longitude + t * dy);
  // }
  // static double  calculateDistance(LatLng point1, LatLng point2) {
  //   return Geolocator.distanceBetween(
  //     point1.latitude,
  //     point1.longitude,
  //     point2.latitude,
  //     point2.longitude,
  //   );
  // }

  // double calculateDistanceBetweenTwoPoints(
  //     double startLat, double startLong, double endLat, double endLong) {
  //   const double earthRadiusKm = 6372.8;

  //   double dLat = radians(endLat - startLat);
  //   double dLon = radians(endLong - startLong);
  //   double radStartLat = radians(startLat);
  //   double radEndLat = radians(endLat);

  //   double a = sin(dLat / 2) * sin(dLat / 2) +
  //       sin(dLon / 2) * sin(dLon / 2) * cos(radStartLat) * cos(radEndLat);
  //   double c = 2 * asin(sqrt(a));

  //   double haverdistanceKM = earthRadiusKm * c;
  //   debugPrint('haverdistanceKM: $haverdistanceKM');

  //   return haverdistanceKM * 1000; // Convert to meters
  // }

  // double radians(double degrees) {
  //   return degrees * pi / 180;
  // }

  // static bool pointInPolygon(LatLng point, List<LatLng> polygon) {
  //   int intersectCount = 0;
  //   for (int j = 0; j < polygon.length - 1; j++) {
  //     LatLng a = polygon[j];
  //     LatLng b = polygon[j + 1];

  //     if (_rayCastIntersect(point, a, b)) {
  //       intersectCount++;
  //     }
  //   }
  //   return (intersectCount % 2 == 1); // odd = inside
  // }

  // static bool _rayCastIntersect(LatLng point, LatLng vertA, LatLng vertB) {
  //   double aY = vertA.latitude;
  //   double bY = vertB.latitude;
  //   double aX = vertA.longitude;
  //   double bX = vertB.longitude;
  //   double pY = point.latitude;
  //   double pX = point.longitude;

  //   if ((aY > pY && bY > pY) || (aY < pY && bY < pY) || (aX < pX && bX < pX)) {
  //     return false;
  //   }

  //   double m = (aY - bY) / (aX - bX);
  //   double x = ((pY - bY) / m) + bX;

  //   return x > pX;
  // }

  // static Future<Marker> createCustomMarker(
  //   LatLng position,
  //   String text,
  //   int padding,
  //   double fontSize,
  //   Color fontColor,
  // ) async {
  //   const double arrowHeight = 10.0;
  //   const double arrowWidth = 16.0;

  //   // 1. Prepare the text painter
  //   final textSpan = TextSpan(
  //     text: text,
  //     style: TextStyle(
  //       fontSize: fontSize,
  //       color: fontColor,
  //       height: 1.2,
  //       fontWeight: FontWeight.bold,
  //     ),
  //   );

  //   final textPainter = TextPainter(
  //     text: textSpan,
  //     textDirection: TextDirection.ltr,
  //     textAlign: TextAlign.center,
  //     maxLines: 3,
  //   );

  //   textPainter.layout();

  //   final width = textPainter.width + 2 * padding;
  //   final height = textPainter.height + 2 * padding + arrowHeight;

  //   // 2. Create the canvas
  //   final recorder = ui.PictureRecorder();
  //   final canvas = Canvas(
  //     recorder,
  //     Rect.fromLTWH(0, 0, width, height),
  //   );

  //   // 3. Draw rounded rectangle background
  //   final backgroundPaint = Paint()
  //     ..color = Colors.white.withOpacity(0.8)
  //     ..style = PaintingStyle.fill;

  //   final rRect = RRect.fromRectAndRadius(
  //     Rect.fromLTWH(0, 0, width, height - arrowHeight),
  //     const Radius.circular(8),
  //   );
  //   canvas.drawRRect(rRect, backgroundPaint);

  //   // 4. Draw the arrow
  //   final path = Path();
  //   final centerX = width / 2;
  //   path.moveTo(centerX - arrowWidth / 2, height - arrowHeight);
  //   path.lineTo(centerX + arrowWidth / 2, height - arrowHeight);
  //   path.lineTo(centerX, height);
  //   path.close();
  //   canvas.drawPath(path, backgroundPaint);

  //   // 5. Paint the text
  //   textPainter.paint(canvas, Offset(padding.toDouble(), padding.toDouble()));

  //   // 6. Convert to image and then to bytes
  //   final picture = recorder.endRecording();
  //   final img = await picture.toImage(width.toInt(), height.toInt());
  //   final byteData = await img.toByteData(format: ui.ImageByteFormat.png);
  //   final bytes = byteData!.buffer.asUint8List();

  //   // 7. Create and return the marker
  //   return Marker(
  //     markerId: MarkerId(position.toString()),
  //     position: position,
  //     icon: BitmapDescriptor.fromBytes(bytes),
  //     anchor: const Offset(0.5, 1), // bottom-center of marker
  //   );
  // }

  // static double roundTo(double value, int places) {
  //   double mod = Math.pow(10.0, places).toDouble();
  //   return ((value * mod).round().toDouble() / mod);
  // }

  // static void errorSnackBar(String content) {
  //   Get.snackbar('', content,
  //     snackPosition: SnackPosition.BOTTOM,
  //     backgroundColor: Colors.red,
  //     titleText: SizedBox(),
  //     colorText: Colors.white,);
  // }
  static void errorSnackBar(BuildContext context, String content) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          content,
          style: TextStyle(
            fontSize: context.getFontSize(14),

            backgroundColor: Colors.red,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  //   static List<LatLng> wktToPointsDcs(String wkt) {
  //     if (wkt.isEmpty) {
  //       return [];
  //     }
  //     if (wkt.contains("MULTIPOLYGON")) {
  //       var newString =
  //           wkt.replaceAll("MULTIPOLYGON(((", "").replaceAll(")))", "");

  //       var points = newString.split(")),");
  //       List<List<LatLng>> latLong = points.map((e) {
  //         var polygonPoints = e.split(",");

  //         List<LatLng> latLongs = polygonPoints.map((e1) {
  //           var tempArr = e1.replaceAll("((", "").trim().split(" ");

  //           if (tempArr.length == 2) {
  //             return LatLng(
  //                 double.parse(tempArr.last), double.parse(tempArr.first));
  //           } else {
  //             return const LatLng(0, 0);
  //           }
  //         }).toList();
  //         return latLongs;
  //       }).toList();

  //       return latLong.firstOrNull ?? [];
  //     } else {
  //       var newString = wkt.replaceAll("POLYGON ((", "").replaceAll("))", "");

  //       var points = newString.split(",");
  //       List<LatLng> latLong = points.map((e) {
  //         var tempArr = e.trim().split(" ");
  //         if (tempArr.length == 2) {
  //           return LatLng(
  //               double.parse(tempArr.last), double.parse(tempArr.first));
  //         } else {
  //           return const LatLng(0, 0);
  //         }
  //       }).toList();
  //       return latLong;
  //     }
  //   }

  //   static Future<void> getAppVersion() async {
  //     PackageInfo packageInfo = await PackageInfo.fromPlatform();

  //     // String appName = packageInfo.appName;
  //     // String packageName = packageInfo.packageName;
  //     apkVersion = packageInfo.version; // App version
  //     // String buildNumber = packageInfo.buildNumber; // Build number
  //     //
  //     // print("App Name: $appName");
  //     // print("Package Name: $packageName");
  //     // print("Version: $version");
  //     // print("Build Number: $buildNumber");
  //   }

  //   static Future<String?> getDeviceId() async {
  //     try {
  //       DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  //       AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
  //       return androidInfo.id; // This is the ANDROID_ID equivalent
  //     } on PlatformException {
  //       return null;
  //     }
  //   }
  // }

  Route smoothRoute(Widget page) {
    return PageRouteBuilder(
      transitionDuration: const Duration(milliseconds: 400),
      pageBuilder: (_, animation, __) => page,
      transitionsBuilder: (_, animation, __, child) {
        final slide =
            Tween<Offset>(
              begin: const Offset(0.0, 0.08),
              end: Offset.zero,
            ).animate(
              CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
            );

        final fade = Tween<double>(begin: 0.0, end: 1.0).animate(animation);

        return FadeTransition(
          opacity: fade,
          child: SlideTransition(position: slide, child: child),
        );
      },
    );
  }
}
