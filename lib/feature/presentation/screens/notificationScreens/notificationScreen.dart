import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:question_app/components/styles/textStyles.dart';
import 'package:question_app/feature/data/models/dataModels/notification_model.dart';
import 'package:question_app/utils/extensions/context_extensions.dart';
import 'package:question_app/utils/extensions/size.dart';
import 'package:question_app/utils/extensions/widget.dart';
import '../../../../../components/coreComponents/AppButton.dart';
import '../../../../../components/coreComponents/ImageView.dart';
import '../../../../../components/coreComponents/TextView.dart';
import '../../../../../components/styles/appColors.dart';
import '../../../../../components/styles/appImages.dart';
import '../../../../../components/styles/app_strings.dart';
import '../../../../components/coreComponents/appBar2.dart';
import '../../../../services/storage/preferences.dart';
import '../../controller/auth_ctrl.dart';


class Notificationscreen extends StatefulWidget {
  const Notificationscreen({super.key});

  @override
  State<Notificationscreen> createState() => _NotificationscreenState();
}

class _NotificationscreenState extends State<Notificationscreen> {
  List<String> todayNotifications = ['Joe', 'Albert'];
  List<String> lastWeekNotifications = ['Sarah', 'Bob', 'Emma'];


  @override
  void initState() {
    // TODO: implement initState
    super.initState();

   getData();
  }


