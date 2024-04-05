import 'package:flutter/material.dart';
import 'package:ftoast/ftoast.dart';
import 'package:panara_dialogs/panara_dialogs.dart';

///
import '../utils/strings.dart';
import '../../main.dart';

/// Empty Title & Subtite TextFields Warning
emptyFieldsWarning(context) {
  return FToast.toast(
    context,
    msg: MyString.oopsMsg,
    subMsg: "You must fill all Fields!",
    corner: 20.0,
    duration: 2000,
    padding: const EdgeInsets.all(20),
  );
}

/// Nothing Enter When user try to edit the current tesk
nothingEnterOnUpdateTaskMode(context) {
  return FToast.toast(
    context,
    msg: MyString.oopsMsg,
    subMsg: "You must edit the tasks then try to update it!",
    corner: 20.0,
    duration: 3000,
    padding: const EdgeInsets.all(20),
  );
}

/// No task Warning Dialog
dynamic warningNoTask(BuildContext context) {
  return PanaraInfoDialog.showAnimatedGrow(
    context,
    title: MyString.oopsMsg,
    message:
        "There is no Task For Delete!\n Try adding some and then try to delete it!",
    buttonText: "Okay",
    onTapDismiss: () {
      Navigator.pop(context);
    },
    panaraDialogType: PanaraDialogType.warning,
    customIcon: Icon(Icons.warning, color: Colors.orange,size: 50.0,), // Add custom icon here
  );
}

/// Delete All Task Dialog
dynamic deleteAllTask(BuildContext context) {
  return PanaraConfirmDialog.show(
    context,
    title: MyString.areYouSure,
    message:
        "Do You really want to delete all tasks? You will no be able to undo this action!",
    confirmButtonText: "Yes",
    cancelButtonText: "No",
    onTapCancel: () {
      Navigator.pop(context);
    },
    onTapConfirm: () {
      BaseWidget.of(context).dataStore.box.clear();
      Navigator.pop(context);
    },
    panaraDialogType: PanaraDialogType.error,
    barrierDismissible: false,
    customIcon: Icon(Icons.error, color: Colors.red,size: 50.0,),
    
  );
}

/// lottie asset address
String lottieURL = 'assets/lottie/1.json';
class PanaraInfoDialog {
  static void showAnimatedGrow(
    BuildContext context, {
    required String title,
    required String message,
    required String buttonText,
    required Function onTapDismiss,
    required PanaraDialogType panaraDialogType,
    Widget? customIcon, // Add a parameter for custom icon
  }) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          elevation: 0.0,
          backgroundColor: Colors.transparent,
          child: Container(
            padding: EdgeInsets.all(20.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20.0),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                customIcon ?? _buildDefaultIcon(panaraDialogType), // Use custom icon if provided
                SizedBox(height: 20.0),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10.0),
                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16.0,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 20.0),
                ElevatedButton(
                  onPressed: () {
                    onTapDismiss();
                  },
                  child: Text(
                    buttonText,
                    style: TextStyle(
                      fontSize: 16.0,
                      color: Colors.white,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange, // Change button color here
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 40.0, vertical: 12.0),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  static Widget _buildDefaultIcon(PanaraDialogType panaraDialogType) {
    IconData iconData;
    Color iconColor;

    switch (panaraDialogType) {
      case PanaraDialogType.warning:
        iconData = Icons.warning;
        iconColor = Colors.orange;
        break;
      case PanaraDialogType.error:
        iconData = Icons.error;
        iconColor = Colors.red;
        break;
      default:
        iconData = Icons.info;
        iconColor = Colors.blue;
    }

    return Icon(
      iconData,
      color: iconColor,
      size: 40.0,
    );
  }
}

class PanaraConfirmDialog {
  static void show(
    BuildContext context, {
    required String title,
    required String message,
    required String confirmButtonText,
    required String cancelButtonText,
    required Function onTapConfirm,
    required Function onTapCancel,
    required PanaraDialogType panaraDialogType,
    bool barrierDismissible = true,
    Widget? customIcon, // Add a parameter for custom icon
  }) {
    showDialog(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          elevation: 0.0,
          backgroundColor: Colors.transparent,
          child: Container(
            padding: EdgeInsets.all(20.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20.0),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                customIcon ?? _buildDefaultIcon(panaraDialogType), // Use custom icon if provided
                SizedBox(height: 20.0),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10.0),
                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16.0,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 20.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    ElevatedButton(
                      onPressed: () {
                        onTapCancel();
                      },
                      child: Text(
                        cancelButtonText,
                        style: TextStyle(
                          fontSize: 16.0,
                          color: const Color.fromARGB(255, 255, 0, 0),
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white, // Change button color to white
                        side: BorderSide(color: Colors.red), // Change button color here
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
                      ),
                    ),
                    SizedBox(width: 20.0),
                    ElevatedButton(
                      onPressed: () {
                        onTapConfirm();
                      },
                      child: Text(
                        confirmButtonText,
                        style: TextStyle(
                          fontSize: 16.0,
                          color: Colors.white,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red, // Change button color here
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  static Widget _buildDefaultIcon(PanaraDialogType panaraDialogType) {
    IconData iconData;
    Color iconColor;

    switch (panaraDialogType) {
      case PanaraDialogType.warning:
        iconData = Icons.warning;
        iconColor = Colors.orange;
        break;
      case PanaraDialogType.error:
        iconData = Icons.error;
        iconColor = Colors.red;
        break;
      default:
        iconData = Icons.info;
        iconColor = Colors.blue;
    }

    return Icon(
      iconData,
      color: iconColor,
      size: 60.0, // Increase icon size here
    );
  }
}

