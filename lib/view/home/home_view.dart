import 'package:ToDo/view/home/widgets/notification_controllerdart';
import 'package:animate_do/animate_do.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:flutter_slider_drawer/flutter_slider_drawer.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:lottie/lottie.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:share/share.dart';
import '../../main.dart';
import '../../models/task.dart';
import '../../utils/colors.dart';
import '../../utils/constanst.dart';
import '../../utils/strings.dart';
import '../../view/home/widgets/task_widget.dart';
import '../../view/tasks/task_view.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  GlobalKey<SliderDrawerState> dKey = GlobalKey<SliderDrawerState>();

  

  // Method to check the number of completed tasks
  int checkDoneTask(List<Task> tasks) {
    int count = 0;
    for (Task task in tasks) {
      if (task.isCompleted) {
        count++;
      }
    }
    return count;
  }
  
void scheduleRepeatedNotifications() {
  Duration repeatInterval = Duration(seconds: 14400); 
  DateTime initialTime = DateTime.now().add(Duration(minutes: 30, hours: 3));
  
 for (int i = 0; i < 10; i++) { 
  DateTime notificationTime = initialTime.add(repeatInterval * i); 
  Future.delayed(repeatInterval * i, () {
    AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: i.toInt() + 1, // Explicit conversion to 32-bit integer
        channelKey: "basic_channel",
        title: "Check your ToDo list!",
        body: "Stay organized with your tasks!",
      ),
    );
  });
}

}

 bool isReminderActivated = false;

void toggleReminder(bool activate) {
  setState(() {
    isReminderActivated = activate;
    if (isReminderActivated) {
      scheduleRepeatedNotifications();
    } else {
      cancelNotifications();
    }
  });
}

void cancelNotifications() {
  AwesomeNotifications().cancelAllSchedules();
}

void showReminderDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Daily Reminder'),
        content: Text('Would you like to activate the daily reminder?'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
           // toggleReminder(false);
              Navigator.of(context).pop();
            },
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              toggleReminder(true);
              Navigator.of(context).pop();
            },
            child: Text('Activate'),
          ),
        ],
      );
    },
  );
}

  @override
  Widget build(BuildContext context) {
    final base = BaseWidget.of(context);
    var textTheme = Theme.of(context).textTheme;

    return ValueListenableBuilder(
      valueListenable: base.dataStore.listenToTask(),
      builder: (ctx, Box<Task> box, Widget? child) {
        var tasks = box.values.toList();
        tasks.sort((a, b) => a.createdAtDate.compareTo(b.createdAtDate));

        return Scaffold(
  backgroundColor: Colors.white,
  floatingActionButton: Padding(
    padding: const EdgeInsets.only(bottom:  80.0,right: 11),
    child: FloatingActionButton(
      onPressed: () {
  showReminderDialog(context);
},
        backgroundColor: Color.fromARGB(255, 255, 152, 152), 
      child: Icon(Icons.notification_add),
      mini: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30.0), 
      ),
    ),
  ),
  body: Stack(
    children: [
      SliderDrawer(
        isDraggable: false,
        key: dKey,
        animationDuration: 1000,
        appBar: MyAppBar(drawerKey: dKey),
        slider: MySlider(),
        child: _buildBody(tasks, base, textTheme),
      ),
      Positioned(
        bottom: 16.0,
        right: 16.0,
        child: const FAB(),
      ),
    ],
  ),
);

      },
    );
  }

  SizedBox _buildBody(
    List<Task> tasks,
    BaseWidget base,
    TextTheme textTheme,
  ) {
    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.fromLTRB(55, 0, 0, 0),
            width: double.infinity,
            height: 100,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: 25,
                  height: 25,
                  child: CircularProgressIndicator(
                    valueColor: const AlwaysStoppedAnimation(Color(0xff4568dc),),
                    backgroundColor: Colors.grey,
                    value: tasks.isEmpty ? 0 : checkDoneTask(tasks) / tasks.length,
                  ),
                ),
                const SizedBox(width: 25),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(MyString.mainTitle, style: textTheme.headline1),
                    const SizedBox(height: 3),
                    Text(
                      "${checkDoneTask(tasks)} of ${tasks.length} tasks",
                      style: textTheme.subtitle1,
                    ),
                  ],
                )
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(top: 10),
            child: Divider(
              thickness: 2,
              indent: 100,
            ),
          ),
          SizedBox(
            width: double.infinity,
            height: 495,
            child: tasks.isNotEmpty
                ? ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    itemCount: tasks.length,
                    itemBuilder: (BuildContext context, int index) {
                      var task = tasks[index];
                      return Dismissible(
                        direction: DismissDirection.horizontal,
                        background: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(
                              Icons.delete_outline,
                              color: Colors.grey,
                            ),
                            SizedBox(width: 8),
                            Text(MyString.deletedTask, style: TextStyle(color: Colors.grey)),
                          ],
                        ),
                        onDismissed: (direction) {
                          base.dataStore.dalateTask(task: task);
                        },
                        key: Key(task.id),
                        child: TaskWidget(task: tasks[index]),
                      );
                    },
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FadeIn(
                        child: SizedBox(
                          width: 200,
                          height: 200,
                          child: Lottie.asset(
                            lottieURL,
                            animate: tasks.isNotEmpty ? false : true,
                          ),
                        ),
                      ),
                      FadeInUp(
                        from: 30,
                        child: const Text(MyString.doneAllTask),
                      ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}

class MySlider extends StatefulWidget {
  const MySlider({Key? key}) : super(key: key);

  @override
  _MySliderState createState() => _MySliderState();
}

class _MySliderState extends State<MySlider> {
 
