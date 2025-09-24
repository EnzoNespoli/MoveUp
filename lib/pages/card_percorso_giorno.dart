import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // per formattare la data

import 'mappa_percorsi.dart';
import '../lingua.dart';

// ====== WRAPPER ======
class CardPercorsoGiorno extends StatefulWidget {
  const CardPercorsoGiorno({
    super.key,
    required this.fetchTraccia, // <- funzione che chiama la tua API
    this.initialDate,
    this.height = 300,
    this.levelsToShow = const {'L1', 'L2'},
    this.minSegmentMeters = 1,
    this.title,
    this.framed = true, // <--- NUOVO
    this.showHeader = true, // <--- NUOVO
  });

  /// Deve ritornare una mappa con almeno: {'segments': List, 'bbox': List?}
  final Future<Map<String, dynamic>> Function(DateTime date) fetchTraccia;

  final DateTime? initialDate;
  final double height;
  final Set<String> levelsToShow;
  final double minSegmentMeters;
  final String? title;
  final bool framed; // <--- NUOVO
  final bool showHeader; // <--- NUOVO

  @override
  State<CardPercorsoGiorno> createState() => _CardPercorsoGiornoState();
}

class _CardPercorsoGiornoState extends State<CardPercorsoGiorno> {
  late DateTime _date;
  bool _loading = false;
  String? _error;
  List<dynamic> _segments = const [];
  List<dynamic>? _bbox;

  @override
  void initState() {
    super.initState();
    _date = widget.initialDate ?? DateTime.now();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final data = await widget.fetchTraccia(_date);
      _segments = (data['segments'] as List?) ?? const [];
      _bbox = data['bbox'] as List?;
    } catch (e) {
      _error = e.toString();
    } finally {
      if (!mounted) return;
      setState(() {
        _loading = false;
      });
    }
  }

  void _changeDay(int delta) {
    setState(() {
      _date = _date.add(Duration(days: delta));
    });
    _load();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now(),
      helpText: context.t.card_percorso_1,
      cancelText: context.t.card_percorso_2,
      confirmText: context.t.card_percorso_3,
    );
    if (!context.mounted) return;
    if (picked != null) {
      setState(() {
        _date = picked;
      });
      _load();
    }
  }

  @override
  Widget build(BuildContext context) {
    final dateLabel = DateFormat.yMMMEd().format(_date);
    final title = widget.title ?? '${context.t.card_percorso_4} $dateLabel';

    final content = Padding(
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.showHeader)
            Row(
              children: [
                const Icon(Icons.map, color: Colors.blue),
                const SizedBox(width: 6),
                Expanded(
                    child: Text(title,
                        style: const TextStyle(fontWeight: FontWeight.w600))),
                IconButton(
                    icon: const Icon(Icons.chevron_left),
                    onPressed: _loading ? null : () => _changeDay(-1)),
                IconButton(
                    icon: const Icon(Icons.calendar_today),
                    onPressed: _loading ? null : _pickDate),
                IconButton(
                    icon: const Icon(Icons.chevron_right),
                    onPressed: _loading ? null : () => _changeDay(1)),
              ],
            ),
          const SizedBox(height: 8),
          if (_loading)
            SizedBox(
                height: widget.height,
                child: const Center(child: CircularProgressIndicator()))
          else if (_error != null)
            SizedBox(
                height: widget.height,
                child: Center(
                    child: Text('Errore: $_error',
                        style: TextStyle(color: Colors.red))))
          else
            MappaPercorsi(
              segments: _segments,
              bbox: _bbox,
              height: widget.height,
              levelsToShow: widget.levelsToShow,
              minSegmentMeters: widget.minSegmentMeters, 
            ),
        ],
      ),
    );

    // Se framed=true, avvolgi in una Card; altrimenti restituisci solo il contenuto
    return widget.framed
        ? Card(
            margin: const EdgeInsets.symmetric(vertical: 8),
            color: Colors.blueGrey[50],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: Colors.blueGrey.shade300, width: 2),
            ),
            child: content,
          )
        : content;
  }
}
