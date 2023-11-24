import 'package:emploiflutter/ui/utils/common_widget/common_appbar.dart';
import 'package:emploiflutter/ui/utils/theme/theme.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../../frame_work/controller/setting_controller/terms_privacy_policy_controller/terms_privacy_policy_controller.dart';

class TermsAndCondition extends ConsumerWidget {
  const TermsAndCondition({super.key});

  @override
  Widget build(BuildContext context,WidgetRef ref) {
    final termsPrivacyWatch = ref.watch(termsPrivacyPolicyController);
    WebViewController webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.disabled)
      ..loadHtmlString(termsPrivacyWatch.termHtmlString);
    // ..loadRequest(Uri.parse('https://flutter.dev'));
    return Scaffold(
      appBar: const CommonAppBar(title: "Terms And Condition",isLeadingShow: true,),
      body: termsPrivacyWatch.termHtmlString.isEmpty ? const Center(
        child: CircularProgressIndicator(),) : WebViewWidget(
        controller: webViewController,),
    );
  }
}
