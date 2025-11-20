import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../db.dart'; // Importa la costante globale
import '../services/app_header.dart'; // importa il tuo header
import '../lingua.dart';

class OnboardingPage extends StatefulWidget {
  final void Function(Locale?) onChangeLocale; // <-- aggiungi
  const OnboardingPage({super.key, required this.onChangeLocale});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  static const String kTermsVersion = '2025-08-16';

  final PageController _controller = PageController();
  int paginaCorrente = 0;
  bool accettato = false;

  final immagini = const [
    'assets/onboarding1.png',
    'assets/onboarding2.png',
    'assets/onboarding3.png', 
  ];

  

  bool get _ultimaPagina => paginaCorrente == immagini.length - 1;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Precarica le immagini per evitare flicker
    for (final p in immagini) {
      precacheImage(AssetImage(p), context);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> salvaOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboarding_completato', true);
    await prefs.setString('terms_version', kTermsVersion);
    await prefs.setString(
      'terms_accepted_at',
      DateTime.now().toIso8601String(),
    );
  }

  Future<void> _openDocSheet(String title, String body) async {
    await showModalBottomSheet(
      context: context,
      useSafeArea: true,
      isScrollControlled: true,
      showDragHandle: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.9,
        maxChildSize: 0.95,
        minChildSize: 0.5,
        builder: (_, controller) => Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          child: Column(
            children: [
              Row(
                children: [
                  const Icon(Icons.description_outlined),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      title,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              const Divider(),
              const SizedBox(height: 8),
              Expanded(
                child: SingleChildScrollView(
                  controller: controller,
                  child: SelectableText(
                    body,
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.copyWith(height: 1.4),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    final testi =  [
    context.t.onb1_body,
    context.t.onb2_body,
    context.t.onb3_body,
    
  ];

  final titoli = <String>[
  context.t.onb1, // nuova chiave
  context.t.onb2,                   // per ora vuoto
  context.t.onb3,                   // per ora vuoto
];

    final theme = Theme.of(context);

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(120),
        child: AppHeader(
          showBack: false, // o true se vuoi la freccia indietro
          onChangeLocale: widget.onChangeLocale, // dal tuo MoveApp
          //height: 120, // <--- più basso
          // oppure lascia vuoto se il titolo è già nel widget
        ),
      ),
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            // Barra in alto con "Salta" (fino all'ultima pagina)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              child: Row(
                children: [
                  const Spacer(),
                  if (!_ultimaPagina)
                    TextButton(
                      onPressed: () {
                        _controller.animateToPage(
                          immagini.length - 1,
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      },
                      child:  Text(context.t.botton_salta),
                    ),
                ],
              ),
            ),

            // Contenuto
            Expanded(
              child: PageView.builder(
                controller: _controller,
                itemCount: immagini.length,
                onPageChanged: (i) => setState(() => paginaCorrente = i),
                itemBuilder: (context, i) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        immagini[i],
                        fit: BoxFit.contain,
                        height: 300,
                      ),
                      const SizedBox(height: 24),
                      ConstrainedBox(
  constraints: const BoxConstraints(maxWidth: 360),
  child: Column(
    children: [
      Text(
        titoli[i], // "Cosa fa MoveUP?"
        textAlign: TextAlign.center,
        style: theme.textTheme.headlineSmall?.copyWith(
          fontWeight: FontWeight.w700,
        ),
      ),
      const SizedBox(height: 8),
      Text(
        testi[i], // body
        textAlign: TextAlign.center,
        style: theme.textTheme.titleMedium?.copyWith(
          height: 1.4,
          color: theme.colorScheme.onSurface.withOpacity(0.8),
        ),
      ),
    ],
  ),
),
                    ],
                  ),
                ),
              ),
            ),

            // Indicatori pagina
            Padding(
              padding: const EdgeInsets.only(bottom: 8, top: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  immagini.length,
                  (i) => AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    height: 8,
                    width: i == paginaCorrente ? 24 : 8,
                    decoration: BoxDecoration(
                      color: i == paginaCorrente
                          ? theme.colorScheme.primary
                          : theme.colorScheme.primary.withOpacity(.3),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
            ),

            // Checkbox + link (solo ultima pagina)
            if (_ultimaPagina)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Checkbox.adaptive(
                      value: accettato,
                      onChanged: (v) => setState(() => accettato = v ?? false),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Wrap(
                        alignment: WrapAlignment.start,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          Text(context.t.condizioni_uso),
                          InkWell(
                            onTap: () => _openDocSheet(
                              context.t.condizioni_uso2,
                              condizioniTesto,
                            ),
                            child: Text(
                              context.t.condizioni_uso2,
                              style: TextStyle(
                                color: theme.colorScheme.primary,
                                decoration: TextDecoration.underline,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          Text(context.t.privacy_policy),
                          InkWell(
                            onTap: () => _openDocSheet(
                              context.t.privacy_policy2,
                              privacyPolicyTesto,
                            ),
                            child: Text(
                              context.t.privacy_policy2,
                              style: TextStyle(
                                color: theme.colorScheme.primary,
                                decoration: TextDecoration.underline,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          const Text('.'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

            // CTA
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: (_ultimaPagina && accettato)
                      ? () async {
                          await salvaOnboarding();
                          if (context.mounted) Navigator.pop(context);
                        }
                      : () {
                          if (!_ultimaPagina) {
                            _controller.nextPage(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            );
                          }
                        },
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 150),
                    child: Text(
                      _ultimaPagina ? context.t.botton_prosegui : context.t.botton_avanti,
                      key: ValueKey(_ultimaPagina),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// --- Pagine documenti (puoi continuare a usarle se vuoi aprirle a schermo intero) ---

class CondizioniPage extends StatelessWidget {
  const CondizioniPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.t.condizioni_uso2)),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Text(
          condizioniTesto,
          style: TextStyle(fontSize: 16, height: 1.4),
        ),
      ),
    );
  }
}

class PrivacyPage extends StatelessWidget {
  const PrivacyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.t.privacy_policy)),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Text(
          privacyPolicyTesto,
          style: TextStyle(fontSize: 16, height: 1.4),
        ),
      ),
    );
  }
}

// --- Costanti testo (mantengo i tuoi placeholder $dt_* come da tuo sorgente) ---

const String condizioniTesto = """
MOVEUP TERMS OF USE (updated)

Last updated: August 16, 2025
Service owner: $dt_ragione_sociale
Registered office: $dt_indirizzo – $dt_localita – $dt_stato
Contacts: $dt_email – $dt_email_support – $dt_telefono

1) ACCEPTANCE OF TERMS AND CHANGES
By downloading, installing, or using MoveUp (the “App” or “Service”), you agree to these Terms. 
If you do not agree, do not use the Service. 
We may modify these Terms; material changes will be notified in-app or by email and will become effective on the stated effective date. 
Your continued use after that date constitutes acceptance.

2) WHAT MOVEUP IS (NO MEDICAL/EMERGENCY SERVICE)
MoveUp helps you monitor movements (e.g., trips and activity levels) and view personal statistics and reports. 
It is not a medical device and does not provide medical advice. 
The Service is not an emergency or safety-of-life system and must not be relied upon for such purposes.

3) REQUIREMENTS
You must be at least 16 years old (or the minimum age in your country), 
have a compatible smartphone and Internet access, and provide accurate information. 
You are responsible for keeping your account secure.

4) PLANS AND DATA RETENTION
Free (unregistered): data visible only for the current day, deleted within 24 hours.
Start: retained 7 days; Basic: 30 days; Plus: 180 days; Pro: 365 days.
You may request early deletion at any time (see Privacy Policy). 
Retention specifics are described in the Privacy Policy.

5) PERMISSIONS AND GEOLOCATION (INCLUDING BACKGROUND)
The App may request location and motion sensor permissions. 
You can enable/disable them in device settings. 
Some features will not work without them. 
Background location may be used to deliver continuous tracking; this may increase battery usage.

6) ACCEPTABLE USE
You agree not to use the Service unlawfully, dangerously, or to track third parties without a lawful basis and valid consent. 
You must not tamper with the App, upload malware, attempt to reverse engineer, or circumvent protections. 
Do not interact with the App while driving or in situations requiring full attention.

7) SUBSCRIPTIONS, PAYMENTS, AND RENEWALS
Paid plans are billed via the relevant platform provider (Apple App Store/Google Play) or Stripe.
Pricing & periods: shown in the App/Store at checkout, inclusive/exclusive of taxes per Store rules.
Auto-renewal: subscriptions auto-renew at the end of each billing period unless you cancel at least 24 hours before renewal via your Store account settings.
Cancellation: takes effect at the end of the current paid period; access continues until then. We do not provide partial period refunds.
Trials/Promotions: when available, terms will be shown at sign-up; trial conversions auto-renew unless cancelled in time.
Refunds: governed by the relevant Store’s policies and applicable law.
Price changes: we may change prices with prior notice; changes apply on the next renewal.

8) THIRD-PARTY SERVICES
The Service integrates third-party services (e.g., maps/tiles providers, analytics, payment processors, hosting). 
Their availability and terms are outside our control; use is subject to their licenses and policies (e.g., OpenStreetMap attribution requirements). 
We are not responsible for outages caused by such third parties.

9) INTELLECTUAL PROPERTY
The software, the “MoveUp” name and logos, and other content are protected by intellectual property rights and remain the property of $dt_ragione_sociale or its licensors. 
Except as permitted by law, you may not copy, modify, decompile, or distribute the App without prior authorization.

10) USER CONTENT
Any notes or content you create remain yours. 
You grant us a non-exclusive, worldwide, royalty-free license to host, process, and display such content solely to provide and improve the Service.

11) NO MEDICAL ADVICE
Information in the App is for informational and wellness purposes only and does not replace professional medical advice. Always consult a qualified professional for health or diagnosis matters.

12) PRIVACY
Processing of personal data is described in our Privacy Policy available in-app or at mytrak.app/privacy. 
The Data Controller is $dt_ragione_sociale. You can exercise your GDPR rights as described therein.

13) DISCLAIMER; LIMITATION OF LIABILITY
The Service is provided “as is” and “as available.” To the maximum extent permitted by law, we disclaim all warranties (express or implied).
Except for liability that cannot be excluded by law, our total aggregate liability arising out of or related to the 
Service is limited to the amount you paid for the Service in the 12 months preceding the event giving rise to the claim. 
Nothing in these Terms limits consumer rights that cannot be excluded under applicable law.

14) TERMINATION
We may suspend or terminate your access if you materially breach these Terms or use the Service unlawfully. 
You may cancel at any time through your Store account settings; cancellation is effective at period end.

15) GOVERNING LAW AND JURISDICTION
These Terms are governed by Italian law. 
If you are a consumer, the court of your place of residence has jurisdiction; otherwise, the competent court is $dt_localita.

16) MISCELLANEOUS
If any provision is held invalid, the remaining provisions remain in effect. 
These Terms constitute the entire agreement between you and us regarding the Service.

17) CONTACTS
For questions, billing issues, or legal notices: $dt_email or $dt_email_support.

This document provides general information and does not constitute legal advice.
""";

const String privacyPolicyTesto = """
MOVEUP PRIVACY POLICY (updated)

Last updated: August 16, 2025
Service owner (Data Controller): $dt_ragione_sociale
Registered office: $dt_indirizzo – $dt_localita – $dt_stato
Contacts: $dt_email – $dt_email_support – $dt_telefono

1) INTRODUCTION
This Privacy Policy describes how MoveUp (“we”, “us”) collects, uses, stores, and protects personal data of users who download and use the app (the “Service”). 
Where we rely on consent, you can withdraw it at any time without affecting the lawfulness of processing before the withdrawal.

2) DATA COLLECTED
Registration data: email, password (hashed), gender, year of birth, and similar profile fields.
Usage data: GPS location (including precise and background location, if you enable it), 
device-detected physical activity and motion sensor signals, movement statistics, and app interaction events needed to provide features.
Payment data: handled securely by external providers (e.g., Apple App Store, Google Play, Stripe). MoveUp does not store full payment card details.
Technical logs/diagnostics: IP address, device and OS information, identifiers (e.g., push token/advertising ID where applicable), 
timestamps and error logs for security, fraud prevention and performance.
Support communications: messages you send to support and related metadata.

3) PURPOSES OF PROCESSING
We process data to:
deliver the app’s core features (monitoring, statistics, reports);
manage accounts, authentication and subscription plans;
ensure security, prevent abuse, debug and improve performance;
send in-app and push notifications (with your prior consent where required);
comply with legal obligations (e.g., accounting/tax).

4) LEGAL BASES
Contract (Art. 6(1)(b) GDPR): to provide the Service you request.
Consent (Art. 6(1)(a)): for GPS tracking (especially precise/background), push notifications, 
and marketing—optional and revocable at any time via device/app settings.
Legal obligation (Art. 6(1)(c)): e.g., retention of accounting/tax records.
Legitimate interest (Art. 6(1)(f)): IT security, fraud prevention, Service analytics in a privacy-preserving way. 
Balancing tests available on request.

5) BACKGROUND LOCATION & SENSORS
If you enable it, the app may collect background location/motion to provide continuous tracking and statistics—even when the app is not in the foreground. 
You can enable/disable permissions in system settings at any time; some features may be limited without them.

6) RETENTION PERIOD
Free (unregistered): deleted within 24 hours.
Start: 7 days.
Basic: 30 days.
Plus: 180 days.
Pro: 365 days.
After these periods, data are deleted or anonymized unless a different legal obligation applies. 
Backups and logs may have short additional retention (typically up to 30–90 days) for security/continuity, after which they are rotated or anonymized.

7) DATA RECIPIENTS (PROCESSORS/THIRD PARTIES)
We share data with:
hosting and cloud providers;
payment providers (Apple/Google/Stripe);
technical/analytics partners strictly for Service operation.
All are bound by data processing agreements and confidentiality. A current list of key processors is available on request.

8) INTERNATIONAL TRANSFERS
Some providers may process data outside the EU/EEA. 
Where this occurs, we use adequate safeguards, such as the EU Commission’s Standard Contractual Clauses and additional measures as needed.

9) SECURITY
We implement appropriate technical and organizational measures to protect data against unauthorized access, loss, misuse, or destruction (e.g., encryption in transit, access controls, logging).

10) YOUR RIGHTS
You have the right to: access, rectification, erasure, restriction, objection, and data portability; to withdraw consent at any time; 
and to lodge a complaint with the Supervisory Authority (Garante).
How to exercise your rights: email $dt_email_support from the address linked to your account. 
We may request information to verify identity. 
We will respond within 30 days (extendable where permitted by law).

11) CHILDREN
The Service is not intended for children under 16. 
If we learn that a child used the Service without valid consent, we will delete the data.

12) CHANGES TO THIS POLICY
We may update this Policy from time to time. 
Material changes will be notified in-app or by email, and the “Last updated” date will change. 
Continued use after the effective date constitutes acceptance.

13) CONTACTS
For requests, complaints, or to exercise your rights, contact:
$dt_email_support or write to $dt_indirizzo – $dt_localita – $dt_stato.

This document provides general information and does not constitute legal advice.

By ticking “I have read and accept the Terms and the Privacy Policy,” 
you declare that you understand how your data are processed pursuant to EU Regulation 2016/679 (GDPR).
""";
