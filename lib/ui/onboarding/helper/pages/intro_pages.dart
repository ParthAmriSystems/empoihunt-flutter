
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lottie/lottie.dart';

import '../../../utils/theme/theme.dart';

class IntroPageView extends StatelessWidget {
  final IntroPageModel model;
  final List<Effect<dynamic>>? imgEffects;
  const IntroPageView({super.key, required this.model, this.imgEffects});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Animate(
          effects: imgEffects,
          child: Expanded(
            child: SizedBox(
                child: Image.asset(model.filePath,)),
          )
              // .animate().scale(duration: Duration(milliseconds: 700)),
        ),
        Text(textAlign: TextAlign.center,model.title,style: TextStyle(fontWeight: FontWeight.w700,fontSize: 20.sp,color: Colors.black),).animate().slide(duration: Duration(milliseconds: 700),),
        SizedBox(height: 8.h,),
        Text(textAlign: TextAlign.center,model.subtile,style: TextStyle(fontWeight: FontWeight.w700,fontSize: 14.sp,color: Colors.grey)).animate().slide(duration: Duration(milliseconds: 700)),
        SizedBox(height: 50.h,),
      ],
    );
  }
}


typedef IntroPageModel = ({String filePath, String title, String subtile});



class IntroLottiePageView extends StatelessWidget {
  final IntroPageModel model;
  final List<Effect<dynamic>>? imgEffects;
  final double? width;
  final double? height;
  const IntroLottiePageView({super.key, required this.model, this.imgEffects, this.width, this.height});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Animate(
            effects: imgEffects,
            child: Expanded(
              child: SizedBox(
              height: height??200.h,
                  width:width?? 300.w,
                  child: Lottie.asset(model.filePath,repeat: true)),
            )
          // .animate().scale(duration: Duration(milliseconds: 700)),
        ),
        Text(textAlign: TextAlign.center,model.title,style: TextStyle(fontWeight: FontWeight.w700,fontSize: 20.sp,color: Colors.black),).animate().slide(duration: Duration(milliseconds: 700),),
        SizedBox(height: 8.h,),
        Text(textAlign: TextAlign.center,model.subtile,style: TextStyle(fontWeight: FontWeight.w700,fontSize: 14.sp,color: Colors.grey)).animate().slide(duration: Duration(milliseconds: 700)),
        SizedBox(height: 50.h,),
      ],
    );
  }
}