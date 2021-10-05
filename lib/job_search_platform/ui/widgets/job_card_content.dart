import 'package:challenges/job_search_platform/models/job_card_model.dart';
import 'package:flutter/material.dart';

class JobCardContent extends StatelessWidget {
  const JobCardContent({
    Key? key,
    required this.jobCard,
    required this.map,
    this.imageSize = 20,
    this.jobPositionSize = 18,
  }) : super(key: key);

  final JobCardModel jobCard;
  final Widget map;
  final double imageSize;
  final double jobPositionSize;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    color: Colors.grey.withOpacity(.15),
                    child: Image.asset(
                      'lib/job_search_platform/assets/${jobCard.id}.png',
                      height: imageSize,
                      width: imageSize,
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                Text(
                  jobCard.company,
                  style: TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 10),
                Text(
                  jobCard.position,
                  maxLines: 2,
                  style: TextStyle(
                    color: Colors.white.withOpacity(.85),
                    fontWeight: FontWeight.bold,
                    fontSize: jobPositionSize,
                    wordSpacing: 1000,
                  ),
                ),
                const SizedBox(height: 15),
                RichText(
                  text: TextSpan(
                    style: DefaultTextStyle.of(context).style.copyWith(fontSize: 16),
                    children: [
                      TextSpan(
                        text: '\$${jobCard.salary}k',
                        style: TextStyle(
                          color: Colors.white.withOpacity(.85),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      TextSpan(
                        text: '/${jobCard.salaryFrecuency}',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ),
                Spacer()
              ],
            ),
          ),
        ),
        Expanded(
          child: Container(color: Colors.transparent, child: map),
        )
      ],
    );
  }
}
