import 'package:flutter/material.dart';
import 'package:vet/mock_data/exam_announcements.dart';
import '../announcements/announcement_list.dart';

class ExamRegistrationListPage extends StatelessWidget {
  const ExamRegistrationListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const AnnouncementListPage(
      title: 'สมัครสอบ',
      announcements: examAnnouncements,
    );
  }
}
