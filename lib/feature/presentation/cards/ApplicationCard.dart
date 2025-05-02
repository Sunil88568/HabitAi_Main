
import 'package:flutter/material.dart';
import 'package:question_app/components/styles/textStyles.dart';
import 'package:question_app/utils/extensions/size.dart';
import 'package:question_app/utils/extensions/widget.dart';

import '../../../components/coreComponents/TextView.dart';
import '../../../components/styles/appColors.dart';

class ApplicationCard extends StatelessWidget {
  final String dueDate;
  final String applicantName;
  final String applicantId;
  final String processMapped;
  final VoidCallback onViewTap;

  const ApplicationCard({
    super.key,
    required this.dueDate,
    required this.applicantName,
    required this.applicantId,
    required this.processMapped,
    required this.onViewTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: 16.horizontal + 10.vertical,
      padding: 16.all,
      decoration: BoxDecoration(
        color: AppColors.cardBaground,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
               TextView(
                 text:
                "Due Date",
                style: 14.txtregularBtncolor,
              ),
              20.width,
              TextView(
                text: dueDate,
                style: 14.txtregularBtncolor,
              ),
            ],
          ),
          15.height,
          _buildInfoRow("Applicant Name", applicantName, boldValue: true),
          4.height,
          _buildInfoRow("Applicant ID", applicantId),
          4.height,
          _buildInfoRow("Process Mapped", processMapped),

          10.height,

          Align(
            alignment: Alignment.centerRight,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.lightBlue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
              ),
              onPressed: onViewTap,
              child: TextView(
                text:
                "View",
                style: 14.txtRegularWhite,
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, {bool boldValue = false}) {
    return Padding(
      padding: 8.bottom,
      child: Row(
        children: [
          Expanded(
            child: TextView(
              text:
              "$label :",
              style: 14.txtBoldGrey,
            ),
          ),
          Expanded(
            child: TextView(
              text:
              value,
              style: 14.txtBoldBlack,
            ),
          ),
        ],
      ),
    );
  }
}
