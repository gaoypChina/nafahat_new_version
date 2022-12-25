import 'package:perfume_store_mobile_app/controller/category_controller.dart';
import 'package:perfume_store_mobile_app/view/custom_widget/custom_button.dart';

import '../../../apies/category_apies.dart';
import '../../../services/app_imports.dart';
import '../../custom_widget/loading_efffect/loading_filter_category.dart';
import 'filter_result_screen.dart';

class FilterScreen extends StatefulWidget {
  @override
  State<FilterScreen> createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  CategoryController categoryController = Get.find();
  List<BrandModel> brandItems = [
    BrandModel('Aesthetica', false),
    BrandModel('Aesthetica', false),
    BrandModel('Aesthetica', false),
    BrandModel('Aesthetica', false),
  ];
  List<CategoryModel> categoryItems = [
    CategoryModel('قسم العطور', true),
    CategoryModel('قسم العناية البشرة', false),
    CategoryModel('قسم المكياج', false),
    CategoryModel('قسم العناية بالشعر', false),
  ];
  RangeValues values = const RangeValues(0, 1000);

  int? selectedCategoryId;
  String? selectedCategoryName;
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      CategoryApies.categoryApies.getCategoryData('0');
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(
        () {
          var category = categoryController.getCategoryData!.value.listCategoryResponse;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 83.h,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 35.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                        onTap: () {
                          Get.back();
                        },
                        child: Icon(
                          Icons.close,
                          size: 30.w,
                        ))
                  ],
                ),
              ),
              SizedBox(
                height: 12.h,
              ),
              Expanded(
                child: SingleChildScrollView(
                  physics:const BouncingScrollPhysics(),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 35.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomText(
                          'فرز حسب',
                          fontSize: 18.sp,
                        ),
                        Divider(
                          thickness: 2,
                          height: 29.h,
                        ),
                        // Column(
                        //   crossAxisAlignment: CrossAxisAlignment.start,
                        //   children: [
                        //     CustomText('الماركات', fontSize: 18.sp, fontWeight: FontWeight.normal),
                        //     SizedBox(
                        //       height: 18.h,
                        //     ),
                        //     CustomText(
                        //       'بحث في الماركات',
                        //       fontSize: 14.sp,
                        //       fontWeight: FontWeight.normal,
                        //       color: const Color(0xff9E9E9E),
                        //     ),
                        //     ListView.builder(
                        //       physics: const NeverScrollableScrollPhysics(),
                        //       shrinkWrap: true,
                        //       itemCount: brandItems.length,
                        //       itemBuilder: (context, index) {
                        //         return Row(
                        //           children: [
                        //             Checkbox(
                        //               value: brandItems[index].checked,
                        //               onChanged: (bool? value) {
                        //                 setState(() {
                        //                   brandItems[index].checked = value;
                        //                 });
                        //               },
                        //               activeColor: AppColors.primaryColor,
                        //             ),
                        //             CustomText(brandItems[index].brandName, fontSize: 16.sp, fontWeight: FontWeight.normal),
                        //           ],
                        //         );
                        //       },
                        //     ),
                        //   ],
                        // ),
                        // Divider(
                        //   thickness: 2,
                        //   height: 40.h,
                        // ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomText('السعر', fontSize: 18.sp, fontWeight: FontWeight.normal),
                            RangeSlider(
                                min: 0,
                                max: 1000,
                                activeColor: AppColors.primaryColor,
                                inactiveColor: const Color(0xffE4E4E4),
                                labels: RangeLabels(values.start.round().toString(), values.end.round().toString()),
                                values: values,
                                onChanged: (newValues) {
                                  setState(() => values = newValues);
                                  print(values.start.toInt());
                                  print(values.end.toInt());
                                }),
                            SizedBox(height: 5.h,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Container(
                                  alignment: Alignment.center,
                                  width: 61.w,
                                  height: 37.h,
                                  decoration: BoxDecoration(color: AppColors.greyBorder, borderRadius: BorderRadius.circular(8.r)),
                                  child: CustomText(values.start.round().toString(), fontSize: 16.sp, fontWeight: FontWeight.normal),
                                ),
                                Container(
                                  alignment: Alignment.center,
                                  width: 61.w,
                                  height: 37.h,
                                  decoration: BoxDecoration(color: AppColors.greyBorder, borderRadius: BorderRadius.circular(8.r)),
                                  child: CustomText(values.end.round().toString(), fontSize: 16.sp, fontWeight: FontWeight.normal),
                                ),
                              ],
                            )
                          ],
                        ),
                        Divider(
                          thickness: 2,
                          height: 54.h,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomText('القسم', fontSize: 18.sp, fontWeight: FontWeight.normal),
                            SizedBox(
                              height: 18.h,
                            ),
                            CustomText(
                              'بحث في الأقسام',
                              fontSize: 14.sp,
                              fontWeight: FontWeight.normal,
                              color: const Color(0xff9E9E9E),
                            ),
                            category == null ?const LoadingFilterCategory(): ListView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: category.length -1,
                              itemBuilder: (context, index) {
                                return Row(
                                  children: [
                                    Checkbox(
                                      value: selectedCategoryId == category[index].id,
                                      onChanged: (bool? value) {
                                        setState(() {
                                          selectedCategoryId = category[index].id;
                                          selectedCategoryName = category[index].name;
                                        });
                                      },
                                      activeColor: AppColors.primaryColor,
                                    ),
                                    CustomText(category[index].name, fontSize: 16.sp, fontWeight: FontWeight.normal),
                                  ],
                                );
                              },
                            ),
                          ],
                        ),
                        SizedBox(height: 40.h,),
                        CustomButton(
                          onTap: (){
                            if(selectedCategoryId!=null){
                              Get.to(()=>FilterResultScreen(
                                categoryName: selectedCategoryName,
                                categoryId: selectedCategoryId,
                                maxPrice: values.end.toInt(),
                                minPrice: values.start.toInt(),
                              ));
                            }else{
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(const SnackBar(content: Text('يرجى اختيار القسم')));
                            }
                          },
                          title:'عرض النتائج',
                          height: 60.h,
                        ),
                        SizedBox(height: 40.h,),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class BrandModel {
  String? brandName;
  bool? checked;

  BrandModel(this.brandName, this.checked);
}
class CategoryModel {
  String? categoryName;
  bool? checked;

  CategoryModel(this.categoryName, this.checked);
}