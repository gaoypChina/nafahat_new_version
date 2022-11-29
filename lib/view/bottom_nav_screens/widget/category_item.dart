
import '../../../services/app_imports.dart';

class CategoryItem extends StatelessWidget {
final int? index ;
final String? imgUrl ;
final String? title ;
final VoidCallback? onTap ;

  const CategoryItem({super.key, this.index, this.imgUrl, this.title, this.onTap});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          index == 0
              ? SizedBox(
            width: 21.w,
          )
              : const SizedBox(),
          SizedBox(
            height: 90.h,
            width: 78.w,
            child: Column(
              children: [
                Container(
                  height: 52.h,
                  width: 52.w,
                  padding: EdgeInsets.all(5.w),
                  decoration: const BoxDecoration(
                    color: AppColors.greyContainer,
                    shape: BoxShape.circle,
                  ),
                  child: CachedNetworkImageShare(
                    urlImage:
                    imgUrl,
                    fit: BoxFit.contain,
                    heigthNumber: 30.h,
                    widthNumber: 40.w,
                  ),
                ),
                SizedBox(
                  height: 11.h,
                ),
                CustomText(
                  title,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.normal,
                )
              ],
            ),
          ),
          SizedBox(
            width: 9.w,
          ),
        ],
      ),
    );
  }
}
