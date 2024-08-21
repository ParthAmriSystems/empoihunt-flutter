import 'dart:convert';
import 'package:emploiflutter/ui/utils/common_widget/helper.dart';
import 'package:emploiflutter/ui/utils/theme/theme.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

final aiForJobSeekerController = ChangeNotifierProvider((ref) => AiForJobSeekerController());

class AiForJobSeekerController extends ChangeNotifier{

  bool isLoading = false;
  ///----------------------- for selecting job department ------------------///
  final  TextEditingController jobDepartmentController = TextEditingController();
  bool isJobDepartmentSelect = true;
  String? selectedJobDepartment;
  updateJobDepartmentController(String? value) {
    selectedJobDepartment = value;
    isJobDepartmentSelect = true;
    notifyListeners();
  }

  ///----------------------- for selecting job department ------------------///

  final  TextEditingController expertiseController = TextEditingController();
  bool isExpertiseSelect = true;
  String? selectedExpertise;
  updateExpertiseController(String? value) {
    selectedExpertise = value;
    isExpertiseSelect = true;
    notifyListeners();
  }
  List<String> expertiseList = [];
  checkJobDepartment(){
    if(selectedJobDepartment == "IT"){
      expertiseList = [];
      selectedExpertise = null;
      expertiseList.addAll(itExpertise);
    }else if(selectedJobDepartment == "Finance"){
      expertiseList = [];
      selectedExpertise = null;
      expertiseList.addAll(financeExpertise);
    }else{
      expertiseList = [];
      selectedExpertise = null;
      expertiseList.addAll(marketingExpertise);
    }
    notifyListeners();
  }

  ///----------------------- for yearly experience ------------------///
  final  TextEditingController yearlyExperienceController = TextEditingController();
  bool isYearlyExpSelect = true;
  String? selectedYearlyEx;
  updateYearlyExperienceController(String? value) {
    selectedYearlyEx = value;
    isYearlyExpSelect = true;
    notifyListeners();
  }
  ///------------- Gemini At For Question answer  -------------///

  List<QNA> qnaList = [];

    updateIsExpandedTile(int index,bool value){
    qnaList[index].isExpanded = value;
    notifyListeners();
  }

  void submitButton(BuildContext context){
      if(selectedJobDepartment !=null){
        if(selectedExpertise != null){
          if(selectedYearlyEx != null){
            // rocketVisible = true;
            // loadingVisible = false;
            // notifyListeners();
           /* animationController.reset();
            animationController.forward().then((value) {
                rocketVisible = false;
                loadingVisible = true;
                aiSuggestQNA(context);
            });*/
            aiSuggestQNA(context);
          }else{
            isYearlyExpSelect = false;
          }
        }else{
          isExpertiseSelect = false;
        }
      }else{
        isJobDepartmentSelect = false;
      }
      notifyListeners();
  }

  Future<void> aiSuggestQNA(BuildContext context) async{
    qnaList = [];
    try{
      isLoading = true;
      notifyListeners();
      const apiKey = "AIzaSyByYoJEwnEtoj7smhyr12qNgCSYDtr3skg";
      final model = GenerativeModel(model: 'gemini-pro', apiKey: apiKey);
      String prompt = "i am in $selectedJobDepartment and i need more than 30 to 50 question answer related to $selectedExpertise as a experience of $selectedYearlyEx person. and question answer must be in pure json format";
      final content = [Content.text(prompt)];
      final response = await model.generateContent(content);
      final resul = response.text != null? response.text!.replaceAll("*", "").replaceAll("```", "").replaceAll("json", "").trim(): "";
      final data = jsonDecode(resul);
      for(dynamic i in data["questions"]){
        final d = QNA.fromJson(i);
        qnaList.add(d);
        print(d.question);
      }
      isLoading = false;
      notifyListeners();
    }catch(e){
      isLoading = false;
      appCommonShowToast(context: context, msg: "Something went wrong");
      clearData();
      notifyListeners();
      Future.error("Gemini error ${e.toString()}");
    }
  }

  /// Animation ///
 /* late AnimationController animationController;
  late Animation<double> animation;
  bool rocketVisible = false;
  bool loadingVisible = true;

  initializeAnimation({required TickerProvider vsync}){
    animationController =
        AnimationController(vsync: vsync, duration: Duration(seconds:5));
    animation = Tween(end: 1.0, begin: 0.0).animate(animationController);
  }*/
  /// Animation ///

  clearData(){
    expertiseController.clear();
    jobDepartmentController.clear();
    yearlyExperienceController.clear();
    selectedYearlyEx = null;
    selectedExpertise = null;
    selectedJobDepartment = null;
    qnaList= [];
    isJobDepartmentSelect=true;
    isExpertiseSelect=true;
    isYearlyExpSelect=true;
   /* rocketVisible = false;
    loadingVisible = true;*/
    notifyListeners();
  }

}

class QNA{

  final String? question;
  final String? answer;
   bool  isExpanded;
  QNA({this.answer,this.question,this.isExpanded = false});


  factory QNA.fromJson(Map<String, dynamic> json)=>QNA(
    answer: json["answer"],
    question: json["question"]
  );
}

List<String> itExpertise = [
  'Software Development',
  'Web Development',
  'Mobile App Development',
  'Data Science',
  'Machine Learning',
  'Artificial Intelligence',
  'Cybersecurity',
  'Network Administration',
  'Cloud Computing',
  'DevOps',
  'Database Management',
  'IT Project Management',
  'Information Systems Management',
  'User Experience (UX) Design',
  'User Interface (UI) Design',
  'IT Infrastructure Management',
  'IT Consulting',
  'IT Security Management',
  'Systems Analysis',
  'Enterprise Resource Planning (ERP) Implementation'
];

// Finance
List<String> financeExpertise = [
  'Financial Analysis',
  'Investment Management',
  'Financial Planning',
  'Risk Management',
  'Corporate Finance',
  'Accounting',
  'Financial Reporting',
  'Taxation',
  'Audit',
  'Portfolio Management',
  'Asset Management',
  'Wealth Management',
  'Financial Modeling',
  'Quantitative Analysis',
  'Compliance and Regulatory Affairs',
  'Treasury Management',
  'Financial Markets',
  'Insurance',
  'Mergers and Acquisitions (M&A)',
  'Corporate Governance'
];

// Marketing
List<String> marketingExpertise = [
  'Digital Marketing',
  'Content Marketing',
  'Social Media Marketing',
  'Search Engine Optimization (SEO)',
  'Search Engine Marketing (SEM)',
  'Email Marketing',
  'Influencer Marketing',
  'Brand Management',
  'Marketing Strategy',
  'Market Research',
  'Consumer Behavior Analysis',
  'Marketing Analytics',
  'Marketing Automation',
  'Public Relations (PR)',
  'Advertising',
  'Product Management',
  'Customer Relationship Management (CRM)',
  'Marketing Communications',
  'Event Marketing',
  'Retail Marketing'
];
