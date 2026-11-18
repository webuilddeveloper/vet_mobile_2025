import 'package:flutter/material.dart';
import 'package:vet/mock_data/job_announcements.dart';
import '../announcements/announcement_list.dart';

class JobListPage extends StatelessWidget {
  const JobListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const AnnouncementListPage(
      title: 'ประกาศรับสมัครงาน',
      announcements: jobAnnouncements,
    );
  }
}
