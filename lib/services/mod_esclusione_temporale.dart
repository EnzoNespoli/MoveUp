class EsclusioneTemporale {
  final int id;
  final int utenteId;
  final int? attiva;
  final String nome;
  final int giorniBitmask;
  final String oraInizio;
  final String oraFine;
  final String? note;
  final String? timezone;
  final String? createdAt;
  final String? updatedAt;

  EsclusioneTemporale({
    required this.id,
    required this.utenteId,
    required this.nome,
    required this.giorniBitmask,
    required this.oraInizio,
    required this.oraFine,
    this.note,
    this.attiva,
    this.timezone,
    this.createdAt,
    this.updatedAt,
  });

// ...nel modello EsclusioneTemporale...
  EsclusioneTemporale copyWith({
    int? id,
    int? utenteId,
    int? attiva,
    String? nome,
    int? giorniBitmask,
    String? oraInizio,
    String? oraFine,
    String? note,
    String? timezone,
    String? createdAt,
    String? updatedAt,
  }) =>
      EsclusioneTemporale(
        id: id ?? this.id,
        utenteId: utenteId ?? this.utenteId,
        attiva: attiva ?? this.attiva,
        nome: nome ?? this.nome,
        giorniBitmask: giorniBitmask ?? this.giorniBitmask,
        oraInizio: oraInizio ?? this.oraInizio,
        oraFine: oraFine ?? this.oraFine,
        note: note ?? this.note,
        timezone: timezone ?? this.timezone,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );

  factory EsclusioneTemporale.fromJson(Map<String, dynamic> json) =>
      EsclusioneTemporale(
        id: json['id'],
        utenteId: json['utente_id'],
        nome: json['nome'],
        giorniBitmask: json['giorni_bitmask'],
        oraInizio: json['ora_inizio'],
        oraFine: json['ora_fine'],
        note: json['note'],
        attiva: json['attiva'],
        timezone: json['timezone'],
        createdAt: json['created_at'],
        updatedAt: json['updated_at'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'utente_id': utenteId,
        'nome': nome,
        'giorni_bitmask': giorniBitmask,
        'ora_inizio': oraInizio,
        'ora_fine': oraFine,
        'note': note,
        'attiva': attiva,
        'timezone': timezone,
        'created_at': createdAt,
        'updated_at': updatedAt,
      };
}
