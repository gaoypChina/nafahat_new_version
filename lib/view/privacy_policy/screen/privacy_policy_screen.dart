

import 'package:perfume_store_mobile_app/privacy_policy.dart';
import 'package:perfume_store_mobile_app/view/teems_and_conditions.dart';

import '../../../services/app_imports.dart';

class PrivacyPolicyScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Column(
        children: [
          SizedBox(height: 60.h,),
          Row(
            children: [
              IconButton(onPressed: (){Get.back();}, icon: Icon(Icons.arrow_back)),
              CustomText('privacy_policy_value'.tr,fontSize: 15.sp,),
            ],
          ),
          SizedBox(height: 10.h,),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: CustomText(privacyPolicies,fontSize: 13.sp,fontWeight: FontWeight.normal,),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
