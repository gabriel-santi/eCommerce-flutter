import 'package:ecommerce_app/src/constants/app_sizes.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class CardShimmer extends StatelessWidget {
  const CardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[200]!,
      child: Row(
        children: [
          Flexible(
            flex: 1,
            child: Container(
              height: 100,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(Sizes.p16),
                color: Colors.grey[300],
              ),
            ),
          ),
          gapW8,
          Flexible(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 30,
                  width: 180,
                  margin: EdgeInsets.only(top: Sizes.p8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(Sizes.p4),
                    color: Colors.grey[300],
                  ),
                ),
                gapH8,
                Container(
                  height: 20,
                  width: 50,
                  margin: EdgeInsets.only(top: Sizes.p8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(Sizes.p4),
                    color: Colors.grey[300],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
