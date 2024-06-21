import 'package:emploiflutter/frame_work/controller/filter_job_preference/filter_job_preference_controller.dart';
import 'package:emploiflutter/ui/utils/constant/app_string_constant.dart';
import 'package:emploiflutter/ui/utils/theme/theme.dart';

class DomainFilter extends ConsumerWidget {
  const DomainFilter({super.key});

  @override
  Widget build(BuildContext context,WidgetRef ref) {
    final filterJobPrefWatch = ref.watch(filterJobPreferenceController);
    return SingleChildScrollView(
      child: Wrap(
          spacing: 8,
          runSpacing: 3,
          children: List.generate(
            growable: true,
              domainList.length,
                  (index) {
                final filter = domainList[index];
                return FilterChip(
                    label: Text(filter),
                  onSelected: (selected) {
                      filterJobPrefWatch.addDomainToList(index: index,selected: selected, value: filter,);
                  },
                  selected: index == filterJobPrefWatch.selectedFilterDomainIndex,
                    );
              })),
    );
  }
}