  Future<void> showConfirmationDialog(BuildContext context, int index ,  bool isToday) async {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;

    bool? confirmDeletion = await showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return Stack(
          children: [
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
              child: Container(
                color: Colors.black.withOpacity(0.3),
              ),
            ),
            AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              backgroundColor: Colors.white,
              insetPadding: EdgeInsets.symmetric(horizontal: width * 0.1),
              contentPadding: EdgeInsets.zero,
              titlePadding: EdgeInsets.zero,
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(height: height * 0.02),
                    TextView(
                      text: "Delete?",
                      style: 24.txtBoldBlack,
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: height * 0.02),
                    Divider(
                      color: AppColors.Grey,
                      thickness: 1,
                      height: 1,
                    ),
                    SizedBox(height: height * 0.02),
                    TextView(
                      text: "Are you sure you want to delete this notification?",
                      textAlign: TextAlign.center,
                      style: 16.txtRegularBlack,
                      margin: EdgeInsets.only(top: height * 0.02),
                    ),
                  ],
                ),
              ),
              actionsAlignment: MainAxisAlignment.center,
              actions: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Flexible(
                        child: SizedBox(
                          height: height * 0.07,
                          child: AppButton(
                            radius: 25.sdp,
                            label: "Cancel",
                            labelStyle: 14.txtRegularBlack,
                            buttonColor: AppColors.white,
                            buttonBorderColor: AppColors.grey,
                            onTap: () {
                              Navigator.of(context).pop(false);
                            },
                            isFilledButton: false,
                          ),
                        ),
                      ),
                      SizedBox(width: width * 0.04),
                      Flexible(
                        child: SizedBox(
                          height: height * 0.07,
                          child: AppButton(
                            radius: 25.sdp,
                            label: "Delete",
                            labelStyle: 14.txtBoldWhite,
                            buttonColor: AppColors.btnColor,
                            onTap: () {
                              context.pop();
                            },
                            isFilledButton: false,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: height * 0.01),
              ],
            ),
          ],
        );
      },
    );
    if (confirmDeletion == true) {
      setState(() {
        if (isToday) {
          todayNotifications.removeAt(index);
        } else {
          lastWeekNotifications.removeAt(index);
        }
      });
    } else {
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        forceMaterialTransparency: true,
        centerTitle: true,
        backgroundColor: AppColors.white,
        elevation: 0,
        title: Text(  AppStrings.Notifications,),
        titleTextStyle: 24.txtBoldWhite,
        leading: GestureDetector(
          onTap: () {
            context.pop();
          },
          child: Icon(
            Icons.arrow_back_ios_new,
            color: AppColors.white,
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: 20.left + 20.right + 20.top,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // if (AuthCtrl.find.notificationModel.data!.isNotEmpty)
              //   Row(
              //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //     children: [
              //       TextView(
              //         margin: 3.right + 10.bottom+ 10.top,
              //         text: 'Today',
              //         style: 14.txtBoldWhite,
              //       ),
              //       TextView(
              //         margin: 3.right + 10.bottom + 10.top,
              //         text: AppStrings.markAll,
              //         style: 14.txtRegularWhite,
              //       )
              //     ],
              //   ),
          (AuthCtrl.find.notificationModel.data!.isNotEmpty)?Expanded(
                child: ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: AuthCtrl.find.notificationModel.data!.length,
                  itemBuilder: (BuildContext context, int index) {
                    double dragExtent = 0.0;
                    bool showDeleteIcon = false;

                    var notification = AuthCtrl.find.notificationModel.data![index];
                    return StatefulBuilder(
                      builder: (context, setState) {
                        return Stack(
                          children: [
                            if (showDeleteIcon)
                              Positioned.fill(
                                child: Align(
                                  alignment: Alignment.centerRight,
                                  child: AnimatedContainer(
                                    margin: 5.top + 5.bottom,
                                    duration: const Duration(milliseconds: 300),
                                    width: dragExtent.abs(),
                                    height: double.infinity,
                                    decoration: BoxDecoration(
                                      color: AppColors.red,
                                      borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(16),
                                        bottomLeft: Radius.circular(16),
                                      ),
                                    ),
                                    alignment: Alignment.center,
                                    child: Padding(
                                      padding: 20.left,
                                      child: GestureDetector(
                                        onTap: () {
                                          showConfirmationDialog(context, index, false);
                                        },
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Icon(Icons.delete,size: 30,)
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            GestureDetector(
                              onHorizontalDragUpdate: (details) {
                                setState(() {
                                  if (details.primaryDelta! < 0) {
                                    dragExtent = (dragExtent + details.primaryDelta!).clamp(-100.0, 0.0);
                                    showDeleteIcon = dragExtent < -30;
                                  }
                                });
                              },
                              onHorizontalDragEnd: (details) {
                                setState(() {
                                  if (dragExtent < -90) {
                                    dragExtent = -100.0;
                                  } else {
                                    dragExtent = 0.0;
                                    showDeleteIcon = false;
                                  }
                                });
                              },
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 300),
                                transform: Matrix4.translationValues(dragExtent, 0, 0),
                                child: NotificationItem(
                                  notification: notification,
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    );

                  },
                ),
              ):Expanded(child: Center(child: Text("No notification found",style:20.txtBoldWhite))),


            ],
          ),
        ),
      ),
    );
  }

  Future<void> getData() async {

    await AuthCtrl.find.getNotifications(Preferences.profile!.id.toString());
    setState(() {

    });

  }
}



class NotificationItem extends StatelessWidget {

  final Data notification;
  const NotificationItem({ super.key, required this.notification});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: 5.vertical,
      child: Container(
        height: 100,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: Colors.grey.withOpacity(0.5)),
        ),
        child: Padding(
          padding: 17.horizontal + 8.vertical,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: 8.top,
                          child: Row(
                            children: [
                              Icon(Icons.circle,color: AppColors.green,size: 6,),
                              10.width,
                              TextView(
                                text: notification.title.toString(),
                                style: 14.txtBoldBlack,
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: 8.top,
                          child: TextView(
                            text: AuthCtrl.find.timeAgo(notification.createdAt.toString()),
                            style: 12.txtRegularGrey,
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: 8.top,
                      child: Row(
                        children: [
                          Flexible(
                            child: TextView(
                              text: notification.message.toString(),
                              style: 12.txtRegularGrey,
                              maxlines: 2,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
