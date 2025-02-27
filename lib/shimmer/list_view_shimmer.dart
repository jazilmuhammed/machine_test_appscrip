import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

Widget userListShimmer() {
  return Container(
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.black12.withOpacity(0.03)),
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
    child: Row(
      children: [
        Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Container(
            height: 36,
            width: 36,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(90),
              color: Colors.white,
              border: Border.all(width: 0.5),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
              child: Container(
                width: 100,
                height: 14,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 5),
            Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
              child: Container(
                width: 150,
                height: 12,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ],
    ),
  );
}
