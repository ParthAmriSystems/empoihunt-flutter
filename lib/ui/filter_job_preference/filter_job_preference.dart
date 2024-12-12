import 'package:emploiflutter/frame_work/controller/filter_job_preference/filter_job_preference_controller.dart';
import 'package:emploiflutter/frame_work/repository/services/hive_service/box_service.dart';
import 'package:emploiflutter/ui/filter_job_preference/helper/domain_filter/domain_filter.dart';
import 'package:emploiflutter/ui/filter_job_preference/helper/location_filter/location_filter.dart';
import 'package:emploiflutter/ui/filter_job_preference/helper/mode_filter/mode_filter.dart';
import 'package:emploiflutter/ui/filter_job_preference/helper/package_filter/package_filter.dart';
import 'package:emploiflutter/ui/utils/constant/app_constant.dart';
import 'package:emploiflutter/ui/utils/common_widget/common_appbar.dart';
import 'package:emploiflutter/ui/utils/extension/context_extension.dart';
import 'package:emploiflutter/ui/utils/theme/app_color.dart';
import 'package:emploiflutter/ui/utils/theme/theme.dart';

import '../utils/theme/text_styles.dart';


class FilterJobPreference extends ConsumerStatefulWidget {
  const FilterJobPreference({super.key});

  @override
  ConsumerState<FilterJobPreference> createState() => _FilterJobPreferenceState();
}

class _FilterJobPreferenceState extends ConsumerState<FilterJobPreference> with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    ref.read(filterJobPreferenceController).tabController = TabController(length: 4, vsync: this,animationDuration: const Duration(milliseconds: 500));
  }
  @override
  Widget build(BuildContext context) {
    final filterJobPrefWatch = ref.watch(filterJobPreferenceController);
    final userData = BoxService.boxService.userGetDetailBox.get(userDetailKey)!.user;

    return  Scaffold(
      appBar:  CommonAppBar(title: "Filter Job Preference",isLeadingShow: true,actions: [IconButton(onPressed: ()async{
        if(userData.iRole == 0){
          context.pop();
          await filterJobPrefWatch.filterApiForJobSeeker(context);
        }else if(userData.iRole ==1){
          context.pop();
          await filterJobPrefWatch.filterApiForRecruiter(context);
        }
      }, icon: Icon(Icons.check,color: AppColors.colors.blackColors,))],),
      body: DefaultTabController(
        length:userData.iRole ==0? 4 : 3,
        animationDuration: Duration(milliseconds: 300),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            filterJobPrefWatch.selectedValue[0].value.isNotEmpty || filterJobPrefWatch.selectedValue[1].value.isNotEmpty || filterJobPrefWatch.selectedValue[2].value.isNotEmpty || filterJobPrefWatch.selectedValue[3].value.isNotEmpty?
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: List.generate(
                    filterJobPrefWatch.selectedValue.length, (index) {
                  final selected = filterJobPrefWatch.selectedValue[index];
                  return selected.value.isNotEmpty? Container(
                      padding: EdgeInsets.symmetric(horizontal: 10.w,vertical: 10.h),
                      margin: EdgeInsets.symmetric(horizontal: 10.w,vertical: 12.h),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.r),
                          color:AppColors.colors.blueColors
                      ),
                      child: Text(selected.value,style: TextStyles.w400.copyWith(fontSize: 12.sp,color: AppColors.colors.whiteColors),)):const SizedBox();
                }),
              ),
            ) :const SizedBox(),
            SizedBox(
              height: 45.h,
              width: MediaQuery.of(context).size.width,
              child:  TabBar(
                isScrollable: true,indicatorSize: TabBarIndicatorSize.label,
                indicatorColor: AppColors.colors.clayColors,
                labelColor: AppColors.colors.clayColors,
                tabAlignment: TabAlignment.start, padding: EdgeInsets.zero,
                unselectedLabelColor: AppColors.colors.blackColors,
                tabs:  userData.iRole  ==0?
                [Tab(child: Container(padding: EdgeInsets.symmetric(horizontal: 6.w),child: const Text("Domain"))),
                  Tab(child: Container(padding: EdgeInsets.symmetric(horizontal: 6.w),child: const Text("Location"))),
                  Tab(child: Container(padding: EdgeInsets.symmetric(horizontal: 6.w),child: const Text("Mode"))),
                  Tab(child: Container(padding: EdgeInsets.symmetric(horizontal: 6.w),child: const Text("Package"))),]
                    :
                [Tab(child: Container(padding: EdgeInsets.symmetric(horizontal: 22.w),child: const Text("Domain"))),
                  Tab(child: Container(padding: EdgeInsets.symmetric(horizontal: 22.w),child: const Text("Location"))),
                  Tab(child: Container(padding: EdgeInsets.symmetric(horizontal: 22.w),child: const Text("Mode"))),],
              ),
            ),
              Expanded(
              child: SizedBox(
                child: TabBarView(
                    children: userData.iRole  ==0?
                    [const DomainFilter(), const LocationFilter(), const ModeFilter(), const PackageFilter()]:
                    [const DomainFilter(), const LocationFilter(), const ModeFilter(),]
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
