import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';
import 'package:perfume_store_mobile_app/controller/product_controller.dart';

import '../../../apies/product_apies.dart';
import '../../../controller/category_controller.dart';
import '../../../services/app_imports.dart';

import '../../bottom_nav_screens/widget/perfume_product_item.dart';

import '../../custom_widget/loading_efffect/loading_product.dart';
import '../../custom_widget/loading_efffect/sliver_loading_product.dart';
import '../../filter/screens/filter_screen.dart';
import '../../perfume_details/screens/perfume_details_screen.dart';
import '../../search/screen/search_screen.dart';

class ShopByCategoryScreen extends StatefulWidget {
  final int? categoryId;
  final String? categoryName;
  final bool fullCategoryName;

  const ShopByCategoryScreen({super.key, this.categoryId, this.categoryName, this.fullCategoryName = false});

  @override
  State<ShopByCategoryScreen> createState() => _ShopByCategoryScreenState();
}

class _ShopByCategoryScreenState extends State<ShopByCategoryScreen> {
  CategoryController categoryController = Get.find();
  ProductController productController = Get.find();

  String? selectedDropDown = 'order_by_popularity_value'.tr;
  int _currentPage = 1;

  String? order;
  String? orderBy;

  void dropDown(String value) {
    if (value == 'order_by_popularity_value'.tr) {
      ProductApies.productApies
          .getProductByCategory(pageNumber: '1', category: widget.categoryId.toString(), order: 'asc', orderBy: 'popularity');
      setState(() {
        order = 'asc';
        orderBy = 'popularity';
      });
    } else if (value == 'order_by_rating_value'.tr) {
      ProductApies.productApies
          .getProductByCategory(pageNumber: '1', category: widget.categoryId.toString(), order: 'asc', orderBy: 'rating');
      setState(() {
        order = 'asc';
        orderBy = 'rating';
      });
    } else if (value == 'order_by_recent_value'.tr) {
      ProductApies.productApies
          .getProductByCategory(pageNumber: '1', order: 'asc', category: widget.categoryId.toString(), orderBy: 'date');
      setState(() {
        order = 'asc';
        orderBy = 'date';
      });
    } else if (value == 'order_by_min_to_height_price_value'.tr) {
      ProductApies.productApies
          .getProductByCategory(pageNumber: '1', category: widget.categoryId.toString(), order: 'desc', orderBy: 'price');
      setState(() {
        order = 'desc';
        orderBy = 'price';
      });
    } else if (value == 'order_by_height_to_min_price_value'.tr) {
      ProductApies.productApies
          .getProductByCategory(pageNumber: '1', category: widget.categoryId.toString(), order: 'desc', orderBy: 'price');
      setState(() {
        order = 'asc';
        orderBy = 'price';
      });
    }
  }

  getData() async {
    ProductApies.productApies.getProductByCategory(pageNumber: '1', category: widget.categoryId.toString());
    ProductApies.productApies.getLastViewProduct(category: widget.categoryId.toString());
  }

  @override
  void initState() {
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
    ProductApies.productApies.listProductByCategory = null;
    getData();
    super.initState();
  }

