import 'package:doc_diff_app/features/comparison/presentation/widgets/pdf_upload_area.dart';
import 'package:flutter/material.dart';

class CustomUploadCard extends StatelessWidget {
  const CustomUploadCard({super.key, required this.badge, required this.title});

  final String badge, title;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(30),
      decoration: BoxDecoration(
        color: Color(0XFFFFFFFF),
        borderRadius: BorderRadius.circular(26),
        border: Border.all(color: Color(0XFFDDE2E6)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: Color(0XFFE6F0F8),
                ),
                child: Text(
                  badge,
                  style: TextStyle(
                    color: Color(0XFF003053),
                    fontFamily: 'IBM Plex Sans',
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  fontFamily: 'IBM Plex Sans',
                  color: Color(0XFF101C28),
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: 18),
          PdfUploadArea(),
        ],
      ),
    );
  }
}
