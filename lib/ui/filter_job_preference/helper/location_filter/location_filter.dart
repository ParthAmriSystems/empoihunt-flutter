import 'package:emploiflutter/frame_work/controller/filter_job_preference/filter_job_preference_controller.dart';
import 'package:emploiflutter/frame_work/repository/services/shared_pref_services.dart';
import 'package:emploiflutter/ui/utils/constant/app_constant.dart';
import 'package:emploiflutter/ui/utils/theme/theme.dart';

class LocationFilter extends ConsumerWidget {
  const LocationFilter({super.key});

  @override
  Widget build(BuildContext context,WidgetRef ref) {
    final filterJobPrefWatch = ref.watch(filterJobPreferenceController);
    return SingleChildScrollView(
      child: Wrap(
          spacing: 8,
          runSpacing: 3,
          children: [
            if (SharedPrefServices.services.getList(locationListKey) !=null )
            ...List.generate(
                growable: true,
                SharedPrefServices.services.getList(locationListKey)!.length,
                // filterJobPrefWatch.domainList.length,
                    (index) {
                  // final filter = filterJobPrefWatch.domainList[index];
                  final filter = SharedPrefServices.services.getList(locationListKey)![index];
                  return FilterChip(
                    label: Text(filter),
                    onSelected: (selected) {
                      filterJobPrefWatch.addLocationToList(index: index,selected: selected, value: filter,);
                    },
                    selected: index == filterJobPrefWatch.selectedFilterLocationIndex,
                  );
                })
                else const Center(child: Text("No Data"),)
          ]),
    );
  }
}
