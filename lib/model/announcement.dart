/// Shared data for announcement lists and their detail pages.
class Announcement {
  const Announcement({
    required this.code,
    required this.title,
    required this.category,
    required this.imagePath,
    required this.description,
    required this.author,
    required this.authorImagePath,
    required this.dateLabel,
  });

  final String code;
  final String title;
  final String category;
  final String imagePath;
  final String description;
  final String author;
  final String authorImagePath;
  final String dateLabel;
}
