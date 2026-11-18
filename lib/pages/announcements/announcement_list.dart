import 'package:flutter/material.dart';
import 'package:vet/component/header.dart';
import 'package:vet/component/service_menu_image.dart';
import 'announcement_detail.dart';
import 'package:vet/model/announcement.dart';

class AnnouncementListPage extends StatefulWidget {
  const AnnouncementListPage({
    super.key,
    required this.title,
    required this.announcements,
  });

  final String title;
  final List<Announcement> announcements;

  @override
  State<AnnouncementListPage> createState() => _AnnouncementListPageState();
}

class _AnnouncementListPageState extends State<AnnouncementListPage> {
  final _searchController = TextEditingController();
  String _category = 'ทั้งหมด';
  String _query = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final jobs =
        widget.announcements.where((job) {
          return (_category == 'ทั้งหมด' || job.category == _category) &&
              job.title.toLowerCase().contains(_query.trim().toLowerCase());
        }).toList();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: header(
        context,
        () => Navigator.pop(context),
        title: widget.title,
      ),
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: const BoxDecoration(
                border: Border(bottom: BorderSide(color: Color(0xFFDDDDDD))),
              ),
              child: Row(
                children:
                    [
                      'ทั้งหมด',
                      ...widget.announcements
                          .map((item) => item.category)
                          .toSet()
                          .where((category) => category != 'ทั้งหมด'),
                    ].map((category) {
                      final selected = _category == category;
                      return Padding(
                        padding: const EdgeInsets.only(right: 16),
                        child: InkWell(
                          onTap: () => setState(() => _category = category),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  color:
                                      selected
                                          ? Colors.black
                                          : Colors.transparent,
                                  width: 2,
                                ),
                              ),
                            ),
                            child: Text(
                              category,
                              style: TextStyle(
                                fontSize: 16,
                                color:
                                    selected
                                        ? Colors.black
                                        : const Color(0xFF666666),
                                fontWeight:
                                    selected
                                        ? FontWeight.w600
                                        : FontWeight.normal,
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
              child: TextField(
                controller: _searchController,
                onChanged: (value) => setState(() => _query = value),
                textInputAction: TextInputAction.search,
                decoration: InputDecoration(
                  hintText: 'ใส่คำที่ต้องการค้นหา...',
                  hintStyle: const TextStyle(
                    fontSize: 13,
                    color: Color(0xFFAAAAAA),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
                  isDense: true,
                  suffixIcon:
                      _query.isEmpty
                          ? const Icon(Icons.search, color: Color(0xFF555555))
                          : IconButton(
                            tooltip: 'ล้างคำค้นหา',
                            onPressed: () {
                              _searchController.clear();
                              setState(() => _query = '');
                            },
                            icon: const Icon(Icons.close),
                          ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
                  ),
                ),
              ),
            ),
            Expanded(
              child:
                  jobs.isEmpty
                      ? Center(child: Text('ไม่พบรายการ${widget.title}'))
                      : ListView.separated(
                        keyboardDismissBehavior:
                            ScrollViewKeyboardDismissBehavior.onDrag,
                        padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
                        itemCount: jobs.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 18),
                        itemBuilder:
                            (context, index) => InkWell(
                              onTap:
                                  () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder:
                                          (_) => AnnouncementDetailPage(
                                            pageTitle: widget.title,
                                            announcement: jobs[index],
                                          ),
                                    ),
                                  ),
                              child: _AnnouncementCard(job: jobs[index]),
                            ),
                      ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AnnouncementCard extends StatelessWidget {
  const _AnnouncementCard({required this.job});

  final Announcement job;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(3),
        boxShadow: const [
          BoxShadow(
            color: Color(0x26000000),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 37,
                child: AspectRatio(
                  aspectRatio: 1,
                  child: ServiceMenuImage(assetPath: job.imagePath),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                flex: 63,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      job.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 28),
                    Row(
                      children: [
                        Container(
                          width: 30,
                          height: 30,
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            color: Color(0xFF2A97B9),
                            shape: BoxShape.circle,
                          ),
                          child: Image.asset(
                            job.authorImagePath,
                            fit: BoxFit.contain,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(job.author, style: TextStyle(fontSize: 10)),
                              Text(
                                job.dateLabel,
                                style: TextStyle(
                                  fontSize: 8,
                                  color: Color(0xFF666666),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Icon(
                          Icons.more_horiz,
                          size: 16,
                          color: Color(0xFF999999),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(height: 1, color: Color(0xFFCCCCCC)),
          const SizedBox(height: 4),
        ],
      ),
    );
  }
}