  @override
  void initState() {
    AwesomeNotifications().setListeners(
        onActionReceivedMethod: NotificationController.onActionReceivedMethod,
        onNotificationCreatedMethod:
            NotificationController.onNotificationCreatedMethod,
        onNotificationDisplayedMethod:
            NotificationController.onNotificationDisplayedMethod,
        onDismissActionReceivedMethod:
            NotificationController.onDismissActionReceivedMethod);
    super.initState();
  }

  static const List<IconData> icons = [
    CupertinoIcons.home,
    Icons.share,
    CupertinoIcons.alarm,
    CupertinoIcons.escape,
  ];

  static const List<String> texts = [
    "Home",
    "Share",
    "Alert",
    "Log out",
  ];
DateTime scheduleTime = DateTime.now();

void scheduleRepeatedNotifications() {
  Duration repeatInterval = Duration(seconds: 14400); 
  DateTime initialTime = DateTime.now().add(Duration(minutes: 30, hours: 3));
  
 for (int i = 0; i < 10; i++) { 
  DateTime notificationTime = initialTime.add(repeatInterval * i); 
  Future.delayed(repeatInterval * i, () {
    AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: i.toInt() + 1, // Explicit conversion to 32-bit integer
        channelKey: "basic_channel",
        title: "Check your ToDo list!",
        body: "Stay organized with your tasks!",
      ),
    );
  });
}

}

 bool isReminderActivated = false;

void toggleReminder(bool activate) {
  setState(() {
    isReminderActivated = activate;
    if (isReminderActivated) {
      scheduleRepeatedNotifications();
    } else {
      cancelNotifications();
    }
  });
}

void cancelNotifications() {
  AwesomeNotifications().cancelAllSchedules();
}

 void showDailyReminderDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Daily Reminder'),
          content: Text('Would you like to activate the daily reminder?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                toggleReminder(false);
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                toggleReminder(true);
                Navigator.of(context).pop();
              },
              child: Text('Activate'),
            ),
          ],
        );
      },
    );
  }



void _shareApp(BuildContext context) {

  String appLink = 'https://ToDoappstorelink';
  Share.share(appLink, subject: 'Check out ToDo app!');
}




  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 35),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: MyColors.primaryGradientColor,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        children: [
          Center(
            child: Image.asset(
              'assets/img/ic5.png',
              width: 150,
              height: 140,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 8),
          Text("IDISC Planner", style: textTheme.headline2),
          Text("junior flutter devs", style: textTheme.headline3),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 30, horizontal: 10),
            width: double.infinity,
            height: 300,
            child: ListView.builder(
              itemCount: 4,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (ctx, i) {
                return InkWell(
              onTap: () {
  if (i == 1) {
    _shareApp(context);
  } else if (i == 2) {
    showDailyReminderDialog(context);
  } else if (i == 3) {
    Navigator.of(context).popUntil((route) => route.isFirst);
  } else {
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        transitionDuration: Duration(milliseconds: 700),
        pageBuilder: (context, animation, secondaryAnimation) => FadeTransition(
          opacity: animation,
          child: HomeView(),
        ),
      ),
    );
  }
},

                  child: Container(
                    margin: const EdgeInsets.all(5),
                    child: ListTile(
                      leading: Icon
(
                        icons[i],
                        color: Color.fromARGB(255, 255, 156, 156), 
                        size: 30,
                      ),
                      title: Row(
                        children: [
                          Text(
                            texts[i],
                            style: const TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
                          ),
                          if (i == 2) SizedBox(width: 20),
                          if (i == 2)
                            Row(
                          
                            ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class MyAppBar extends StatefulWidget {
  const MyAppBar({Key? key, required this.drawerKey}) : super(key: key);
  
  final GlobalKey<SliderDrawerState> drawerKey;

  @override
  State<MyAppBar> createState() => _MyAppBarState();
}

class _MyAppBarState extends State<MyAppBar> with SingleTickerProviderStateMixin {
  late AnimationController controller;
  bool isDrawerOpen = false;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  /// toggle for drawer and icon aniamtion
  void toggle() {
    setState(() {
      isDrawerOpen = !isDrawerOpen;
      if (isDrawerOpen) {
        controller.forward();
        widget.drawerKey.currentState!.openSlider();
      } else {
        controller.reverse();
        widget.drawerKey.currentState!.closeSlider();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var base = BaseWidget.of(context).dataStore.box;
    return SizedBox(
      width: double.infinity,
      height: 132,
      child: Padding(
        padding: const EdgeInsets.only(top: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            /// Animated Icon - Menu & Close
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: IconButton(
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  icon: AnimatedIcon(
                    icon: AnimatedIcons.menu_close,
                    progress: controller,
                    size: 40,
                  ),
                  onPressed: toggle),
            ),

            /// Delete Icon
            Padding(
              padding: const EdgeInsets.only(right: 20),
              child: GestureDetector(
                onTap: () {
                  base.isEmpty
                      ? warningNoTask(context)
                      : deleteAllTask(context);
                },
                child: const Icon(
                  CupertinoIcons.trash,
                  size: 40,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FAB extends StatefulWidget {
  const FAB({Key? key}) : super(key: key);

  @override
  _FABState createState() => _FABState();
}

class _FABState extends State<FAB> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    )..repeat(reverse: true);
    _animation = Tween<double>(begin: 1.0, end: 0.9).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          CupertinoPageRoute(
            builder: (context) => TaskView(
              taskControllerForSubtitle: null,
              taskControllerForTitle: null,
              task: null,
            ),
          ),
        );
      },
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return Transform.scale(
            scale: _animation.value,
            child: Material(
              borderRadius: BorderRadius.circular(15),
              elevation: 10,
              child: Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                     color: Color(0xff4568dc),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: const Center(
                  child: Icon(
                    Icons.add,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}
