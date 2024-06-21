import 'package:emploiflutter/frame_work/controller/filter_job_preference/filter_job_preference_controller.dart';
import 'package:emploiflutter/ui/utils/constant/app_string_constant.dart';
import 'package:emploiflutter/ui/utils/theme/theme.dart';

class ModeFilter extends ConsumerWidget {
  const ModeFilter({super.key});

  @override
  Widget build(BuildContext context,WidgetRef ref) {
    final filterJobPrefWatch = ref.watch(filterJobPreferenceController);
    return Wrap(
        spacing: 8,
        runSpacing: 3,
        children: List.generate(modeList.length,
                (index) {
              final filter = modeList[index];
              return FilterChip(
                label: Text(filter),
                onSelected: (selected) {
                  filterJobPrefWatch.addModeToList(index: index,selected: selected, value: filter);
                },
                selected: index == filterJobPrefWatch.selectedFilterModeIndex,
              );
            }));
  }
}