  late ScrollController _scrollController;
  bool _showBackToTopButton = false;
  void _scrollListener() {
    if (_scrollController.offset >= 400 && !_showBackToTopButton) {
      setState(() {
        _showBackToTopButton = true;
      });
    } else if (_scrollController.offset < 400 && _showBackToTopButton) {
      setState(() {
        _showBackToTopButton = false;
      });
    }
  }
  @override
  void dispose() {
    _scrollController.dispose(); // dispose the controller
    super.dispose();
  }
  void _scrollToTop() {
    _scrollController.animateTo(0,
        duration: const Duration(seconds: 1), curve: Curves.linear);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: _showBackToTopButton == false
          ? null
          : FloatingActionButton(
        onPressed: _scrollToTop,
        backgroundColor: AppColors.primaryColor,
        child: const Icon(Icons.arrow_upward),
      ),
      body: Obx(
            () {
          var product = productController.getProductByCategoryData!.value.data;
          var lastViewedProduct = productController.getLastViewedProduct!.value.data;

          return LazyLoadScrollView(
            onEndOfPage: () {
              if (productController.getProductByCategoryData?.value.headers?.xWPTotal != 0) {
                setState(() {
                  _currentPage++;
                });
                ProductApies.productApies
                    .getProductByCategory(
                    order: order,
                    category: widget.categoryId.toString(),
                    orderBy: orderBy,
                    pageNumber: _currentPage.toString())
                    .then((value) {
                  print('_currentPage ');
                });
              }
            },
            child: CustomScrollView(
              controller: _scrollController,
              physics: const BouncingScrollPhysics(),
              slivers: [
                SliverPadding(
                  padding: EdgeInsets.only(top: 40.h,right: 5.w,left: 5.w),
                  sliver: SliverToBoxAdapter(
                    child: Row(
                      children: [
                        const BackButton(),
                        Spacer(),
                        IconButton(
                          onPressed: () {
                            Get.to(() => SearchScreen());
                          },
                          icon: Icon(Icons.search),
                        ),
                      ],
                    ),
                  ),
                ),
                SliverPadding(
                  padding: EdgeInsets.symmetric(horizontal: 20.0.w,vertical: 15.h),
                  sliver: SliverToBoxAdapter(
                    child: Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: 3,
                              child: widget.fullCategoryName
                                  ? CustomText(
                                widget.categoryName,
                                fontWeight: FontWeight.bold,
                                fontSize: 12.sp,
                              )
                                  : CustomText(
                                widget.categoryName == 'top_offers_value'.tr
                                    ? widget.categoryName
                                    : '${"shop_from_category_value".tr}${widget.categoryName}',
                                fontWeight: FontWeight.bold,
                                fontSize: 12.sp,
                              ),
                            ),
                            const Spacer(),
                            SizedBox(
                              child: DecoratedBox(
                                decoration: BoxDecoration(
                                  border: Border.all(color: const Color(0xffF5E7EA), width: 1),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 7.0.w),
                                  child: DropdownButton<String>(
                                    underline: SizedBox(),
                                    focusColor: Colors.white,
                                    value: selectedDropDown,
                                    style: TextStyle(color: Colors.white, fontSize: 10.sp),
                                    iconEnabledColor: Colors.black,
                                    items: <String>[
                                      'order_by_popularity_value'.tr,
                                      'order_by_rating_value'.tr,
                                      'order_by_recent_value'.tr,
                                      'order_by_min_to_height_price_value'.tr,
                                      'order_by_height_to_min_price_value'.tr,
                                    ].map<DropdownMenuItem<String>>((String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: CustomText(
                                          value,
                                          fontSize: 10.sp,
                                        ),
                                      );
                                    }).toList(),
                                    hint: CustomText(
                                      "order_default_value".tr,
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.normal,
                                    ),
                                    onChanged: (String? value) {
                                      ProductApies.productApies.listProductByCategory = null;

                                      dropDown(value!);
                                      setState(() {
                                        selectedDropDown = value;
                                      });
                                    },
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 12.w,
                            ),
                            GestureDetector(
                              onTap: () {
                                Get.to(() => FilterScreen());
                              },
                              child: SvgPicture.asset(
                                'assets/svg/filter.svg',
                                fit: BoxFit.contain,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                SliverPadding(
                  padding: EdgeInsets.symmetric(horizontal: 20.0.w),
                  sliver: ProductApies.productApies.listProductByCategory == null
                      ? SliverLoadingProduct(8)
                      : ProductApies.productApies.listProductByCategory!.isEmpty
                      ? SliverToBoxAdapter(
                    child: Center(
                      child: Container(
                        margin: EdgeInsets.only(top: 50.h),
                        child: CustomText(
                          'no_item_found_value'.tr,
                          fontSize: 18.sp,
                        ),
                      ),
                    ),
                  )
                      : SliverGrid(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      childAspectRatio: 0.45.h,
                      crossAxisCount: 2,
                      crossAxisSpacing: 11.w,
                      mainAxisSpacing: 16.h,
                    ),
                    delegate: SliverChildBuilderDelegate(
                      childCount: ProductApies.productApies.listProductByCategory?.length ?? 0,

                      (_, index) {
                        print(index);
                        return PerfumeProductItem(
                          id: ProductApies.productApies.listProductByCategory?[index].id.toString(),
                          imgUrl: ProductApies.productApies.listProductByCategory?[index].images?[0].src ?? '',
                          brandName: ProductApies.productApies.listProductByCategory![index].brands!.isNotEmpty
                              ? ProductApies.productApies.listProductByCategory![index].brands != null
                              ? ProductApies.productApies.listProductByCategory![index].brands![0].name
                              : ''
                              : '',
                          perfumeName: ProductApies.productApies.listProductByCategory?[index].title ?? '',
                          perfumeRate: double.parse(
                              ProductApies.productApies.listProductByCategory?[index].averageRating ?? '0.0'),
                          rateCount: ProductApies.productApies.listProductByCategory?[index].ratingCount.toString() ??
                              '0',
                          priceBeforeDiscount: ProductApies.productApies.listProductByCategory?[index].regularPrice ?? '',
                          priceAfterDiscount: ProductApies.productApies.listProductByCategory?[index].salePrice ?? '',
                          onTapBuy: () {
                            print(ProductApies.productApies.listProductByCategory?[index].id.toString());
                            Get.to(() => PerfumeDetailsScreen(
                              productId: ProductApies.productApies.listProductByCategory?[index].id.toString(),
                            ));
                          },
                        );
                      },
                    ),
                  ),
                ),
                SliverPadding(
                  padding: EdgeInsets.symmetric(vertical: 40.h),
                  sliver: SliverToBoxAdapter(
                    child: product == null ? CupertinoActivityIndicator() : SizedBox(),
                  ),
                ),
                SliverPadding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  sliver: SliverToBoxAdapter(
                    child:  Row(
                      children: [
                        CustomText(
                          'last_seen_value'.tr,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.normal,
                        ),
                      ],
                    ),
                  ),
                ),
                SliverPadding(
                  padding: EdgeInsets.symmetric(vertical: 40.h,horizontal: 20.w),
                  sliver:  lastViewedProduct == null
                      ? SliverLoadingProduct(2)
                      : SliverGrid(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      childAspectRatio: 0.45.h,
                      crossAxisCount: 2,
                      crossAxisSpacing: 11.w,
                      mainAxisSpacing: 16.h,
                    ),
                    delegate: SliverChildBuilderDelegate(
                          (_, index) {
                        return PerfumeProductItem(
                          id: lastViewedProduct[index].images?[0].id.toString(),
                          imgUrl: lastViewedProduct[index].images?[0].src ?? '',
                          brandName: lastViewedProduct[index].brands!.isNotEmpty
                              ? lastViewedProduct[index].brands != null
                              ? lastViewedProduct[index].brands![0].name
                              : ''
                              : '',
                          perfumeName: lastViewedProduct[index].title ?? '',
                          perfumeRate: double.parse(lastViewedProduct[index].averageRating ?? '0.0'),
                          rateCount: lastViewedProduct[index].ratingCount.toString() ?? '0',
                          priceBeforeDiscount: lastViewedProduct[index].regularPrice ?? '',
                          priceAfterDiscount: lastViewedProduct[index].salePrice ?? '',
                          onTapBuy: () {
                            print(lastViewedProduct[index].id.toString());
                            Get.to(() => PerfumeDetailsScreen(
                              productId: lastViewedProduct[index].id.toString(),
                            ));
                          },
                        );
                      },
                      childCount: lastViewedProduct.length ?? 0,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
