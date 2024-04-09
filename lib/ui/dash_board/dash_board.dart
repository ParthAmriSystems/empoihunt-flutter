import 'package:emploiflutter/frame_work/repository/services/hive_service/box_service.dart';
import 'package:emploiflutter/ui/utils/app_constant.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../frame_work/controller/dash_board_controller/dash_board_controller.dart';
import '../../frame_work/repository/services/ze_go_cloud_service/ze_go_cloud_service.dart';
import '../utils/theme/app_color.dart';
import '../utils/theme/theme.dart';

class DashBoard extends ConsumerStatefulWidget {
  const DashBoard({super.key});

  @override
  ConsumerState<DashBoard> createState() => _DashBoardState();
}

class _DashBoardState extends ConsumerState<DashBoard> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    final user = BoxService.boxService.userGetDetailBox.get(userDetailKey)!;
    ZeGoCloudService.service.onUserLogin(user);

    print("-------------------------------------------Dash Board User Details-----------------------------------------------");
    print(user.user.vFirebaseId.toString());
    print(user.user.tUpadatedAt);
    print(user.user.id);
    print(user.user.iRole);
    print(user.user.vFirstName);
    print(user.user.vLastName);
    print(user.user.tProfileUrl);
    print(user.tAuthToken);
  }
  @override
  Widget build(BuildContext context) {
    final dashBoardWatch  = ref.watch(dashBoardController);
    final userData = BoxService.boxService.userGetDetailBox.get(userDetailKey);
    return PopScope(
      canPop: dashBoardWatch.isExitApp,
      onPopInvoked: (didPop) async{
        dashBoardWatch.updateIsExitApp(true);
        Fluttertoast.showToast(
            msg: "Please again to close app",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0
        );
        await Future.delayed(Duration(seconds: 2),(){
          dashBoardWatch.updateIsExitApp(false);
        });
      },
      child: Scaffold(
        body: userData!.user.iRole  == 0 ? dashBoardWatch.jobSeekerPages[dashBoardWatch.selectedIndex] : dashBoardWatch.recruiterPages[dashBoardWatch.selectedIndex],
        bottomNavigationBar: BottomNavigationBar(
          selectedItemColor: AppColors.colors.clayColors,
          unselectedItemColor: AppColors.colors.blueColors,
          items: userData.user.iRole  == 0?
          [
             const BottomNavigationBarItem(
               icon: Icon(Icons.home),
               label: "Home"
             ),
            BottomNavigationBarItem(
                icon: Icon(Icons.location_city_outlined ),
                label: "Campus"
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.rocket ),
                label: "AI"
            ),
            const BottomNavigationBarItem(
                icon: Icon(Icons.settings),
                label: "Setting"
            ),
          ]:
          [
             const BottomNavigationBarItem(
               icon: Icon(Icons.home),
               label: "Home"
             ),
            BottomNavigationBarItem(
                icon: Icon(Icons.add_box_sharp),
                label: "Post"
            ),
            const BottomNavigationBarItem(
                icon: Icon(Icons.settings),
                label: "Setting"
            ),
          ],
          showUnselectedLabels: false,
          currentIndex: dashBoardWatch.selectedIndex,
          onTap: (index){
            dashBoardWatch.updateSelectedIndex(index);
          },
        ),
      ),
    );
  }
}
