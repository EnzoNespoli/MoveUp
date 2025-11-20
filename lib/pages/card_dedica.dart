import 'package:flutter/material.dart';

class CardDedica extends StatelessWidget {
  final String title;
  final String testo;
  final String? assetPhoto1; // es. 'assets/img/lova1.jpg'
  final String? assetPhoto2; // es. 'assets/img/lova2.jpg'

  const CardDedica({
    Key? key,
    required this.title,
    required this.testo,
    this.assetPhoto1,
    this.assetPhoto2,
  }) : super(key: key);

  Widget _photoAsset(String? assetPath) {
    if (assetPath == null || assetPath.isEmpty) {
      return const SizedBox.shrink();
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Image.asset(
        assetPath,
        height: 120,
        width: double.infinity,
        fit: BoxFit.cover,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
     color: Colors.blueGrey[50],
      margin: EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.blueGrey, width: 2),
      ),
      child: ExpansionTile(
        initiallyExpanded: false,
        title: Text(title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  testo,
                  style: const TextStyle(fontSize: 14),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    if (assetPhoto1 != null)
                      Expanded(child: _photoAsset(assetPhoto1)),
                    if (assetPhoto1 != null && assetPhoto2 != null)
                      const SizedBox(width: 12),
                    if (assetPhoto2 != null)
                      Expanded(child: _photoAsset(assetPhoto2)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
