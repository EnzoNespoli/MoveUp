class Slide {
  final String image;
  final String title;
  final String? subtitle;
  final String? ctaText;
  final String? ctaLink;
  final String? alt;
  final bool visible;

  Slide({
    required this.image,
    required this.title,
    this.subtitle,
    this.ctaText,
    this.ctaLink,
    this.alt,
    this.visible = true,
  });

  factory Slide.fromJson(Map<String, dynamic> j) => Slide(
        image: j['image'] as String,
        title: j['title'] as String,
        subtitle: j['subtitle'] as String?,
        ctaText: j['ctaText'] as String?,
        ctaLink: j['ctaLink'] as String?,
        alt: j['alt'] as String?,
        visible: (j['visible'] ?? true) as bool,
      );
}
