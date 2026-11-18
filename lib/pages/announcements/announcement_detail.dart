import 'package:flutter/material.dart';
import 'package:vet/model/announcement.dart';
import 'package:vet/component/header.dart';
import 'package:vet/component/service_menu_image.dart';

class AnnouncementDetailPage extends StatelessWidget {
  const AnnouncementDetailPage({
    super.key,
    required this.pageTitle,
    required this.announcement,
  });

  final String pageTitle;
  final Announcement announcement;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: header(context, () => Navigator.pop(context), title: pageTitle),
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: AspectRatio(
                  aspectRatio: 3 / 2,
                  child: ServiceMenuImage(assetPath: announcement.imagePath),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                announcement.title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  CircleAvatar(
                    backgroundColor: const Color(0xFF2A97B9),
                    child: Padding(
                      padding: const EdgeInsets.all(6),
                      child: Image.asset(
                        announcement.authorImagePath,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          announcement.author,
                          style: TextStyle(fontSize: 13),
                        ),
                        Text(
                          announcement.dateLabel,
                          style: TextStyle(
                            fontSize: 11,
                            color: Color(0xFF777777),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Divider(),
              const SizedBox(height: 16),
              const Text(
                'รายละเอียดประกาศ',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 12),
              SelectableText(
                announcement.description,
                style: const TextStyle(fontSize: 15, height: 1.7),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
