import 'package:emploiflutter/frame_work/repository/services/shared_pref_services.dart';
import 'package:emploiflutter/ui/utils/constant/app_constant.dart';
import 'package:emploiflutter/ui/utils/common_widget/common_appbar.dart';
import 'package:emploiflutter/ui/utils/theme/theme.dart';
import 'package:webview_flutter/webview_flutter.dart';

class TermsAndCondition extends ConsumerWidget {
  const TermsAndCondition({super.key});

  @override
  Widget build(BuildContext context,WidgetRef ref) {
    // final termsPrivacyWatch = ref.watch(termsPrivacyPolicyController);
    WebViewController webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.disabled)
      ..loadHtmlString(SharedPrefServices.services.getString(termsAndConditionStringKey));
    // ..loadRequest(Uri.parse('https://flutter.dev'));
    return Scaffold(
      appBar: const CommonAppBar(title: "Terms And Condition",isLeadingShow: true,),
      body: WebViewWidget(
        controller: webViewController,),
    );
  }
}
